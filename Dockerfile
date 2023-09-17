FROM ruby:3.2.2

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
 && apt-get install --no-install-recommends -y nodejs=18.13.0+dfsg1-1 npm=9.2.0~ds1-1 postgresql-client=15+248 \
 && apt-get remove cmdtest \
 && apt-get remove yarn \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
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
