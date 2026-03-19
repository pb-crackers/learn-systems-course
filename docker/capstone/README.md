# Foundation Capstone: Dockerized Multi-Service App

## The Challenge

You are a new DevOps engineer. Your first task: take a three-tier application — web frontend,
API backend, and PostgreSQL database — and make it runnable anywhere with a single command.
You will write the Dockerfiles, configure the networking, persist the database, automate
deployment with a shell script, and verify the entire stack is healthy.

The source code for the API and web frontend is provided in this directory. Your job is
to write the Dockerfiles, compose.yml, and deploy.sh.

## Architecture

```
Browser
   │
   │ HTTP :8080
   ▼
┌──────────────────────┐
│  web  (nginx)        │  Serves static HTML, reverse proxies /api/* to api
│  port 8080:80        │
└──────────┬───────────┘
           │ HTTP :3000  (internal network only — not published to host)
           ▼
┌──────────────────────┐
│  api  (Node.js)      │  Express API with /health, /api/items
│  port 3000           │
└──────────┬───────────┘
           │ TCP :5432   (internal network only — not published to host)
           ▼
┌──────────────────────┐
│  db   (PostgreSQL)   │  Stores items; data persists in a named volume
│  port 5432           │
└──────────────────────┘
```

## Services

| Service | Base Image         | External Port | Notes                                      |
|---------|--------------------|---------------|--------------------------------------------|
| web     | nginx:alpine       | 8080 → 80     | Reverse proxy for api; serves index.html   |
| api     | node:20-alpine     | none          | Express app; only reachable through web    |
| db      | postgres:16-alpine | none          | PostgreSQL; data in named volume           |

## API Contract

### GET /health

Response: `200 OK`
```json
{ "status": "healthy" }
```

### GET /api/items

Response: `200 OK`
```json
[
  { "id": 1, "name": "sample-item" }
]
```

### POST /api/items

Request body:
```json
{ "name": "my-item" }
```

Response: `201 Created`
```json
{ "id": 2, "name": "my-item" }
```

## Requirements

1. Write `docker/capstone/api/Dockerfile` — the API must run as a non-root user and
   listen on port 3000.

2. Write `docker/capstone/web/Dockerfile` — use a multi-stage build; the final image
   must be under 100MB.

3. Create `docker/capstone/compose.yml` that brings up all three services on a custom
   bridge network. The API must NOT be accessible from outside the Compose network —
   only accessible through the web service (no `ports:` mapping on the api service).

4. Configure the PostgreSQL service with a named volume so data survives container
   restarts and recreation.

5. Write `docker/capstone/deploy.sh` — a shell script that builds all images, starts
   the stack, and prints a health status summary. The script must exit non-zero if any
   service fails to start.

6. Run `bash docker/capstone/verify.sh` from the project root to validate your deployment.

## Success Criteria

- All three services are running (`docker compose ps` shows running)
- Web service is accessible on host port 8080
- API responds to web service requests (networking works)
- Database data persists across container restarts
- API container runs as non-root user (uid != 0)
- `deploy.sh` exits 0 on success, non-zero on failure
- `verify.sh` passes all 7 checks

## Getting Started

The API source code is in `docker/capstone/api/app.js` and the web frontend is in
`docker/capstone/web/index.html`. Read them to understand what each service does before
writing the Dockerfiles.

A sample nginx configuration is provided at `docker/capstone/web/nginx.conf` — it sets up
the reverse proxy from nginx to the API service. You may use it directly or adapt it.

You write: `api/Dockerfile`, `web/Dockerfile`, `compose.yml`, `deploy.sh`

## Verification

Run from the project root (not from inside docker/capstone/):

```bash
bash docker/capstone/verify.sh
```

Each FAIL message includes the exact command to investigate the failure.
