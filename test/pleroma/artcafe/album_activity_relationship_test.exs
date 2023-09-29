# Artcafe: Pleroma's dA-browsing, hawkash-shipping younger sister
# Copyright © 2023 Artcafe Authors <https://joinartcafe.org/>
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Pleroma.Artcafe.AlbumActivityRelationshipTest do
  use Pleroma.DataCase, async: true
  import Pleroma.Factory
  alias Pleroma.Artcafe.AlbumActivityRelationship
  alias Pleroma.Web.CommonAPI

  describe "create/2" do
    test "with valid params" do
      user = insert(:user)
      album = insert(:album, user: user)

      {:ok, activity} = CommonAPI.post(user, %{status: "gayming moment"})
      {:ok, rel} = AlbumActivityRelationship.create(album.id, activity.id)

      assert rel.album_id == album.id
      assert rel.activity_id == activity.id
    end

    test "with invalid params" do
      {:error, changeset} = AlbumActivityRelationship.create(nil, "")
      refute changeset.valid?

      assert changeset.errors == [
               album_id: {"can't be blank", [validation: :required]},
               activity_id: {"can't be blank", [validation: :required]}
             ]
    end
  end

  describe "destroy/2" do
    test "deletes the given item" do
      user = insert(:user)
      album = insert(:album, user: user)

      {:ok, activity} = CommonAPI.post(user, %{status: "#ggameing"})
      {:ok, _} = AlbumActivityRelationship.create(album.id, activity.id)

      {:ok, _} = AlbumActivityRelationship.destroy(album.id, activity.id)
    end
  end

  describe "get/2" do
    test "gets a bookmark" do
      user = insert(:user)
      album = insert(:album, user: user)

      {:ok, activity} = CommonAPI.post(user, %{status: "rory ashfur"})
      {:ok, rel} = AlbumActivityRelationship.create(album.id, activity.id)

      assert rel == AlbumActivityRelationship.get(album.id, activity.id)
    end
  end

  describe "for_activity_query/1" do
    test "prepares a query that returns all albums, which a given activity is in" do
      user = insert(:user)
      {:ok, activity} = CommonAPI.post(user, %{status: "rory ashfur"})

      album1 = insert(:album, user: user)
      album2 = insert(:album, user: user)
      album3 = insert(:album, user: user)
      {:ok, rel1} = AlbumActivityRelationship.create(album1.id, activity.id)
      {:ok, rel2} = AlbumActivityRelationship.create(album2.id, activity.id)
      {:ok, rel3} = AlbumActivityRelationship.create(album3.id, activity.id)

      assert [rel1, rel2, rel3] == Repo.all(AlbumActivityRelationship.for_activity_query(activity.id))
    end
  end

  describe "for_album_query/1" do
    test "prepares a query that returns all activities within an album" do
      user = insert(:user)
      {:ok, activity1} = CommonAPI.post(user, %{status: "scientists discover why edgy cat man ashfur so edgy"})
      {:ok, activity2} = CommonAPI.post(user, %{status: "ashfur in gotye bodypaint screaming at squilf"})
      {:ok, activity3} = CommonAPI.post(user, %{status: "hawkash so perfect love these slimy grimbos"})

      album = insert(:album, user: user)
      {:ok, rel1} = AlbumActivityRelationship.create(album.id, activity1.id)
      {:ok, rel2} = AlbumActivityRelationship.create(album.id, activity2.id)
      {:ok, rel3} = AlbumActivityRelationship.create(album.id, activity3.id)

      assert [rel1, rel2, rel3] == Repo.all(AlbumActivityRelationship.for_album_query(album.id))
    end
  end
end
