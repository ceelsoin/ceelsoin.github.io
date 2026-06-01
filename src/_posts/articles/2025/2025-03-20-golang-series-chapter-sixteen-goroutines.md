---
layout: post
title:  "Golang series: Chapter Sixteen - Goroutines: Concurrency Basics"
description: Go makes concurrency simple with goroutines. Learn how to run code concurrently and coordinate it safely.
tags: golang goroutines concurrency tutorial
lang: en
---

# Goroutines in Go: Concurrency Made Simple

Here we go — one of the features that made me fall in love with Go when I started at Globo. **Goroutines** are Go's way of running things concurrently, and they're so lightweight and easy to use that concurrency stops feeling like a scary topic.

A goroutine is like a thread, but much cheaper. You can spawn thousands of them without breaking a sweat.

> 🧠 Missed Chapter 15? [Check it out here](/2025/02/25/golang-series-chapter-fifteen-defer-panic-recover.html) to learn about defer, panic, and recover first.

---

## What Is a Goroutine?

A goroutine is a **lightweight thread of execution** managed by the Go runtime — not the OS. It starts with just a few kilobytes of stack space and grows as needed.

When you run `main()`, you're already inside a goroutine — the main goroutine.

---

## Starting a Goroutine

Just add the `go` keyword before a function call:

```go
package main

import (
    "fmt"
    "time"
)

func say(message string) {
    for i := 0; i < 3; i++ {
        fmt.Println(message)
        time.Sleep(100 * time.Millisecond)
    }
}

func main() {
    go say("hello")  // runs concurrently
    say("world")     // runs in main goroutine
}
```

**Output (order may vary):**
```
world
hello
world
hello
world
hello
```

---

## The Problem: main Doesn't Wait

If main exits before a goroutine finishes, the goroutine is killed:

```go
package main

import "fmt"

func main() {
    go fmt.Println("This may never print!")
    // main exits immediately
}
```

This is a common gotcha for beginners. Let's fix it.

---

## sync.WaitGroup

`sync.WaitGroup` lets the main goroutine wait for a group of goroutines to finish:

```go
package main

import (
    "fmt"
    "sync"
)

func worker(id int, wg *sync.WaitGroup) {
    defer wg.Done() // signal completion when this function returns

    fmt.Printf("Worker %d starting\n", id)
    // simulate work
    fmt.Printf("Worker %d done\n", id)
}

func main() {
    var wg sync.WaitGroup

    for i := 1; i <= 5; i++ {
        wg.Add(1) // register a goroutine
        go worker(i, &wg)
    }

    wg.Wait() // block until all goroutines call wg.Done()
    fmt.Println("All workers finished")
}
```

**Output (order may vary):**
```
Worker 3 starting
Worker 1 starting
Worker 5 starting
Worker 2 starting
Worker 4 starting
Worker 4 done
Worker 1 done
Worker 2 done
Worker 3 done
Worker 5 done
All workers finished
```

The order is non-deterministic — that's the nature of concurrency. Always design for it.

---

## Race Conditions

When multiple goroutines access shared state without coordination, you get a **race condition**:

```go
package main

import (
    "fmt"
    "sync"
)

func main() {
    var counter int
    var wg sync.WaitGroup

    for i := 0; i < 1000; i++ {
        wg.Add(1)
        go func() {
            defer wg.Done()
            counter++ // ❌ race condition!
        }()
    }

    wg.Wait()
    fmt.Println("Counter:", counter) // probably not 1000
}
```

The final value of `counter` will likely be less than 1000 because goroutines are reading and writing to it simultaneously.

---

## sync.Mutex: Protecting Shared State

A `Mutex` (mutual exclusion lock) ensures only one goroutine accesses a block of code at a time:

```go
package main

import (
    "fmt"
    "sync"
)

func main() {
    var mu sync.Mutex
    var counter int
    var wg sync.WaitGroup

    for i := 0; i < 1000; i++ {
        wg.Add(1)
        go func() {
            defer wg.Done()
            mu.Lock()
            counter++ // ✅ safe
            mu.Unlock()
        }()
    }

    wg.Wait()
    fmt.Println("Counter:", counter) // always 1000
}
```

**Output:**
```
Counter: 1000
```

---

## Detecting Race Conditions

Go has a built-in race detector. Run your program with:

```bash
go run -race main.go
```

Or your tests:

```bash
go test -race ./...
```

It will report any detected race conditions with the exact goroutine and line that caused them. Use it regularly — especially before shipping to production.

---

## Goroutines Are Not Free (But Close To It)

A goroutine starts with around **2–8 KB** of stack — compared to ~1 MB for an OS thread. The Go runtime can multiplex thousands of goroutines onto a handful of OS threads.

```go
package main

import (
    "fmt"
    "sync"
)

func main() {
    var wg sync.WaitGroup
    for i := 0; i < 100_000; i++ {
        wg.Add(1)
        go func() {
            defer wg.Done()
        }()
    }
    wg.Wait()
    fmt.Println("Ran 100,000 goroutines — no problem")
}
```

**Output:**
```
Ran 100,000 goroutines — no problem
```

---

## Quick Reference

- ✅ `go f()` — start a goroutine
- ✅ `sync.WaitGroup` — wait for goroutines to finish
- ✅ `sync.Mutex` — protect shared state from concurrent access
- ✅ `go run -race` — detect race conditions
- ⚠️ `main` doesn't wait for goroutines — use WaitGroup or channels
- ⚠️ Shared variables accessed by multiple goroutines must be protected

---

> 🔗 Next up: **Chapter Seventeen — Channels** → [Read it here](/2025/04/10/golang-series-chapter-seventeen-channels.html)
