defmodule MemoryGameWeb.GamesChannel do
  use MemoryGameWeb, :channel

  alias MemoryGame.Game

  def join("games:" <> name, payload, socket) do
    if authorized?(payload) do
      game = MemoryGame.GameBackup.load(name) || Game.new()
      socket = socket
      |> assign(:game, game)
      |> assign(:name, name)
      {:ok, %{"join" => name, "game" => Game.client_view(game)}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("click", %{"cardKey" => cardKey}, socket) do
    game = Game.click_card(socket.assigns[:game], cardKey)
    MemoryGame.GameBackup.save(socket.assigns[:name], game)
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
  end

  def handle_in("restart", _, socket) do
    game = Game.restart()
    MemoryGame.GameBackup.save(socket.assigns[:name], game)
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
  end

  def handle_in("reset_two", _,  socket) do
    game = Game.reset_two(socket.assigns[:game])
    MemoryGame.GameBackup.save(socket.assigns[:name], game)
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{ "game" => Game.client_view(game)}}, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
