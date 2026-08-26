# Kisumu Ruby Community Website

The official website for the Kisumu Ruby Community, a community of Ruby and Rails developers based in Kisumu, Kenya. Built with Roda, Sequel, PostgreSQL, and Tailwind CSS v4.

---

## Tech Stack

- Ruby (3.4.3)
- Roda - web framework
- Sequel - database toolkit
- PostgreSQL - database
- Puma - web server
- Tailwind CSS v4 - styling (Space Mono + JetBrains Mono)
- ERB - templating
- Node.js / npm - for Tailwind CLI
- dotenv - environment variable loading
- bcrypt - password hashing

---

## Project Structure

```
.
├── .github/
│   ├── pull_request_template.md
│   └── workflows/
│       ├── fly-deploy.yml      # Deploy to Fly.io on merge to main
│       ├── ping.yml            # Keep-alive ping for the deployed app
│       └── pr-check.yml        # CI checks on pull requests
├── app/
│   ├── assets/
│   │   └── tailwind.css        # Tailwind CSS input (design tokens + base styles)
│   ├── jobs/                   # Background jobs (placeholder)
│   ├── models/                 # Sequel models
│   │   ├── company.rb
│   │   ├── event.rb
│   │   ├── event_speaker.rb
│   │   ├── post.rb             # stub
│   │   ├── profile.rb          # stub
│   │   ├── resource.rb
│   │   ├── sponsor.rb          # stub
│   │   ├── subscriber.rb       # stub
│   │   └── user.rb
│   ├── routes/                 # Route handler classes
│   │   ├── about.rb
│   │   ├── admin.rb
│   │   ├── blog.rb             # stub
│   │   ├── companies.rb
│   │   ├── contact.rb
│   │   ├── events.rb
│   │   ├── home.rb
│   │   ├── join.rb             # Redirects to /contact
│   │   ├── members.rb          # stub
│   │   └── resources.rb
│   ├── services/               # Business logic
│   │   ├── admin/
│   │   │   ├── companies_admin_service.rb
│   │   │   ├── events_admin_service.rb
│   │   │   └── resources_admin_service.rb
│   │   ├── about_service.rb
│   │   ├── blog_service.rb     # stub
│   │   ├── companies_service.rb
│   │   ├── contact_service.rb
│   │   ├── events_service.rb
│   │   ├── home_service.rb
│   │   ├── join_service.rb
│   │   ├── members_service.rb  # stub
│   │   └── resources_service.rb
│   ├── validators/             # Input validation (placeholder)
│   └── views/
│       ├── pages/
│       │   ├── admin/
│       │   │   ├── events/
│       │   │   │   ├── form.erb    # Create / edit event
│       │   │   │   ├── index.erb   # Events list
│       │   │   │   └── rsvps.erb   # Event attendees
│       │   │   ├── companies/
│       │   │   │   ├── form.erb    # Create / edit company
│       │   │   │   └── index.erb   # Companies list
│       │   │   └── resources/
│       │   │       ├── form.erb    # Create / edit resource
│       │   │       └── index.erb   # Resources list
│       │   ├── blog/
│       │   │   ├── index.erb   # Blog list (stub)
│       │   │   └── show.erb    # Blog post detail (stub)
│       │   ├── events/
│       │   │   ├── index.erb   # Events list
│       │   │   └── show.erb    # Event detail
│       │   ├── 404.erb
│       │   ├── 500.erb
│       │   ├── about.erb
│       │   ├── built_with_ruby.erb
│       │   ├── contact.erb
│       │   ├── index.erb       # Homepage
│       │   ├── join.erb
│       │   ├── members.erb     # stub
│       │   └── resources.erb
│       ├── partials/
│       │   ├── admin_nav.erb   # Shared admin tab navigation
│       │   ├── footer.erb
│       │   ├── header.erb
│       │   └── seo.erb         # SEO meta tags partial
│       └── layout.erb
├── config/
│   ├── database.rb             # Sequel DB connection
│   └── rack_attack.rb          # Rate limiting / throttling
├── db/
│   ├── 001_create_users.rb
│   ├── 002_create_events.rb
│   ├── 003_create_event_speakers.rb
│   ├── 004_create_posts.rb
│   ├── 005_create_resources.rb
│   ├── 006_create_subscribers.rb
│   ├── 007_create_sponsors.rb
│   ├── 008_create_rsvps.rb
│   ├── 009_update_users_for_github_oauth.rb
│   ├── 010_update_events.rb
│   ├── 011_add_description_to_resources.rb
│   ├── 012_create_companies.rb
│   └── seeds.rb
├── guide/
│   └── project-description.md  # Full feature requirements
├── lib/
│   ├── display_count.rb
│   ├── middleware/
│   │   └── security_headers.rb
│   └── utils/
│       └── image_upload.rb
├── public/
│   ├── assets/
│   │   └── logo/
│   │       └── KRC-1.png
│   ├── uploads/                # Local image uploads (dev only)
│   ├── manifest.json           # PWA manifest
│   ├── robots.txt
│   ├── style.css               # Compiled Tailwind CSS output
│   └── sw.js                   # Service worker
├── tests/
├── .dockerignore
├── .env.example
├── .gitignore
├── Dockerfile
├── fly.toml                    # Fly.io deployment config
├── app.rb                      # Main application
├── config.ru                   # Rack entry point
├── Gemfile
├── Gemfile.lock
├── package.json
├── package-lock.json
└── Procfile                    # Process types for `foreman start` (web + css)
```

---

## Routes

