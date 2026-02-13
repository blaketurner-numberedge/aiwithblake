#!/bin/bash
#
# Local AI Setup Script for Linux
# Part of The Local AI Setup Blueprint - aiwithblake.com
#
# This script installs:
# - Ollama (for running LLMs)
# - Docker (for containerized AI tools)
# - Open WebUI (web interface for Ollama)
# - Python dependencies
# - NVIDIA drivers/CUDA (if NVIDIA GPU detected)
#
# Supported: Ubuntu 20.04+, Debian 11+, Fedora 35+, Arch
#
# Run with: bash setup-linux.sh
#

set -e

echo "================================"
echo "🚀 Local AI Setup for Linux"
echo "================================"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Detect distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
    DISTRO_VERSION=$VERSION_ID
else
    echo -e "${RED}❌ Cannot detect Linux distribution${NC}"
    exit 1
fi

echo -e "${BLUE}Detected: $NAME $DISTRO_VERSION${NC}"
echo ""

# Check for NVIDIA GPU
if command -v nvidia-smi &> /dev/null || lspci | grep -i nvidia &> /dev/null; then
    echo -e "${GREEN}✓ NVIDIA GPU detected${NC}"
    NVIDIA_GPU=true
else
    echo -e "${YELLOW}⚠️  No NVIDIA GPU detected. Will use CPU mode.${NC}"
    NVIDIA_GPU=false
fi

# Function to install packages based on distro
install_packages() {
    case $DISTRO in
        ubuntu|debian)
            sudo apt-get update
            sudo apt-get install -y curl wget git python3 python3-pip python3-venv
            ;;
        fedora)
            sudo dnf install -y curl wget git python3 python3-pip
            ;;
        arch|manjaro)
            sudo pacman -Sy --noconfirm curl wget git python python-pip
            ;;
        *)
            echo -e "${YELLOW}⚠️  Unknown distro. Please install: curl, wget, git, python3, pip${NC}"
            ;;
    esac
}

echo -e "${BLUE}📦 Installing dependencies...${NC}"
install_packages
echo -e "${GREEN}✓ Dependencies installed${NC}"

# Install Docker
echo ""
echo -e "${BLUE}🐳 Installing Docker...${NC}"

if command -v docker &> /dev/null; then
    echo -e "${GREEN}✓ Docker already installed${NC}"
else
    # Docker install based on distro
    case $DISTRO in
        ubuntu|debian)
            sudo apt-get install -y ca-certificates gnupg
            sudo install -m 0755 -d /etc/apt/keyrings
            curl -fsSL https://download.docker.com/linux/$DISTRO/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$DISTRO $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            sudo apt-get update
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            ;;
        fedora)
            sudo dnf -y install dnf-plugins-core
            sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
            sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            ;;
        arch)
            sudo pacman -Sy --noconfirm docker docker-compose
            ;;
    esac
    
    # Start and enable Docker
    sudo systemctl start docker
    sudo systemctl enable docker
    
    # Add user to docker group
    sudo usermod -aG docker $USER
    echo -e "${GREEN}✓ Docker installed${NC}"
    echo -e "${YELLOW}⚠️  Log out and back in for docker group changes to take effect${NC}"
fi

# Install NVIDIA Container Toolkit if applicable
if [ "$NVIDIA_GPU" = true ]; then
    echo ""
    echo -e "${BLUE}🎮 Installing NVIDIA Container Toolkit...${NC}"
    
    if ! command -v nvidia-ctk &> /dev/null; then
        case $DISTRO in
            ubuntu|debian)
                distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
                curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
                curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
                sudo apt-get update
                sudo apt-get install -y nvidia-container-toolkit
                ;;
            fedora)
                sudo dnf install -y nvidia-container-toolkit
                ;;
        esac
        
        sudo nvidia-ctk runtime configure --runtime=docker
        sudo systemctl restart docker
        echo -e "${GREEN}✓ NVIDIA Container Toolkit installed${NC}"
    else
        echo -e "${GREEN}✓ NVIDIA Container Toolkit already installed${NC}"
    fi
fi

echo ""
echo -e "${BLUE}🤖 Installing Ollama...${NC}"

if command -v ollama &> /dev/null; then
    echo -e "${GREEN}✓ Ollama already installed${NC}"
else
    curl -fsSL https://ollama.com/install.sh | sh
    echo -e "${GREEN}✓ Ollama installed${NC}"
fi

# Start Ollama service
if [ "$NVIDIA_GPU" = true ]; then
    echo -e "${BLUE}🎮 Starting Ollama with GPU support...${NC}"
else
    echo -e "${BLUE}🔄 Starting Ollama service...${NC}"
fi

sudo systemctl start ollama
sudo systemctl enable ollama
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

if [ "$NVIDIA_GPU" = true ]; then
    echo "  → Mixtral 8x7B - Requires more VRAM, excellent for coding"
    ollama pull mixtral
fi

echo -e "${GREEN}✓ Models downloaded${NC}"

echo ""
echo -e "${BLUE}🐍 Setting up Python environment...${NC}"

# Create virtual environment
VENV_PATH="$HOME/.local-ai-venv"
if [ ! -d "$VENV_PATH" ]; then
    python3 -m venv "$VENV_PATH"
    echo -e "${GREEN}✓ Python virtual environment created${NC}"
fi

# Activate and install packages
source "$VENV_PATH/bin/activate"
pip install --upgrade pip
pip install openai requests llama-cpp-python

echo -e "${GREEN}✓ Python packages installed${NC}"

echo ""
echo -e "${BLUE}🌐 Installing Open WebUI...${NC}"

# Run Open WebUI with Docker
if [ "$NVIDIA_GPU" = true ]; then
    docker run -d -p 3000:8080 --gpus=all --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:cuda
else
    docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main
fi

echo -e "${GREEN}✓ Open WebUI installed${NC}"
echo -e "${BLUE}Access it at: http://localhost:3000${NC}"

echo ""
echo "================================"
echo -e "${GREEN}✅ Setup Complete!${NC}"
echo "================================"
echo ""
echo "Your Local AI Environment:"
echo ""
echo "  🤖 Ollama (CLI)      : ollama run llama3.2"
echo "  🌐 Open WebUI        : http://localhost:3000"
echo ""
if [ "$NVIDIA_GPU" = true ]; then
    echo -e "  🎮 GPU Acceleration: ${GREEN}Enabled${NC}"
    nvidia-smi --query-gpu=name,memory.total --format=csv,noheader
else
    echo -e "  🖥️  Running Mode: ${YELLOW}CPU only${NC}"
fi
echo ""
echo "Useful commands:"
echo "  ollama list          # List installed models"
echo "  ollama run <model>   # Run a model"
echo "  ollama pull <model>  # Download a new model"
echo "  docker logs open-webui  # Check Open WebUI logs"
echo ""
echo "📚 Next steps:"
echo "  1. Visit http://localhost:3000 for the web UI"
echo "  2. Run: ollama run llama3.2"
echo "  3. Read model-guide.md for more recommendations"
echo ""
if [ "$NVIDIA_GPU" = false ]; then
    echo -e "${YELLOW}💡 Tip: With a dedicated GPU, you'll get 5-10x faster inference${NC}"
    echo "     Check the hardware guide for GPU recommendations"
fi
echo ""
echo -e "${BLUE}Need help? Visit aiwithblake.com${NC}"
