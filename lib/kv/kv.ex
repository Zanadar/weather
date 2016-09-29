defmodule Weather.KV do
  use GenServer

  @name Weather.KV

  ## Client
  def start_link(opt \\ [] ) do
    GenServer.start_link(__MODULE__, :ok, name: @name)
  end

  def get(key) do
    GenServer.call(@name, {:get, key})
  end

  def put(key, value) do
    GenServer.call(@name, {:put, key, value})
  end

  def delete(key) do
    GenServer.call(@name, {:delete, key})
  end

  def clear do
    GenServer.cast(@name, :reset)
  end

  def has?(key) do
    GenServer.call(@name, {:has, key})
  end

  ## Server callbacks
  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:get, key}, _from, state) do
    value = Map.get(state, key)
    {:reply, value, state}
  end

  def handle_call({:put, key, value}, _from, state) do
    state = Map.put_new(state, key, value)
    {:reply, :ok, state}
  end

  def handle_call({:delete, key}, _from, state) do
    state = Map.delete(state, key)
    {:reply, :ok, state}
  end

  def handle_call({:has, key}, _from, state) do
    has? = Map.has_key?(state, key)
    {:reply, has?, state}
  end

  def handle_cast(:reset, state) do
    {:noreply, %{}}
  end
end
