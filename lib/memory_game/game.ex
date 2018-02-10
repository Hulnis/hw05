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
    IO.puts("game1")
    IO.inspect(game)
    IO.puts("card")
    IO.inspect(card)
    IO.puts("prevCard")
    IO.inspect(prevCard)
    game = if oneClicked do
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
        game1 = game
        |> Map.put(:oneClicked, false)
        |> Map.put(:prevCard, nil)

        gameCards1 = game.cards
        |> Map.put(card.key, new_card1)
        |> Map.put(prevCard.key, new_card2)

        Map.put(game1, :cards, gameCards1)
      else
        Task.async(fn -> hide_two_cards(game, card, prevCard) end)
        new_card = %{
          :value => card.value,
          :state => "revealed",
          :key => card.key
        }
        Map.put(game, :oneClicked, false)
        Map.put(game, :prevCard, nil)
        Map.put(game.cards, card.key, new_card)

        game1 = game
        |> Map.put(:oneClicked, false)
        |> Map.put(:prevCard, nil)

        gameCards1 = game.cards
        |> Map.put(card.key, new_card)

        Map.put(game1, :cards, gameCards1)
      end
    else
      IO.puts("else case")
      new_card = %{
        :value => card.value,
        :state => "revealed",
        :key => card.key
      }
      game
      |> Map.put(:oneClicked, true)
      |> Map.put(:prevCard, card)
      |> Map.put(:cards, Map.put(game.cards, card.key, new_card))
    end
    IO.puts("game2")
    IO.inspect(game)
  end
end
