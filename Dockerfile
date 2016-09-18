FROM ruby:2.3.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev postgresql-client
RUN mkdir /tenken
WORKDIR /tenken
ADD Gemfile /tenken/Gemfile
ADD Gemfile.lock /tenken/Gemfile.lock
RUN bundle install
ADD . /tenken
