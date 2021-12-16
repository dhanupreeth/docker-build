FROM ubuntu:16.04

ENV RUBY_MAJOR="2.7" \
    RUBY_VERSION="2.7.1" \
    BUNDLER_VERSION="2.2.27" \
    GEM_VERSION="3.1.2"

ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_PATH="$GEM_HOME" \
	BUNDLE_BIN="$GEM_HOME/bin" \
	BUNDLE_SILENCE_ROOT_WARNING=1 \
	BUNDLE_APP_CONFIG="$GEM_HOME"

ENV PATH $BUNDLE_BIN:$PATH

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      build-essential \
      curl \
      libffi-dev \
      libgdbm-dev \
      libncurses-dev \
      libssl-dev \
      libyaml-dev \
      zlib1g-dev \
      wget \
      curl \
      bzip2 \
      make \
      gcc \
      libxml2 \
      libxml2-dev \
      libxslt1-dev \
      nodejs \
      postgresql-contrib \
      libpq-dev \
      git-core \
      imagemagick \
      libmagickcore-dev \
      libmagickwand-dev \
      build-essential \
      patch \
      zlib1g-dev \
      libssl-dev \
      libreadline-gplv2-dev \
      libffi-dev \
&& rm -rf /var/lib/apt/lists/*

RUN echo 'gem: --no-document' >> /.gemrc

RUN mkdir -p /tmp/ruby \
  && curl -L "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.bz2" \
      | tar -xjC /tmp/ruby --strip-components=1 \
  && cd /tmp/ruby \
  && ./configure --disable-install-doc \
  && make \
  && make install \
  && gem update --system \
  && rm -r /tmp/ruby

RUN gem update --system "$GEM_VERSION" \
    && gem install --no-document bundler --version "$BUNDLER_VERSION"

ENV TERM xterm
RUN gem install foreman
