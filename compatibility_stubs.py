"""
Compatibility wrapper for optional C++ extensions.
This allows TRELLIS.2 to run with pure Python implementations
when compiled extensions are not available.
"""

class MockCuMesh:
    """Mock cumesh module for compatibility"""
    def __getattr__(self, name):
        raise ImportError(f"cumesh.{name} not available - using pure Python fallback")

# Try to import cumesh, fall back to mock
try:
    import cumesh
except ImportError:
    cumesh = MockCuMesh()
    import sys
    sys.modules['cumesh'] = cumesh

__all__ = ['cumesh']
