defmodule Pelable.Learn.ThreadPost do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Learn.{Thread, Post}

  # A post can belong to multiple threads, imagine sharing the same post to different communities
  # And of course a thread is composed of multiple posts or at least one
  schema "thread_posts" do

    belongs_to :thread, Thread
    belongs_to :post, Post

    timestamps()
  end

  @doc false
  def changeset(thread_post, attrs) do
    thread_post
    |> cast(attrs, [:thread_id, :post_id])
    |> validate_required([:thread_id, :post_id])
    |> foreign_key_constraint(:thread_id)
    |> foreign_key_constraint(:post_id)
  end
end
