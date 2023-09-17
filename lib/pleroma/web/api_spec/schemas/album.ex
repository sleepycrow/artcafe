# Artcafe: Pleroma's dA-browsing, hawkash-shipping younger sister
# Copyright © 2023 Artcafe Authors <https://joinartcafe.org/>
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Pleroma.Web.ApiSpec.Schemas.Album do
  alias OpenApiSpex.Schema
  alias Pleroma.Web.ApiSpec.Schemas.Account
  alias Pleroma.Web.ApiSpec.Schemas.FlakeID

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "Album",
    description: "Represents an album",
    type: :object,
    properties: %{
      id: FlakeID,
      title: %Schema{type: :string, description: "The user-defined title of the album"},
      description: %Schema{type: :string, description: "The user-defined description of the album"},
      is_public: %Schema{type: :boolean, description: "Whether the album is public"},
      account: %Schema{allOf: [Account], description: "The account that created this album"}
    },
    example: %{
      "id" => "2ogB842GmVXw5D0YnWNQYQ",
      "title" => "HAWKFROSTxASHFUR CONTENT",
      "description" => "edgy cats kissing edgy cats kissing edgy cats kissing",
      "is_public" => true,
      "account" => %{
        "acct" => "nick6",
        "avatar" => "http://localhost:4001/images/avi.png",
        "avatar_static" => "http://localhost:4001/images/avi.png",
        "bot" => false,
        "created_at" => "2020-04-07T19:48:51.000Z",
        "display_name" => "Test テスト User 6",
        "emojis" => [],
        "fields" => [],
        "followers_count" => 1,
        "following_count" => 0,
        "header" => "http://localhost:4001/images/banner.png",
        "header_static" => "http://localhost:4001/images/banner.png",
        "id" => "9toJCsKN7SmSf3aj5c",
        "is_locked" => false,
        "note" => "Tester Number 6",
        "pleroma" => %{
          "background_image" => nil,
          "is_confirmed" => true,
          "hide_favorites" => true,
          "hide_followers" => false,
          "hide_followers_count" => false,
          "hide_follows" => false,
          "hide_follows_count" => false,
          "is_admin" => false,
          "is_moderator" => false,
          "relationship" => %{
            "blocked_by" => false,
            "blocking" => false,
            "domain_blocking" => false,
            "endorsed" => false,
            "followed_by" => false,
            "following" => true,
            "id" => "9toJCsKN7SmSf3aj5c",
            "muting" => false,
            "muting_notifications" => false,
            "note" => "",
            "requested" => false,
            "showing_reblogs" => true,
            "subscribing" => false,
            "notifying" => false
          },
          "skip_thread_containment" => false,
          "tags" => []
        },
      }
    }
  })
end
