#!/bin/bash
# TRELLIS.2 Web App Launcher
# Simple startup script with proper environment configuration

cd /home/jeb/programs/stable2/trellis_20251218_181718
source venv/bin/activate

# Configure CUDA 13.0
export PATH=/usr/local/cuda-13.0/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-13.0/lib64:$LD_LIBRARY_PATH
export PYTORCH_ALLOC_CONF=expandable_segments:True

# Start the app
echo "========================================"
echo "TRELLIS.2 Web Application Starting"
echo "========================================"
echo ""
echo "Environment:"
echo "  Python: $(python --version)"
echo "  PyTorch: $(python -c 'import torch; print(torch.__version__)')"
echo "  CUDA: $(python -c 'import torch; print(torch.cuda.get_device_name(0) if torch.cuda.is_available() else \"None\")')"
echo ""
echo "First launch may take 5-15 minutes to download the 4B model."
echo "Subsequent launches will be much faster."
echo ""
echo "Access the app at: http://localhost:7860"
echo ""
echo "========================================"
echo ""

python app.py
