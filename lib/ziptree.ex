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

  @doc """
  Creates a new zip tree. The ziptree is a reference, and you can only manipulate it using this lib's
  functions.
  """
  @spec new() :: {:ok, ziptree()}
  defdelegate new(), to: Nif

  @doc """
  Returns the size of the zip tree, that is, the total number of inserted elements.
  It's O(1) because it's stored, not calculated.
  """
  @spec size(ziptree()) :: {:ok, integer()}
  defdelegate size(ziptree), to: Nif

  @doc """
  Inserts the element in the zip tree. Not all types can be used for the key or the value,
  we do not allow Reference, Function, Port or Pid. It's O(log n).
  Please note that ziptree is a mutable structure, so while we return the updated zip tree
  for ease of use, any variables that stored the ziptree before the put will be altered as well.
  """
  @spec put(ziptree(), key :: term(), value :: term()) :: {:ok, ziptree()}
  def put(ziptree, key, value) do
    case Nif.put(ziptree, key, value) do
      {:ok, _} -> {:ok, ziptree}
      other -> other
    end
  end

  @doc """
  Deletes the element with a certain key from the zip tree. It's O(log n).
  Please note that ziptree is a mutable structure, so while we return the updated zip tree
  for ease of use, any variables that stored the ziptree before the put will be altered as well.
  """
  @spec delete(ziptree(), key :: term()) :: {:ok, ziptree()} | {:error, :not_found}
  def delete(ziptree, key) do
    case Nif.delete(ziptree, key) do
      {:ok, _} -> {:ok, ziptree}
      other -> other
    end
  end

  @doc """
  Gets the value for a certain key. It's O(log n).
  """
  @spec get(ziptree(), key :: term()) :: {:ok, term()} | {:error, :not_found}
  defdelegate get(ziptree, key), to: Nif
end
