# crypto_mobil

Flutter client for the crypto app (Android, iOS, web, desktop) built with **Clean Architecture + BLoC** and real‑time price streaming.

---

## Purpose

This app is designed as a **portfolio‑grade** project to demonstrate:

- layered architecture on Flutter (domain / data / presentation),
- real‑time data integration with Socket.IO,
- testable state management with BLoC,
- type‑safe networking and model handling (no `dynamic` chaos),
- and production‑style concerns (DI, env config, local storage).

---

## Features

- **Home**
  - Live market list (prices update in real time via Socket.IO)
  - Overview card (24h volume + BTC dominance from backend ticker data)
  - Filter bar: All, Gainers, Losers, Watchlist (with mixin‑based logic)

- **Coin Detail**
  - Candlestick chart (Binance klines) with multiple intervals
  - Live price updates for the selected symbol only
  - 24h market stats: change %, volume, high/low, etc.

- **Search**
  - Server‑side symbol search (`/api/market/symbols?search=...`)
  - Coin icons via CDN (`CoinImageHelper` + `cached_network_image`)

- **Watchlist**
  - Favorites stored locally (SharedPreferences via `WatchlistRepository`)
  - Summary card for total balance / change (ready for extension)
  - Tapping a favorite navigates to coin detail

- **Settings**
  - UI built and wired, ready for additional options (themes, locales, etc.)

---

## Architecture & tech stack

- **Architecture**
  - Clean Architecture split under `lib/core` (domain + data + shared) and `lib/feature` (screens + BLoC).
  - Domain: `entities`, `repositories` (abstract), `usecases`.
  - Data: `datasources` (Dio + Socket.IO + local storage) and concrete repositories.
  - Presentation: feature‑scoped BLoC + widgets.

- **State management**
  - `flutter_bloc` + `equatable` for Home, CoinDetail, Search, Watchlist flows.

- **Networking & real‑time**
  - `dio` with interceptors + error mapping.
  - `socket_io_client` wrapped in `SocketClient` (subscribe/unsubscribe, health logs).

- **Config & DI**
  - `envied` (`lib/core/config/env.dart`) reads `.env` at build time.
  - `get_it` + `injectable` for dependency injection (`lib/core/di/injection.dart`).

- **Storage & utilities**
  - `flutter_secure_storage` + `shared_preferences` via `LocalStorageDataSource`.
  - `json_serializable` models for prices, klines, tickers, symbols.
  - Reusable mixins: loading, error handling, debounce, connectivity.

---

## Environment

Client uses Envied with a local `.env` file (not committed). Example:

API_BASE_URL=http://localhost:3000
WS_BASE_URL=ws://localhost:3000
ENABLE_LOGS=true

Values are configured in `lib/core/config/env.dart`.  
`.env` is git‑ignored; only `.env.example` is versioned.

---

## Setup & Run

cd crypto_mobil
cp .env.example .env   # adjust URLs if needed
flutter pub get
flutter run

Backend is expected to run at `API_BASE_URL` (see `crypto_backend`).

---

## Screenshots

Add your screenshots under `crypto_mobil/screenshots/` and reference them here, e.g.:

![Home](screenshots/home.png)
![Coin Detail](screenshots/coin_detail.png)
![Search](screenshots/search.png)
![Watchlist](screenshots/watchlist.png)
