defmodule ZipTree.NifTest do
  use ExUnit.Case, async: true

  alias ZipTree.Nif

  test "creates, adds items, an then removes them" do
    assert {:ok, ziptree} = Nif.new()
    assert {:ok, nil} == Nif.put(ziptree, "Zinogre", "jasper")
    assert {:ok, nil} == Nif.get(ziptree, "Brachydios")
    assert {:ok, 1} == Nif.size(ziptree)
    assert {:ok, nil} == Nif.put(ziptree, "Brachydios", "pallium")
    assert {:ok, 2} == Nif.size(ziptree)
    assert {:ok, "pallium"} == Nif.get(ziptree, "Brachydios")
    assert {:ok, "jasper"} == Nif.delete(ziptree, "Zinogre")
    assert {:ok, 1} == Nif.size(ziptree)
    assert {:ok, nil} == Nif.get(ziptree, "Zinogre")
  end
end
