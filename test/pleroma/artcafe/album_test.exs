# Artcafe: Pleroma's dA-browsing, hawkash-shipping younger sister
# Copyright © 2023 Artcafe Authors <https://joinartcafe.org/>
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Pleroma.Artcafe.AlbumTest do
  #alias Pleroma.Repo
  alias Pleroma.Artcafe.Album
  use Pleroma.DataCase, async: true

  import Pleroma.Factory

  describe "create/2" do
    test "creates an album" do
      user = insert(:user)

      {:ok, %Album{} = album} = Album.create(user, %{
        title: "test album",
        description: "test description",
        is_public: true
      })

      assert album == Album.get_by_id(album.id)
    end

    test "fails when given no title or a blank title" do
      user = insert(:user)

      assert {:error, changeset} = Album.create(user, %{
        title: "",
        description: "asd",
        is_public: true
      })
      assert changeset.errors == [title: {"can't be blank", [validation: :required]}]
    end
  end

  describe "update/2" do
    test "updates an album's info" do
      album = insert(:album)

      assert {:ok, %Album{title: title, description: description, is_public: is_public}}
             = Album.update(album, %{title: "werewolf cute", description: "long hair all saints street cute", is_public: false})
      assert "werewolf cute" == title
      assert "long hair all saints street cute" == description
      assert false == is_public
    end

    test "(also) fails when given a blank title" do
      album = insert(:album)

      assert {:error, changeset} = Album.update(album, %{ title: "" })
      assert changeset.errors == [title: {"can't be blank", [validation: :required]}]
    end
  end

  describe "delete/1" do
    test "deletes an album" do
      album = insert(:album)

      {:ok, _} = Album.delete(album)
      assert is_nil(Album.get_by_id(album.id))
    end
  end

  describe "all_by_user/1" do
    test "returns all the albums owned by a given user" do
      user = insert(:user)
      album1 = insert(:album, user: user, is_public: true)
      album2 = insert(:album, user: user, is_public: false)
      _someone_elses_album = insert(:album)

      albums = Album.all_by_user(user)
      assert [album1.id, album2.id] == Enum.map(albums, fn album -> album.id end)
    end
  end

  describe "public_by_user/1" do
    test "returns only the public albums owned by a given user" do
      user = insert(:user)
      album1 = insert(:album, user: user, is_public: true)
      album2 = insert(:album, user: user, is_public: true)
      _private_album = insert(:album, user: user, is_public: false)

      albums = Album.public_by_user(user)
      assert [album1.id, album2.id] == Enum.map(albums, fn album -> album.id end)
    end
  end

  describe "get_by_id/1" do
    test "returns the album by the given id" do
      insert(:album, is_public: true)
      %Album{id: album_id} = insert(:album, is_public: false)

      assert %Album{id: ^album_id} = Album.get_by_id(album_id)
    end

    test "returns nil if no album with the given id exists" do
      insert(:album, is_public: true)
      insert(:album, is_public: false)

      assert nil == Album.get_by_id("asdasd")
    end
  end

  describe "is_owned_by?/2" do
    test "returns true if the album is owned by the user" do
      user = insert(:user)
      album = insert(:album, user: user)

      assert Album.is_owned_by?(album, user)
    end

    test "returns false if the album is not owned by the user" do
      user = insert(:user)
      album = insert(:album)

      refute Album.is_owned_by?(album, user)
    end
  end

  describe "is_visible_for?/2" do
    test "returns true if the album is owned by the user" do
      user = insert(:user)
      album = insert(:album, user: user, is_public: false)

      assert Album.is_visible_for?(album, user)
    end

    test "returns true if the album is public" do
      user = insert(:user)
      album = insert(:album, is_public: true)

      assert Album.is_visible_for?(album, user)
    end

    test "returns false if the album is private and not owned by the user" do
      user = insert(:user)
      album = insert(:album, is_public: false)

      refute Album.is_owned_by?(album, user)
    end
  end
end
