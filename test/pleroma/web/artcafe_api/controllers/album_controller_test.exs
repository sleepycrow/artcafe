# Artcafe: Pleroma's dA-browsing, hawkash-shipping younger sister
# Copyright © 2023 Artcafe Authors <https://joinartcafe.org/>
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Pleroma.Web.ArtcafeAPI.AlbumControllerTest do
  use Pleroma.Web.ConnCase, async: false
  use Oban.Testing, repo: Pleroma.Repo

  alias Pleroma.Artcafe.Album
  alias Pleroma.Artcafe.AlbumActivityRelationship
  alias Pleroma.Activity
  alias Pleroma.Repo
  alias Pleroma.Web.CommonAPI

  import Pleroma.Factory

  setup do: oauth_access(["read:albums", "write:albums"])


  # ALBUM MANAGEMENT ###############################################################################
  describe "GET /api/v1/artcafe/albums/" do
    test "should let the user see their albums", %{user: user, conn: conn} do
      %Album{id: public_album_id} = insert(:album, user: user)
      %Album{id: private_album_id} = insert(:album, user: user, is_public: false)
      %Album{id: foreign_album_id} = insert(:album)

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> get("/api/v1/artcafe/albums")

      response = json_response_and_validate_schema(conn, 200)
      response_ids = Enum.map(response, fn album -> Map.get(album, "id") end)

      assert Enum.member?(response_ids, public_album_id)
      assert Enum.member?(response_ids, private_album_id)
      refute Enum.member?(response_ids, foreign_album_id)
    end
  end

  describe "POST /api/v1/artcafe/albums" do
    test "should let user create an album", %{conn: conn} do
      conn1 =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/api/v1/artcafe/albums", %{
          "title" => "undertlae sans",
          "description" => "getting that skeleton dick",
          "is_public" => true
        })

      assert %{"id" => first_id, "title" => "undertlae sans", "description" => "getting that skeleton dick", "is_public" => true} =
             json_response_and_validate_schema(conn1, 200)
      assert Album.get_by_id(first_id)

      conn2 =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/api/v1/artcafe/albums", %{
          "title" => "snas undertalle"
        })

      assert %{"id" => second_id, "title" => "snas undertalle", "description" => nil, "is_public" => false} =
             json_response_and_validate_schema(conn2, 200)
      assert Album.get_by_id(second_id)
    end

    test "should not let user create an album when signed out" do
      conn =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> post("/api/v1/artcafe/albums", %{
          "title" => "undertlae sans",
          "description" => "getting that skeleton dick",
          "is_public" => true
        })

      json_response(conn, 403) # there literally is what the fuck do you mean you can't find it aaaaaaaaaa
    end
  end

  describe "GET /api/v1/artcafe/albums/:id" do
    test "should let user view info about album owned by them", %{user: user, conn: conn} do
      %Album{id: album_id} = insert(:album, user: user, is_public: false)

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> get("/api/v1/artcafe/albums/#{album_id}")

      assert %{"id" => ^album_id, "title" => "bird album", "description" => "bird bird bird bird bird", "is_public" => false}
             = json_response_and_validate_schema(conn, 200)
    end

    test "should let user view info about public album", %{conn: conn} do
      %Album{id: album_id} = insert(:album, is_public: true)

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> get("/api/v1/artcafe/albums/#{album_id}")

      assert %{"id" => ^album_id, "title" => "bird album", "description" => "bird bird bird bird bird", "is_public" => true}
             = json_response_and_validate_schema(conn, 200)
    end

    test "should not let user view info about someone else's private album", %{conn: conn} do
      %Album{id: album_id} = insert(:album, is_public: false)

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> get("/api/v1/artcafe/albums/#{album_id}")

      json_response_and_validate_schema(conn, 404)
    end
  end

  describe "PATCH /api/v1/artcafe/albums/:id" do
    test "should let user edit an album owned by them", %{user: user, conn: conn} do
      %Album{id: album_id} = insert(:album, user: user)

      assert %Album{title: "bird album", description: "bird bird bird bird bird", is_public: true}
             = Album.get_by_id(album_id)

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> patch("/api/v1/artcafe/albums/#{album_id}", %{
          "title" => "gaming album",
          "description" => "gaming gaming gaming gaming gaming",
          "is_public" => true
        })

      assert %{"id" => ^album_id, "title" => "gaming album", "description" => "gaming gaming gaming gaming gaming", "is_public" => true}
             = json_response_and_validate_schema(conn, 200)

      assert %Album{id: ^album_id, title: "gaming album", description: "gaming gaming gaming gaming gaming", is_public: true}
             = Album.get_by_id(album_id)
    end

    test "should not let user edit an album that is owned by someone else", %{conn: conn} do
      %Album{id: album_id} = insert(:album)
      assert %Album{title: "bird album", description: "bird bird bird bird bird", is_public: true}
             = Album.get_by_id(album_id)

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> patch("/api/v1/artcafe/albums/#{album_id}", %{
          "title" => "gaming album",
          "description" => "gaming gaming gaming gaming gaming",
          "is_public" => true
        })

      json_response_and_validate_schema(conn, 403)
      assert %Album{title: "bird album", description: "bird bird bird bird bird", is_public: true}
             = Album.get_by_id(album_id)
    end
  end

  describe "DELETE /api/v1/artcafe/albums/:id" do
    test "should let user delete an album owned by them", %{user: user, conn: conn} do
      %Album{id: album_id} = insert(:album, user: user)

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> delete("/api/v1/artcafe/albums/#{album_id}")

      json_response_and_validate_schema(conn, 200)
      refute Album.get_by_id(album_id)
    end

    test "should not let user delete an album owned by someone else", %{conn: conn} do
      %Album{id: album_id} = insert(:album)

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> delete("/api/v1/artcafe/albums/#{album_id}")

      json_response_and_validate_schema(conn, 403)
      assert Album.get_by_id(album_id)
    end
  end

  describe "GET /api/v1/artcafe/accounts/:id/albums" do
    test "should let user see any user's public albums", %{conn: conn} do
      # GIVEN
      other_user = insert(:user)

      insert(:album, is_public: true)
      insert(:album, user: other_user, is_public: false)
      %Album{id: public_album_id_1} = insert(:album, user: other_user, is_public: true)
      %Album{id: public_album_id_2} = insert(:album, user: other_user, is_public: true)

      # WHEN
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> get("/api/v1/artcafe/accounts/#{other_user.nickname}/albums")

      # THEN
      resp = json_response_and_validate_schema(conn, 200)
      assert [^public_album_id_1, ^public_album_id_2] = Enum.map(resp, fn album -> Map.get(album, "id") end)
    end
  end

  # ALBUM CONTENT MANAGEMENT #######################################################################
  describe "GET /api/v1/artcafe/albums/:id/content" do
    test "should let user see contents of albums they have access to", %{user: user, conn: conn} do
      # GIVEN
      %Album{id: album1_id} = insert(:album, is_public: true)
      %Album{id: album2_id} = insert(:album, user: user, is_public: false)

      {:ok, %Activity{id: activity1_id}} = CommonAPI.post(user, %{status: "heweoo?"})
      {:ok, %Activity{id: activity2_id}} = CommonAPI.post(user, %{status: "heweoo!"})

      {:ok, _} = AlbumActivityRelationship.create(album1_id, activity1_id)
      {:ok, _} = AlbumActivityRelationship.create(album1_id, activity2_id)

      {:ok, _} = AlbumActivityRelationship.create(album2_id, activity2_id)
      {:ok, _} = AlbumActivityRelationship.create(album2_id, activity1_id)

      # WHEN
      conn1 =
        conn
        |> put_req_header("content-type", "application/json")
        |> get("/api/v1/artcafe/albums/#{album1_id}/content")

      conn2 =
        conn
        |> put_req_header("content-type", "application/json")
        |> get("/api/v1/artcafe/albums/#{album2_id}/content")

      # THEN
      resp1 = json_response_and_validate_schema(conn1, 200)
      assert [^activity2_id, ^activity1_id] = Enum.map(resp1, fn activity -> Map.get(activity, "id") end)

      resp2 = json_response_and_validate_schema(conn2, 200)
      assert [^activity1_id, ^activity2_id] = Enum.map(resp2, fn activity -> Map.get(activity, "id") end)
    end

    test "should not let the user see contents of albums they don't have access to", %{user: user, conn: conn} do
      # GIVEN
      %Album{id: album_id} = insert(:album, is_public: false)

      {:ok, %Activity{id: activity1_id}} = CommonAPI.post(user, %{status: "heweoo?"})
      {:ok, %Activity{id: activity2_id}} = CommonAPI.post(user, %{status: "heweoo!"})

      {:ok, _} = AlbumActivityRelationship.create(album_id, activity1_id)
      {:ok, _} = AlbumActivityRelationship.create(album_id, activity2_id)

      # WHEN
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> get("/api/v1/artcafe/albums/#{album_id}/content")

      # THEN
      json_response_and_validate_schema(conn, 404)
    end

    test "should only let the user see the statuses they have access to", %{user: user, conn: conn} do
      # for clarity's sake, this means the endpoint should NOT show the user things such as
      # followers-only statuses of people they don't follow or DMs not addressed to them, even if they are
      # in a list the user does have access to. such items should just be quietly ommited for said user.

      # GIVEN
      %Album{id: album_id} = insert(:album, is_public: true)

      other_user = insert(:user)
      {:ok, %Activity{id: own_dm_id}} = CommonAPI.post(user, %{status: "yo can i get uhhhhh fortnite", visibility: "direct"})
      {:ok, %Activity{id: hidden_dm_id}} = CommonAPI.post(other_user, %{status: "heweoo?", visibility: "direct"})
      {:ok, %Activity{id: followers_post_id}} = CommonAPI.post(other_user, %{status: "heweoo!", visibility: "private"})

      {:ok, _} = AlbumActivityRelationship.create(album_id, followers_post_id)
      {:ok, _} = AlbumActivityRelationship.create(album_id, own_dm_id)
      {:ok, _} = AlbumActivityRelationship.create(album_id, hidden_dm_id)

      # WHEN
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> get("/api/v1/artcafe/albums/#{album_id}/content")

      # THEN
      resp = json_response_and_validate_schema(conn, 200)
      assert [^own_dm_id] = Enum.map(resp, fn activity -> Map.get(activity, "id") end)
    end
  end

  describe "POST /api/v1/artcafe/albums/:id/content" do
    test "should let the user add content to an album they own", %{user: user, conn: conn} do
      album = insert(:album, user: user)
      %Album{id: album_id} = album
      {:ok, %Activity{id: activity_id}} = CommonAPI.post(user, %{status: "heweoo?"})

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/api/v1/artcafe/albums/#{album_id}/content", %{id: activity_id})

      json_response_and_validate_schema(conn, 200)
      assert [%AlbumActivityRelationship{activity_id: ^activity_id}] = Repo.all(Album.get_items_query(album))
    end

    test "should not let the user add content to an album they don't own", %{user: user, conn: conn} do
      album = insert(:album)
      %Album{id: album_id} = album
      {:ok, %Activity{id: activity_id}} = CommonAPI.post(user, %{status: "heweoo?"})

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> post("/api/v1/artcafe/albums/#{album_id}/content", %{id: activity_id})

      json_response_and_validate_schema(conn, 403)
      assert [] = Repo.all(Album.get_items_query(album))
    end
  end

  describe "DELETE /api/v1/artcafe/albums/:id/content" do
    test "should let the user delete content from an album they own", %{user: user, conn: conn} do
      album = insert(:album, user: user)
      %Album{id: album_id} = album
      {:ok, %Activity{id: activity_id}} = CommonAPI.post(user, %{status: "heweoo?"})
      {:ok, _} = AlbumActivityRelationship.create(album_id, activity_id)

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> delete("/api/v1/artcafe/albums/#{album_id}/content", %{id: activity_id})

      json_response_and_validate_schema(conn, 200)
      assert [] = Repo.all(Album.get_items_query(album))
    end

    test "should not let the user delete content from an album they don't own", %{user: user, conn: conn} do
      album = insert(:album)
      %Album{id: album_id} = album
      {:ok, %Activity{id: activity_id}} = CommonAPI.post(user, %{status: "heweoo?"})
      {:ok, _} = AlbumActivityRelationship.create(album_id, activity_id)

      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> delete("/api/v1/artcafe/albums/#{album_id}/content", %{id: activity_id})

      json_response_and_validate_schema(conn, 403)
      assert [%AlbumActivityRelationship{activity_id: ^activity_id}] = Repo.all(Album.get_items_query(album))
    end
  end

  describe "GET /api/v1/artcafe/statuses/:id/albums" do
    test "should let user see their albums that contain a given post", %{user: user, conn: conn} do
      # GIVEN
      %Album{id: user_album_id} = insert(:album, user: user, is_public: false)
      %Album{id: foreign_album_id} = insert(:album, is_public: true)

      {:ok, %Activity{id: activity_id}} = CommonAPI.post(user, %{status: "heweoo?"})

      {:ok, _} = AlbumActivityRelationship.create(user_album_id, activity_id)
      {:ok, _} = AlbumActivityRelationship.create(foreign_album_id, activity_id)

      # WHEN
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> get("/api/v1/artcafe/statuses/#{activity_id}/albums")

      # THEN
      resp = json_response_and_validate_schema(conn, 200)
      assert [^user_album_id] = Enum.map(resp, fn album -> Map.get(album, "id") end)
    end
  end
end
