defmodule MemoryGame.Game do

  def new do
    restart()
  end

  def restart do
    %{
      cards: gen_cards(),
      delay: false,
      oneClicked: false,
      clickedCard1: nil,
      clickedCard2: nil,
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
      counter: game.counter,
      delay: game.delay,
    }
  end

  def reset_two(game) do
    card1 = game.clickedCard1
    card2 = game.clickedCard2
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
    gameCards =
    Map.put(game.cards, card1.key, new_card1)
    |> Map.put(card2.key, new_card2)

    Map.put(game, :cards, gameCards)
    |> Map.put(:delay, false)
  end

  def click_card(game, cardKey) do
    clickedCard1 = game.clickedCard1
    oneClicked = game.oneClicked
    card = game.cards[cardKey]
    IO.puts("game1")
    IO.inspect(game)
    game = if oneClicked do
      if card.key === clickedCard1.key do
        game
      else
        if card.value === clickedCard1.value do
          new_card1 = %{
            :value => card.value,
            :state => "solved",
            :key => card.key
          }
          new_card2 = %{
            :value => clickedCard1.value,
            :state => "solved",
            :key => clickedCard1.key
          }
          game1 = game
          |> Map.put(:oneClicked, false)
          |> Map.put(:clickedCard1, nil)

          gameCards1 = game.cards
          |> Map.put(card.key, new_card1)
          |> Map.put(clickedCard1.key, new_card2)

          Map.put(game1, :cards, gameCards1)
        else
          new_card = %{
            :value => card.value,
            :state => "revealed",
            :key => card.key
          }
          Map.put(game, :oneClicked, false)
          Map.put(game, :clickedCard1, nil)
          Map.put(game.cards, card.key, new_card)

          game1 = game
          |> Map.put(:oneClicked, false)
          |> Map.put(:clickedCard1, card)
          |> Map.put(:clickedCard2, clickedCard1)
          |> Map.put(:delay, true)

          gameCards1 = game.cards
          |> Map.put(card.key, new_card)

          Map.put(game1, :cards, gameCards1)
        end
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
      |> Map.put(:clickedCard1, card)
      |> Map.put(:cards, Map.put(game.cards, card.key, new_card))
    end
    IO.puts("game2")
    IO.inspect(game)

    counter1 = game.counter + 1
    Map.put(game, :counter, counter1)
  end
end