| Method | Path                          | Description                        |
|--------|-------------------------------|------------------------------------|
| GET    | /                             | Homepage                           |
| GET    | /about                        | About page                         |
| GET    | /contact                      | Contact & Join page                |
| POST   | /contact                      | Submit contact/proposal form       |
| GET    | /events                       | Events list                        |
| GET    | /events/:id                   | Event detail                       |
| POST   | /events/:id/rsvp              | RSVP to an event                   |
| POST   | /events/:id/rsvp/cancel       | Cancel RSVP                        |
| GET    | /resources                    | Resources page                     |
| GET    | /built-with-ruby              | Built with Ruby companies page     |
| GET    | /join                         | Redirects to /contact              |
| GET    | /admin/events                 | Admin — events list                |
| GET    | /admin/events/new             | Admin — new event form             |
| POST   | /admin/events                 | Admin — create event               |
| GET    | /admin/events/:id/edit        | Admin — edit event form            |
| POST   | /admin/events/:id             | Admin — update event               |
| POST   | /admin/events/:id/delete      | Admin — delete event               |
| GET    | /admin/events/:id/rsvps       | Admin — view event attendees       |
| GET    | /admin/resources              | Admin — resources list             |
| GET    | /admin/resources/new          | Admin — new resource form          |
| POST   | /admin/resources              | Admin — create resource            |
| GET    | /admin/resources/:id/edit     | Admin — edit resource form         |
| POST   | /admin/resources/:id          | Admin — update resource            |
| POST   | /admin/resources/:id/delete   | Admin — delete resource            |
| GET    | /admin/companies              | Admin — companies list             |
| GET    | /admin/companies/new          | Admin — new company form           |
| POST   | /admin/companies              | Admin — create company             |
| GET    | /admin/companies/:id/edit     | Admin — edit company form          |
| POST   | /admin/companies/:id          | Admin — update company             |
| POST   | /admin/companies/:id/delete   | Admin — delete company             |

---

## Database Schema

| Table            | Key Fields                                                              |
|------------------|-------------------------------------------------------------------------|
| `users`          | id (uuid), name, email, password_digest, created_at                    |
| `profiles`       | id (uuid), full_name, bio, avatar_url, github, linkedin, role, is_public |
| `events`         | id (uuid), title, description, type, date, location, cover_image, status, created_by |
| `event_speakers` | id (uuid), event_id, name, bio, photo_url                              |
| `posts`          | id (uuid), title, slug, content, author_id, cover_image, tags, status, published_at |
| `resources`      | id (uuid), title, url, category, description, submitted_by, is_approved, created_at |
| `subscribers`    | id (uuid), email, subscribed_at                                        |
| `sponsors`       | id (uuid), name, logo_url, website_url, is_active                      |
| `companies`      | id (uuid), name, website_url, logo_url, description, country, category, is_approved, created_at |
| `rsvps`          | id (uuid), event_id, user_id, created_at                               |

---

## Prerequisites

- Ruby 3.4.3 (via rbenv or rvm)
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

Copy `.env.example` to `.env` and fill in the values:

```bash
cp .env.example .env
```

| Variable | Description |
|---|---|
| `DATABASE_URL` | PostgreSQL connection string |
| `FORMSPREE_CONTACT_URL` | Formspree endpoint for the contact form |
| `FORMSPREE_PROPOSAL_URL` | Formspree endpoint for the talk proposal form |
| `GITHUB_CLIENT_ID` | GitHub OAuth App client ID |
| `GITHUB_CLIENT_SECRET` | GitHub OAuth App client secret |
| `ADMIN_GITHUB_USERNAME` | Comma-separated GitHub usernames to seed as admins (e.g. `alice,bob`) |
| `SESSION_SECRET` | Random secret for cookie sessions - minimum 64 characters |

**GitHub OAuth App setup:**
1. Go to https://github.com/settings/developers → New OAuth App
2. Set Homepage URL to `http://localhost:9292`
3. Set Callback URL to `http://localhost:9292/auth/github/callback`
4. Copy the Client ID and Secret into `.env`

**Generate a session secret:**
```bash
ruby -e "require 'securerandom'; puts SecureRandom.hex(64)"
```

### 5. Create the database

```bash
createdb kisumu_ruby_community
```

### 6. Run migrations

```bash
bundle exec ruby -e "
  require 'dotenv/load'
  require 'sequel'
  require 'sequel/extensions/migration'
  DB = Sequel.connect(ENV.fetch('DATABASE_URL'))
  Sequel::Migrator.run(DB, 'db')
  puts 'Migrations complete. Version: ' + DB[:schema_info].first[:version].to_s
"
```

### 7. Seed the database (optional)

```bash
bundle exec ruby db/seeds.rb
```

---

## Running the App

The `Procfile` defines the processes needed for local development:

```
web: rackup -s puma
css: npx @tailwindcss/cli -i ./app/assets/tailwind.css -o ./public/style.css --watch
```

### Option A: Run both processes with Foreman

[Foreman](https://github.com/ddollar/foreman) reads the `Procfile` and starts the web server and Tailwind watcher together with a single command.

```bash
gem install foreman
foreman start
```

The app will be available at http://localhost:9292, and `public/style.css` will rebuild automatically as you edit `app/assets/tailwind.css`.

### Option B: Run processes manually

If you don't have Foreman installed, start each process in its own terminal:

```bash
# Terminal 1: web server
rackup -s puma

# Terminal 2: Tailwind CSS watcher
npx @tailwindcss/cli -i ./app/assets/tailwind.css -o ./public/style.css --watch
```

The app will be available at http://localhost:9292.

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
