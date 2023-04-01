# Pleroma: A lightweight social networking server
# Copyright © 2017-2022 Pleroma Authors <https://pleroma.social/>
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Pleroma.Integration.MastodonWebsocketTest do
  # Needs a streamer, needs to stay synchronous
  use Pleroma.DataCase

  import ExUnit.CaptureLog
  import Pleroma.Factory

  alias Pleroma.Integration.WebsocketClient
  alias Pleroma.Web.CommonAPI
  alias Pleroma.Web.OAuth

  @moduletag needs_streamer: true, capture_log: true

  @path Pleroma.Web.Endpoint.url()
        |> URI.parse()
        |> Map.put(:scheme, "ws")
        |> Map.put(:path, "/api/v1/streaming")
        |> URI.to_string()

  def start_socket(qs \\ nil, headers \\ []) do
    path =
      case qs do
        nil -> @path
        qs -> @path <> qs
      end

    WebsocketClient.start_link(self(), path, headers)
  end

  defp decode_json(json) do
    with {:ok, %{"event" => event, "payload" => payload_text}} <- Jason.decode(json),
         {:ok, payload} <- Jason.decode(payload_text) do
      {:ok, %{"event" => event, "payload" => payload}}
    end
  end

  test "refuses invalid requests" do
    capture_log(fn ->
      assert {:error, %WebSockex.RequestError{code: 404}} = start_socket("?stream=ncjdk")
      Process.sleep(30)
    end)
  end

  test "requires authentication and a valid token for protected streams" do
    capture_log(fn ->
      assert {:error, %WebSockex.RequestError{code: 401}} =
               start_socket("?stream=user&access_token=aaaaaaaaaaaa")

      assert {:error, %WebSockex.RequestError{code: 401}} = start_socket("?stream=user")
      Process.sleep(30)
    end)
  end

  test "allows unified stream" do
    assert {:ok, _} = start_socket()
  end

  test "allows public streams without authentication" do
    assert {:ok, _} = start_socket("?stream=public")
    assert {:ok, _} = start_socket("?stream=public:local")
    assert {:ok, _} = start_socket("?stream=public:remote&instance=lain.com")
    assert {:ok, _} = start_socket("?stream=hashtag&tag=lain")
  end

  test "receives well formatted events" do
    user = insert(:user)
    {:ok, _} = start_socket("?stream=public")
    {:ok, activity} = CommonAPI.post(user, %{status: "nice echo chamber"})

    assert_receive {:text, raw_json}, 1_000
    assert {:ok, json} = Jason.decode(raw_json)

    assert "update" == json["event"]
    assert json["payload"]
    assert {:ok, json} = Jason.decode(json["payload"])

    view_json =
      Pleroma.Web.MastodonAPI.StatusView.render("show.json", activity: activity, for: nil)
      |> Jason.encode!()
      |> Jason.decode!()

    assert json == view_json
  end

  describe "subscribing via WebSocket" do
    test "can subscribe" do
      user = insert(:user)
      {:ok, pid} = start_socket()
      WebsocketClient.send_text(pid, %{type: "subscribe", stream: "public"} |> Jason.encode!())
      assert_receive {:text, raw_json}, 1_000

      assert {:ok,
              %{
                "event" => "pleroma.respond",
                "payload" => %{"type" => "subscribe", "result" => "success"}
              }} = decode_json(raw_json)

      {:ok, activity} = CommonAPI.post(user, %{status: "nice echo chamber"})

      assert_receive {:text, raw_json}, 1_000
      assert {:ok, json} = Jason.decode(raw_json)

      assert "update" == json["event"]
      assert json["payload"]
      assert {:ok, json} = Jason.decode(json["payload"])

      view_json =
        Pleroma.Web.MastodonAPI.StatusView.render("show.json", activity: activity, for: nil)
        |> Jason.encode!()
        |> Jason.decode!()

      assert json == view_json
    end

    test "won't double subscribe" do
      user = insert(:user)
      {:ok, pid} = start_socket()
      WebsocketClient.send_text(pid, %{type: "subscribe", stream: "public"} |> Jason.encode!())
      assert_receive {:text, raw_json}, 1_000

      assert {:ok,
              %{
                "event" => "pleroma.respond",
                "payload" => %{"type" => "subscribe", "result" => "success"}
              }} = decode_json(raw_json)

      WebsocketClient.send_text(pid, %{type: "subscribe", stream: "public"} |> Jason.encode!())
      assert_receive {:text, raw_json}, 1_000

      assert {:ok,
              %{
                "event" => "pleroma.respond",
                "payload" => %{"type" => "subscribe", "result" => "ignored"}
              }} = decode_json(raw_json)

      {:ok, _activity} = CommonAPI.post(user, %{status: "nice echo chamber"})

      assert_receive {:text, _}, 1_000
      refute_receive {:text, _}, 1_000
    end

    test "can unsubscribe" do
      user = insert(:user)
      {:ok, pid} = start_socket()
      WebsocketClient.send_text(pid, %{type: "subscribe", stream: "public"} |> Jason.encode!())
      assert_receive {:text, raw_json}, 1_000

      assert {:ok,
              %{
                "event" => "pleroma.respond",
                "payload" => %{"type" => "subscribe", "result" => "success"}
              }} = decode_json(raw_json)

      WebsocketClient.send_text(pid, %{type: "unsubscribe", stream: "public"} |> Jason.encode!())
      assert_receive {:text, raw_json}, 1_000

      assert {:ok,
              %{
                "event" => "pleroma.respond",
                "payload" => %{"type" => "unsubscribe", "result" => "success"}
              }} = decode_json(raw_json)

      {:ok, _activity} = CommonAPI.post(user, %{status: "nice echo chamber"})
      refute_receive {:text, _}, 1_000
    end
  end

  describe "with a valid user token" do
    setup do
      {:ok, app} =
        Pleroma.Repo.insert(
          OAuth.App.register_changeset(%OAuth.App{}, %{
            client_name: "client",
            scopes: ["read"],
            redirect_uris: "url"
          })
        )

      user = insert(:user)

      {:ok, auth} = OAuth.Authorization.create_authorization(app, user)

      {:ok, token} = OAuth.Token.exchange_token(app, auth)

      %{app: app, user: user, token: token}
    end

    test "accepts valid tokens", state do
      assert {:ok, _} = start_socket("?stream=user&access_token=#{state.token.token}")
    end

    test "accepts the 'user' stream", %{token: token} = _state do
      assert {:ok, _} = start_socket("?stream=user&access_token=#{token.token}")

      capture_log(fn ->
        assert {:error, %WebSockex.RequestError{code: 401}} = start_socket("?stream=user")
        Process.sleep(30)
      end)
    end

    test "accepts the 'user:notification' stream", %{token: token} = _state do
      assert {:ok, _} = start_socket("?stream=user:notification&access_token=#{token.token}")

      capture_log(fn ->
        assert {:error, %WebSockex.RequestError{code: 401}} =
                 start_socket("?stream=user:notification")

        Process.sleep(30)
      end)
    end

    test "accepts valid token on Sec-WebSocket-Protocol header", %{token: token} do
      assert {:ok, _} = start_socket("?stream=user", [{"Sec-WebSocket-Protocol", token.token}])

      capture_log(fn ->
        assert {:error, %WebSockex.RequestError{code: 401}} =
                 start_socket("?stream=user", [{"Sec-WebSocket-Protocol", "I am a friend"}])

        Process.sleep(30)
      end)
    end

    test "disconnect when token is revoked", %{app: app, user: user, token: token} do
      assert {:ok, _} = start_socket("?stream=user:notification&access_token=#{token.token}")
      assert {:ok, _} = start_socket("?stream=user&access_token=#{token.token}")

      {:ok, auth} = OAuth.Authorization.create_authorization(app, user)

      {:ok, token2} = OAuth.Token.exchange_token(app, auth)
      assert {:ok, _} = start_socket("?stream=user&access_token=#{token2.token}")

      OAuth.Token.Strategy.Revoke.revoke(token)

      assert_receive {:close, _}
      assert_receive {:close, _}
      refute_receive {:close, _}
    end
  end
end
