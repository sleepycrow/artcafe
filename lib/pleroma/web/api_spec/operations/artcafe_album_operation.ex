# Artcafe: Pleroma's dA-browsing, hawkash-shipping younger sister
# Copyright © 2023 Artcafe Authors <https://joinartcafe.org/>
# SPDX-License-Identifier: AGPL-3.0-only

#TODO: document (& refine) the responses, they're not accurate

defmodule Pleroma.Web.ApiSpec.ArtcafeAlbumOperation do
  alias OpenApiSpex.Operation
  alias OpenApiSpex.Reference
  alias OpenApiSpex.Schema
  alias Pleroma.Web.ApiSpec.Schemas.ApiError
  alias Pleroma.Web.ApiSpec.Schemas.FlakeID
  alias Pleroma.Web.ApiSpec.Schemas.Album
  alias Pleroma.Web.ApiSpec.Schemas.Status

  import Pleroma.Web.ApiSpec.Helpers

  def open_api_operation(action) do
    operation = String.to_existing_atom("#{action}_operation")
    apply(__MODULE__, operation, [])
  end

  def index_operation do
    %Operation{
      tags: ["Albums"],
      summary: "Retrieve a list of albums",
      description: "Fetch all albums that the user owns",
      security: [%{"oAuth" => ["read:albums"]}],
      operationId: "AlbumController.index",
      responses: %{
        200 => Operation.response("Array of Album", "application/json", array_of_albums())
      }
    }
  end

  def create_operation do
    %Operation{
      tags: ["Albums"],
      summary: "Create an album",
      description: "Create an album",
      operationId: "AlbumController.create",
      requestBody: request_body(
        "Parameters",
        %Schema{
          description: "POST body for creating a new album",
          type: :object,
          properties: %{
            title: %Schema{type: :string, description: "Album title"},
            is_public: %Schema{type: :boolean, description: "Whether the list should be public", default: false}
          },
          required: [:title]
        },
        required: true
      ),
      security: [%{"oAuth" => ["write:albums"]}],
      responses: %{
        200 => Operation.response("Album", "application/json", Album),
        400 => Operation.response("Error", "application/json", ApiError),
        404 => Operation.response("Error", "application/json", ApiError)
      }
    }
  end

  def show_operation do
    %Operation{
      tags: ["Albums"],
      summary: "Retrieve info about an album",
      description: "Retrieve info about an album",
      operationId: "AlbumController.show",
      parameters: [album_id_param()],
      security: [%{"oAuth" => ["read:albums"]}],
      responses: %{
        200 => Operation.response("Album", "application/json", Album),
        404 => Operation.response("Error", "application/json", ApiError)
      }
    }
  end

  def update_operation do
    %Operation{
      tags: ["Albums"],
      summary: "Update album info",
      description: "Update album info",
      operationId: "AlbumController.update",
      parameters: [album_id_param()],
      requestBody: request_body(
        "Parameters",
        %Schema{
          description: "POST body for updating an album",
          type: :object,
          properties: %{
            title: %Schema{type: :string, description: "Album title"},
            is_public: %Schema{type: :boolean, description: "Whether the list should be public"}
          },
          required: []
        },
        required: true
      ),
      security: [%{"oAuth" => ["write:albums"]}],
      responses: %{
        200 => Operation.response("Album", "application/json", Album),
        422 => Operation.response("Error", "application/json", ApiError)
      }
    }
  end

  def delete_operation do
    %Operation{
      tags: ["Albums"],
      summary: "Delete an album",
      operationId: "AlbumController.delete",
      parameters: [album_id_param()],
      security: [%{"oAuth" => ["write:albums"]}],
      responses: %{
        200 => Operation.response("Empty object", "application/json", %Schema{type: :object})
      }
    }
  end

  def get_public_albums_for_user_operation do
    %Operation{
      tags: ["Albums"],
      summary: "Retrieve a list of albums for a user",
      description: "Fetch all public albums that the given user owns",
      security: [%{"oAuth" => ["read:albums"]}],
      operationId: "AlbumController.get_public_albums_for_user",
      parameters: [
        %Reference{"$ref": "#/components/parameters/accountIdOrNickname"}
      ],
      responses: %{
        200 => Operation.response("Array of Album", "application/json", array_of_albums())
      }
    }
  end

  def get_user_albums_for_status_operation do
    %Operation{
      tags: ["Albums"],
      summary: "Retrieve a list of albums for a given status",
      description: "Fetch all albums the current user owns that contain the given status",
      security: [%{"oAuth" => ["read:albums"]}],
      operationId: "AlbumController.get_user_albums_for_status",
      parameters: [
        Operation.parameter(:id, :path, FlakeID, "Status ID",
          example: "9umDrYheeY451cQnEe",
          required: true
        )
      ],
      responses: %{
        200 => Operation.response("Array of Album", "application/json", array_of_albums())
      }
    }
  end

  def get_items_operation do
    %Operation{
      tags: ["Albums"],
      summary: "Get activities in album",
      description: "Gets the activities in a given",
      operationId: "AlbumController.get_items",
      parameters: [album_id_param() | pagination_params()],
      security: [%{"oAuth" => ["read:albums"]}],
      responses: %{
        200 => Operation.response("Status", "application/json", Status)
      }
    }
  end

  def add_item_operation do
    %Operation{
      tags: ["Albums"],
      summary: "Add activity to album",
      description: "Adds the specified activity to an album owned by you",
      operationId: "AlbumController.add_item",
      parameters: [album_id_param()],
      requestBody: add_remove_item_body(),
      security: [%{"oAuth" => ["write:albums"]}],
      responses: %{
        200 => Operation.response("Empty object", "application/json", %Schema{type: :object})
      }
    }
  end

  def remove_item_operation do
    %Operation{
      tags: ["Albums"],
      summary: "Add activity to album",
      description: "Adds the specified activity to an album owned by you",
      operationId: "AlbumController.remove_item",
      parameters: [album_id_param()],
      requestBody: add_remove_item_body(),
      security: [%{"oAuth" => ["write:albums"]}],
      responses: %{
        200 => Operation.response("Empty object", "application/json", %Schema{type: :object})
      }
    }
  end

  defp array_of_albums do
    %Schema{
      title: "ArrayOfAlbums",
      description: "Response schema for albums",
      type: :array,
      items: Album,
      example: [
        %{"id" => "2ogB842GmVXw5D0YnWNQYQ", "title" => "Favorites", "is_public" => true},
        %{"id" => "AYkuNPgUEB8qG2JBHk", "title" => "Best of the best", "is_public" => false}
      ]
    }
  end

  defp album_id_param do
    Operation.parameter(:id, :path, FlakeID, "Album ID",
      example: "9umDrYheeY451cQnEe",
      required: true
    )
  end

  defp add_remove_item_body do
    request_body(
      "Parameters",
      %Schema{
        description: "POST body for adding/removing an item from an album",
        type: :object,
        properties: %{
          id: FlakeID
        },
        required: []
      },
      required: true
    )
  end
end
