defmodule MyGenServer do
  @callback init() :: String.t()
  @callback handle_transform(data :: String.t()) :: String.t()

  defmacro __using__(_params) do
    quote do
      @behaviour MyGenServer
    end
  end

  def transform(module) do
    module.init |> module.handle_transform
  end
end

defmodule MyGenServerImpl do
  use MyGenServer

  @impl MyGenServer
  def init, do: "hej"

  @impl MyGenServer
  @spec handle_transform(any()) :: <<_::40, _::_*8>>
  def handle_transform(data), do: "#{data} hopp"
end
