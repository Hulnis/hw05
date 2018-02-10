defmodule MemoryGame.Game do
  def new do
    restart()
  end

  def restart do
    %{
      cards: gen_cards(),
      oneClicked: false,
      prevCard: nil,
      counter: 0,
    }
  end

  def gen_cards() do
    values = ["A", "B", "C", "D", "E", "F", "G", "H"]
    cards = %{}
    index_key = 0
    Enum.each(values, fn val ->
      card1 = %{
        :value => val,
        :state => "solved",
        :key => index_key,
      }
      Maps.put(cards, index_key, card1)
      index_key = index_key + 1
      card2 = %{
        :value => val,
        :state => "solved",
        :key => index_key,
      }
      Maps.put(cards, index_key, card2)
      index_key = index_key + 1
    end)
    cards
  end

  def client_view(game) do
    %{
      cards: game.cards,
      counter: game.counter
    }
  end

  def hide_two_cards(game, card1, card2) do
    Process.sleep(1000)
    Map.update(game.cards, card1.key, &(Map.update(&1, :state, &("hidden"))
    Map.update(game.cards, card2.key, &(Map.update(&1, :state, &("hidden"))
  end

  def click_card(game, card) do
    oneClicked = game.oneClicked
    prevCard = game.prevCard

    if (oneClicked) do
      if card.key === prevCard.key do
        game.oneClicked = false
        game.prevCard = nil
        Map.update(game.cards, card.key, &(Map.update(&1, :state, &("solved"))
        Map.update(game.cards, prevCard.key, &(Map.update(&1, :state, &("solved"))
      else
        game.oneClicked = false
        game.prevCard = nil
        Task.async(fn -> hide_two_cards(game, card1, card2) end)
        Map.update(game.cards, card.key, &(Map.update(&1, :state, &("revealed"))
      end
    else
      game.oneClicked = true
      game.prevCard = card
      Map.update(game.cards, card.key, &(Map.update(&1, :state, &("revealed"))
    end
  end
end
