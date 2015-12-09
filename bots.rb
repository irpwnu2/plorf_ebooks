require 'twitter_ebooks'

# This is an example bot definition with event handlers commented out
# You can define and instantiate as many bots as you like

class MyBot < Ebooks::Bot
  # Configuration here applies to all MyBots
  attr_accessor :original, :model, :model_path

  def configure
    # Consumer details come from registering an app at https://dev.twitter.com/
    # Once you have consumer details, use "ebooks auth" for new access tokens
    self.consumer_key = 'AxmGZuB47XrZqScAZP0Hz1aZc' # Your app consumer key
    self.consumer_secret = 'J76VSJJTSyu5QEEand76h3oMbQicSMdljOEKYfQS6vYtXNSA83' # Your app consumer secret

    # Users to block instead of interacting with
    self.blacklist = ['tnietzschequote']

    # Range in seconds to randomize delay when bot.delay is called
    self.delay_range = 1..6
  end

  def on_startup
    load_model!

    scheduler.every '24h' do
      # Tweet something every 24 hours
      # See https://github.com/jmettraux/rufus-scheduler
      # tweet("hi")
      # pictweet("hi", "cuteselfie.jpg")
    end

    scheduler.every '1h' do
      statement = model.make_statement(140)
      tweet(statement)
    end
  end

  def on_message(dm)
    # Reply to a DM
    reply(dm, "secret secrets")
  end

  def on_follow(user)
    # Follow a user back
    follow(user.screen_name)
  end

  def on_mention(tweet)
    # Reply to a mention
      statement = model.make_statement(120)
      reply(tweet, statement)
  end

  def on_timeline(tweet)
    # Reply to a tweet in the bot's timeline
    #  reply(tweet, "good content, my guy")
  end

  private
  def load_model!
    return if @model

    @model_path ||= "model/#{original}.model"

    log "Loading model #{model_path}"
    @model = Ebooks::Model.load(model_path)
  end
end

# Make a MyBot and attach it to an account
MyBot.new("plorf_ebooks") do |bot|
  bot.access_token = "4420111767-GwOmj0gagrrOGFAwYhPKSc0sWKgMY5Tqg8pDXbV" # Token connecting the app to this account
  bot.access_token_secret = "0c4bs94MyZxKsunB6o2QFv4rdLL1vKIK5jz9rEI9Efqvz" # Secret connecting the app to this account

  bot.original = "plorf_"
end