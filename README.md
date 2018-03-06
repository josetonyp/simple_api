# Simple API

Simple API that handles users and contract and works as sandbox for Sinatra and MondoDB projects.

### Prerequisites

You will need to have Mongo DB install in local in order to run this project for development purposes. Please follow the following [installation instruccion.](https://docs.mongodb.com/manual/installation/)

### Installing

1) Run bundler to install dependencies

```
bundle install
```

2) Require aliases from bin folder to include in your currect shell session CLI helpers to aid with development.

```
. ./bin/.aliases
```


## Running the tests

Tests are developed with Rspec and Rack::Test, to execute test run:

```
bundle exec rspec
```

There is an script on Bin folder to test deployed app to production. To execute this script run:

```
ruby ./bin/http_tests.rb
```

## Deployment

This application is deployed on a sandbox on heroku free tier. To deploy to this application ask for permission and run:

```
git push heroku master
```

You can visit the working app at [https://young-retreat-51574.herokuapp.com/api/xyz](https://young-retreat-51574.herokuapp.com/api/xyz)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
