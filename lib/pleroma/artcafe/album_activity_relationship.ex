# Artcafe: Pleroma's dA-browsing, hawkash-shipping younger sister
# Copyright © 2023 Artcafe Authors <https://joinartcafe.org/>
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Pleroma.Artcafe.AlbumActivityRelationship do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias Pleroma.Artcafe.AlbumActivityRelationship
  alias Pleroma.Artcafe.Album
  alias Pleroma.Activity
  alias Pleroma.Repo

  @type t :: %__MODULE__{}

  schema "album_activity_relationships" do
    belongs_to :album, Album, type: FlakeId.Ecto.CompatType
    belongs_to :activity, Activity, type: FlakeId.Ecto.CompatType

    timestamps()
  end

  @spec create(FlakeId.Ecto.CompatType.t(), FlakeId.Ecto.CompatType.t()) ::
          {:ok, AlbumActivityRelationship.t()} | {:error, Changeset.t()}
  def create(album_id, activity_id) do
    attrs = %{
      album_id: album_id,
      activity_id: activity_id
    }

    %Pleroma.Artcafe.AlbumActivityRelationship{}
    |> cast(attrs, [:album_id, :activity_id])
    |> validate_required([:album_id, :activity_id])
    |> unique_constraint([:album_id, :activity_id], name: :album_activity_relationships_album_id_activity_id_index)
    |> Repo.insert()
  end

  @spec for_album_query(FlakeId.Ecto.CompatType.t()) :: Ecto.Query.t()
  def for_album_query(album_id) do
    from(
      r in Pleroma.Artcafe.AlbumActivityRelationship,
      where: r.album_id == ^album_id,
      order_by: [desc: r.inserted_at],
      join: activity in Activity,
      on: activity.id == r.activity_id,
    )
  end

  @spec for_activity_query(FlakeId.Ecto.CompatType.t()) :: Ecto.Query.t()
  def for_activity_query(activity_id) do
    from(
      r in Pleroma.Artcafe.AlbumActivityRelationship,
      where: r.activity_id == ^activity_id,
      order_by: [desc: r.inserted_at],
      join: album in Album,
      on: album.id == r.album_id,
    )
  end

  def get(album_id, activity_id) do
    Pleroma.Artcafe.AlbumActivityRelationship
    |> where(album_id: ^album_id)
    |> where(activity_id: ^activity_id)
    |> Repo.one()
  end

  @spec destroy(FlakeId.Ecto.CompatType.t(), FlakeId.Ecto.CompatType.t()) ::
          {:ok, AlbumActivityRelationship.t()} | {:error, Changeset.t()}
  def destroy(album_id, activity_id) do
    from(relation in AlbumActivityRelationship,
      where: relation.album_id == ^album_id,
      where: relation.activity_id == ^activity_id
    )
    |> Repo.one()
    |> Repo.delete()
  end
end
