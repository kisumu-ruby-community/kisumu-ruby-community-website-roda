# Kisumu Ruby Community Website

The official website for the Kisumu Ruby Community, a community of Ruby and Rails developers based in Kisumu, Kenya. Built with Roda, Sequel, PostgreSQL, and Tailwind CSS v4.

---

## Tech Stack

- Ruby (3.4.3)
- Roda - web framework
- Sequel - database toolkit
- PostgreSQL - database
- Puma - web server
- Tailwind CSS v4 - styling
- ERB - templating
- Node.js / npm - for Tailwind CLI

---

## Project Structure

```
.
├── app/
│   ├── assets/         # Tailwind CSS input
│   ├── models/         # Sequel models
│   ├── routes/         # Route handler classes
│   ├── services/       # Business logic
│   ├── validators/     # Input validation
│   ├── jobs/           # Background jobs
│   └── views/
│       ├── pages/      # Page templates
│       ├── partials/   # Shared partials (header, footer)
│       └── layout.erb  # Base layout
├── config/
│   └── database.rb     # Database connection
├── db/
│   ├── 001_create_users.rb  # Migrations
│   └── seeds.rb             # Seed data
├── public/
│   ├── assets/         # Static assets (images, etc.)
│   └── style.css       # Compiled Tailwind CSS output
├── tests/
├── app.rb              # Main application
├── config.ru           # Rack entry point
├── Gemfile
└── package.json
```

---

## Prerequisites

Ensure the following are installed on your system:

- Ruby 3.4.3 (via rbenv or rvm recommended)
- Bundler (`gem install bundler`)
- PostgreSQL
- Node.js and npm

---

## Setup

### 1. Clone the repository

```bash
git clone https://github.com/kisumu-ruby-community/kisumu-ruby-community-website-roda.git
cd kisumu-ruby-community-website-roda
```

### 2. Install Ruby dependencies

```bash
bundle install
```

### 3. Install Node dependencies

```bash
npm install
```

### 4. Configure environment variables

Copy the example below into a `.env` file at the project root and update the values to match your local PostgreSQL setup:

```bash
DATABASE_URL=postgres://<username>:<password>@localhost/kisumu_ruby_community
```

### 5. Create the database

```bash
createdb kisumu_ruby_community
```

### 6. Run migrations

```bash
bundle exec sequel -m db $DATABASE_URL
```

Or with the URL inline:

```bash
bundle exec sequel -m db postgres://<username>:<password>@localhost/kisumu_ruby_community
```

### 7. Seed the database (optional)

```bash
bundle exec ruby db/seeds.rb
```

---

## Running the App

### Start the web server

```bash
rackup -s puma
```

The app will be available at http://localhost:9292.

### Compile Tailwind CSS

In a separate terminal, run the Tailwind watcher to compile styles on file changes:

```bash
npx @tailwindcss/cli -i ./app/assets/tailwind.css -o ./public/style.css --watch
```

To compile once without watching:

```bash
npx @tailwindcss/cli -i ./app/assets/tailwind.css -o ./public/style.css
```

---

## Routes

| Method | Path       | Description       |
|--------|------------|-------------------|
| GET    | /          | Homepage          |
| GET    | /about     | About page        |
| GET    | /contact   | Contact page      |

---

## Database

Migrations are located in `db/` and follow the naming convention `001_description.rb`. Sequel's built-in migrator is used to run them.

To run migrations:

```bash
bundle exec sequel -m db $DATABASE_URL
```

To roll back, Sequel migrations support a `down` block. Use the `-M` flag to target a specific version:

```bash
bundle exec sequel -m db -M 0 $DATABASE_URL
```

---

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Commit your changes (`git commit -m 'Add your feature'`)
4. Push to the branch (`git push origin feature/your-feature`)
5. Open a pull request

---

## License

MIT
