# Build stage
FROM python:3.12-alpine AS pybuilder
ADD pyproject.toml pdm.lock /build/
WORKDIR /build

# Install build dependencies
RUN apk add --no-cache alpine-sdk python3-dev musl-dev linux-headers

# Install PDM and dependencies
RUN pip install pdm
RUN pdm install

# Runner stage
FROM python:3.12-alpine AS runner
WORKDIR /app

# Install runtime dependencies
RUN apk update && apk add --no-cache bash ffmpeg aria2

# Copy virtual environment from build stage
COPY --from=pybuilder /build/.venv/lib/ /usr/local/lib/

# Copy application source
COPY src /app

# Ensure start.sh is executable
RUN chmod +x /app/start.sh

# Set working directory
WORKDIR /app

# Run the script
CMD ["bash", "start.sh"]
