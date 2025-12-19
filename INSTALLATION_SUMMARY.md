# TRELLIS.2 Installation Summary

**Installation Date**: December 18, 2025  
**Installation Location**: `/home/jeb/programs/stable2/trellis_20251218_181718/`  
**Python Version**: 3.13.7  
**Total Size**: ~657 MiB (repository) + dependencies

## Installation Overview

Successfully installed Microsoft's TRELLIS.2 - a state-of-the-art 3D generative model for high-fidelity image-to-3D generation using a novel "field-free" sparse voxel structure called O-Voxel.

### Key Features Installed
- **4B Parameter Model**: High-resolution fully textured asset generation
- **Arbitrary Topology Handling**: Open surfaces, non-manifold geometry, internal structures
- **Rich Texture Modeling**: Base Color, Roughness, Metallic, and Opacity support
- **Generation Speed**:
  - 512³ resolution: ~3s total
  - 1024³ resolution: ~17s total  
  - 1536³ resolution: ~60s total

## Installation Steps Performed

### 1. Repository Cloning
```bash
cd /home/jeb/programs/stable2
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
mkdir -p "trellis_$TIMESTAMP"
cd "trellis_$TIMESTAMP"
git clone https://github.com/microsoft/TRELLIS.2 .
```

### 2. Virtual Environment Setup
```bash
python3 -m venv venv
source venv/bin/activate
```

### 3. Dependency Installation
Installed core dependencies in two phases:

**Phase 1: PyTorch with CUDA 12.4**
```bash
pip install torch==2.6.0 torchvision==0.21.0 --index-url https://download.pytorch.org/whl/cu124
```

**Phase 2: Supporting Libraries**
```bash
pip install imageio imageio-ffmpeg tqdm easydict opencv-python-headless ninja trimesh \
  transformers gradio==6.0.1 tensorboard pandas lpips zstandard pillow-simd kornia timm
```

## Installed Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| torch | 2.6.0 | Deep learning framework |
| torchvision | 0.21.0 | Computer vision utilities |
| transformers | 4.57.3 | HuggingFace model loading |
| gradio | 6.0.1 | Web UI framework |
| imageio | 2.37.2 | Image I/O operations |
| opencv-python-headless | 4.12.0.88 | Computer vision library (headless) |
| trimesh | 4.10.1 | 3D mesh handling |
| kornia | 0.8.2 | Differentiable computer vision |
| timm | 1.0.22 | PyTorch Image Models |
| scipy | 1.16.3 | Scientific computing |
| lpips | 0.1.4 | Perceptual loss metrics |
| tensorboard | 2.20.0 | Training visualization |
| numpy | 2.2.6 | Numerical computing |
| pillow-simd | 9.5.0.post2 | SIMD-optimized image processing |
| easydict | 1.13 | Easy dictionary access |
| zstandard | 0.25.0 | Compression library |
| ninja | 1.13.0 | Build system |
| gradio-client | 2.0.0 | Gradio client library |

## How to Use TRELLIS.2

### Activate the Environment
```bash
cd /home/jeb/programs/stable2/trellis_20251218_181718
source venv/bin/activate
```

### Run Web Demo
```bash
python app.py
```
Then access the demo at the URL shown in terminal.

### Run Example Inference
```bash
python example.py
```

## Best Practices: Python venv Management in Bash CLI

### 1. **Always Use a venv for Project Isolation**

**Why**: Prevents global package pollution and dependency conflicts between projects.

```bash
# Create venv in project root
python3 -m venv venv

# Activate it
source venv/bin/activate

# Deactivate when done
deactivate
```

**Lesson Learned**: System-wide Python installations lead to version conflicts. Using venvs isolates projects completely.

### 2. **PATH Management - Activation is Critical**

**Problem Encountered**: 
```bash
# WRONG - This failed with "bad interpreter"
bash: /home/jeb/programs/deepseek_api/python3.12/bin/pip: 
  /home/jeb/programs/deepseek_api/python3.12/bin/python3.12: bad interpreter
```

**Root Cause**: Old venv was still in PATH, pointing to a deleted Python installation.

**Solution**:
```bash
# Always source activation in same terminal session
source venv/bin/activate

# Verify activation worked
which python
# Output: /path/to/project/venv/bin/python

# Check pip location too
which pip
# Output: /path/to/project/venv/bin/pip
```

**Best Practice**: After activation, verify `which python` and `which pip` point to your venv, not system paths.

