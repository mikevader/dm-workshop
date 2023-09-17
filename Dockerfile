FROM ruby:3.2.2

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
 && apt-get install -y nodejs npm postgresql-client \
 && apt-get remove cmdtest \
 && apt-get remove yarn \
 && apt-get clean \
 && rm /var/lib/apt/lists/* \
 && npm install -g yarn

RUN mkdir /app
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.4.19 \
 && bundle install
COPY . .

RUN export NODE_OPTIONS=--openssl-legacy-provider \
 && rake assets:precompile

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
