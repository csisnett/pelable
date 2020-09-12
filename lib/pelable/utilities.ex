defmodule Pelable.Utilities do

    def markdown_to_html(changeset) do
        case changeset do
          %Ecto.Changeset{valid?: true, changes: %{description_markdown: description}} ->
            put_change(changeset, :description_html, Earmark.as_html!(description))
          _ ->
            changeset
        end
      end


end