# Hardware Buyer's Guide for Local AI

*Part of The Local AI Setup Blueprint - aiwithblake.com*

---

## Introduction

Choosing the right hardware for local AI depends on your budget, use case, and performance expectations. This guide breaks down three recommended setups based on my real-world testing.

**Key factors to consider:**
- **RAM**: AI models live in memory. More RAM = larger models.
- **GPU/Neural Engine**: Apple Silicon Neural Engine is excellent. NVIDIA GPUs for Linux/Windows.
- **Storage**: Models range from 4GB to 80GB+. SSD required.

---

## Tier 1: Budget — $400-600

**Best for**: Getting started, small models, learning the ropes

### Recommended: M2 Mac Mini (8GB RAM)
- **Price**: $499 (refurbished: $379-429)
- **RAM**: 8GB unified memory
- **Storage**: 256GB SSD (upgrade to external SSD recommended)
- **Neural Engine**: 16-core

**What you can run:**
- Llama 3 8B (fast, conversational)
- Mistral 7B (good for coding)
- Stable Diffusion SDXL (image generation, ~30 sec/image)
- Phi-3 Mini (very fast for simple tasks)

**Performance expectations:**
- Text generation: 15-30 tokens/second (8B models)
- Image generation: 30-60 seconds per image
- Good for personal projects, experimentation

**My take**: This is what I started with. Perfect for learning and handles 90% of daily tasks.

---

## Tier 2: Mid-Range — $800-1200

**Best for**: Power users, developers, running multiple models

### Recommended: M2 Pro Mac Mini (16GB RAM)
- **Price**: $999-1099 (refurbished: ~$849)
- **RAM**: 16GB unified memory
- **Storage**: 512GB SSD
- **Neural Engine**: 16-core (faster memory bandwidth)

**What you can run:**
- Llama 3 70B (quantized, slower but capable)
- Mixtral 8x7B (excellent for coding)
- Larger Stable Diffusion models
- Background AI services (always-on assistants)

**Performance expectations:**
- Text generation: 25-40 tokens/second (8B models)
- Can run 2-3 models simultaneously
- Good for development workflows, serious projects

### Alternative: Custom PC with NVIDIA GPU
- **GPU**: RTX 3060 12GB ($250-300 used)
- **CPU**: Ryzen 5 5600X ($150)
- **RAM**: 32GB DDR4 ($80)
- **Storage**: 1TB NVMe SSD ($60)
- **Motherboard/PSU/Case**: ~$200

**Pros**: More VRAM for larger models, CUDA ecosystem
**Cons**: More power, noise, setup complexity

---

## Tier 3: Performance — $1500-2500

**Best for**: Professionals, running largest models, development

### Recommended: M3 Max MacBook Pro (36GB RAM)
- **Price**: $1999+ (refurbished: ~$1650)
- **RAM**: 36GB unified memory (can run 70B models well)
- **Neural Engine**: 18-core (faster, more efficient)
- **Storage**: 512GB SSD

**What you can run:**
- Llama 3 70B at good speed
- Multiple large models simultaneously
- Video generation (Wan 2.1, CogVideo)
- Large vision-language models

### Alternative: NVIDIA RTX 4090 Workstation
- **GPU**: RTX 4090 24GB ($1600)
- **Build around**: $2200-2500 total
- **VRAM**: 24GB — can run most models comfortably

---

## Quick Reference: Model Size vs RAM

| Model Size | Minimum RAM | Recommended | Best For |
|------------|-------------|-------------|----------|
| 3B | 4GB | 8GB | Fast tasks, edge devices |
| 7-8B | 8GB | 16GB | General chat, coding |
| 13-14B | 12GB | 24GB | Better reasoning |
| 30-34B | 20GB | 32GB | Advanced tasks |
| 70B+ | 40GB | 64GB+ | State-of-the-art |

---

## Storage Recommendations

Models add up fast. Here's what to expect:

| Model | Size (Q4_K_M) |
|-------|---------------|
| Llama 3 8B | 4.7GB |
| Mistral 7B | 4.1GB |
| Mixtral 8x7B | 26GB |
| Llama 3 70B | 40GB |
| Stable Diffusion XL | 6-7GB |
| SD 3 Medium | 4GB |

**Recommendation**: Start with 512GB minimum, 1TB+ preferred. External SSDs work great.

---

## Used vs New

**Great used buys:**
- Mac Studio M1 Max (excellent value, lots of RAM)
- RTX 3090 (24GB VRAM, great for local AI)
- Mac Mini M2 (often on sale at Best Buy/Apple refurbished)

**Avoid:**
- Intel-based Macs (no Neural Engine)
- Gaming laptops with low VRAM
- Cards without CUDA support for NVIDIA builds

---

## My Recommendations

**If you're just starting**: M2 Mac Mini 8GB ($499) — this is what changed everything for me

**If you're serious about local AI**: M2 Pro 16GB or wait for M4 Mac Mini

**If you need maximum flexibility**: Build a PC with RTX 3090/4090

---

*Questions? Hit me up at aiwithblake.com*
