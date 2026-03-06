<div align="center">

# 🤖 AI Commit & Deploy

### *Ship code smarter. Commit with intelligence. Deploy with confidence.*

A battle-tested CLI tool that automates your entire Git workflow — from quality checks and AI-generated commit messages to security scanning and automated push.

<br/>

![Build](https://img.shields.io/badge/build-passing-brightgreen?style=for-the-badge&logo=github-actions)
![Version](https://img.shields.io/badge/version-1.0.0-blue?style=for-the-badge)
![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)
![Python](https://img.shields.io/badge/python-3.9+-yellow?style=for-the-badge&logo=python)
![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-lightgrey?style=for-the-badge)

<br/>

[**🚀 Quick Start**](#-installation) · [**⚙️ Configuration**](#%EF%B8%8F-configuration) · [**📖 Usage**](#-usage) · [**🤝 Contributing**](#-contributing)

</div>

---

## 🧠 What is AI Commit & Deploy?

**AI Commit & Deploy** is a command-line tool that replaces your manual `git add → git commit → git push` ritual with a single intelligent command. It enforces quality, prevents secrets from leaking, and uses AI to write meaningful commit messages that actually describe what changed — and *why*.

No more `"fix stuff"` commits. No more pushing broken builds. No more exposed API keys in version history.

```bash
# Before
git add .
git commit -m "fix stuff"   # 😬
git push origin main

# After
git add .
ai-commit                    # 🚀 one command does it all, intelligently
```

---

## ✨ Key Features

| Feature | Description |
|---|---|
| 🧪 **Automated Testing** | Runs your test suite before every commit. Fails fast if tests don't pass. |
| 🔍 **Intelligent Linting** | Auto-detects ESLint, Ruff, Flake8 or any custom linter and enforces code standards. |
| 🤖 **AI-Generated Commits** | Reads your staged diff and generates a [Conventional Commit](https://www.conventionalcommits.org/) message using GPT, Claude, DeepSeek, or a local LLM. |
| 🔒 **Secret Scanning** | Detects leaked API keys, tokens, passwords, and private keys before they ever reach GitHub. |
| 🏗️ **Production Build Check** | Verifies your app compiles successfully for production before pushing. |
| 🌐 **Multi-Provider AI** | OpenAI · Anthropic · DeepSeek · Ollama · Any OpenAI-compatible API. |
| 🖥️ **Cross-Platform** | Works on Linux, macOS, and Windows (Git Bash / WSL). |
| ⚙️ **Zero Hardcoding** | All configuration lives in `.env` files. Nothing sensitive ever touches the codebase. |

---

## 📋 Prerequisites

Before you begin, make sure you have the following installed on your machine:

- **[Git](https://git-scm.com/downloads)** `v2.30+` — with Git Bash if on Windows
- **[Python](https://python.org/downloads)** `v3.9+` — with "Add to PATH" enabled
- **[Node.js](https://nodejs.org)** `v18+` — if working on JavaScript/TypeScript projects
- **An AI Provider API Key** — one of the following:
  - 🟢 [OpenAI API Key](https://platform.openai.com/api-keys)
  - 🟣 [Anthropic API Key](https://console.anthropic.com/settings/keys)
  - 🔵 [DeepSeek API Key](https://platform.deepseek.com/api_keys)
  - 🟡 [Ollama](https://ollama.com) (local, completely free — no key needed)

> **Windows users:** Make sure to use **Git Bash** as your terminal, not CMD or PowerShell.

---

## 🚀 Installation

### 1 — Clone the repository

```bash
git clone https://github.com/angelluna03030/ai-commit-deploy.git
cd ai-commit-deploy
```

### 2 — Run the installer

```bash
# Linux / macOS / Windows (Git Bash)
bash install.sh
```

The installer will automatically:
- Copy the `ai-commit` script to `~/.local/bin/` and add it to your PATH
- Create the global config directory at `~/.ai-commit/`
- Generate a `~/.ai-commit/.env` file from the template
- Add the `gai` shortcut alias to your shell

### 3 — Reload your shell

```bash
source ~/.bashrc    # or ~/.zshrc on macOS
```

### 4 — Verify the installation

```bash
ai-commit --help
# or using the alias:
gai --help
```

---

## ⚙️ Configuration

All configuration is managed through `.env` files — **never hardcoded**. The tool loads config in the following priority order (highest wins):

```
Shell environment variables  >  <project>/.env  >  ~/.ai-commit/.env
```

### Setting up your global config

```bash
nano ~/.ai-commit/.env
```

### Environment Variables Reference

#### 🤖 AI Provider Settings

| Variable | Required | Example | Description |
|---|---|---|---|
| `AI_COMMIT_PROVIDER` | ✅ | `custom` | AI backend: `openai` · `anthropic` · `ollama` · `custom` |
| `OPENAI_API_KEY` | ⚠️ | `API_KEY-...` | Required only when provider is `openai` |
| `ANTHROPIC_API_KEY` | ⚠️ | `API_KEY-...` | Required only when provider is `anthropic` |
| `AI_COMMIT_API_KEY` | ⚠️ | `API_KEY...` | Required when provider is `custom` (DeepSeek, Groq, etc.) |
| `AI_COMMIT_BASE_URL` | ⚠️ | `https://api.deepseek.com` | Base URL for `custom` provider |
| `AI_COMMIT_MODEL` | ✅ | `deepseek-chat` | Model name to use for generation |
| `AI_COMMIT_DIFF_MAX_CHARS` | ❌ | `8000` | Max diff characters sent to AI (controls cost) |

#### 🧪 Quality Phase Settings

| Variable | Default | Example | Description |
|---|---|---|---|
| `AI_COMMIT_SKIP_QUALITY` | `false` | `true` | Skip tests and linting entirely |
| `AI_COMMIT_TEST_CMD` | auto-detect | `npm run test` | Override the test command |
| `AI_COMMIT_LINT_CMD` | auto-detect | `npm run lint` | Override the lint command |

#### 🔒 Security & Build Settings

| Variable | Default | Example | Description |
|---|---|---|---|
| `AI_COMMIT_STRICT_SECURITY` | `true` | `false` | Block commit when secrets are found |
| `AI_COMMIT_SKIP_SECURITY` | `false` | `true` | Disable secret scanning entirely |
| `AI_COMMIT_BUILD_CMD` | auto-detect | `npm run build` | Override the build command |
| `AI_COMMIT_SKIP_BUILD` | `false` | `true` | Skip the production build check |

#### 🚀 Git Phase Settings

| Variable | Default | Example | Description |
|---|---|---|---|
| `AI_COMMIT_NO_PUSH` | `false` | `true` | Commit locally without pushing |
| `AI_COMMIT_PUSH_REMOTE` | `origin` | `upstream` | Target remote for git push |
| `AI_COMMIT_PUSH_FLAGS` | _(empty)_ | `--force-with-lease` | Extra flags for git push |
| `AI_COMMIT_NO_CONFIRM` | `false` | `true` | Skip the Y/n confirmation prompt |

### Provider Configuration Examples

<details>
<summary><b>🟢 OpenAI</b></summary>

```env
AI_COMMIT_PROVIDER=openai
OPENAI_API_KEY=API_KEY
AI_COMMIT_MODEL=gpt-4o-mini
```
</details>

<details>
<summary><b>🟣 Anthropic (Claude)</b></summary>

```env
AI_COMMIT_PROVIDER=anthropic
ANTHROPIC_API_KEY=API_KEY
AI_COMMIT_MODEL=claude-3-5-haiku-20241022
```
</details>

<details>
<summary><b>🔵 DeepSeek</b></summary>

```env
AI_COMMIT_PROVIDER=custom
AI_COMMIT_BASE_URL=https://api.deepseek.com
AI_COMMIT_API_KEY=API_KEY
AI_COMMIT_MODEL=deepseek-chat
```
</details>

<details>
<summary><b>🟡 Ollama (Local — Free)</b></summary>

```env
AI_COMMIT_PROVIDER=ollama
OLLAMA_BASE_URL=http://localhost:11434
AI_COMMIT_MODEL=llama3
```
</details>

---

## 📖 Usage

### Basic workflow

```bash
# 1. Stage your changes as usual
git add .

# 2. Run the full AI-powered pipeline
ai-commit
```

### CLI Options

```bash
ai-commit [options]

Options:
  --dry-run        Run all phases but skip git commit and push (safe preview)
  --no-push        Commit locally without pushing to remote
  --no-quality     Skip the tests and linting phase
  --no-security    Skip the secret scanning phase
  --no-build       Skip the production build check
  --provider X     Override AI_COMMIT_PROVIDER on-the-fly
```

### Common command examples

```bash
# Full pipeline (recommended)
ai-commit

# Preview what commit message the AI would generate — no changes made
ai-commit --dry-run

# Commit only, useful when working with Pull Requests
ai-commit --no-push

# Use a different AI provider just this once
ai-commit --provider ollama

# Skip quality checks for a quick WIP checkpoint (use with caution)
ai-commit --no-quality --no-build

# Use the short alias
gai
gai-dry    # dry-run
gai-np     # no-push
```

### What an interactive session looks like

```
╔══════════════════════════════════════╗
║        AI-COMMIT  v1.0               ║
║  Quality · AI · Security · Push      ║
╚══════════════════════════════════════╝

──────────────────────────────────────────────────────
  PHASE 1 · Quality Validation (Tests & Linting)
──────────────────────────────────────────────────────
→ Running linter: npm run lint
✔ Linter passed
→ Running tests: npm run test
✔ Tests passed
✔ All quality checks passed ✓

──────────────────────────────────────────────────────
  PHASE 2 · AI Commit Message Generation
──────────────────────────────────────────────────────
→ Staged files: src/auth/login.ts, src/auth/guards.ts
→ Sending diff to AI — please wait…

Generated commit message:
───────────────────────────────────────────────────────
feat(auth): add JWT refresh token validation guard

Implement a NestJS guard that validates refresh tokens on
protected routes, rejecting expired or tampered tokens with
a 401 response. Centralizes auth logic and removes duplicate
checks from individual controllers.
───────────────────────────────────────────────────────

Accept this message? [Y/n/e(dit)]: Y

──────────────────────────────────────────────────────
  PHASE 3 · Production-Ready Check
──────────────────────────────────────────────────────
✔ No secrets detected ✓
✔ Build succeeded ✓

──────────────────────────────────────────────────────
  PHASE 4 · Git Commit & Push
──────────────────────────────────────────────────────
✔ Commit created ✓
✔ Pushed to origin/main ✓

═══════════════════════════════════════════════
  🚀  All phases passed — code shipped!
═══════════════════════════════════════════════
```

---

## 🏗️ Workflow Architecture

The tool enforces a strict, sequential 4-phase pipeline. If any phase fails, the process halts immediately — nothing reaches GitHub until your code is clean.

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   git add .  →  ai-commit                                  │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  PHASE 1 · Quality Gate                              │  │
│  │  ├─ Auto-detects: npm test, pytest, vitest, jest     │  │
│  │  ├─ Auto-detects: eslint, ruff, flake8               │  │
│  │  └─ BLOCKS on first failure ✗                        │  │
│  └──────────────────────────┬───────────────────────────┘  │
│                             │ ✓ all pass                    │
│  ┌──────────────────────────▼───────────────────────────┐  │
│  │  PHASE 2 · AI Commit Generation                      │  │
│  │  ├─ Reads git diff --cached                          │  │
│  │  ├─ Sends to AI provider (OpenAI / Claude / etc.)    │  │
│  │  ├─ Generates Conventional Commit message            │  │
│  │  └─ Interactive confirm / edit before proceeding     │  │
│  └──────────────────────────┬───────────────────────────┘  │
│                             │ ✓ accepted                    │
│  ┌──────────────────────────▼───────────────────────────┐  │
│  │  PHASE 3 · Production-Ready Check                    │  │
│  │  ├─ Scans staged files for 8+ secret patterns        │  │
│  │  ├─ Integrates gitleaks / trufflehog if installed    │  │
│  │  ├─ Runs production build (npm build / make / etc.)  │  │
│  │  └─ BLOCKS on secrets or build failure ✗             │  │
│  └──────────────────────────┬───────────────────────────┘  │
│                             │ ✓ clean & builds             │
│  ┌──────────────────────────▼───────────────────────────┐  │
│  │  PHASE 4 · Git Automation                            │  │
│  │  ├─ git commit -m "<AI generated message>"           │  │
│  │  └─ git push origin <current-branch>                 │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
│                    🚀  Code shipped!                        │
└─────────────────────────────────────────────────────────────┘
```

### Secret patterns detected

The security scanner checks for over 8 patterns including AWS credentials, GitHub tokens, Stripe keys, JWT tokens, private keys, Slack tokens, and generic `API_KEY=` / `password=` assignments.

---

## 🔧 Recommended Companion Tools

| Tool | Purpose | Install |
|---|---|---|
| [Husky](https://typicode.github.io/husky) | Git hooks — enforce quality on every commit | `npm i -D husky` |
| [lint-staged](https://github.com/lint-staged/lint-staged) | Run linters only on staged files | `npm i -D lint-staged` |
| [Commitlint](https://commitlint.js.org) | Validate conventional commit format | `npm i -D @commitlint/cli` |
| [gitleaks](https://github.com/gitleaks/gitleaks) | Advanced secret detection | `brew install gitleaks` |
| [Ollama](https://ollama.com) | Run LLMs locally for free | `brew install ollama` |

---

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn and build. Any contribution you make is **greatly appreciated**.

1. Fork the repository
2. Create your feature branch: `git checkout -b feat/amazing-feature`
3. Stage your changes: `git add .`
4. Let the tool do its magic: `ai-commit` *(yes, use the tool to commit to the tool 🙂)*
5. Open a Pull Request

Please make sure your code follows the existing style and that all tests pass before submitting a PR.

### Reporting bugs

Found a bug? Please [open an issue](https://github.com/angelluna03030/ai-commit-deploy/issues) with:
- Your OS and shell (e.g. Windows 11, Git Bash)
- The exact command you ran
- The full error output

---

## 📄 License

Distributed under the **MIT License**. See [`LICENSE`](./[LICENSE](https://github.com/angelluna03030/AI-Commit/blob/main/LICENSE.txt)) for full details.

```
MIT License — Copyright (c) 2025 Angel Stiven Garcia Luna

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files, to deal in the Software
without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of the
Software, subject to the standard MIT terms.
```

---

## 👤 Author

<div align="center">

<img src="https://avatars.githubusercontent.com/angelluna03030" width="80" style="border-radius:50%"/>

**Angel Stiven Garcia Luna**

[![GitHub](https://img.shields.io/badge/GitHub-angelluna03030-181717?style=for-the-badge&logo=github)](https://github.com/angelluna03030)
[![Portfolio](https://img.shields.io/badge/Portfolio-Visit-0A66C2?style=for-the-badge&logo=vercel)](https://portafoliowebangelluna.vercel.app)
[![Email](https://img.shields.io/badge/Email-Contact-EA4335?style=for-the-badge&logo=gmail)](mailto:angelstivengarcialuna@gmail.com)

*"Automate the boring parts. Focus on what matters."*

</div>

---

<div align="center">

Made with ❤️ by [Angel Luna](https://github.com/angelluna03030) · Give it a ⭐ if it saved you time!

</div>
