defmodule PigpioTester.SocketApi do
  use GenServer
  require Logger

  @type state :: %{
          client_socket: :gen_tcp.socket() | nil,
          expectations: %{atom => fun},
          listen_socket: :gen_tcp.socket() | nil,
          port: non_neg_integer
        }

  @spec start(non_neg_integer) :: GenServer.on_start()
  def start(port \\ 8888) do
    GenServer.start(__MODULE__, port)
  end

  @spec init(non_neg_integer) :: {:ok, state, {:continue, :listen}}
  def init(port) do
    state = %{
      client_socket: nil,
      expectations: %{},
      listen_socket: nil,
      port: port
    }

    {:ok, state, {:continue, :listen}}
  end

  @spec handle_continue(:listen, state) :: {:noreply, state}
  def handle_continue(:listen, %{port: port} = state) do
    {:ok, listen_socket} = :gen_tcp.listen(port, [:binary, {:packet, 0}, {:active, true}])

    # Spawn an async process to wait for a connection...
    my_pid = self()

    Task.start(fn ->
      {:ok, socket} = :gen_tcp.accept(listen_socket)

      :gen_tcp.controlling_process(socket, my_pid)

      send(my_pid, {:socket_connected, socket})
    end)

    {:noreply, %{state | listen_socket: listen_socket}}
  end

  @spec handle_info({:socket_connected, :gen_tcp.socket()}, state) :: {:noreply, state}
  def handle_info({:socket_connected, socket}, state) do
    Logger.info("(SocketApi) Socket client connected.")

    {:noreply, %{state | client_socket: socket}}
  end

  def handle_info({:tcp, socket, data}, %{client_socket: socket} = state) do
    Logger.debug("(SocketApi) Handling socket message: #{inspect(data)}")
    # TODO...
    {:noreply, state}
  end

  def handle_info(msg, state) do
    Logger.debug("(SocketApi) Received unhandled message: #{inspect(msg)}")
    {:noreply, state}
  end
end
