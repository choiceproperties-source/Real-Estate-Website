#!/usr/bin/env bash
set -e

echo "Running devcontainer setup..."

WORKSPACE_DIR=$(pwd)
echo "Workspace: $WORKSPACE_DIR"

echo "Installing global helper packages..."
npm install -g pnpm npx --silent || true

# Backend
if [ -d "$WORKSPACE_DIR/backend" ]; then
  echo "Installing backend dependencies..."
  cd "$WORKSPACE_DIR/backend"
  if [ -f package-lock.json ]; then
    npm ci || npm install
  else
    npm install || true
  fi
fi

# Frontend
if [ -d "$WORKSPACE_DIR/frontend" ]; then
  echo "Installing frontend dependencies..."
  cd "$WORKSPACE_DIR/frontend"
  if [ -f package-lock.json ]; then
    npm ci || npm install
  else
    npm install || true
  fi
fi

# Admin
if [ -d "$WORKSPACE_DIR/admin" ]; then
  echo "Installing admin dependencies..."
  cd "$WORKSPACE_DIR/admin"
  if [ -f package-lock.json"; then
    npm ci || npm install
  else
    npm install || true
  fi
fi

# Helper to run all apps
cat > "$WORKSPACE_DIR/.devcontainer/start-servers.sh" <<'STARTSH'
#!/usr/bin/env bash
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

npx -y concurrently \
"cd backend && npm run dev --prefix . || npm start --prefix ." \
"cd frontend && npm run dev --prefix . || npm start --prefix ." \
"cd admin && npm run dev --prefix . || npm start --prefix ."
STARTSH

chmod +x "$WORKSPACE_DIR/.devcontainer/start-servers.sh"

echo "Setup complete. To start all apps run: bash .devcontainer/start-servers.sh"
