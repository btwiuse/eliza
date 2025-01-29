FROM btwiuse/ufo AS ufo

# Use a specific Node.js version for better reproducibility
FROM node:23.3.0-slim AS builder

# Install pnpm globally and necessary build tools
RUN npm install -g pnpm@9.4.0 && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        git \
        python3 \
        python3-pip \
        curl \
        node-gyp \
        ffmpeg \
        libtool-bin \
        autoconf \
        automake \
        libopus-dev \
        make \
        g++ \
        build-essential \
        libcairo2-dev \
        libjpeg-dev \
        libpango1.0-dev \
        libgif-dev \
        openssl \
        libssl-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set Python 3 as the default python
RUN ln -sf /usr/bin/python3 /usr/bin/python

# Set the working directory
WORKDIR /app

# Copy application code
COPY . .

# Add the polkadot plugin
RUN git clone https://github.com/btwiuse/elizaos-plugin-polkadot /app/packages/plugin-polkadot

# Install dependencies
RUN pnpm install --no-frozen-lockfile

# Copy the rest of the application code
COPY agent ./agent
COPY client ./client
COPY packages ./packages
COPY scripts ./scripts
COPY characters ./characters

# Build the project
RUN pnpm run build

# Final runtime image
#ROM node:23.3.0-slim

# Install runtime dependencies
#UN npm install -g pnpm@9.4.0 && \
#   apt-get update && \
#   apt-get install -y \
#       git \
#       python3 \
#       ffmpeg && \
#   apt-get clean && \
#   rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy built artifacts and production dependencies from the builder stage
#OPY --from=builder /app/package.json ./
#OPY --from=builder /app/pnpm-workspace.yaml ./
#OPY --from=builder /app/.npmrc ./
#OPY --from=builder /app/turbo.json ./
#OPY --from=builder /app/node_modules ./node_modules
#OPY --from=builder /app/agent ./agent
#OPY --from=builder /app/client ./client
#OPY --from=builder /app/lerna.json ./
#OPY --from=builder /app/packages ./packages
#OPY --from=builder /app/scripts ./scripts
#OPY --from=builder /app/characters ./characters

COPY --from=ufo /usr/bin/ufo /usr/bin/ufo

# Expose necessary ports
EXPOSE 3000 5173

ENV OPENAI_API_KEY="<INSERT_YOUR_KEY>"

# server :3000
# pnpm start --characters="characters/trump.character.json,characters/tate.character.json"

# client :5173
# pnpm start:client

RUN apt update && apt install -y curl jq tmux vim

# Set the command to run the application
CMD ufo term
