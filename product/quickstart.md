# Local AI Quickstart Guide
## Get Running in 30 Minutes

### Pre-Flight Checklist
Before you begin, ensure you have:
- [ ] Computer with at least 8GB RAM (16GB+ recommended)
- [ ] 20GB free disk space
- [ ] Internet connection for initial download

---

## Phase 1: Install OpenClaw (5 minutes)

### Mac/Linux
```bash
curl -fsSL https://openclaw.sh/install.sh | bash
```

### Windows (PowerShell Admin)
```powershell
irm https://openclaw.sh/install.ps1 | iex
```

Verify installation:
```bash
openclaw --version
```

---

## Phase 2: Download Your First Model (10 minutes)

We'll use Llama 3.2 (3B) - fast, capable, and runs on most hardware.

```bash
# Download the model
openclaw models pull llama3.2:3b

# Test it
openclaw run llama3.2:3b "Hello, explain what you can do"
```

### Alternative: Tiny Models for Weak Hardware
If the above is slow, try these smaller options:
```bash
openclaw models pull tinyllama:1.1b    # For 4GB RAM
openclaw models pull phi3:3.8b          # Microsoft's efficient model
```

---

## Phase 3: Start the Web Interface (10 minutes)

```bash
# Start the chat server
openclaw server start

# Open in browser
open http://localhost:3000
```

You now have a ChatGPT-like interface running locally!

---

## Phase 4: Test Common Tasks (5 minutes)

Try these prompts in the web interface:

| Task | Prompt Example |
|------|----------------|
| Coding | "Write a Python function to validate email addresses" |
| Writing | "Draft a professional email requesting time off" |
| Analysis | "Summarize this text: [paste text]" |
| Brainstorming | "Give me 10 blog post ideas about remote work" |

---

## Quick Troubleshooting

| Issue | Solution |
|-------|----------|
| "Out of memory" | Use a smaller model (tinyllama:1.1b) |
| Slow responses | Close browser tabs; Models run faster with more RAM free |
| Download fails | Check internet; Try again with `openclaw models pull llama3.2:3b --retry` |
| Port 3000 in use | Run `openclaw server start --port 3001` |

---

## Next Steps

✅ **You did it!** You now have local AI running.

To go deeper, see the **full blueprint** that came with this guide:
- Hardware optimization tips
- Model recommendations by task
- Cost analysis: Cloud vs Local
- Privacy hardening checklist

---

## One-Command Reference

```bash
# Quick start everything
openclaw server start &
openclaw run llama3.2:3b

# List available models
openclaw models list

# Stop the server
openclaw server stop
```

---

**Questions?** Check the full blueprint or join our Discord: discord.gg/openclaw

*This guide is part of the Local AI Setup Blueprint. Keep it handy!*
