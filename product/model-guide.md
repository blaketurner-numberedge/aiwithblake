# Model Recommendations Guide

*Part of The Local AI Setup Blueprint - aiwithblake.com*

---

## Quick Start: My Top Picks

| Use Case | Best Model | Size | Speed | Quality |
|----------|-----------|------|-------|---------|
| General Chat | Llama 3.1 8B | 4.7GB | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Coding | Qwen 2.5 Coder 7B | 4.4GB | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Reasoning | Phi-4 14B | 9.1GB | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Creative Writing | Llama 3.1 70B (Q4) | 40GB | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Embeddings | Nomic Embed | 0.5GB | ⭐⭐⭐⭐⭐ | - |
| Vision | Llava 1.6 7B | 4.5GB | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |

---

## Recommended Models by Category

### 🗨️ General Chat & Conversations

#### Llama 3.1 / 3.2 (8B)
```bash
ollama pull llama3.1
ollama pull llama3.2
```
- **Best for**: Daily conversations, general questions
- **Why**: Excellent instruction following, safe responses, fast
- **Context**: 128K (3.1) / 8K (3.2) tokens
- **My take**: This is my go-to for 90% of tasks. Surprisingly capable for its size.

#### Mistral 7B / NeMo
```bash
ollama pull mistral
ollama pull mistral-nemo
```
- **Best for**: Creative tasks, less restricted conversations
- **Why**: More willing, creative responses
- **Context**: 32K tokens (NeMo)

### 💻 Coding & Technical Tasks

#### Qwen 2.5 Coder (7B/14B)
```bash
ollama pull qwen2.5-coder:7b
ollama pull qwen2.5-coder:14b
```
- **Best for**: Code completion, debugging, explanations
- **Why**: Trained specifically on code, excellent suggestions
- **My take**: Better than Copilot for some languages. The 7B is crazy fast.

#### DeepSeek Coder V2 (16B Lite)
```bash
ollama pull deepseek-coder-v2:16b-lite
```
- **Best for**: Complex code reasoning, architecture
- **Why**: State-of-the-art for coding benchmarks

#### Mixtral 8x7B
```bash
ollama pull mixtral
```
- **Best for**: When you have VRAM to spare, want best coding performance
- **Size**: 26GB (Q4)
- **Why**: Mixture of Experts = huge effective parameter count
- **My take**: Worth the download if you do serious coding work.

### 🧠 Reasoning & Analysis

#### Phi-4 (14B)
```bash
ollama pull phi4
```
- **Best for**: Logical reasoning, math, structured thinking
- **Why**: Microsoft's latest, excellent reasoning per parameter
- **Size**: 9.1GB (Q4)
- **My take**: The dark horse. Often outperforms 70B models on reasoning tasks.

#### Llama 3.1 70B (Q4)
```bash
ollama pull llama3.1:70b
```
- **Best for**: Complex analysis, when quality matters most
- **Size**: 40GB (Q4_K_M)
- **Requirements**: 48GB+ RAM recommended, or 24GB VRAM + RAM offload

### 🎨 Image Generation

#### Stable Diffusion XL
- **UI**: Use LM Studio or ComfyUI
- **Best for**: High-quality image generation
- **Size**: ~6-7GB

#### SD 3 Medium
- **Best for**: Better text rendering, more flexible styles
- **Available**: Via LM Studio model browser

#### FLUX (dev/schnell)
- **Best for**: Photorealistic images, excellent prompt adherence
- **Note**: Requires more resources, FLUX Schnell is faster

### 👁️ Vision & Multimodal

#### Llava 1.6 7B
```bash
ollama pull llava-phi3
ollama pull llava:13b
```
- **Best for**: Image description, visual Q&A
- **Usage**: `ollama run llava`
- **Example**: Show it a screenshot, ask "What's in this image?"

#### BakLLaVA
```bash
ollama pull bakllava
```
- **Best for**: Better OCR, reading text in images
- **Why**: Optimized for text recognition in visuals

### 📊 Embeddings & RAG

#### Nomic Embed Text
```bash
ollama pull nomic-embed-text
```
- **Best for**: Document embeddings, semantic search
- **Size**: Tiny (<1GB), very fast
- **My take**: Essential for building RAG systems locally.

#### all-minilm
```bash
ollama pull all-minilm
```
- **Alternative**: Smaller, faster, slightly less capable

---

## Model Sizes Explained

When you see "Q4_K_M" or similar in model names, that's quantization:

| Quantization | Size Reduction | Quality | Use When |
|--------------|----------------|---------|----------|
| Q4_K_M | ~4-bit | 95-98% | Most cases, recommended |
| Q5_K_M | ~5-bit | 98-99% | Balanced quality/size |
| Q6_K | ~6-bit | 99%+ | When quality is critical |
| Q8_0 | ~8-bit | ~100% | Maximum quality, large |
| FP16 | Full | 100% | Enterprise, benchmarking |

**My recommendation**: Start with Q4_K_M. You won't notice the difference for most tasks.

---

## RAM Requirements by Model Size

| Model | Q4_K_M Size | Min RAM | Recommended |
|-------|-------------|---------|-------------|
| TinyLLama 1B | 0.6GB | 4GB | 8GB |
| Phi-3 Mini 4B | 2.3GB | 8GB | 8GB |
| Llama 3.1 8B | 4.7GB | 8GB | 16GB |
| Mistral 7B | 4.1GB | 8GB | 16GB |
| Llama 3.1 70B | 40GB | 48GB | 64GB+ |

---

## My Personal Workflow

**Daily driver**: Llama 3.1 8B (fast, capable)
**Coding**: Qwen 2.5 Coder 7B (excellent suggestions)
**Deep reasoning**: Phi-4 14B (when I need good thinking)
**RAG**: Nomic Embed (fast, quality embeddings)
**Vision**: Llava 1.6 (screenshots, diagrams)

---

## Where to Find More Models

1. **Ollama Library**: https://ollama.com/library
2. **Hugging Face**: https://huggingface.co/models
3. **LM Studio Model Browser**: Built-in discovery
4. **TheBloke**: https://huggingface.co/TheBloke (quantized models)

---

## Useful Commands

```bash
# See all available model versions
ollama list

# Pull a specific quantized version
ollama pull llama3.1:8b-instruct-q5_K_M

# Run with custom parameters
timeout 120 /usr/local/bin/ollama run llama3.1 --verbose

# Remove a model to free space
ollama rm mistral

# Get model info
ollama show llama3.1
```

---

*Want more recommendations? Check aiwithblake.com for updates*
