FROM ruby:3.4.3-slim

# System dependencies
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    curl \
    build-essential \
    libpq-dev \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Ruby gems
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local without 'development test' && \
    bundle install --jobs 4 --retry 3

# Install Node deps first
COPY package.json package-lock.json ./

# Make sure optional native deps are included
ENV npm_config_include=optional=true

RUN npm ci

# Copy only the files needed for Tailwind build
COPY app/assets/tailwind.css app/assets/tailwind.css
COPY . .

# Build Tailwind using the current CLI package entrypoint
RUN npx @tailwindcss/cli -i ./app/assets/tailwind.css -o ./public/style.css

# Remove Node deps after build
RUN rm -rf node_modules

EXPOSE 9292

CMD ["bundle", "exec", "puma", "-p", "9292", "-e", "production"]