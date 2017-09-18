defmodule EtsHelperTest do
  use ExUnit.Case

  test "Creating and checking table" do
    table_name = :table1
    EtsHelper.init_table(table_name)
    assert EtsHelper.exist?(table_name)
  end

  test "Creating and checking table with options" do
    table_name = :table2
    EtsHelper.init_table(table_name, [:named_table, :public, {:read_concurrency, true}, {:write_concurrency, true}])
    assert EtsHelper.exist?(table_name)
  end  

  test "Checking a table which does not exist" do
    table_name = :table3
    assert(not EtsHelper.exist?(table_name))
  end     

  test "Inserting and reading a register with an atom key" do
    table_name = :table4
    EtsHelper.init_table(table_name)
    EtsHelper.insert(table_name, {:key, :data})
    assert EtsHelper.get(table_name, :key) == [{:key, :data}]
  end   

  test "Inserting and reading a register with a number key" do
    table_name = :table5
    EtsHelper.init_table(table_name)
    EtsHelper.insert(table_name, {1, :data})
    assert EtsHelper.get(table_name, 1) == [{1, :data}]
  end  

  test "Inserting and reading a list of registers" do
    table_name = :table6
    EtsHelper.init_table(table_name, [:named_table, :bag])
    EtsHelper.insert(table_name, [{1, :data1}, {1, :data2}])
    assert EtsHelper.get(table_name, 1) == [{1, :data1}, {1, :data2}]
  end  
  
  test "Counting" do
    table_name = :table7
    EtsHelper.init_table(table_name, [:named_table])
    EtsHelper.insert(table_name, [{1, :data1}, {2, :data2}])
    assert EtsHelper.count(table_name) == 2
  end  

  test "Deleting an object" do
    table_name = :table8
    EtsHelper.init_table(table_name)
    EtsHelper.insert(table_name, [{1, :data1}, {2, :data2}])
    if EtsHelper.count(table_name) == 2 do
      EtsHelper.delete(table_name, 1)
      assert EtsHelper.count(table_name) == 1
    else
      assert false
    end
  end   

  test "Deleting all the objects of a table" do
    table_name = :table9
    EtsHelper.init_table(table_name)
    EtsHelper.insert(table_name, [{1, :data1}, {2, :data2}])
    if EtsHelper.count(table_name) == 2 do
      EtsHelper.delete_all(table_name)
      assert EtsHelper.count(table_name) == 0
    else
      assert false
    end
  end    

  test "Table Info" do
    table_name = :table10
    EtsHelper.init_table(table_name)
    case EtsHelper.info(table_name) do
      [] -> assert false
      info when is_list(info) -> assert true
      _ -> false
    end
  end 

  test "Delete all the odd data" do
    table_name = :table11
    EtsHelper.init_table(table_name)    
    Enum.each(1..50, 
              fn input -> 
                key = "Key" <> Integer.to_string(input)
                EtsHelper.insert(table_name, {key, input}) 
              end
              )
    if EtsHelper.count(table_name) == 50 do
      EtsHelper.delete_data_with(table_name, fn x -> rem(x, 2) != 0 end)
      assert EtsHelper.count(table_name)
    else
      assert false
    end
  end

  test "Pattern Matching" do
    table_name = :table12
    EtsHelper.init_table(table_name)    
    EtsHelper.insert(table_name, [{:brunte, :horse, 5}, {:ludde, :dog, 5}, {:rufsen, :dog, 7}])
    assert EtsHelper.match(table_name, {:"_", :dog, :"$1"}) == [[7], [5]]
  end

  test "Everything" do
    table_name = :table13
    EtsHelper.init_table(table_name)    
    EtsHelper.insert(table_name, [{:brunte, :horse, 5}, {:ludde, :dog, 5}, {:rufsen, :dog, 7}])
    objects = table_name |> EtsHelper.all() |> Enum.sort()
    assert objects == [{:brunte, :horse, 5}, {:ludde, :dog, 5}, {:rufsen, :dog, 7}]
  end    

  test "Getting Keys" do
    table_name = :table14
    EtsHelper.init_table(table_name)
    EtsHelper.insert(table_name, [{1, :data1}, {2, :data2}])
    keys = table_name |> EtsHelper.keys() |> Enum.sort()
    assert keys == [1, 2]
  end   
  
end
