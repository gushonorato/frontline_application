defmodule FrontlineApplicationWeb.FrontlineWildfireApplicationLive do
  use FrontlineApplicationWeb, :live_view

  alias FrontlineApplicationWeb.Components

  @resume """
  <span class="text-5xl font-bold text-black">Hi Christopher!</span>

  > And to everyone else reading this application whom I haven't heard of yet! 😊

  # Who I am?

  I'm Gustavo Honorato, a 42 years old software developer based in Niterói, Brazil, a mid-sized city right next to the famous Rio de Janeiro. While Niterói may not be widely known internationally, it offers stunning views of Rio's skyline (which, I must say, is a great motivator when debugging tricky Elixir code). Now, you might be wondering about the time zone difference, but don't worry, it's not an issue. I guarantee it! Let me show you why:

  !!timezone_clocks!!

  Niterói follows Brasília Standard Time (BRT, UTC-3). To ensure seamless collaboration, I'm flexible with my working hours and open to adjusting to a `1 PM – 10 PM` (BRT) schedule, which aligns perfectly with your `8 AM – 5 PM` PT workday. This means we'd have a full overlap, making communication and teamwork smooth and efficient.

  I am happy to take the appropriate legal actions when this becomes a reality. Additionally, I am available to relocate to the U.S. if needed.

  # My Story

  I got into computers at a young age, mostly thanks to video games. Eventually, I wanted to go beyond just playing and started exploring how things worked behind the scenes. At 14 years old, I began learning HTML, CSS, and a bit of JavaScript, which led me to build my first website in 1997: a static homepage for my Diablo 1 clan, hosted on GeoCities, and of course, featuring Comic Sans font (good old times!).

  At 16, I took a Delphi course (back when it was still owned by Borland) at a local technical school. That's when I really started diving into the world of programming.

  From there, my passion for development only grew. I pursued a B.Sc. in Computer Science and later a [M.Sc. in Human-Computer Interaction](https://bdtd.ibict.br/vufind/Record/PUC_RIO-1_21fffdbd3c3e35cb78f849ebc701beec) at Pontifícia Universidade Católica do Rio de Janeiro (PUC-Rio), widely recognized as the best university in Brazil in the field of Computer Science.

  # Why me?

  Frontline Wildfire Defense is a startup, and over nearly 20 years, I've founded 4 startups. Only one succeeded, but the failures were just as valuable. I like to think of myself as a developer who embraces challenges and isn't afraid to take risks. But since this is a developer role, let's dive into the technical side of things.

  ## Before Elixir

  Before discovering Elixir, I worked with a variety of programming languages. I started with C/C++, then moved on to Java, C#, and Ruby on Rails. And, of course, JavaScript has been a constant in every job I've had. I also worked at major consulting firms like Accenture before transitioning to startups. I've also spoken at Brazilian conferences like RubyConf BR.

  <figure class="w-full">
    <a data-fslightbox href="/images/rubyconf.jpg">
      <img src="/images/rubyconf.jpg" alt="Me at RubyConf" class="my-0 mx-auto">
    </a>
    <figcaption class="text-center">I was talking about SEO for developers at RubyConf BR 2018</figcaption>
  </figure>

  ## When Elixir came into my life

  ### Food Pops

  During the pandemic in 2020, local restaurants struggled with high delivery app fees. To help them, I created [Food Pops](https://foodpops.delivery), a commission-free food delivery platform with a small monthly fee. It became my largest Elixir project, which I developed entirely on my own (including the design and implementation of the landing page). It evolved into a full-featured system with checkout, online payments, discount coupons, and business hours management.

  For me, it was important to release a product with a beautiful UI. I'm not a UI designer, and I didn't have the money to hire a good one, so I had to find solutions. I used customized versions of [Tailwind UI](https://tailwindui.com/) to deliver a beautiful UI to my clients.

  <div class="flex justify-between space-x-4 items-center h-96 my-16">
    <figure class="w-1/2">
      <a data-fslightbox href="/images/food-pops-mobile.jpg">
        <img src="/images/food-pops-mobile-small.jpg" alt="UI for customers to order food" class="h-96 border border-gray-200 rounded my-0 mx-auto">
      </a>
      <figcaption class="text-center">UI for customers to order food</figcaption>
    </figure>

    <figure class="w-1/2">
      <a data-fslightbox href="/images/order-manager.png">
        <img src="/images/order-manager.png" alt="Dashboard of ongoing orders for restaurant owners" class="object-contain border border-gray-200 rounded my-0">
      </a>
      <figcaption class="text-center">Dashboard of ongoing orders for restaurant owners</figcaption>
    </figure>
  </div>

  My proudest achievement? An efficient store open/closed status verification. The system uses a clever numerical encoding to represent opening and closing periods. Here are the key points:

  1. **Basic Structure**:
   - Periods are divided into 15-minute intervals (`@valid_minutes [0, 15, 30, 45]`)
   - Valid days are 1 to 7 (`@valid_days 1..7`)
   - Valid hours are 0 to 23 (`@valid_hours 0..23`)

  2. **Schema Fields**:
   ```elixir
   field :day, :integer, virtual: true            # weekday (1-7)
   field :open_hour, :integer, virtual: true      # opening hour (0-23)
   field :open_minute, :integer, virtual: true    # opening minute (0,15,30,45)
   field :close_hour, :integer, virtual: true     # closing hour (0-23)
   field :close_minute, :integer, virtual: true   # closing minute (0,15,30,45)

   field :close, :integer                        # encoded closing value
   field :open, :integer                         # encoded opening value
   ```

    Virtual fields are populated when a record is loaded from the database to simplify data manipulation.

  3. **Encoding**:
   - The system converts times into a single integer using the `encode/1` function
   - The basic formula is:
     - `encode_day`: (day - 1) * 24 * 4 (multiplies by 4 because there are 4 15-min periods per hour)
     - `encode_hour`: hour * 4
     - `encode_minute`: minute converted to corresponding 15-minute period

  4. **Handling Periods Crossing Midnight**:
   ```elixir
   close =
     if close < open do
       close_day = if (day + 1) not in @valid_days, do: 1, else: day + 1
       encode({close_day, get_field(c, :close_hour), get_field(c, :close_minute)})
     else
       close
     end
   ```
   If the closing time is less than the opening time (e.g., opens at 10PM and closes at 2AM), the system automatically adjusts to the next day.

  The advantages of this system are:
  - Store periods efficiently (just two integers)
  - Make simple comparisons between periods
  - Easily handle periods that cross midnight
  - Maintain 15-minute precision which is suitable for most business use cases

  What would I do differently? Instead of using all those virtual fields, I might implement a custom Ecto.Type. However, I found the existing approach sufficient and chose to focus on other important features.

  ### Giving back to the community

  I've always believed that the best way to grow as a developer is by engaging with the community. I'm an [active participant in the Elixir Forum](https://elixirforum.com/u/gushonorato/activity), where I frequently help answer questions and discuss best practices. In fact, it was through the forum that I first came across this job opportunity from Frontline Wildfire Defense!

  Beyond discussions, I've also contributed directly to the Phoenix LiveView framework. My first contribution was back in 2019, in the early days of Phoenix LiveView ([PR #1094](https://github.com/phoenixframework/phoenix_live_view/pull/1094) and [PR #463](https://github.com/phoenixframework/phoenix_live_view/pull/463)) by fixing some bugs.

  In 2019, I also released my first Elixir open-source project, [Mechanize](https://github.com/gushonorato/mechanize), an easy-to-use, browserless scraping library for Elixir.

  Giving back to the open-source community has always been important to me. More than that, I want to help establish Elixir and Phoenix as the go-to technologies for building startups. With this goal in mind, I've released another open-source project, which I'll introduce next.

  ### Magic Auth

  Last month I released my second open-source project, [Magic Auth](https://github.com/gushonorato/magic_auth), a simple and secure authentication library for Phoenix LiveView.

  While `phx.gen.auth` is amazing, it can require a significant amount of time to implement all the necessary flows, such as password resets, recovery screens, and UI customization. Magic Auth is designed to simplify authentication, requiring virtually the same minimal effort as implementing a BASIC HTTP authentication flow, but with much more power!

  This could be archieved because Magic Auth comes with a generetor that do all the heavy lifting. Actually, it's just 3 simple steps:

  1. Add Magic Auth to your project:
  ```elixir
  def deps do
    [
      {:magic_auth, "~> 0.1.0"}
    ]
  end
  ```

  1. Install and migrate:
  ```bash
  $ mix magic_auth.install
  $ mix ecto.migrate
  ```

  1. Protect your controllers and LiveViews routes:
  ```elixir
  defmodule MyAppWeb.Router do
      # Additional router contents...

      scope "/", MyAppWeb do
        # Add MagicAuth.require_authenticated/2 plug to protect controllers
        # and LiveView first mount (disconnected)
        pipe_through [:browser, :require_authenticated]

        get "/protected_controller", ProtectedController, :index

        # Use MagicAuth.required_authenticated/4 to protect LiveView's socket connection
        live_session :authenticated, on_mount: [{MagicAuth, :require_authenticated}] do
          live "/protected_live_view", ProtectedLiveView
        end
      end
  end
  ```

  And the developer get a fully functional authentication system like shown in screen below:

  <figure class="w-full">
    <a data-fslightbox href="/images/magic_auth_in_action.gif">
      <img src="/images/magic_auth_in_action.gif" alt="Magic Auth Demo" class="my-0 mx-auto">
    </a>
    <figcaption class="text-center">See Magic Auth in action</figcaption>
  </figure>

  ### Tests

  If you look at the open-source projects I've released, you'll see that I'm obsessed with testing. Although TDD suggests writing tests before implementation, I usually do it afterward. Before or after, what matters is that the software is well-tested. There is no bad software, only poorly tested software.

  # Soft Skills

  I'm a smiley, approachable person who genuinely enjoys discussing ideas. I do have opinions and like to express them, but I also value listening and open dialogue. When presented with compelling arguments, I have no problem changing my mind and I see it as an opportunity to learn and grow.

  As you can probably tell from this application, I also enjoy writing 😅.

  # After hours

  - I aways try to keep learning new things. I reserve at least 2 hours on tuesday and thursday to learn something new. At the time, I'm reading the [Machine Learning in Elixir](https://pragprog.com/titles/smelixir/machine-learning-in-elixir/) book.

  - I follow a lot on X (Twitter) from various developers, companies and indie hackers to stay up to date.

  - Since I'm not a native English speaker, I'm always looking for ways to improve my English.

  - Every night, before hitting the gym, I like to walk along the beach. It's not just for the physical benefits, but also for the mental clarity and relaxation it brings.

  <div class="rounded-md bg-yellow-50 px-4 py-2">
    <p class="text-sm font-medium text-yellow-800">I have plenty more to share, I hope I already convinced you enough to start a conversation. I am looking forward to your response / feedback!</p>
  </div>


  """

  def mount(_paramsm, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :update_time, 1000)
    {:ok, assign_current_time(socket)}
  end

  def handle_info(:update_time, socket) do
    Process.send_after(self(), :update_time, 1000)
    {:noreply, assign_current_time(socket)}
  end

  defp assign_current_time(socket), do: assign(socket, :current_time, DateTime.utc_now())

  def render(assigns) do
    ~H"""
    <article class="prose max-w-none">
      <.render_resume current_time={@current_time} />
    </article>
    """
  end

  attr :current_time, :any, required: true

  defp render_resume(assigns) do
    content = @resume |> Earmark.as_html!(escape: false) |> raw() |> render_code_blocks()

    assigns
    |> assign(:content, content)
    |> render_clocks()
  end

  attr :current_time, :any, required: true
  attr :content, :any, required: true

  defp render_clocks(assigns) do
    {:safe, content} = assigns.content
    [prelude, postlude] = String.split(content, "!!timezone_clocks!!")
    assigns = assign(assigns, prelude: prelude, postlude: postlude)

    ~H"""
    {{:safe, @prelude}}
    <Components.timezones current_time={@current_time} />
    {{:safe, @postlude}}
    """
  end

  defp render_code_blocks({:safe, html}) do
    html =
      Regex.replace(~r/<pre><code class=".*?">(.*?)<\/code><\/pre>/s, html, fn
        _content, block ->
          Makeup.highlight(block)
      end)

    {:safe, html}
  end
end
