#!/bin/bash
set -e

# Run picoclaw onboard if config doesn't exist (you might want to skip this if you mount config)
if [ ! -f "$HOME/.picoclaw/config.json" ]; then
    echo "Initializing PicoClaw..."
    # 'picoclaw onboard' is interactive so it might hang the script if not handled,
    # but we just start it here so the user can configure it or we start the daemon.
    # Note: If it requires interaction, we might just start the background service instead.
    echo "PicoClaw will need configuration. Run 'docker exec -it <container> picoclaw onboard' to configure it."
fi

echo "Starting PicoClaw AI Assistant in the background..."
# Assuming picoclaw runs as a background daemon or can be put in background
# For some tools, starting it without arguments runs the agent, but you can also use 'nohup'
nohup picoclaw > /tmp/picoclaw.log 2>&1 &

echo "Starting bash shell..."
exec /bin/bash
