defmodule Ziptree.BenchmarkTest do
  @moduledoc false

  use ExUnit.Case, async: false

  @moduletag :benchmark
  @moduletag timeout: :infinity

  setup do
    mock_data =
      Enum.map(1..1_000, fn _ ->
        %{
          key: random_number(),
          value: random_number()
        }
      end)

    {:ok, filled_ziptree} = Ziptree.new()

    Enum.map(mock_data, fn %{key: key, value: value} ->
      Ziptree.put(filled_ziptree, key, value)
    end)

    %{mock_data: mock_data, filled_ziptree: filled_ziptree}
  end

  test "put", %{mock_data: mock_data} do
    {:ok, ziptree} = Ziptree.new()

    Benchee.run(
      %{
        "put" => fn %{key: key, value: value} ->
          Ziptree.put(ziptree, key, value)
        end
      },
      inputs: %{"random" => Enum.random(mock_data)},
      parallel: 2
    )
  end

  test "get", %{mock_data: mock_data, filled_ziptree: filled_ziptree} do
    Benchee.run(
      %{
        "get" => fn %{key: key} ->
          Ziptree.get(filled_ziptree, key)
        end
      },
      inputs: %{"random" => Enum.random(mock_data)},
      parallel: 2
    )
  end

  test "delete", %{mock_data: mock_data, filled_ziptree: filled_ziptree} do
    Benchee.run(
      %{
        "delete" => fn %{key: key} ->
          Ziptree.delete(filled_ziptree, key)
        end
      },
      inputs: %{"random" => Enum.random(mock_data)},
      parallel: 2
    )
  end

  defp random_number do
    :rand.uniform() |> Kernel.*(10_000) |> Kernel.trunc()
  end
end
