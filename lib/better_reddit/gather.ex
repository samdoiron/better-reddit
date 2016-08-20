defmodule BetterReddit.Gather do
  @moduledoc ~S"""
  Gatherer is the constant process that gathers content fron Reddit's
  API and stores it in the database.
  """

  require Logger

  @subreddits ~w(
AskReddit
funny
todayilearned
pics
science
worldnews
IAmA
announcements
videos
gaming
movies
Music
aww
news
gifs
explainlikeimfive
askscience
EarthPorn
books
television
LifeProTips
mildlyinteresting
DIY
Showerthoughts
space
sports
tifu
Jokes
InternetIsBeautiful
food
history
gadgets
photoshopbattles
nottheonion
dataisbeautiful
Futurology
Documentaries
GetMotivated
personalfinance
listentothis
philosophy
UpliftingNews
OldSchoolCool
Art
creepy
nosleep
WritingPrompts
TwoXChromosomes
Fitness
technology
bestof
WTF
AdviceAnimals
politics
atheism
woahdude
europe
gonewild
leagueoflegends
trees
pokemongo
gameofthrones
interestingasfuck
4chan
Games
BlackPeopleTwitter
programming
Android
nsfw
sex
cringepics
pcmasterrace
reactiongifs
malefashionadvice
ImGoingToHellForThis
pokemon
RealGirls
Overwatch
Frugal
fffffffuuuuuuuuuuuu
YouShouldKnow
NSFW_GIF
Unexpected
relationships
HistoryPorn
AskHistorians
oddlysatisfying
lifehacks
nfl
soccer
StarWars
tattoos
comics
OutOfTheLoop
JusticePorn
Minecraft
FoodPorn
facepalm
cringe
nba
hiphopheads
me_irl
wheredidthesodago
GlobalOffensive
anime
buildapc
wallpapers
GameDeals
hearthstone
freebies
gentlemanboners
conspiracy
Cooking
TrueReddit
cats
olympics
talesfromtechsupport
shittyaskscience
apple
loseit
EatCheapAndHealthy
skyrim
asoiaf
NetflixBestOf
humor)

  @reddit_api_timeout_ms 2_000

  def start_link do
    case Task.start_link(fn -> run() end) do
      {:ok, pid} ->
        Process.register(pid, __MODULE__)
        {:ok, pid}
      other -> other
    end
  end

  def run do
    for subreddit <- @subreddits do
      sleep_timeout()
      update_subreddit(subreddit)
    end
    run()
  end

  defp update_subreddit(name) do
    Logger.debug("updating subreddit #{name}")
    listing = BetterReddit.Reddit.HTTP.get_subreddit(name)
    BetterReddit.Repo.put_listing(name, listing)
  end

  defp sleep_timeout do
    :timer.sleep(@reddit_api_timeout_ms)
  end
end
