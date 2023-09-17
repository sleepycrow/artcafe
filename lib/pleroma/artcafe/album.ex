# Artcafe: Pleroma's dA-browsing, hawkash-shipping younger sister
# Copyright © 2023 Artcafe Authors <https://joinartcafe.org/>
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Pleroma.Artcafe.Album do
  use Ecto.Schema

  import Pleroma.Web.ActivityPub.Utils, only: [as_local_public: 0]
  import Ecto.Query
  import Ecto.Changeset

  alias Pleroma.Artcafe.AlbumActivityRelationship
  alias Pleroma.Constants
  alias Pleroma.Repo
  alias Pleroma.User
  alias Pleroma.Activity

  require Pleroma.Constants

  @type t :: %__MODULE__{}
  @primary_key {:id, FlakeId.Ecto.CompatType, autogenerate: true}

  schema "albums" do
    field :title, :string
    field :description, :string
    field :is_public, :boolean
    belongs_to :user, User, type: FlakeId.Ecto.CompatType
    many_to_many :activities, Activity, join_through: "album_activity_relationships"

    timestamps()
  end

  def changeset(album, attrs \\ %{}) do
    album
    |> cast(attrs, [:title, :is_public])
    |> validate_required([:title])
  end

  def all_for_user(user) do
    query =
      from(
        album in Pleroma.Artcafe.Album,
        where: album.user_id == ^user.id,
        order_by: [desc: album.inserted_at],
        limit: 50,
        preload: :user
      )

    Repo.all(query)
  end

  def public_for_user(user) do
    query =
      from(
        album in Pleroma.Artcafe.Album,
        where: album.user_id == ^user.id,
        where: album.is_public == true,
        order_by: [desc: album.inserted_at],
        limit: 50,
        preload: :user
      )

    Repo.all(query)
  end

  def get(id, nil) do
    query =
      from(
        album in Pleroma.Artcafe.Album,
        where: album.id == ^id,
        where: album.is_public == true,
        preload: :user
      )

    Repo.one(query)
  end

  def get(id, %{id: user_id} = _user) do
    query =
      from(
        album in Pleroma.Artcafe.Album,
        where: album.id == ^id,
        where: album.user_id == ^user_id or album.is_public == true,
        preload: :user
      )

    Repo.one(query)
  end

  def update(%Pleroma.Artcafe.Album{} = album, params \\ %{}) do
    album
    |> changeset(params)
    |> Repo.update()
  end

  def create(%User{} = creator, params \\ %{}) do
    changeset =
      %Pleroma.Artcafe.Album{user_id: creator.id}
      |> changeset(params)

    if changeset.valid? do
      # attempt to add user data to album if successful, otherwise just pass on the result
      case Repo.insert(changeset) do
        {:ok, data} -> {:ok, Repo.preload(data, [:user])}
        result -> result
      end
    else
      {:error, changeset}
    end
  end

  def delete(%Pleroma.Artcafe.Album{} = album) do
    Repo.delete(album)
  end

  def get_items(%Pleroma.Artcafe.Album{} = album, user) do
    acceptable_recipients = get_acceptable_recipients_for_user(user)

    AlbumActivityRelationship.for_album_query(album.id)
    |> where([_, activity], fragment("? && ?", activity.recipients, ^acceptable_recipients))
  end

  def get_user_albums_for_activity(activity_id, %User{} = user) do
    AlbumActivityRelationship.for_activity_query(activity_id)
    |> where([_, album], album.user_id == ^user.id)
    |> Repo.all()
    |> Enum.map(fn rel -> rel.album end)
  end
  def get_user_albums_for_status(_, _), do: []

  def is_owned_by?(%Pleroma.Artcafe.Album{} = album, %User{} = user), do: album.user_id == user.id
  def is_owned_by?(_, _), do: false

  def is_visible_for?(%Pleroma.Artcafe.Album{} = album, %User{} = user), do: is_owned_by?(album, user) or (album.is_public == true)
  def is_visible_for?(_, _), do: false

  defp get_acceptable_recipients_for_user(%User{} = user) do
    get_acceptable_recipients_for_user(nil)
    |> Enum.concat([user.ap_id | User.following(user)])
  end

  defp get_acceptable_recipients_for_user(_) do
    [Constants.as_public(), as_local_public()]
  end
end
