---
layout: post
title:  "Golang series: Chapter Eighteen - Packages & Modules"
description: Organize your Go code with packages and manage dependencies with Go modules.
tags: golang packages modules tutorial
lang: en
---

# Packages & Modules in Go: Organizing Your Code

So far every example we've written lives in a single file with `package main`. That's fine for learning — but real-world Go projects are organized into **packages**, and their dependencies are managed with **modules**.

This chapter is about structure: how to split your code, how to control what's public vs private, and how Go's module system keeps your dependencies under control.

> 🧠 Missed Chapter 17? [Check it out here](/2025/04/10/golang-series-chapter-seventeen-channels.html) to learn about channels and concurrency first.

---

## What Is a Package?

A **package** is a directory of `.go` files that share the same `package` declaration. Every Go file starts with one:

```go
package main   // the entry point package
package utils  // a custom package
package http   // standard library package
```

---

## Exported vs Unexported

Go uses **capitalization** to control visibility — there are no `public` or `private` keywords:

- **Capitalized** identifier → exported (visible outside the package)
- **Lowercase** identifier → unexported (package-private)

```go
// package mathutils
package mathutils

var pi = 3.14159 // unexported — only accessible inside mathutils

func Add(a, b int) int { // exported — accessible from other packages
    return a + b
}

func helper(n int) int { // unexported
    return n * 2
}
```

---

## Creating Your First Package

Let's build a small project with a custom package.

**Project structure:**
```
myproject/
  go.mod
  main.go
  greet/
    greet.go
```

**greet/greet.go:**
```go
package greet

import "fmt"

// Hello is exported — callable from outside the greet package
func Hello(name string) string {
    return fmt.Sprintf("Hello, %s! Welcome to Go.", name)
}

// Goodbye is also exported
func Goodbye(name string) string {
    return fmt.Sprintf("Goodbye, %s. See you next time!", name)
}
```

**main.go:**
```go
package main

import (
    "fmt"
    "myproject/greet"
)

func main() {
    fmt.Println(greet.Hello("Celso"))
    fmt.Println(greet.Goodbye("Celso"))
}
```

**Output:**
```
Hello, Celso! Welcome to Go.
Goodbye, Celso. See you next time!
```

---

## Go Modules

A **module** is a collection of packages with a `go.mod` file at the root, declaring the module name and Go version.

### Initializing a Module

```bash
mkdir myproject && cd myproject
go mod init github.com/ceelsoin/myproject
```

This creates `go.mod`:

```
module github.com/ceelsoin/myproject

go 1.22
```

The module path is the import path prefix for all packages in this module. It doesn't have to be a real URL during development, but it should be when publishing.

---

## Adding External Dependencies

```bash
go get github.com/some/package
```

Go automatically:
1. Downloads the package
2. Updates `go.mod` with the dependency and version
3. Creates/updates `go.sum` with cryptographic hashes for verification

### go.sum: Your Security Net

```
github.com/some/package v1.2.3 h1:abc123...
github.com/some/package v1.2.3/go.mod h1:def456...
```

Never delete `go.sum`. It ensures you always build with the exact same code.

---

## Useful Module Commands

```bash
go mod tidy        # remove unused deps, add missing ones
go mod download    # download all dependencies to local cache
go list -m all     # list all dependencies with versions
go get pkg@v1.2.3  # get a specific version
go mod vendor      # copy dependencies into a vendor/ folder
```

---

## The init Function

Each package can have an `init()` function that runs automatically when the package is imported — before `main()`:

```go
package database

import "fmt"

var connection string

func init() {
    connection = "postgres://localhost:5432/mydb"
    fmt.Println("Database package initialized")
}
```

> ⚠️ Avoid heavy logic in `init`. It makes testing harder and execution order harder to reason about. Prefer explicit initialization functions.

---

## Blank Imports

Sometimes you import a package only for its `init` side effects (e.g., registering a driver):

```go
import _ "github.com/lib/pq" // registers PostgreSQL driver
```

The `_` tells Go you're intentionally ignoring the package's exports.

---

## Internal Packages

Go enforces access control at the directory level with an `internal` directory:

```
myproject/
  internal/
    config/
      config.go  // only importable by code inside myproject/
  api/
    handler.go
```

Code outside `myproject/` cannot import `myproject/internal/config`. Great for enforcing clean boundaries in large projects.

---

## Quick Reference

- ✅ `package name` — every file declares its package
- ✅ Capitalized = exported, lowercase = unexported
- ✅ `go mod init module/path` — create a module
- ✅ `go get` — add dependency
- ✅ `go mod tidy` — clean up go.mod and go.sum
- ✅ `init()` — runs at package initialization (use sparingly)
- ✅ `import _` — blank import for side effects
- ✅ `internal/` — enforces package access boundaries

---

> 🔗 Next up: **Chapter Nineteen — Testing in Go** → [Read it here](/2025/05/22/golang-series-chapter-nineteen-testing.html)
