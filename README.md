# BuszMobile

Reference implementation for MyBusz gRPC endpoints.

Flutter app demonstrating real-time bus arrivals and live tracking for Johor Bahru public transit.

## Features

- **Bus Stop Search** - Find stops by name or code with service chip display
- **Live Arrivals** - Real-time ETAs with 15-second polling, live/scheduled indicators
- **Bus Map** - Live GPS positions of buses on OpenStreetMap with heading arrows
- **Debug Metadata** - ETA source (realtime/ML/scheduled), delay status, staleness indicators
- **ECDSA Auth** - Nonce-challenge authentication with P-256 key signing

## Architecture

```
Flutter App (Connect-RPC / gRPC-Web)
    |
    v
FrontlineService (gRPC-Web gateway)
    |
    +-- Valkey (real-time bus positions, ETAs)
    +-- DataService (static data from PostgreSQL)
    +-- RabbitMQ (push updates)
```

### Project Structure

```
lib/
  core/           # Router, theme, auth service
  data/
    models/       # Domain models (mapped from protobuf)
    services/     # Connect-RPC client
  features/
    search/       # Bus stop search screen + providers
    stop_detail/  # Stop arrivals, bus map, detail widgets
  gen/            # Generated protobuf code (not committed, see below)
  main.dart       # Entry point
protos/           # Proto definitions (git submodule placeholder)
```

## Setup

### Prerequisites

- Flutter 3.41+ / Dart 3.11+
- `buf` CLI (for protobuf code generation)
- Access credentials for the MyBusz Identity Service

### Configuration

Copy the environment template and fill in your credentials:

```bash
cp .env.example .env.json
```

### Running

```bash
# Desktop (reads .env from filesystem)
flutter run

# Mobile / explicit credentials
flutter run --dart-define-from-file=.env.json

# Build APK
flutter build apk --dart-define-from-file=.env.json
```

### Protobuf Code Generation

Proto definitions are managed as a git submodule in `protos/`. To regenerate Dart bindings:

```bash
buf generate
```

This outputs Connect-RPC clients and protobuf message classes into `lib/gen/`.

## License

This project is licensed under the GNU General Public License v2.0 - see [LICENSE](LICENSE) for details.
