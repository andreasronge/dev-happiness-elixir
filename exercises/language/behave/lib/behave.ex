defmodule Worker do
  @callback init() :: {:ok, state :: any} | {:error, reason :: any}
  @callback perform(state :: any) :: {:ok, result :: any} | {:error, reason :: any}
end

defmodule Parser do
  @doc """
  Parses a string and returns map.

  ## Examples

      iex> JSONParser.parse("hej")
      %{data: "hej"}
  """
  @callback parse(data :: String.t()) :: map()
end

defmodule JSONParser do
  @behaviour Parser

  @impl Parser
  @spec parse(any()) :: %{data: any()}
  def parse(data) do
    %{data: data}
  end
end

defmodule WorkProcess do
  def execute(worker) do
    with {:ok, state} <- worker.init() do
      worker.perform(state)
    else
      {:error, message} -> "oops #{inspect(message)}"
    end
  end
end

defmodule Md5Worker do
  @behaviour Worker

  @impl Worker
  def init(), do: {:ok, "lots of data"}

  @impl Worker
  def perform(state) do
    {:ok, :crypto.hash(:md5, state) |> Base.encode16()}
  end
end
