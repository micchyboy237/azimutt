# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Clone the Azimutt repository
git clone https://github.com/azimuttapp/azimutt.git
cd azimutt

# Install PostgreSQL
brew install postgresql
brew services start postgresql

# Install pnpm
brew install pnpm

# Install Node.js
brew install node

# Install Elm
npm install -g elm
elm --version

# Install elm-spa
npm install -g elm-spa
elm-spa --version

# Install Phoenix Framework
brew install elixir
mix local.hex
mix archive.install hex phx_new
mix phx.new --version

# Install pre-commit
brew install pre-commit

# Create PostgreSQL user and database
psql postgres <<EOF
CREATE USER postgres WITH SUPERUSER PASSWORD 'postgres';
CREATE DATABASE azimutt_dev;
\q
EOF

# Copy environment file and adapt values
cp .env.example .env

# Source environment and install dependencies
source .env && pnpm install

# Run pre-commit install
pre-commit install

# Start the Azimutt server
source .env && pnpm start

# Output instruction to navigate to Azimutt
echo "Navigate to http://localhost:4000 and log in with admin@azimutt.app (password: admin)"

# Allow execution of the script
# chmod +x _install.sh
# ./_install.sh
