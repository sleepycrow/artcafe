# Artcafe: Pleroma's dA-browsing, hawkash-shipping younger sister
# Copyright © 2023 Artcafe Authors <https://joinartcafe.org/>
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Pleroma.Web.ApiSpec.Schemas.Album do
  alias OpenApiSpex.Schema
  alias Pleroma.Web.ApiSpec.Schemas.FlakeID

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Album",
    description: "Represents an album",
    type: :object,
    properties: %{
      id: FlakeID,
      title: %Schema{type: :string, description: "The user-defined title of the album"},
      is_public: %Schema{type: :boolean, description: "Whether the album is public"},
    },
    example: %{
      "id" => "2ogB842GmVXw5D0YnWNQYQ",
      "title" => "Favorites",
      "is_public" => true
    }
  })
end
