# EtsHelper

[![hex.pm](https://img.shields.io/hexpm/v/ets_helper.svg?style=flat-square)](https://hex.pm/packages/ets_helper) [![hexdocs.pm](https://img.shields.io/badge/docs-latest-green.svg?style=flat-square)](https://hexdocs.pm/ets_helper/) [![Build Status](https://travis-ci.org/mendrugory/ets_helper.svg?branch=master)](https://travis-ci.org/mendrugory/ets_helper)

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
  iex> EtsHelper.insert(:my_table, {{:key, 2}, {1, 2, 3}})
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

## Test
  Run the tests.
  ```bash
  $> mix test 
  ```

