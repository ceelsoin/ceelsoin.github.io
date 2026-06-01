---
layout: post
title:  "Golang series: Chapter Seventeen - Channels"
description: Channels are Go's way of communicating between goroutines safely. Learn buffered, unbuffered, and the select statement.
tags: golang channels concurrency tutorial
lang: en
---

# Channels in Go: Communicating Between Goroutines

Last chapter we saw goroutines sharing state with mutexes. But Go has a higher-level tool for concurrent communication: **channels**. They're built on a simple philosophy from Tony Hoare's CSP model, adopted as Go's motto:

> *"Do not communicate by sharing memory; instead, share memory by communicating."*

A channel is a typed conduit through which goroutines can send and receive values — safely, without mutexes.

> 🧠 Missed Chapter 16? [Check it out here](/2025/03/20/golang-series-chapter-sixteen-goroutines.html) to understand goroutines before diving into how they communicate.

---

## Creating a Channel

Use `make` with the channel type:

```go
ch := make(chan int)       // unbuffered channel of int
ch := make(chan string, 5) // buffered channel with capacity 5
```

---

## Sending and Receiving

- `ch <- value` — send a value into the channel
- `value := <-ch` — receive a value from the channel

```go
package main

import "fmt"

func sum(a, b int, ch chan int) {
    ch <- a + b
}

func main() {
    ch := make(chan int)
    go sum(10, 20, ch)

    result := <-ch // blocks until sum sends
    fmt.Println("Result:", result)
}
```

**Output:**
```
Result: 30
```

---

## Unbuffered Channels

An **unbuffered channel** has no storage. A send blocks until a receiver is ready, and a receive blocks until a sender sends. This synchronization is built in:

```go
package main

import "fmt"

func ping(ch chan string) {
    ch <- "ping"
}

func main() {
    ch := make(chan string)
    go ping(ch)

    msg := <-ch
    fmt.Println(msg)
}
```

**Output:**
```
ping
```

---

## Buffered Channels

A **buffered channel** has a capacity. Sends don't block until the buffer is full:

```go
package main

import "fmt"

func main() {
    ch := make(chan int, 3)

    ch <- 1
    ch <- 2
    ch <- 3
    // ch <- 4 would block here — buffer is full

    fmt.Println(<-ch)
    fmt.Println(<-ch)
    fmt.Println(<-ch)
}
```

**Output:**
```
1
2
3
```

---

## Closing a Channel

A sender can **close** a channel to signal that no more values will be sent:

```go
package main

import "fmt"

func generate(ch chan int) {
    for i := 1; i <= 5; i++ {
        ch <- i
    }
    close(ch)
}

func main() {
    ch := make(chan int, 5)
    go generate(ch)

    for v := range ch { // range receives until channel is closed
        fmt.Println(v)
    }
}
```

**Output:**
```
1
2
3
4
5
```

> ⚠️ Only the **sender** should close a channel. Sending to a closed channel panics. Receiving from a closed channel returns the zero value immediately.

---

## Checking if a Channel Is Closed

Use the two-value receive form:

```go
v, ok := <-ch
if !ok {
    fmt.Println("Channel is closed")
}
```

---

## The select Statement

`select` lets a goroutine wait on multiple channel operations at once — like a switch for channels:

```go
package main

import (
    "fmt"
    "time"
)

func main() {
    ch1 := make(chan string)
    ch2 := make(chan string)

    go func() {
        time.Sleep(100 * time.Millisecond)
        ch1 <- "from ch1"
    }()

    go func() {
        time.Sleep(200 * time.Millisecond)
        ch2 <- "from ch2"
    }()

    for i := 0; i < 2; i++ {
        select {
        case msg := <-ch1:
            fmt.Println(msg)
        case msg := <-ch2:
            fmt.Println(msg)
        }
    }
}
```

**Output:**
```
from ch1
from ch2
```

`select` picks whichever case is ready first. If multiple are ready simultaneously, it picks one at random.

---

## select with Default (Non-Blocking)

Add a `default` case to avoid blocking:

```go
select {
case msg := <-ch:
    fmt.Println("Received:", msg)
default:
    fmt.Println("No message ready")
}
```

---

## Timeout Pattern with select

Combining `select` and `time.After` is idiomatic for adding timeouts:

```go
package main

import (
    "fmt"
    "time"
)

func slowOperation(ch chan string) {
    time.Sleep(2 * time.Second)
    ch <- "result"
}

func main() {
    ch := make(chan string)
    go slowOperation(ch)

    select {
    case result := <-ch:
        fmt.Println("Got result:", result)
    case <-time.After(1 * time.Second):
        fmt.Println("Timed out!")
    }
}
```

**Output:**
```
Timed out!
```

This pattern is everywhere in real-world Go services — any network call or database query should have a timeout.

---

## Fan-Out: One Sender, Many Workers

```go
package main

import (
    "fmt"
    "sync"
)

func worker(id int, jobs <-chan int, wg *sync.WaitGroup) {
    defer wg.Done()
    for j := range jobs {
        fmt.Printf("Worker %d processed job %d\n", id, j)
    }
}

func main() {
    jobs := make(chan int, 10)
    var wg sync.WaitGroup

    for w := 1; w <= 3; w++ {
        wg.Add(1)
        go worker(w, jobs, &wg)
    }

    for j := 1; j <= 9; j++ {
        jobs <- j
    }
    close(jobs)

    wg.Wait()
}
```

This worker pool pattern is one of the most common Go concurrency patterns in production.

---

## Quick Reference

- ✅ `make(chan T)` — unbuffered channel
- ✅ `make(chan T, n)` — buffered channel with capacity n
- ✅ `ch <- v` — send (blocks if no receiver / buffer full)
- ✅ `v := <-ch` — receive (blocks if nothing to receive)
- ✅ `close(ch)` — signal no more values (sender only)
- ✅ `for v := range ch {}` — receive until closed
- ✅ `select` — wait on multiple channels at once
- ⚠️ Sending to a closed channel panics

---

> 🔗 Next up: **Chapter Eighteen — Packages & Modules** → [Read it here](/2025/05/01/golang-series-chapter-eighteen-packages-and-modules.html)
