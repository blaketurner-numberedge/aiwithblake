#!/bin/bash
# OpenClaw Local AI Setup Script
# One-command installation for macOS and Linux

set -e

echo "⚡ Local AI Setup Script"
echo "========================"

# Check OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    echo "✓ macOS detected"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    echo "✓ Linux detected"
else
    echo "✗ Unsupported OS: $OSTYPE"
    exit 1
fi

# Check for Homebrew (macOS)
if [ "$OS" == "macos" ]; then
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
fi

# Install dependencies
echo ""
echo "📦 Installing dependencies..."

if [ "$OS" == "macos" ]; then
    brew install python@3.11 node git
elif [ "$OS" == "linux" ]; then
    sudo apt-get update
    sudo apt-get install -y python3.11 python3-pip nodejs npm git
fi

# Install Ollama (easiest way to run models)
echo ""
echo "🦙 Installing Ollama..."
if ! command -v ollama &> /dev/null; then
    curl -fsSL https://ollama.com/install.sh | sh
    echo "✓ Ollama installed"
else
    echo "✓ Ollama already installed"
fi

# Pull recommended models
echo ""
echo "📥 Downloading starter models..."
echo "This may take 10-30 minutes depending on your connection..."

ollama pull llama3.1:8b
echo "✓ Llama 3.1 8B (general purpose)"

ollama pull codellama:7b
echo "✓ CodeLlama 7B (coding)"

ollama pull nomic-embed-text
echo "✓ Nomic Embed (embeddings)"

# Install Python packages
echo ""
echo "🐍 Installing Python packages..."
pip3 install --user openai requests

# Create workspace
echo ""
echo "📁 Setting up workspace..."
mkdir -p ~/local-ai/models
mkdir -p ~/local-ai/projects
mkdir -p ~/local-ai/prompts

# Create test script
cat > ~/local-ai/test.py << 'EOF'
#!/usr/bin/env python3
"""Quick test of local AI setup"""

import subprocess
import json

def test_ollama():
    """Test if Ollama is running"""
    try:
        result = subprocess.run(
            ['ollama', 'list'],
            capture_output=True,
            text=True,
            timeout=10
        )
        if result.returncode == 0:
            print("✓ Ollama is running")
            print("\nInstalled models:")
            print(result.stdout)
            return True
    except Exception as e:
        print(f"✗ Ollama test failed: {e}")
        return False

def test_model():
    """Test model inference"""
    print("\n🧪 Testing model inference...")
    try:
        result = subprocess.run(
            ['ollama', 'run', 'llama3.1:8b', 'Say "Local AI is working!" and nothing else.'],
            capture_output=True,
            text=True,
            timeout=30
        )
        if result.returncode == 0:
            print("✓ Model responded:")
            print(result.stdout)
            return True
    except Exception as e:
        print(f"✗ Model test failed: {e}")
        return False

if __name__ == "__main__":
    print("🚀 Testing Local AI Setup")
    print("=" * 40)
    
    if test_ollama() and test_model():
        print("\n✅ All tests passed!")
        print("\nNext steps:")
        print("1. Try: ollama run llama3.1:8b")
        print("2. Read the full guide in the blueprint")
        print("3. Join our Discord for help")
    else:
        print("\n❌ Some tests failed. Check the troubleshooting guide.")
EOF

chmod +x ~/local-ai/test.py

# Create startup script
cat > ~/local-ai/start.sh << 'EOF'
#!/bin/bash
# Start local AI services

echo "🚀 Starting Local AI..."

# Check if Ollama is running
if ! pgrep -x "ollama" > /dev/null; then
    echo "Starting Ollama..."
    ollama serve &
    sleep 2
fi

echo "✓ Local AI is ready!"
echo ""
echo "Try these commands:"
echo "  ollama list          # See installed models"
echo "  ollama run llama3.1  # Chat with AI"
echo "  python3 ~/local-ai/test.py  # Run tests"
EOF

chmod +x ~/local-ai/start.sh

# Final message
echo ""
echo "✅ Setup complete!"
echo ""
echo "📋 Quick Start:"
echo "1. Run: ~/local-ai/start.sh"
echo "2. Test: python3 ~/local-ai/test.py"
echo "3. Chat: ollama run llama3.1:8b"
echo ""
echo "📚 Next: Read the full blueprint guide"
echo "💬 Join: Discord community for support"
