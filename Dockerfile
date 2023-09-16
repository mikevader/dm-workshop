FROM ruby:3.0

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get install -y nodejs yarn postgresql-client

RUN mkdir /app
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.2.25 \
 && bundle install
COPY . .

RUN export NODE_OPTIONS=--openssl-legacy-provider \
 && rake assets:precompile

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
