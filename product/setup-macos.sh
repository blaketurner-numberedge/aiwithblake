#!/bin/bash
#
# Local AI Setup Script for macOS
# Part of The Local AI Setup Blueprint - aiwithblake.com
#
# This script installs:
# - Homebrew (if needed)
# - Ollama (for running LLMs)
# - LM Studio (GUI for local AI)
# - Open WebUI (web interface for Ollama)
# - Python dependencies
#
# Run with: bash setup-macos.sh
#

set -e

echo "================================"
echo "🚀 Local AI Setup for macOS"
echo "================================"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check macOS version
OS_VERSION=$(sw_vers -productVersion)
echo -e "${BLUE}Detected macOS $OS_VERSION${NC}"

if [[ $(echo "$OS_VERSION 14.0" | awk '{print ($1 < $2)}') -eq 1 ]]; then
    echo -e "${YELLOW}⚠️  Warning: macOS 14+ recommended for best performance${NC}"
fi

echo ""

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo -e "${BLUE}📦 Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo -e "${GREEN}✓ Homebrew already installed${NC}"
fi

# Update Homebrew
echo -e "${BLUE}🔄 Updating Homebrew...${NC}"
brew update

echo ""
echo -e "${BLUE}🤖 Installing Ollama...${NC}"

if command -v ollama &> /dev/null; then
    echo -e "${GREEN}✓ Ollama already installed${NC}"
else
    brew install --cask ollama
    echo -e "${GREEN}✓ Ollama installed${NC}"
fi

# Start Ollama service
echo -e "${BLUE}🔄 Starting Ollama service...${NC}"
ollama serve &
sleep 2

echo ""
echo -e "${BLUE}📥 Downloading recommended models...${NC}"

# Pull recommended models
echo "  → Llama 3.2 (8B) - General purpose"
ollama pull llama3.2

echo "  → Phi-4 (14B) - Good balance of speed and quality"
ollama pull phi4

echo "  → Nomic Embed - For RAG/embeddings"
ollama pull nomic-embed-text

echo -e "${GREEN}✓ Models downloaded${NC}"

echo ""
echo -e "${BLUE}🎨 Installing LM Studio...${NC}"

if [ -d "/Applications/LM Studio.app" ]; then
    echo -e "${GREEN}✓ LM Studio already installed${NC}"
else
    brew install --cask lm-studio
    echo -e "${GREEN}✓ LM Studio installed${NC}"
fi

echo ""
echo -e "${BLUE}🐍 Setting up Python environment...${NC}"

# Install Python 3.11 if not present
if ! command -v python3 &> /dev/null; then
    brew install python@3.11
fi

# Create virtual environment
VENV_PATH="$HOME/.local-ai-venv"
if [ ! -d "$VENV_PATH" ]; then
    python3 -m venv "$VENV_PATH"
    echo -e "${GREEN}✓ Python virtual environment created${NC}"
fi

# Activate and install packages
source "$VENV_PATH/bin/activate"
pip install --upgrade pip
pip install openai requests

echo -e "${GREEN}✓ Python packages installed${NC}"

echo ""
echo -e "${BLUE}🌐 Installing Open WebUI (optional web interface)...${NC}"

if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}⚠️  Docker not found. Install Docker Desktop to use Open WebUI:${NC}"
    echo "    brew install --cask docker"
else
    echo "Open WebUI can be started with:"
    echo "  docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main"
fi

echo ""
echo "================================"
echo -e "${GREEN}✅ Setup Complete!${NC}"
echo "================================"
echo ""
echo "Your Local AI Environment:"
echo ""
echo "  🤖 Ollama (CLI)      : ollama run llama3.2"
echo "  💬 Test your setup   : ollama run llama3.2"
echo "  🎨 LM Studio (GUI)   : /Applications/LM Studio.app"
echo ""
echo "Useful commands:"
echo "  ollama list          # List installed models"
echo "  ollama run <model>   # Run a model"
echo "  ollama pull <model>  # Download a new model"
echo ""
echo "📚 Next steps:"
echo "  1. Open LM Studio to test GUI interface"
echo "  2. Run: ollama run llama3.2"
echo "  3. Read model-guide.md for more recommendations"
echo ""
echo -e "${BLUE}Need help? Visit aiwithblake.com${NC}"
