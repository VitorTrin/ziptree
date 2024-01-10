defmodule Ziptree do
  @moduledoc """
  ## What is a zip tree
  Zip tree is a random access data structure that is equivalent to a skiplist,
  but instead of being stored in multiple arrays it is stored in a binary balanced tree.

  It was created in 2018 (Zip Trees, by Robert E. Tarjan, Caleb C. Levy, Stephen Timmel) and then futher improved
  in 2023 (Zip-zip Trees: Making Zip Trees More Balanced, Biased, Compact, or Persistent by Ofek Gila, Michael T. Goodrich, Robert E. Tarjan)

  ## What is this lib

  This is a nif for the rust implementation of zip trees, more specifically the zip zip tree implementation.
  """

  alias Ziptree.Nif

  @type ziptree :: reference()

  @spec new() :: {:ok, ziptree()}
  defdelegate new(), to: Nif

  @spec size(ziptree()) :: {:ok, integer()}
  defdelegate size(ziptree), to: Nif

  @spec put(ziptree(), key :: term(), value :: term()) :: {:ok, ziptree() | nil}
  def put(ziptree, key, value) do
    case Nif.put(ziptree, key, value) do
      {:ok, _} -> {:ok, ziptree}
      other -> other
    end
  end

  @spec delete(ziptree(), key :: term()) :: {:ok, term() | nil}
  def delete(ziptree, key) do
    case Nif.delete(ziptree, key) do
      {:ok, _} -> {:ok, ziptree}
      other -> other
    end
  end

  @spec get(ziptree(), key :: term()) :: {:ok, term()} | {:error, :not_found}
  defdelegate get(ziptree, key), to: Nif
end
