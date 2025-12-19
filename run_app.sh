#!/bin/bash
# TRELLIS.2 App Launcher with Logging

set -e

PROJECT_DIR="/home/jeb/programs/stable2/trellis_20251218_181718"
LOG_FILE="$PROJECT_DIR/app.log"
PID_FILE="$PROJECT_DIR/.app.pid"

cd "$PROJECT_DIR"
source venv/bin/activate

# Configure CUDA
export PATH=/usr/local/cuda-13.0/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-13.0/lib64:$LD_LIBRARY_PATH
export PYTORCH_ALLOC_CONF=expandable_segments:True

echo "Starting TRELLIS.2 App..."
echo "Log: $LOG_FILE"
echo "---" > "$LOG_FILE"

# Launch app in background
python app.py >> "$LOG_FILE" 2>&1 &
APP_PID=$!
echo $APP_PID > "$PID_FILE"

echo "App PID: $APP_PID"
echo "Waiting for startup..."

# Wait for app to start or log file to have content
for i in {1..60}; do
    if [ -s "$LOG_FILE" ] && grep -q "Running on" "$LOG_FILE" 2>/dev/null; then
        echo "✓ App started successfully!"
        tail -5 "$LOG_FILE"
        echo ""
        echo "App is running at: http://localhost:7860"
        echo "Press Ctrl+C to stop"
        wait $APP_PID
        exit 0
    fi
    sleep 1
    echo -n "."
done

echo ""
echo "App started (PID: $APP_PID)"
echo "Check log at: $LOG_FILE"
tail -20 "$LOG_FILE"
