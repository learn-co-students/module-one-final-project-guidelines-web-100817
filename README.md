# Twitter Bashboard

Twitter Bashboard is a command line application that provides a wide variety of tools to analyze and parse data about your own twitter account and the people you follow. We use Twitter's API to grab people you follow and a selection of their tweets, and utilize Google's Natural Language API to perform sentiment analysis - this means that you can see which of your friends/tweets/hashtags is the most positive or negative, and much more. We've also tried to make user input feel as natural as possible - there are multiple ways to ask the same thing and return the same data.

## Getting Started

To run this on your local computer, you will need keys for Google's Natural Language API. If you'd like to use our keys, please email us for further inquiries. Otherwise, the links below should help you set up your own keys and clone this repo locally.

### Prerequisites

If you want to use this code locally, you must:

  1. Sign up to use Google's Cloud APIs. You can do this [here](https://cloud.google.com/apis/).
  2. Create a new application and get your own set of keys for Google Natural Languge.
  3. Download and install Google Cloud SDK, found [here](https://cloud.google.com/sdk/).
  4. Set your environment variable in your Bash Profile as detailed [here](https://cloud.google.com/natural-language/docs/auth).
  5. Register as a developer with Twitter [here](https://apps.twitter.com/)
  6. Create a new Twitter application and put the keys in config/application.yml

### Installing

Fork and clone this repo, and edit this line to your project_id in lib/sentiment.rb :

```Ruby
class Sentiment
  def self.get_sentiment_score
  ...
  project_id = ENTER YOUR PROJECT NAME HERE
  ...
```

Make sure you run ```bundle install``` before continuing.

To make sure your Google Cloud authentication is working, make a quick new repository and follow the guide found [here](https://cloud.google.com/natural-language/docs/quickstart-client-libraries). If everything is all good, you should be ready to rumble!

Simply run the following command to start our application:

```Bash
ruby bin/run.rb
```

## Built With

* [Google Natural Language](https://cloud.google.com/natural-language/) - Text Analysis
* [Twitter Ruby Gem](https://github.com/sferik/twitter) - A Ruby Interface to the Twitter API
* [ICanHazDadJoke](https://icanhazdadjoke.com/) - A Joke for Any Occasion
* [Cat Facts](https://catfact.ninja/) - All You Ever Wanted to Know About Cats

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Authors

* [Dakota Lillie](https://github.com/dakotalillie)
* [Shirley Lin](https://github.com/slin12)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
