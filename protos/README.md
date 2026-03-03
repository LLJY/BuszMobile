# Protocol Buffer Definitions

This directory is a placeholder for the MyBusz protocol buffer definitions.

In production, this will be a git submodule pointing to the shared proto definitions repository.

## Setup

```bash
# When the submodule is configured:
git submodule update --init

# Regenerate Dart bindings:
buf generate
```

## Structure

```
protos/
  common/types.proto         # Shared types (GeoPoint, ArrivalTime, enums)
  frontline/                 # Client-facing Frontline API
    frontline_service.proto   # gRPC-Web streaming + unary RPCs
```
