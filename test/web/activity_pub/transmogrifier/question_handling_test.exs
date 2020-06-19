# Pleroma: A lightweight social networking server
# Copyright © 2017-2020 Pleroma Authors <https://pleroma.social/>
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Pleroma.Web.ActivityPub.Transmogrifier.QuestionHandlingTest do
  use Pleroma.DataCase

  alias Pleroma.Activity
  alias Pleroma.Object
  alias Pleroma.Web.ActivityPub.Transmogrifier

  setup_all do
    Tesla.Mock.mock_global(fn env -> apply(HttpRequestMock, :request, [env]) end)
    :ok
  end

  test "Mastodon Question activity" do
    data = File.read!("test/fixtures/mastodon-question-activity.json") |> Poison.decode!()

    {:ok, %Activity{local: false} = activity} = Transmogrifier.handle_incoming(data)

    object = Object.normalize(activity, false)

    assert object.data["closed"] == "2019-05-11T09:03:36Z"

    assert object.data["context"] ==
             "tag:mastodon.sdf.org,2019-05-10:objectId=15095122:objectType=Conversation"

    assert object.data["context_id"]

    assert object.data["anyOf"] == []

    assert Enum.sort(object.data["oneOf"]) ==
             Enum.sort([
               %{
                 "name" => "25 char limit is dumb",
                 "replies" => %{"totalItems" => 0, "type" => "Collection"},
                 "type" => "Note"
               },
               %{
                 "name" => "Dunno",
                 "replies" => %{"totalItems" => 0, "type" => "Collection"},
                 "type" => "Note"
               },
               %{
                 "name" => "Everyone knows that!",
                 "replies" => %{"totalItems" => 1, "type" => "Collection"},
                 "type" => "Note"
               },
               %{
                 "name" => "I can't even fit a funny",
                 "replies" => %{"totalItems" => 1, "type" => "Collection"},
                 "type" => "Note"
               }
             ])
  end

  test "returns an error if received a second time" do
    data = File.read!("test/fixtures/mastodon-question-activity.json") |> Poison.decode!()

    assert {:ok, %Activity{local: false} = activity} = Transmogrifier.handle_incoming(data)

    assert {:error, {:validate_object, {:error, _}}} = Transmogrifier.handle_incoming(data)
  end
end
