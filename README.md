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
├── app/
│   ├── assets/
│   │   └── tailwind.css        # Tailwind CSS input (design tokens + base styles)
│   ├── jobs/                   # Background jobs (Phase 2+)
│   ├── models/                 # Sequel models
│   │   ├── user.rb
│   │   ├── profile.rb
│   │   ├── event.rb
│   │   ├── event_speaker.rb
│   │   ├── post.rb
│   │   ├── resource.rb
│   │   ├── subscriber.rb
│   │   └── sponsor.rb
│   ├── routes/                 # Route handler classes
│   │   ├── home.rb
│   │   ├── about.rb
│   │   ├── contact.rb
│   │   ├── events.rb
│   │   ├── blog.rb
│   │   ├── members.rb
│   │   ├── resources.rb
│   │   └── join.rb             # Redirects to /contact
│   ├── services/               # Business logic
│   │   ├── home_service.rb
│   │   ├── about_service.rb
│   │   ├── contact_service.rb
│   │   ├── events_service.rb
│   │   ├── blog_service.rb
│   │   ├── members_service.rb
│   │   └── resources_service.rb
│   ├── validators/             # Input validation
│   └── views/
│       ├── pages/
│       │   ├── index.erb       # Homepage
│       │   ├── about.erb
│       │   ├── contact.erb
│       │   ├── members.erb
│       │   ├── resources.erb
│       │   ├── events/
│       │   │   ├── index.erb   # Events list
│       │   │   └── show.erb    # Event detail
│       │   └── blog/
│       │       ├── index.erb   # Blog list
│       │       └── show.erb    # Blog post detail
│       ├── partials/
│       │   ├── header.erb
│       │   └── footer.erb
│       └── layout.erb
├── config/
│   └── database.rb             # Sequel DB connection
├── db/
│   ├── 001_create_users.rb
│   ├── 002_create_events.rb
│   ├── 003_create_event_speakers.rb
│   ├── 004_create_posts.rb
│   ├── 005_create_resources.rb
│   ├── 006_create_subscribers.rb
│   ├── 007_create_sponsors.rb
│   ├── 008_create_rsvps.rb
│   └── seeds.rb
├── guide/
│   └── project-description.md  # Full feature requirements
├── lib/
│   └── utils/
│       └── create_user_table.sh
├── public/
│   ├── assets/
│   │   └── logo/
│   │       └── KRC-1.png
│   └── style.css               # Compiled Tailwind CSS output
├── tests/
├── app.rb                      # Main application
├── config.ru                   # Rack entry point
├── Gemfile
└── package.json
```

---

## Routes

| Method | Path          | Description            |
|--------|---------------|------------------------|
| GET    | /             | Homepage               |
| GET    | /about        | About page             |
| GET    | /contact      | Contact & Join page    |
| POST   | /contact      | Submit contact/proposal form |
| GET    | /events       | Events list            |
| GET    | /events/:id   | Event detail           |
| GET    | /blog         | Blog list              |
| GET    | /blog/:slug   | Blog post detail       |
| GET    | /members      | Public member directory |
| GET    | /resources    | Resources page         |
| GET    | /join         | Redirects to /contact  |

---

## Database Schema

| Table            | Key Fields                                                              |
|------------------|-------------------------------------------------------------------------|
| `users`          | id (uuid), name, email, password_digest, created_at                    |
| `profiles`       | id (uuid), full_name, bio, avatar_url, github, linkedin, role, is_public |
| `events`         | id (uuid), title, description, type, date, location, cover_image, status, created_by |
| `event_speakers` | id (uuid), event_id, name, bio, photo_url                              |
| `posts`          | id (uuid), title, slug, content, author_id, cover_image, tags, status, published_at |
| `resources`      | id (uuid), title, url, category, submitted_by, is_approved             |
| `subscribers`    | id (uuid), email, subscribed_at                                        |
| `sponsors`       | id (uuid), name, logo_url, website_url, is_active                      |
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
bundle exec sequel -m db $DATABASE_URL
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

```bash
npx @tailwindcss/cli -i ./app/assets/tailwind.css -o ./public/style.css --watch
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
