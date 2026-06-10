# QuickSlot

Monorepo for the QuickSlot hiring hackathon — sports slot booking (badminton / turf).

**Demo walkthrough:** [Loom video](https://www.loom.com/share/493e2172adf74809be09a1f254d7fab8)

```
/
├── lib/          # Flutter app (Clean Architecture + Cubit)
├── server/       # Node.js REST API + Firebase Firestore
└── README.md
```

## Architecture

**Flutter** uses feature-first Clean Architecture: `Screen → Cubit → UseCase → Repository → RemoteDataSource → ApiClient`.

**Backend** is Express + Firestore. Booking concurrency is handled via Firestore transactions on a `slot_locks` collection (unique doc per venue+date+hour). One writer wins; the other gets HTTP 409.

Auth is lightweight: users stored in **Firestore** + `X-User-Id` header (no JWT).

**Firebase project:** `event-booking-system-ea7a6`

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
flutter run                        # Android emulator / iOS simulator (defaults work)

# Physical Android device on same Wi‑Fi as your Mac (auto-detects Mac IP):
flutter run --dart-define=API_BASE_URL=http://$(ipconfig getifaddr en0):3000
```

See the [demo walkthrough](https://www.loom.com/share/493e2172adf74809be09a1f254d7fab8) for a full setup and run explanation.

## API endpoints

| Endpoint | Status codes |
|----------|----------------|
| `GET /users` | 200 |
| `POST /users` | 201, 400, 409 |
| `GET /users/:id` | 200, 404 |
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

## Firestore collections

| Collection | Contents |
|------------|----------|
| `users` | All users (seeded + created via API) |
| `venues` | 5 sports venues |
| `bookings` | Booking records |
| `slot_locks` | Concurrency guard (one doc per booked slot) |

## Demo users (seeded)

| X-User-Id | Name |
|-----------|------|
| user-1 | Alex Kumar |
| user-2 | Priya Sharma |
| user-3 | Rahul Mehta |

Create more via `POST /users` or Flutter `AuthCubit.createUser()`.

Use two different users on two phones to test the live double-booking scenario.
