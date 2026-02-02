# Crypto Projesi

Monorepo: mobil uygulama (Flutter) ve backend API (Node.js).

## Yapı

```
crypto_app/
├── crypto_mobil/    # Flutter mobil uygulama
└── crypto_backend/  # Node.js + Express API
```

## crypto_mobil (Flutter)

Mobil uygulama — Home, Coin detay, Arama, Watchlist, Ayarlar.

```bash
cd crypto_mobil
flutter pub get
flutter run
```

## crypto_backend (Node.js)

REST API — coin listesi, detay, ileride auth vb.

```bash
cd crypto_backend
npm install
npm run dev
```

Varsayılan port: **3000**. Endpoint'ler: `/health`, `/api/coins`, `/api/coins/:id`.

## Geliştirme

- **Mobil:** `crypto_mobil` içinde Flutter komutları kullanın.
- **Backend:** `crypto_backend` içinde `npm run dev` ile watch modunda çalıştırın.

Git init yapıldıysa tüm proje tek repo altında; isterseniz `crypto_mobil` ve `crypto_backend` ayrı repolara da bölünebilir.
