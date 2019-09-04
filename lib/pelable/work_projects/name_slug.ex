defmodule Pelable.WorkProjects.NameSlug do
    use EctoAutoslugField.Slug, from: :name, to: :slug, always_change: true
  end