# NEOCHAT

Web chat mirip WhatsApp, style neo-brutalism, responsive mobile & desktop.

## Fitur

- Login & daftar akun (username + password), dengan captcha
- Centang status pesan: terkirim (✓) dan sudah dibaca (✓✓ biru)
- Admin panel: ban/unban user, hapus akun
- Database Postgres (Neon), bukan localStorage
- Session via JWT httpOnly cookie

## Struktur

```
public/           frontend (html, css, js terpisah)
api/              serverless functions (Vercel)
lib/              helper (db, auth, captcha)
schema.sql        migrasi database + akun admin default
DEPLOY.md         panduan deploy ke Vercel
```

## Setup lokal

```bash
npm install
cp .env.example .env
# isi DATABASE_URL dan JWT_SECRET di .env
vercel dev
```

Lihat `DEPLOY.md` untuk deploy ke Vercel.
