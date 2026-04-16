FROM ruby:3.4.3-slim

# System dependencies
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Ruby gems
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local without 'development test' && \
    bundle install --jobs 4 --retry 3

# Install Node deps and compile Tailwind
COPY package.json package-lock.json ./
COPY app/assets/tailwind.css app/assets/tailwind.css
RUN npm ci && \
    ./node_modules/.bin/tailwindcss -i ./app/assets/tailwind.css -o ./public/style.css

COPY . .

# Remove Node deps after build (not needed at runtime)
RUN rm -rf node_modules

EXPOSE 9292

CMD ["bundle", "exec", "puma", "-p", "9292", "-e", "production"]
