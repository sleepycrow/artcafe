# Artcafe: Pleroma's dA-browsing, hawkash-shipping younger sister
# Copyright © 2023 Artcafe Authors <https://joinartcafe.org/>
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Pleroma.Web.ArtcafeAPI.AlbumController do
  use Pleroma.Web, :controller

  import Pleroma.Web.TranslationHelpers
  import Pleroma.Web.ControllerHelper, only: [add_link_headers: 2]

  alias Pleroma.User
  alias Pleroma.Activity
  alias Pleroma.Web.ActivityPub.Visibility
  alias Pleroma.Web.Plugs.OAuthScopesPlug
  alias Pleroma.Artcafe.Album
  alias Pleroma.Artcafe.AlbumActivityRelationship


  @unauthenticated_access %{fallback: :proceed_unauthenticated, scopes: []}

  @oauth_read_actions [:index, :get_user_albums_for_status]
  @oauth_unauthenticated_read_actions [:show, :public_albums, :get_items]
  @oauth_write_actions [:create, :update, :delete, :add_item, :remove_item]
  plug(Pleroma.Web.ApiSpec.CastAndValidate)
  plug(OAuthScopesPlug, %{scopes: ["read:albums"]} when action in @oauth_read_actions)
  plug(OAuthScopesPlug, %{@unauthenticated_access | scopes: ["read:albums"]} when action in @oauth_unauthenticated_read_actions)
  plug(OAuthScopesPlug, %{scopes: ["write:albums"]} when action in @oauth_write_actions)

  plug(:album_by_id_and_user when action in [:show, :update, :delete, :get_items, :add_item, :remove_item])
  plug(:requires_album_ownership when action in [:update, :delete, :add_item, :remove_item])

  action_fallback(Pleroma.Web.MastodonAPI.FallbackController)

  defdelegate open_api_operation(action), to: Pleroma.Web.ApiSpec.ArtcafeAlbumOperation

  # GET /api/v1/artcafe/albums
  def index(%{assigns: %{user: reading_user}} = conn, _) do
    albums = Pleroma.Artcafe.Album.all_by_user(reading_user)
    render(conn, "index.json", albums: albums, for: reading_user)
  end

  # POST /api/v1/artcafe/albums
  def create(%{assigns: %{user: reading_user}, body_params: params} = conn, _) do
    with {:ok, %Pleroma.Artcafe.Album{} = album} <- Pleroma.Artcafe.Album.create(reading_user, params) do
      render(conn, "show.json", album: album, for: reading_user)
    end
  end

  # GET /api/v1/artcafe/albums/:id
  def show(%{assigns: %{user: reading_user, album: album}} = conn, _) do
    render(conn, "show.json", album: album, for: reading_user)
  end

  # PATCH /api/v1/artcafe/albums/:id
  def update(%{assigns: %{user: reading_user, album: album}, body_params: params} = conn, _) do
    with {:ok, album} <- Pleroma.Artcafe.Album.update(album, params) do
      render(conn, "show.json", album: album, for: reading_user)
    else
      _ -> render_error(conn, :internal_server_error, "Unexpected error occurred.")
    end
  end

  # DELETE /api/v1/artcafe/albums/:id
  def delete(%{assigns: %{album: album}} = conn, _) do
    with {:ok, _album} <- Pleroma.Artcafe.Album.delete(album) do
      json(conn, %{})
    else
      _ -> render_error(conn, :internal_server_error, "Unexpected error occurred.")
    end
  end

  # GET /api/v1/artcafe/accounts/:id/albums
  def get_public_albums_for_user(%{assigns: %{user: reading_user}} = conn, %{id: id}) do
    with %User{} = user <- User.get_cached_by_nickname_or_id(id, for: reading_user),
         :visible <- User.visible_for(user, reading_user) do
      albums = Pleroma.Artcafe.Album.public_by_user(user)
      render(conn, "index.json", albums: albums, for: reading_user)
    else
      _ -> render_error(conn, :not_found, "User not found")
    end
  end

  # GET /api/v1/artcafe/statuses/:id/albums
  def get_user_albums_for_status(%{assigns: %{user: reading_user}} = conn, %{id: activity_id}) do
    with %Activity{} = activity <- Activity.get_by_id_with_object(activity_id),
         true <- Visibility.visible_for_user?(activity, reading_user) do
      albums = Pleroma.Artcafe.Album.get_user_albums_for_activity(activity_id, reading_user)
      render(conn, "index.json", albums: albums, for: reading_user)
    else
      _ -> render_error(conn, :not_found, "Status not found")
    end
  end

  # GET /api/v1/artcafe/albums/:id/content
  def get_items(%{assigns: %{user: reading_user, album: album}} = conn, params) do
    items =
      Album.get_items_for_user_query(album, reading_user)
      |> Pleroma.Pagination.fetch_paginated(params)

    activities = Enum.map(items, fn rel -> rel.activity end)

    conn
    |> add_link_headers(items)
    |> render("content.json", activities: activities, for: reading_user, as: :activity)
  end

  # POST /api/v1/artcafe/albums/:id/content
  def add_item(%{assigns: %{album: album, user: reading_user}, body_params: %{id: activity_id}} = conn, _) do
    with %Activity{} = activity <- Activity.get_by_id_with_object(activity_id),
         true <- Visibility.visible_for_user?(activity, reading_user),
         {:ok, _} <- AlbumActivityRelationship.create(album.id, activity.id) do
      json(conn, %{})
    else
      nil -> render_error(conn, :not_found, "Activity not found")
      _ -> render_error(conn, :internal_server_error, "Unexpected error occurred.")
    end
  end

  # DELETE /api/v1/artcafe/albums/:id/content
  def remove_item(%{assigns: %{album: album, user: reading_user}, body_params: %{id: activity_id}} = conn, _) do
    with %Activity{} = activity <- Activity.get_by_id_with_object(activity_id),
         true <- Visibility.visible_for_user?(activity, reading_user),
         {:ok, _} <- AlbumActivityRelationship.destroy(album.id, activity.id) do
      json(conn, %{})
    else
      nil -> render_error(conn, :not_found, "Activity not found")
      _ -> render_error(conn, :internal_server_error, "Unexpected error occurred.")
    end
  end

  defp album_by_id_and_user(%{assigns: %{user: reading_user}, params: %{id: id}} = conn, _) do
    with %Pleroma.Artcafe.Album{} = album <- Pleroma.Artcafe.Album.get_by_id(id),
         true <- Pleroma.Artcafe.Album.is_visible_for?(album, reading_user) do
      assign(conn, :album, album)
    else
      _ -> render_error(conn, :not_found, "Album not found") |> halt()
    end
  end

  defp requires_album_ownership(%{assigns: %{user: reading_user, album: album}} = conn, _) do
    case Album.is_owned_by?(album, reading_user) do
      true -> conn
      false -> render_error(conn, :forbidden, "No permission to edit album") |> halt()
    end
  end
end
