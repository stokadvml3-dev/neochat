# Deploy NEOCHAT ke Vercel

## 1. Buat database Postgres (Neon, gratis, terintegrasi Vercel)

1. Buka https://vercel.com/dashboard, pilih project (atau buat baru dulu dari step 2).
2. Tab **Storage** → **Create Database** → pilih **Neon Postgres** (atau via https://neon.tech langsung).
3. Setelah dibuat, Vercel otomatis kasih env var `DATABASE_URL` ke project.
   - Kalau bikin manual di neon.tech, copy connection string (yang ada `?sslmode=require`).

## 2. Jalankan schema.sql ke database

Pakai Neon SQL Editor (dashboard neon.tech → project → SQL Editor), paste isi file `schema.sql`, klik Run.

Atau via psql:

```bash
psql "$DATABASE_URL" -f schema.sql
```

Ini otomatis membuat tabel `users`, `messages`, `captchas`, dan insert akun admin:
- username: `admin`
- password: `123`

## 3. Push project ke GitHub

```bash
git init
git add .
git commit -m "init neochat"
git branch -M main
git remote add origin <URL_REPO_GITHUB_KAMU>
git push -u origin main
```

## 4. Import ke Vercel

1. https://vercel.com/new → import repo GitHub ini.
2. Framework preset: **Other**.
3. Sebelum deploy, buka **Environment Variables**, tambahkan:
   - `DATABASE_URL` = connection string dari step 1 (kalau belum otomatis terisi)
   - `JWT_SECRET` = string acak panjang, contoh generate:
     ```bash
     node -e "console.log(require('crypto').randomBytes(48).toString('hex'))"
     ```
4. Klik **Deploy**.

## 5. Selesai

Buka domain Vercel yang diberikan. Login pakai:
- username: `admin`
- password: `123`

**Ganti password admin setelah deploy pertama** — buat user admin baru manual di database lalu hapus/rename yang lama, karena tidak ada endpoint ganti password bawaan di versi ini.

## Catatan keamanan

- Password di-hash pakai bcrypt (12 rounds), tidak pernah disimpan plain text.
- Session pakai JWT httpOnly cookie (`secure`, `sameSite=strict`) — tidak bisa diakses lewat JavaScript di browser.
- Semua query database pakai parameterized query (tagged template `sql`), aman dari SQL injection.
- Captcha wajib untuk login & register, tersimpan di database dengan expiry 5 menit, sekali pakai.
- Admin tidak bisa di-ban atau dihapus lewat endpoint admin.