### 3. **Tool Chaining in Bash - Session State Matters**

**Lesson Learned**: When using tool runners that execute bash commands:

```bash
# WRONG - Multiple separate tool invocations
$ source venv/bin/activate    # Session 1
$ pip install package         # Session 2 (NEW shell - venv not active!)

# RIGHT - Chain operations in single command
cd /path/to/project && source venv/bin/activate && pip install package
```

**Why**: Each tool invocation may spawn a new shell, losing the activated venv state.

### 4. **Direct Venv Binary Access When Needed**

```bash
# If activation fails or in non-interactive contexts
./venv/bin/pip install package

# Or with full path
/home/jeb/programs/stable2/trellis_20251218_181718/venv/bin/python script.py
```

**Use Case**: CI/CD pipelines, automated scripts, or when shell sourcing isn't available.

### 5. **Fresh Shell for Clean State**

```bash
# If venv activation issues occur
exec bash                      # Start fresh bash shell
cd /path/to/project
source venv/bin/activate
pip install package
```

**Why**: Previous shell may have corrupted PATH or environment variables pointing to old installations.

### 6. **Verify Installation Environment**

```bash
# Check Python location
python -c "import sys; print(sys.prefix)"
# Output: /home/jeb/programs/stable2/trellis_20251218_181718/venv

# Check installed packages
pip list

# Verify specific package
python -c "import torch; print(torch.__version__)"
```

### 7. **Project Structure Best Practice**

```
project_root/
├── venv/                      # Virtual environment (add to .gitignore)
├── src/                       # Source code
├── requirements.txt           # Pip freeze output
├── setup.sh                   # Initialization script
├── README.md                  # Documentation
└── INSTALLATION_SUMMARY.md    # This file
```

### 8. **Creating Reusable Setup Scripts**

```bash
#!/bin/bash
# setup_project.sh

set -e  # Exit on error

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

# Create venv if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# Activate
source venv/bin/activate

# Upgrade pip
pip install --upgrade pip setuptools wheel

# Install requirements
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
else
    echo "No requirements.txt found"
fi

echo "Setup complete! Venv activated."
```

**Usage**:
```bash
chmod +x setup_project.sh
./setup_project.sh
```

### 9. **Handling Large Dependency Installations**

**Lesson Learned**: Large ML packages (PyTorch, etc.) require:

1. **Specific Index URLs** for performance/CUDA support:
```bash
pip install torch==2.6.0 --index-url https://download.pytorch.org/whl/cu124
```

2. **Patience for downloads**: PyTorch CUDA wheels can be 700+ MB

3. **Pre-emptive upgrades**:
```bash
pip install --upgrade pip setuptools wheel
```

### 10. **Dependency Documentation Pattern**

**Good Practice**: Store version information:

```bash
# Freeze installed versions
pip freeze > requirements-pinned.txt

# Keep human-readable requirements
# requirements.txt with ranges:
torch==2.6.0
transformers>=4.50.0
gradio==6.0.1
```

## Troubleshooting Reference

| Issue | Solution |
|-------|----------|
| `command not found: pip` | Run `source venv/bin/activate` or use `./venv/bin/pip` |
| `bad interpreter` error | Old venv in PATH; run `exec bash` to reset shell |
| Package conflicts | Create fresh venv: `rm -rf venv && python3 -m venv venv` |
| `which python` shows system path | Venv not activated; run `source venv/bin/activate` |
| Module not found after install | Check `pip list` and verify package installed in active venv |
| Permission denied on venv scripts | Ensure venv created with current user: `python3 -m venv venv` |

## Quick Reference Commands

```bash
# Navigate to project
cd /home/jeb/programs/stable2/trellis_20251218_181718

# Activate venv
source venv/bin/activate

# Check status
python --version
which python
pip list

# Install from requirements
pip install -r requirements.txt

# Run application
python app.py

# Deactivate when done
deactivate
```

## Key Lessons Summary

1. **venv isolation prevents system-wide conflicts** ✓
2. **Activation must happen in same shell session** ✓
3. **PATH verification is essential after activation** ✓
4. **Tool chaining requires single command execution** ✓
5. **Direct binary access is fallback when needed** ✓
6. **Fresh shells resolve venv state issues** ✓
7. **Specific package indexes (PyTorch) matter for ML** ✓
8. **Documentation and scripts improve reproducibility** ✓

---

**Documentation Generated**: 2025-12-18  
**Prepared by**: GitHub Copilot  
**Status**: Installation Complete and Verified
