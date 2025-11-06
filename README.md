# Bank-Exit

A voluntary, non-partisan collective whose aim is to offer legal, peaceful and sovereign tools to as many citizens as possible, to enable banking emancipation and resilience.

<p align="center">
  <img src="app/assets/images/logo_EN.png" width="auto" height="200" alt="Bank-Exit logo">
  <img src="app/assets/images/logo.png" width="200" height="200" alt="Logo Sortie de Banque">
</p>

## 📌 Table of Contents

- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Getting Started](#-getting-started)
- [Available Commands](#-available-commands)
- [Merchant Data](#-merchant-data)
- [Map Routing](#-map-routing)
- [Internationalization](#-internationalization)
- [Tutorials](#-tutorials)
- [Assets and Media](#-assets-and-medias)
- [Running Tests](#-running-tests)
- [Contributing](#-contributing)
- [Security](#-security)
- [License](#-license)

## ✨ Features

- Interactive map of merchants accepting **Bitcoin**, **Monero**, and **Ġ1 (June)**
- Directory of professionals who accept these cryptocurrencies
- Dedicated **Pro Space** to assist businesses in offering crypto payments in-store
- Blog and tutorials section to educate users and merchants

## 🧰 Tech Stack

### 🛠️ Backend

- [**Ruby on Rails 8**](https://rubyonrails.org/) — Full-stack web framework optimized for productivity.
- [**Solid Queue**](https://github.com/rails/solid_queue) — Active Job adapter using the database as a durable queue backend.
- [**Solid Cable**](https://github.com/rails/solid_cable) — Action Cable adapter backed by the database.
- [**Solid Cache**](https://github.com/rails/solid_cache) — In-database caching engine integrated with Rails.

### 🗄️ Database

- [**SQLite**](https://www.sqlite.org/index.html) — Lightweight, serverless SQL database.

### 🖥️ Frontend

- [**Hotwire**](https://hotwired.dev/) — Modern HTML-over-the-wire framework for reactive UIs.
  - [**Turbo**](https://turbo.hotwired.dev/) — Speeds up navigation and updates without full page reloads.
  - [**Stimulus**](https://stimulus.hotwired.dev/) — Lightweight JavaScript framework to enhance HTML behavior.
- [**Importmap**](https://github.com/rails/importmap-rails) — Load JavaScript modules directly in the browser, no bundler required.
- [**Slim**](https://slim-template.github.io/) — Lightweight templating engine with clean syntax.
- [**DaisyUI**](https://daisyui.com/) — Tailwind CSS component library for building UI elements quickly.

### 🚀 Deployment

- [**Kamal**](https://kamal-deploy.org/) — Lightweight Docker-based deployment tool maintained by the Rails team.

### 🧪 Testing

- [**RSpec**](https://rspec.info/) — Behavior-driven development testing framework for Ruby and Rails.

### 🧹 Other Tools

- [**Rubocop**](https://github.com/rubocop/rubocop) — Ruby code linter and formatter following community conventions.

## ⚙️ Getting Started

### Prerequisites

- **Ruby (see `.ruby-version`)**  
  Recommended installation method: [mise](https://mise.jdx.dev/lang/ruby.html) — a minimal, fast, and dependable Ruby installer.  
  See the official Rails guide for details: [Installing Ruby on Rails](https://guides.rubyonrails.org/install_ruby_on_rails.html#installing-ruby)

- **SQLite 3**

### Installation

```bash
$ git clone https://github.com/Unbanked0/bank_exit
$ cd bank_exit

$ bin/setup
```

> [!TIP]
> Website is now ready to be accessed at http://localhost:3000 ! 🎉

To initially populate the database with merchants data, run the command in a Rails console:

```
❯ bin/rails console
bank-exit(dev)> FetchMerchants.call
```

> [!WARNING]
> This process would take few hours because an individual geocoding call is involved for each row to get the country code.  
> To speed up process, comment the `Merchants::AssignCountry.call` in the [FetchMerchants](app/services/fetch_merchants.rb) service to skip the country data.

## 💻 Available Commands

- `bin/dev` – Start processes defined in [Procfile](Procfile) (web and css)
- `bin/rails server` – Start the Rails server only
- `bin/rails db:migrate` – Run migrations to database
- `bin/rails sitemap:refresh:no_ping` – Regenerate the sitemap
- `bundle exec chusaku` – Annotate Rails controllers with route info

## 🏪 Merchant Data

Merchant data that populate the map are retrieved dynamically from the [Overpass](https://overpass-turbo.eu/) API.

A recurring task, managed by [SolidQueue](https://github.com/rails/solid_queue#recurring-tasks), runs every 6 hours to automatically refresh merchants data.
A manual refresh button is still possible in the `maps#index` page.

## 🧭 Map Routing

Itinerary is calculated by the [OSRM Routing API](https://project-osrm.org/docs/v5.5.1/api) that detects the fastest way by car.

Adresses autocomplete are fetched from the Nominatim API through the [geocoder gem](https://github.com/alexreisner/geocoder).

## 🌐 Internationalization

Refer to the [Wiki article](https://github.com/Unbanked0/bank_exit/wiki/Internationalization-(i18n)) to add or update a new locale.

## 🎓 Tutorials

Refer to the [Wiki article](https://github.com/Unbanked0/bank_exit/wiki/Tutorials-Configuration-Documentation) to add or update a tutorial article.

## 🖼️ Assets and Media

- Background images are coming from [Unsplash](https://unsplash.com).
- SVG icons are taken from [Lucide icons](https://lucide.dev).
- Map markers are extracted from [spritesheet.svg](public/map/spritesheet.svg).
- Contact brands icons are coming from official website or Wikipedia.

## 🧪 Running Tests

Before submitting any changes, please ensure the test suite passes:

```bash
$ bin/ci
```

## 🤝 Contributing

We welcome contributions!

- Please read [CONTRIBUTING.md](CONTRIBUTING.md) before submitting a pull request.
- Look for issues labeled `good first issue` or `help wanted`.

## 📄 License

This project is licensed under the **GNU Affero General Public License v3.0 (AGPLv3)**.
See the [LICENSE](LICENSE) file for the full license text and details.

The AGPLv3 license ensures that the source code and any modifications remain open and that users interacting with the software over a network can receive the source code.
