---
layout: post
title:  "Golang series: Chapter Fifteen - Defer, Panic & Recover"
description: Learn how Go handles cleanup with defer, and how to handle unexpected crashes with panic and recover.
tags: golang defer panic recover tutorial
lang: en
---

# Defer, Panic & Recover in Go

In the last chapter we covered how Go handles expected errors — the everyday "something went wrong" scenarios. Now let's look at what happens when things go *really* wrong, and how Go gives you tools to clean up gracefully.

This chapter covers three keywords that work together: `defer`, `panic`, and `recover`.

> 🧠 Missed Chapter 14? [Check it out here](/2025/02/05/golang-series-chapter-fourteen-error-handling.html) to understand Go's error handling model before diving into panic and recover.

---

## defer

`defer` schedules a function call to run **after the surrounding function returns** — regardless of how it returns (normally, via `return`, or even via `panic`).

```go
package main

import "fmt"

func main() {
    fmt.Println("start")
    defer fmt.Println("deferred: runs last")
    fmt.Println("end")
}
```

**Output:**
```
start
end
deferred: runs last
```

---

## defer for Cleanup

The most common real-world use: ensuring a resource is released no matter what happens.

```go
package main

import (
    "fmt"
    "os"
)

func readFile(path string) error {
    f, err := os.Open(path)
    if err != nil {
        return fmt.Errorf("readFile: %w", err)
    }
    defer f.Close() // guaranteed to run when function exits

    // read from f...
    fmt.Println("File opened successfully")
    return nil
}

func main() {
    readFile("example.txt")
}
```

The pattern `open → defer close → work` is used throughout Go's standard library and production code. No matter where the function returns or panics, `f.Close()` will be called.

---

## Multiple defers: LIFO Order

When multiple `defer` calls are present, they execute in **Last In, First Out** (LIFO) order — like a stack:

```go
package main

import "fmt"

func main() {
    defer fmt.Println("first deferred")
    defer fmt.Println("second deferred")
    defer fmt.Println("third deferred")

    fmt.Println("main body")
}
```

**Output:**
```
main body
third deferred
second deferred
first deferred
```

This is intentional — it mirrors the order you'd want to release resources (last acquired, first released).

---

## defer Arguments Are Evaluated Immediately

The arguments to a deferred call are evaluated *when the defer statement runs*, not when the deferred function executes:

```go
package main

import "fmt"

func main() {
    x := 10
    defer fmt.Println("deferred x:", x) // captures x=10 now

    x = 99
    fmt.Println("current x:", x)
}
```

**Output:**
```
current x: 99
deferred x: 10
```

---

## panic

`panic` stops the normal execution of a goroutine immediately. It unwinds the call stack, running any deferred functions along the way, and if nothing stops it, the program crashes with a stack trace.

```go
package main

func main() {
    panic("something went catastrophically wrong")
}
```

**Output:**
```
goroutine 1 [running]:
main.main()
    /tmp/main.go:4 +0x27
exit status 2
```

### When to Use panic

Rarely. `panic` is reserved for **truly unrecoverable situations**:

- ✅ Programming errors (index out of bounds, nil dereference)
- ✅ Initialization failures that make the program impossible to run
- ❌ Expected errors that callers should handle — use `error` for those

At Globo, we never `panic` in request handlers. We return errors and let the HTTP layer handle them gracefully.

---

## recover

`recover` catches a `panic` and lets you handle it — but only inside a **deferred function**:

```go
package main

import "fmt"

func safeRun(fn func()) {
    defer func() {
        if r := recover(); r != nil {
            fmt.Println("Recovered from panic:", r)
        }
    }()

    fn()
}

func main() {
    safeRun(func() {
        panic("something broke")
    })

    fmt.Println("Program continues after recovery")
}
```

**Output:**
```
Recovered from panic: something broke
Program continues after recovery
```

---

## Real-World Pattern: Panic-Safe Middleware

In HTTP servers, it's common to wrap handlers with a recovery middleware to prevent one bad request from crashing the whole server:

```go
package main

import (
    "fmt"
    "net/http"
)

func recoveryMiddleware(next http.HandlerFunc) http.HandlerFunc {
    return func(w http.ResponseWriter, r *http.Request) {
        defer func() {
            if rec := recover(); rec != nil {
                fmt.Printf("panic recovered: %v\n", rec)
                http.Error(w, "Internal Server Error", http.StatusInternalServerError)
            }
        }()
        next(w, r)
    }
}
```

This is the `recover` pattern in production — isolating panics at boundaries without crashing the process.

---

## How They Work Together

```
panic() triggered
    → deferred functions run (LIFO)
        → recover() in a deferred function catches the panic
            → execution resumes after the deferred function
```

If no `recover` is called, the panic propagates up the call stack and crashes the program.

---

## Quick Reference

| Keyword | What it does |
|---|---|
| `defer f()` | Schedules `f()` to run when the surrounding function returns |
| `panic(v)` | Stops execution, unwinds with deferred calls, crashes if unrecovered |
| `recover()` | Inside a deferred function, catches and returns the panic value |

- ✅ Use `defer` for cleanup (close files, release locks, log timing)
- ✅ Multiple defers run LIFO
- ✅ `panic` for truly unrecoverable states only
- ✅ `recover` only works inside a `defer`
- ⚠️ Don't use `panic`/`recover` as general flow control — that's what `error` is for

---

> 🔗 Next up: **Chapter Sixteen — Goroutines: Concurrency Basics** → [Read it here](/2025/03/20/golang-series-chapter-sixteen-goroutines.html)
