# QuickSlot

Feature-first Clean Architecture (mirrors `hivestaff` tickets pattern). **Folder structure + API data sources only** — no UI yet.

## Setup

```bash
flutter pub get
flutter run
```

Set API base URL at build time:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000
```

## Folder structure

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/api_constants.dart
│   ├── di/injection.dart              # wires data sources → repos → use cases
│   ├── network/
│   │   ├── api_client.dart
│   │   └── api_endpoints.dart
│   ├── theme/
│   ├── utils/
│   ├── exceptions.dart
│   └── view_state.dart
└── features/
    ├── auth/
    │   └── domain/entity/
    │   └── presentation/
    │       ├── bloc/                  # Cubit (replaces viewmodel)
    │       ├── widgets/
    │       └── auth_screen.dart
    ├── venues/
    │   ├── data/
    │   │   ├── data_source/           # GET /venues
    │   │   ├── model/
    │   │   └── repositories/
    │   ├── domain/
    │   │   ├── entity/
    │   │   ├── repository/
    │   │   └── use_cases/
    │   └── presentation/
    │       ├── bloc/
    │       ├── widgets/
    │       └── venues_screen.dart
    ├── venue_detail/
    │   ├── data/data_source/          # GET /venues/{id}/slots, POST /bookings
    │   ├── domain/
    │   └── presentation/
    └── bookings/
        ├── data/data_source/          # GET /users/{id}/bookings, DELETE /bookings/{id}
        ├── domain/
        └── presentation/
```

## Layer flow (per feature)

```
Screen → Cubit → UseCase → Repository (abstract) → RepositoryImpl → RemoteDataSource → ApiClient
```

## API endpoints mapped

| Endpoint | Data source |
|----------|-------------|
| `GET /venues` | `venues_remote_data_source.dart` |
| `GET /venues/{id}/slots?date=` | `venue_detail_remote_data_source.dart` |
| `POST /bookings` | `venue_detail_remote_data_source.dart` |
| `GET /users/{id}/bookings` | `bookings_remote_data_source.dart` |
| `DELETE /bookings/{id}` | `bookings_remote_data_source.dart` |

All requests send `X-User-Id` header via `ApiClient`.
