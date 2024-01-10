defmodule ZiptreeTest do
  use ExUnit.Case

  test "creates, adds items, an then removes them" do
    assert {:ok, ziptree} = Ziptree.new()
    assert {:ok, ziptree} == Ziptree.put(ziptree, "Zinogre", "jasper")
    assert {:error, :not_found} == Ziptree.get(ziptree, "Brachydios")
    assert {:ok, 1} == Ziptree.size(ziptree)
    assert {:ok, ziptree} == Ziptree.put(ziptree, "Brachydios", "pallium")
    assert {:ok, 2} == Ziptree.size(ziptree)
    assert {:ok, "pallium"} == Ziptree.get(ziptree, "Brachydios")
    assert {:ok, ziptree} == Ziptree.delete(ziptree, "Zinogre")
    assert {:error, :not_found} == Ziptree.delete(ziptree, "Zinogre")
    assert {:ok, 1} == Ziptree.size(ziptree)
    assert {:error, :not_found} == Ziptree.get(ziptree, "Zinogre")
  end
end
