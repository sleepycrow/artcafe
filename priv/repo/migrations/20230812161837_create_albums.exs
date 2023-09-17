# Artcafe: Pleroma's dA-browsing, hawkash-shipping younger sister
# Copyright © 2023 Artcafe Authors <https://joinartcafe.org/>
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Pleroma.Repo.Migrations.CreateAlbums do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:albums, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string
      add :description, :text
      add :is_public, :boolean, default: false
      add :user_id, references(:users, type: :uuid, on_delete: :nothing), null: false

      timestamps()
    end

    create_if_not_exists table(:album_activity_relationships) do
      add :album_id, references(:albums, type: :uuid, on_delete: :delete_all)
      add :activity_id, references(:activities, type: :uuid, on_delete: :delete_all)

      timestamps()
    end

    create index(:albums, [:user_id])
    create_if_not_exists unique_index(:album_activity_relationships, [:album_id, :activity_id])
  end
end
