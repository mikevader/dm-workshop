FROM ruby:3.2.2

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update -qq \
 && apt-get install --no-install-recommends -y build-essential=12.9 libvips42=8.14.1-3 nodejs=18.13.0+dfsg1-1 npm=9.2.0~ds1-1 postgresql-client=15+248 \
 && apt-get remove cmdtest \
 && apt-get remove yarn \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
 && npm install -g yarn@1.22.19

RUN mkdir /app
WORKDIR /app

ARG RAILS_MASTER_KEY
ENV RAILS_MASTER_KEY=$RAILS_MASTER_KEY

ENV RAILS_LOG_TO_STDOUT="1" \
    RAILS_SERVE_STATIC_FILES="true" \
    RAILS_ENV="production" \
    BUNDLE_WITHOUT="development"

COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.4.19 \
 && bundle install
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile --gemfile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
# shellcheck disable=SC2034 \
RUN export NODE_OPTIONS=--openssl-legacy-provider \
 && SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# Entrypoint prepares the database.
ENTRYPOINT ["/app/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
