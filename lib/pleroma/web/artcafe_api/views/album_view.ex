# Artcafe: Pleroma's dA-browsing, hawkash-shipping younger sister
# Copyright © 2023 Artcafe Authors <https://joinartcafe.org/>
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Pleroma.Web.ArtcafeAPI.AlbumView do
  use Pleroma.Web, :view

  alias Pleroma.Web.ArtcafeAPI.AlbumView
  alias Pleroma.Web.MastodonAPI.StatusView

  def render("index.json", %{albums: albums} = opts) do
    render_many(albums, AlbumView, "show.json", opts)
  end

  def render("show.json", %{album: album}) do
    %{
      id: to_string(album.id),
      title: album.title,
      is_public: album.is_public
    }
  end

  def render("content.json", params) do
    StatusView.render("index.json", params)
  end
end
