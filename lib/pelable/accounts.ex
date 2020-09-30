defmodule Pelable.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Pelable.Repo

  alias Pelable.Accounts.Setting
  alias Pelable.Users.User

  @user_editable_settings ["timezone"]

  defdelegate authorize(action, user, params), to: Pelable.Accounts.Policy

  @doc """
  Returns the list of settings.

  ## Examples

      iex> list_settings()
      [%Setting{}, ...]

  """
  def list_settings do
    Repo.all(Setting)
  end

  @doc """
  Gets a single setting.

  Raises `Ecto.NoResultsError` if the Setting does not exist.

  ## Examples

      iex> get_setting!(123)
      %Setting{}

      iex> get_setting!(456)
      ** (Ecto.NoResultsError)

  """
  def get_setting!(id), do: Repo.get!(Setting, id)

  def get_setting_by_uuid(uuid), do: Repo.get_by(Setting, uuid: uuid)

  #Takes a map with several {key, value} settings and returns a list of keys that are user editable
  # %{"editable_setting" => 1, "non_editable_setting" => "true",} -> ["editeable_setting"]
  def get_editable_keys(%{} = settings_params) do
    keys = Map.keys(settings_params)
    Enum.filter(keys, fn key -> key in @user_editable_settings end)
  end

  def new_setting_value?(%Setting{} = setting, %{} = settings_params) do
    Map.get(settings_params, setting.setting_key) != setting.value
  end

  def editable_settings(%{} = settings_params, %User{} = user) do
    get_editable_keys(settings_params) |> list_these_user_settings(user)
  end

  #Takes a map of user settings key/values and returns the updated settings
  # %{} -> [%Setting{}, ...]
  def update_settings(%{} = settings_params, %User{} = user) do
    editable_settings = editable_settings(settings_params, user)
    settings_to_update = editable_settings |> Enum.filter(fn setting -> new_setting_value?(setting, settings_params) end)
    Enum.map(settings_to_update, &update_setting_from_params(&1, settings_params))
  end

  #Takes a setting and a map and updates it with the new value from the map
  # %Setting{value: value1}, %{key => value2, ...} -> %Setting{value: value2}
  def update_setting_from_params(%Setting{} = setting, %{} = settings_params) do
    setting_key = setting.setting_key
    new_value = Map.get(settings_params, setting_key)
    attrs = %{"setting_key" => setting_key, "value" => new_value}
    {:ok, updated_setting} = update_setting(setting, attrs)
    updated_setting
  end

  #Takes a list of keys and a user and returns the user's settings with those keys
  # ["timezone", ...], %User{id: 1} -> [%Setting{"setting_key": "timezone", user_id: 1}, ...]
  def list_these_user_settings(keys, %User{} = user) when is_list(keys) do
    Enum.map(keys, fn key -> get_user_setting(key, user)end)
  end

  #Takes a key and a user and returns the corresponding Setting
  # String, %User{} -> %Setting{user_id: user.id, setting_key: key}
  def get_user_setting(key, %User{} = user) when is_binary(key) do
    query = 
    from s in Setting,
    where: s.user_id == ^user.id and s.setting_key == ^key,
    select: s
    Repo.one(query)
  end

  def list_user_settings(%User{} = user) do
    query =
    from s in Setting,
    where: s.user_id == ^user.id,
    select: s
    Repo.all(query)
  end

  @doc """
  Creates a setting.

  ## Examples

      iex> create_setting(%{field: value})
      {:ok, %Setting{}}

      iex> create_setting(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_setting(attrs \\ %{}) do
    %Setting{}
    |> Setting.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a setting.

  ## Examples

      iex> update_setting(setting, %{field: new_value})
      {:ok, %Setting{}}

      iex> update_setting(setting, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_setting(%Setting{} = setting, attrs) do
    setting
    |> Setting.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a setting.

  ## Examples

      iex> delete_setting(setting)
      {:ok, %Setting{}}

      iex> delete_setting(setting)
      {:error, %Ecto.Changeset{}}

  """
  def delete_setting(%Setting{} = setting) do
    Repo.delete(setting)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking setting changes.

  ## Examples

      iex> change_setting(setting)
      %Ecto.Changeset{data: %Setting{}}

  """
  def change_setting(%Setting{} = setting, attrs \\ %{}) do
    Setting.changeset(setting, attrs)
  end
end
