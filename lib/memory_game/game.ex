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
    values = Enum.shuffle(["A", "A", "B", "B", "C", "C", "D", "D", "E", "E", "F", "F", "G", "G", "H", "H"])
    cards = Stream.with_index(values, 1)
    |> Enum.map(fn {val, index} ->
      %{
        :value => val,
        :state => "hidden",
        :key => index,
      }
    end)
    cards = cards
    |> Enum.chunk(1)
    cards = cards
    |> Map.new(fn card -> {elem(Map.fetch(Enum.at(card, 0), :key), 1), Enum.at(card, 0)} end)
    cards
  end

  def client_view(game) do
    %{
      cards: Map.values(game.cards),
      counter: game.counter
    }
  end

  def hide_two_cards(game, card1, card2) do
    Process.sleep(500)
    new_card1 = %{
      :value => card1.value,
      :state => "hidden",
      :key => card1.key
    }
    new_card2 = %{
      :value => card2.value,
      :state => "hidden",
      :key => card2.key
    }
    Map.put(game.cards, card1.key, new_card1)
    Map.put(game.cards, card2.key, new_card2)
  end

  def click_card(game, cardKey) do
    prevCard = game.prevCard
    oneClicked = game.oneClicked
    card = game.cards[cardKey]
    IO.puts("card")
    IO.inspect(card)
    IO.puts("prevCard")
    IO.inspect(prevCard)
    if oneClicked do
      if card.key === prevCard.key do
        new_card1 = %{
          :value => card.value,
          :state => "solved",
          :key => card.key
        }
        new_card2 = %{
          :value => prevCard.value,
          :state => "solved",
          :key => prevCard.key
        }
        Map.put(game, oneClicked, false)
        Map.put(game, prevCard, nil)
        Map.put(game.cards, card.key, new_card1)
        Map.put(game.cards, prevCard.key, new_card2)
      else
        Task.async(fn -> hide_two_cards(game, card, prevCard) end)
        new_card = %{
          :value => card.value,
          :state => "revealed",
          :key => card.key
        }
        Map.put(game, oneClicked, false)
        Map.put(game, prevCard, nil)
        Map.put(game.cards, card.key, new_card)
      end
    else
      new_card = %{
        :value => card.value,
        :state => "revealed",
        :key => card.key
      }
      Map.put(game, oneClicked, true)
      Map.put(game, prevCard, card)
      Map.put(game.cards, card.key, new_card)
    end
  end
end
