FROM ruby:2.6-alpine

EXPOSE 4567

RUN apk update && apk add coreutils git make g++ nodejs bash
RUN git clone https://github.com/slatedocs/slate /slate/source

WORKDIR /slate/source

RUN gem install bundler && bundle install

VOLUME /slate/source
VOLUME /slate/source/build

CMD bundle exec middleman build --clean
