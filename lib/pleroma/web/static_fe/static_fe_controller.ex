# Pleroma: A lightweight social networking server
# Copyright © 2017-2022 Pleroma Authors <https://pleroma.social/>
# SPDX-License-Identifier: AGPL-3.0-only

defmodule Pleroma.Web.StaticFE.StaticFEController do
  use Pleroma.Web, :controller

  alias Pleroma.Activity
  alias Pleroma.Object
  alias Pleroma.User
  alias Pleroma.Web.ActivityPub.ActivityPub
  alias Pleroma.Web.ActivityPub.Visibility
  alias Pleroma.Web.Metadata
  alias Pleroma.Web.Router.Helpers

  plug(:assign_id)

  @page_keys ["max_id", "min_id", "limit", "since_id", "order"]

  @doc "Renders requested local public activity or public activities of requested user"
  def show(%{assigns: %{notice_id: notice_id}} = conn, _params) do
    with %Activity{local: true} = activity <-
           Activity.get_by_id_with_object(notice_id),
         true <- Visibility.public?(activity.object),
         {_, true} <- {:visible?, Visibility.visible_for_user?(activity, _reading_user = nil)},
         %User{} = user <- User.get_by_ap_id(activity.object.data["actor"]) do
      url = Helpers.url(conn) <> conn.request_path

      meta =
        Metadata.build_tags(%{
          activity_id: notice_id,
          object: activity.object,
          user: user,
          url: url
        })

      timeline =
        activity.object.data["context"]
        |> ActivityPub.fetch_activities_for_context(%{})
        |> Enum.reverse()
        |> Enum.map(&represent(&1, &1.object.id == activity.object.id))

      render(conn, "conversation.html", %{activities: timeline, meta: meta})
    else
      %Activity{object: %Object{data: data}} ->
        conn
        |> put_status(:found)
        |> redirect(external: data["url"] || data["external_url"] || data["id"])

      _ ->
        not_found(conn, "Post not found.")
    end
  end

  def show(%{assigns: %{username_or_id: username_or_id}} = conn, params) do
    with {_, %User{local: true} = user} <-
           {:fetch_user, User.get_cached_by_nickname_or_id(username_or_id)},
         {_, :visible} <- {:visibility, User.visible_for(user, _reading_user = nil)} do
      meta = Metadata.build_tags(%{user: user})

      params =
        params
        |> Map.take(@page_keys)
        |> Map.new(fn {k, v} -> {String.to_existing_atom(k), v} end)

      timeline =
        user
        |> ActivityPub.fetch_user_activities(_reading_user = nil, params)
        |> Enum.map(&represent/1)

      prev_page_id =
        (params["min_id"] || params["max_id"]) &&
          List.first(timeline) && List.first(timeline).id

      next_page_id = List.last(timeline) && List.last(timeline).id

      render(conn, "profile.html", %{
        user: User.sanitize_html(user),
        timeline: timeline,
        prev_page_id: prev_page_id,
        next_page_id: next_page_id,
        meta: meta
      })
    else
      _ ->
        not_found(conn, "User not found.")
    end
  end

  def show(%{assigns: %{object_id: _}} = conn, _params) do
    url = Helpers.url(conn) <> conn.request_path

    case Activity.get_create_by_object_ap_id_with_object(url) do
      %Activity{} = activity ->
        to = Helpers.o_status_path(Pleroma.Web.Endpoint, :notice, activity)
        redirect(conn, to: to)

      _ ->
        not_found(conn, "Post not found.")
    end
  end

  def show(%{assigns: %{activity_id: _}} = conn, _params) do
    url = Helpers.url(conn) <> conn.request_path

    case Activity.get_by_ap_id(url) do
      %Activity{} = activity ->
        to = Helpers.o_status_path(Pleroma.Web.Endpoint, :notice, activity)
        redirect(conn, to: to)

      _ ->
        not_found(conn, "Post not found.")
    end
  end

  defp get_title(%Object{data: %{"name" => name}}) when is_binary(name),
    do: name

  defp get_title(%Object{data: %{"summary" => summary}}) when is_binary(summary),
    do: summary

  defp get_title(_), do: nil

  defp not_found(conn, message) do
    conn
    |> put_status(404)
    |> render("error.html", %{message: message, meta: ""})
  end

  defp get_counts(%Activity{} = activity) do
    %Object{data: data} = Object.normalize(activity, fetch: false)

    %{
      likes: data["like_count"] || 0,
      replies: data["repliesCount"] || 0,
      announces: data["announcement_count"] || 0
    }
  end

  defp represent(%Activity{} = activity), do: represent(activity, false)

  defp represent(%Activity{object: %Object{data: data}} = activity, selected) do
    {:ok, user} = User.get_or_fetch(activity.object.data["actor"])

    link =
      case user.local do
        true -> Helpers.o_status_url(Pleroma.Web.Endpoint, :notice, activity)
        _ -> data["url"] || data["external_url"] || data["id"]
      end

    content =
      if data["content"] do
        data["content"]
        |> Pleroma.HTML.filter_tags()
        |> Pleroma.Emoji.Formatter.emojify(Map.get(data, "emoji", %{}))
      else
        nil
      end

    %{
      user: User.sanitize_html(user),
      title: get_title(activity.object),
      content: content,
      attachment: data["attachment"],
      link: link,
      published: data["published"],
      sensitive: data["sensitive"],
      selected: selected,
      counts: get_counts(activity),
      id: activity.id
    }
  end

  defp assign_id(%{path_info: ["notice", notice_id]} = conn, _opts),
    do: assign(conn, :notice_id, notice_id)

  defp assign_id(%{path_info: ["users", user_id]} = conn, _opts),
    do: assign(conn, :username_or_id, user_id)

  defp assign_id(%{path_info: ["objects", object_id]} = conn, _opts),
    do: assign(conn, :object_id, object_id)

  defp assign_id(%{path_info: ["activities", activity_id]} = conn, _opts),
    do: assign(conn, :activity_id, activity_id)

  defp assign_id(conn, _opts), do: conn
end
