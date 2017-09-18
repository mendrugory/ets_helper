defmodule EtsHelper do
  @moduledoc """
 `EtsHelper` is a wrapper of [ETS](http://erlang.org/doc/man/ets.html). It does not try to wrap all the
 functionality, only those functions that are constantly used in Elixir projects. It also includes some
 new functions. This is a library that could be improved in the future if it is required by new needs.

## Installation
  Add `ets_helper` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:ets_helper, "~> 0.1.0"}]
  end
  ```
    

## How to use it
  
  * New table
  ```bash
  iex> EtsHelper.init_table(:my_table)
  ```

  * New table with options
  ```bash
  iex> EtsHelper.init_table(:my_table, [:named_table, :public, {:read_concurrency, true}, {:write_concurrency, true}])
  ```  
  
  * Insert data
  ```bash
  iex> EtsHelper.insert(:my_table, {"key", "data"})
  iex> EtsHelper.insert(:my_table, {:key, :data})
  iex> EtsHelper.insert(:my_table, {{:key, 2}, {1, 2, 3})
  ```  

  * Get data
  ```bash
  iex> EtsHelper.get(:my_table, "key")
  ``` 

  * Get all data
  ```bash
  iex> EtsHelper.all(:my_table)
  ```  

  * Get all keys
  ```bash
  iex> EtsHelper.keys(:my_table)
  ```      

  * Delete data
  ```bash
  iex> EtsHelper.delete(:my_table, "key")
  ```   

  * Delete all data
  ```bash
  iex> EtsHelper.delete_all(:my_table)
  ```

  * Delete all registers whose data matches with the given function
  ```bash
  iex> # Delete odd data
  iex> EtsHelper.delete_data_with(:my_table, fn x -> rem(x, 2) != 0 end)
  ```

  * Get data according to given pattern
  ```bash
  iex> EtsHelper.insert(table_name, [{:brunte, :horse, 5}, {:ludde, :dog, 5}, {:rufsen, :dog, 7}])
  iex> EtsHelper.match(table_name, {:"_", :dog, :"$1"})
  ```  
  
  * Table Information
  ```bash
  iex> EtsHelper.info(:my_table)
  ```  
  """

  @doc """
  It creates a new ets table.

  The name of the table has to be an atom.
  """
  def init_table(table_name, args \\ [:named_table]) do
    :ets.new(table_name, args)
  end

  @doc """
  It gets all the keys of the given table.
  """
  def keys(table_name) do
    key = :ets.first(table_name)
    keys(table_name, key, [])
  end

  defp keys(_table_name, :"$end_of_table", acc) do
    acc
  end

  defp keys(table_name, key, acc) do
    next_key = :ets.next(table_name, key)
    keys(table_name, next_key, [key | acc])
  end

  @doc """
  It inserts a new register or registers in the given table.
  """
  def insert(table_name, data) do
    :ets.insert(table_name, data)
  end

  @doc """
  It gets the register from the given table which the given key/id.
  """
  def get(table_name, key) do
    :ets.lookup(table_name, key)
  end


  @doc """
  It deletes the registers from the given table which the given list of keys/ids.
  """
  def delete(table_name, [key | tail_keys]) when is_list(tail_keys) do
    unless Enum.empty?(tail_keys) do
      delete(table_name, tail_keys)
    end
    delete(table_name, key)
  end

  @doc """
  It deletes the register from the given table which the given key/id.
  """
  def delete(table_name, key) do
    :ets.delete(table_name, key)
  end

  @doc """
  It returns a list with the content of the given table.
  """
  def all(table_name) do
    :ets.tab2list(table_name)
  end

  @doc """
  It returns the list of objects that match with the given pattern.

  Patterns have to be atoms or tuples. For example:
  ```bash
    iex> EtsHelper.match(table_name, {:"_", :key, :"$1"})
  ```
  """
  def match(table_name, pattern_matching) do
    :ets.match(table_name, pattern_matching)
  end

  @doc """
  It deletes all the registers whose data matches are filtered with the given function.
  """
  def delete_data_with(table_name, fun) do
    ids =
      all(table_name)
      |> Enum.filter(fn {_id, data} -> fun.(data) end)
      |> Enum.map(fn {id, _data} -> id end)
    Enum.each(ids, fn id -> delete(table_name, id) end)
    ids
  end

  @doc """
  It deletes all the objects of a table.
  """
  def delete_all(table_name) do
    :ets.delete_all_objects(table_name)
  end

  @doc """
  It counts the number of registers of the table.
  """
  def count(table_name) do
    i = info(table_name)
    case Keyword.fetch(i, :size) do
      {:ok, size} -> size
      _ -> :error
    end
  end

  @doc """
  It returns information about the given table.
  """
  def info(table_name), do: :ets.info(table_name)

  @doc """
  It checks if the given table exists.
  """
  def exist?(table_name) do
    case info(table_name) do
      :undefined -> false
      [] -> false
      _ -> true
    end
  end
end
