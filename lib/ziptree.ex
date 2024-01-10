defmodule Ziptree do
  @moduledoc """
  Documentation for `Ziptree`.
  """
  alias Ziptree.Nif

  @type ziptree :: reference()

  @spec new() :: {:ok, ziptree()}
  defdelegate new(), to: Nif

  @spec size(ziptree()) :: {:ok, integer()}
  defdelegate size(ziptree), to: Nif

  @spec put(ziptree(), key :: term(), value :: term()) :: {:ok, term() | nil}
  defdelegate put(ziptree, key, value), to: Nif

  @spec delete(ziptree(), key :: term()) :: {:ok, term() | nil}
  defdelegate delete(ziptree, key), to: Nif

  @spec get(ziptree(), key :: term()) :: {:ok, term()} | {:error, :not_found}
  defdelegate get(ziptree, key), to: Nif
end
