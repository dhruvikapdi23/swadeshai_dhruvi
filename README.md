# QuickSlot

Monorepo for the QuickSlot hiring hackathon — sports slot booking (badminton / turf).

```
/
├── lib/          # Flutter app (Clean Architecture + Cubit)
├── server/       # Node.js REST API + Firebase Firestore
└── README.md
```

## Architecture

**Flutter** uses feature-first Clean Architecture: `Screen → Cubit → UseCase → Repository → RemoteDataSource → ApiClient`.

**Backend** is Express + Firestore. Booking concurrency is handled via Firestore transactions on a `slot_locks` collection (unique doc per venue+date+hour). One writer wins; the other gets HTTP 409.

Auth is lightweight: hardcoded users + `X-User-Id` header (no JWT).

## Setup — Backend

```bash
cd server
npm install
cp .env.example .env
# Add serviceAccountKey.json from Firebase Console
npm run seed
npm run dev          # http://localhost:3000
```

See [server/README.md](server/README.md) for Firestore emulator setup.

## Setup — Flutter app

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000   # Android emulator
# iOS simulator / desktop: http://localhost:3000
```

## API endpoints

| Endpoint | Status codes |
|----------|----------------|
| `GET /venues` | 200 |
| `GET /venues/:id/slots?date=` | 200, 400, 404 |
| `POST /bookings` | 201, 400, 401, 404, **409** |
| `GET /users/:id/bookings` | 200, 401, 403 |
| `DELETE /bookings/:id` | 204, 401, 403, 404 |

## What we cut (and why)

- Full JWT auth — hackathon allows `X-User-Id`; saves ~45 min
- Flutter UI screens — structure + API layer done first; UI next
- Bonus features (polling, offline cache, Docker) — after core E2E works

## With one more day

1. Complete Flutter UI with loading/error/empty states
2. Slot polling bonus (every 5s on venue detail)
3. Widget test for booking conflict snackbar
4. Dockerize the Node server

## AI usage note

AI (Cursor) scaffolded the feature folder structure, Cubit boilerplate, and this Firestore transaction pattern. One fix caught manually: slot hour loop was `hour < 21` instead of `hour <= 21`, which dropped the 9–10 PM slot.

## Demo users

| X-User-Id | Name |
|-----------|------|
| user-1 | Alex Kumar |
| user-2 | Priya Sharma |
| user-3 | Rahul Mehta |

Use two different users on two phones to test the live double-booking scenario.
