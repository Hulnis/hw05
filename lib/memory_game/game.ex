defmodule MemoryGame.Game do

  def new do
    IO.puts("new")
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
    |> Enum.map(values, fn {val, index} ->
      %{
        :value => val,
        :state => "solved",
        :key => index,
      }
    end)
    |> Enum.chunk(1)
    |> Enum.map(fn card -> {card.key, card} end)
    |> Map.new
    IO.inspect(cards)
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

  def click_card(game, card) do
    IO.inspect(game)
  end

  # def click_card(game, card) do
  #   if game.oneClicked === true do
  #     if card.key === prevCard.key do
  #       game.oneClicked = false
  #       game.prevCard = nil
  #       new_card1 = %{
  #         :value => card.value,
  #         :state => "solved",
  #         :key => card.key
  #       }
  #       new_card2 = %{
  #         :value => prevCard.value,
  #         :state => "solved",
  #         :key => prevCard.key
  #       }
  #       Map.put(game.cards, card.key, new_card1)
  #       Map.put(game.cards, prevCard.key, new_card2)
  #     else
  #       game.oneClicked = false
  #       game.prevCard = nil
  #       Task.async(fn -> hide_two_cards(game, card1, card2) end)
  #       new_card = %{
  #         :value => card.value,
  #         :state => "revealed",
  #         :key => card.key
  #       }
  #       Map.put(game.cards, card.key, new_card)
  #     end
  #   else
  #     game.oneClicked = true
  #     game.prevCard = card
  #     new_card = %{
  #       :value => card.value,
  #       :state => "revealed",
  #       :key => card.key
  #     }
  #     Map.put(game.cards, card.key, new_card)
  #   end
  # end
end
