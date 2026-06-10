# QuickSlot API (Node.js + Firebase Firestore)

REST backend for the QuickSlot hackathon app.

## Prerequisites

- Node.js 18+
- Firebase project with **Firestore** enabled
- Service account key JSON (Firebase Console → Project Settings → Service accounts → Generate new private key)

## Quick start

```bash
cd server
npm install
cp .env.example .env
# Edit .env — set GOOGLE_APPLICATION_CREDENTIALS=./serviceAccountKey.json
# Place your serviceAccountKey.json in server/ (gitignored)

npm run seed    # seed 5 venues into Firestore
npm run dev     # start API on http://localhost:3000
```

## Local dev with Firestore Emulator (no cloud project)

```bash
npm install -g firebase-tools   # once
firebase emulators:start --only firestore   # terminal 1

# terminal 2
export FIRESTORE_EMULATOR_HOST=127.0.0.1:8080
export FIREBASE_PROJECT_ID=quickslot-demo
npm run seed
npm run dev
```

## API

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| GET | `/venues` | — | List venues |
| GET | `/venues/:id` | — | Single venue |
| GET | `/venues/:id/slots?date=YYYY-MM-DD` | — | Slots with status |
| POST | `/bookings` | `X-User-Id` | Book a slot (201 / 409) |
| GET | `/users/:id/bookings` | `X-User-Id` | User's bookings |
| DELETE | `/bookings/:id` | `X-User-Id` | Cancel booking |

### Users (stored in Firestore `users` collection)

| Method | Path | Description |
|--------|------|-------------|
| GET | `/users` | List all users |
| POST | `/users` | Create user `{ name, email }` |
| GET | `/users/:id` | Get single user |

Seeded demo users (`npm run seed`):

- `user-1` — Alex Kumar
- `user-2` — Priya Sharma
- `user-3` — Rahul Mehta

`X-User-Id` header is validated against Firestore on protected routes.

### Book a slot

```bash
curl -X POST http://localhost:3000/bookings \
  -H "Content-Type: application/json" \
  -H "X-User-Id: user-1" \
  -d '{"venueId":"venue-1","slotId":"venue-1-2026-06-10-14","date":"2026-06-10"}'
```

## Concurrency safety

Double-booking is prevented with a **Firestore transaction**:

1. Unique lock doc id: `{venueId}_{date}_{hour}` in `slot_locks`
2. Transaction reads lock — if exists → **409 Conflict**
3. Otherwise atomically writes lock + booking

Only one concurrent request wins; the other gets a clear 409.

## Firestore collections

- `venues` — seeded venue catalog
- `slot_locks` — one doc per booked slot (uniqueness guard)
- `bookings` — booking records
