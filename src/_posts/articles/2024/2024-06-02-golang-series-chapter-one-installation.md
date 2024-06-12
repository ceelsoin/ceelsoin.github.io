---
layout: post
title:  "Golang series: Chapter one - Installation & Introduction"
description: Let's start our first series at this blog. We will learn golang.
tags: golang introduction tutorial
lang: en
image: /assets/img/articles/2024/06/golang.webp
---

# Getting Started with Golang (Go)

![Golang (Go) programming language logo](/assets/img/articles/2024/06/golang.webp)

Hey everyone! Welcome to the first tutorial in my Go series. In this series, we’ll dive into **Golang**, or simply **Go**—a powerful, open-source programming language developed by Google.

Whether you're on **Windows**, **macOS**, or **Linux**, you can follow along. Go is a cross-platform, general-purpose language with fast compilation, great concurrency support, and a vibrant community. It's also open source—so you can even contribute to its evolution!

---

## Why I Chose Go

I first heard about Go five years ago from a college friend working at a fintech startup. He said Go was super fast and easy to get into. I didn’t pay much attention back then.

Fast forward a year later, I started working at **Globo**, one of Brazil’s biggest media companies. Most of their backend systems are written in Go—handling high-traffic services with ease. That’s when I seriously began learning and working with Go, and I haven’t looked back since.

---

## Is Go Hard to Learn?

Not at all. If you’ve worked with any other programming language, Go is straightforward to pick up.

Go avoids unnecessary complexity—it doesn’t have classes or inheritance. Instead, it uses **packages** and **interfaces**, promoting clean and simple design patterns.

It also introduces modern concepts like goroutines (for concurrency), pointers (without the pain), and efficient memory management through garbage collection.

---

## Why Learn Go?

Here are a few reasons why Go might be the right language for you:

- ✅ Easy to learn and read
- ⚡ Fast compilation (Go is compiled to native binaries)
- 🔗 Static linking (easy deployment without worrying about dependencies)
- 🔄 Built-in concurrency with goroutines and channels
- 🚀 Widely adopted by the industry (used by companies like Google, Netflix, Uber)
- 🐹 A cute mascot called Gopher 😄
- 🧹 Garbage collection built-in
- 🌍 Fully open source and backed by a strong community
- 🛠️ Excellent tooling (`gofmt`, `vet`, `staticcheck`, and more)

---

## Popular Products Built with Go

You might already be using products powered by Go without even realizing it! Some notable examples include:

- **Docker** – Containerization platform
- **Kubernetes** – Container orchestration system by Google
- **Dropbox** – Migrated performance-critical components from Python to Go
- **Twitch, Netflix, Uber, PayPal** – All use Go in production

---

## Installing Go

Go can be installed on **macOS**, **Linux**, and **Windows**. Just follow the instructions for your OS below.

### macOS

1. Install [Homebrew](https://brew.sh/) if you haven’t already:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Install Go:

```bash
brew install go
```

### Linux

Depending on your Linux distribution, use one of the following:

#### Ubuntu / Debian

```bash
sudo apt update
sudo apt install -y golang
```

#### Fedora

```bash
sudo dnf install -y golang
```

#### Arch Linux

```bash
sudo pacman -S go
```

Alternatively, you can install Go manually:

1. Download the binary from [https://go.dev/dl/](https://go.dev/dl/)
2. Extract it to `/usr/local`:

```bash
sudo tar -C /usr/local -xzf go1.x.x.linux-amd64.tar.gz
```

3. Add Go to your path by editing `~/.profile`, `~/.bashrc`, or `~/.zshrc`:

```bash
export PATH=$PATH:/usr/local/go/bin
```

### Windows

<small>If you're using **WSL (Windows Subsystem for Linux)**, follow the Linux steps above.</small>

Otherwise:

1. Download the **MSI Installer** from [https://go.dev/dl/](https://go.dev/dl/)
2. Double-click to run the installer and follow the instructions
3. It will install Go at `C:\Go` and update your `PATH` environment variable automatically

---

## Verifying Your Installation

To check if Go is installed correctly, run the following in your terminal or command prompt:

```bash
go version
```

Expected output:

```bash
go version go1.21.5 darwin/arm64
```

> The version and architecture may vary depending on your OS or Go version.

If you don’t see a version, double-check that the Go binary is available in your `PATH`.

---

## What’s Next?

In the next tutorial, we’ll write our first **"Hello, World!"** program using Go and explore how Go handles compilation, error messages, and project structure.

Thanks for reading! If you found this helpful, feel free to share and leave your feedback. Let’s build something cool with Go! 🧑‍💻🚀