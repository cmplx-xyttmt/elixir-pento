defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    rand_number = :rand.uniform(10)
    {:ok, assign(socket, score: 0, number: rand_number, message: "Make a guess:", time: time())}
  end

  def render(assigns) do
    ~H"""
    <section class="m-2">
      <h1 class="font-medium">Your score: <%= @score %></h1>
      <h2>
        <%= @message %>
      </h2>
      <h2>
        <%= for n <- 1..10 do %>
          <a class="text-blue-500" href="#" phx-click="guess" phx-value-number={n} phx-value-num2={n * 2}><%= n %></a>
        <% end %>
      </h2>
      <button class="button bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">Restart</button>
    </section>
    """
  end

  def time() do
    DateTime.utc_now |> to_string
  end

  def handle_event("guess", %{"number" => guess}=_data, socket) do
    number = socket.assigns.number
    {new_message, score_diff} = case String.to_integer(guess) do
      ^number -> {"You win, the secret number is #{guess}", 1}
      _ -> {"Your guess: #{guess}. Wrong guess again.", -1}
    end
    score = socket.assigns.score + score_diff
    {
      :noreply,
      assign(
        socket,
        message: new_message,
        score: score,
        time: time()
      )
    }
  end
end
