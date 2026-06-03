FROM python:3.13-slim

# Set the working directory
WORKDIR /app

# Install system dependencies (curl and tar required for PicoClaw)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    tar \
    && rm -rf /var/lib/apt/lists/*

# Install PicoClaw
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        PICOCLAW_ARCH="x86_64"; \
    elif [ "$ARCH" = "aarch64" ]; then \
        PICOCLAW_ARCH="arm64"; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    cd /tmp && \
    curl -fSL "https://github.com/sipeed/picoclaw/releases/latest/download/picoclaw_Linux_${PICOCLAW_ARCH}.tar.gz" -o picoclaw.tar.gz && \
    tar -xzf picoclaw.tar.gz && \
    mv picoclaw /usr/local/bin/ && \
    rm -rf /tmp/*

# Create non-root user matching the host
ARG USER_UID=1000
ARG USER_GID=1000
RUN groupadd -g "${USER_GID}" appgroup && \
    useradd -l -u "${USER_UID}" -g appgroup -m appuser && \
    chown -R appuser:appgroup /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the FastAPI project
COPY . .

# Make the entrypoint script executable
RUN chmod +x /app/entrypoint.sh

# Switch to the non-root user
USER appuser

# Expose FastAPI port
EXPOSE 8000

# Run the entrypoint script which starts both FastAPI and PicoClaw
CMD ["bash", "/app/entrypoint.sh"]
