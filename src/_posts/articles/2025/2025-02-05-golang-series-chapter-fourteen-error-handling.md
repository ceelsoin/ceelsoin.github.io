---
layout: post
title:  "Golang series: Chapter Fourteen - Error Handling"
description: Go handles errors explicitly, not with exceptions. Learn the idiomatic way to deal with errors in Go.
tags: golang errors tutorial
lang: en
---

# Error Handling in Go: Explicit, Clear, and Honest

One thing that stands out immediately when you read Go code is how errors are handled. There are no `try/catch` blocks. No exceptions flying up the call stack. Go treats errors as **values** — just like any other value — and you deal with them where they happen.

This feels strange at first. But after a while, you start to appreciate how honest it is. Nothing is hidden.

> 🧠 Missed Chapter 13? [Check it out here](/2025/01/15/golang-series-chapter-thirteen-interfaces.html) to understand interfaces — `error` itself is an interface.

---

## The error Interface

`error` is a built-in interface with a single method:

```go
type error interface {
    Error() string
}
```

Any type that has an `Error() string` method satisfies the `error` interface. That's it.

---

## Returning Errors

The Go convention is to return an error as the **last return value**:

```go
package main

import (
    "errors"
    "fmt"
)

func divide(a, b float64) (float64, error) {
    if b == 0 {
        return 0, errors.New("division by zero")
    }
    return a / b, nil
}

func main() {
    result, err := divide(10, 2)
    if err != nil {
        fmt.Println("Error:", err)
        return
    }
    fmt.Println("Result:", result)

    _, err = divide(5, 0)
    if err != nil {
        fmt.Println("Error:", err)
    }
}
```

**Output:**
```
Result: 5
Error: division by zero
```

`nil` means no error. Non-nil means something went wrong.

---

## Creating Errors

### errors.New

For simple, static error messages:

```go
import "errors"

var ErrNotFound = errors.New("record not found")
```

### fmt.Errorf

For formatted error messages with context:

```go
import "fmt"

func findUser(id int) error {
    return fmt.Errorf("user with id %d not found", id)
}
```

---

## Wrapping Errors

Since Go 1.13, you can **wrap** an error to add context while preserving the original:

```go
package main

import (
    "errors"
    "fmt"
)

var ErrDatabase = errors.New("database error")

func queryUser(id int) error {
    // Simulating a db failure
    return fmt.Errorf("queryUser(%d): %w", id, ErrDatabase)
}

func main() {
    err := queryUser(42)
    if err != nil {
        fmt.Println(err)

        // Unwrap: check if the root cause is ErrDatabase
        if errors.Is(err, ErrDatabase) {
            fmt.Println("→ Root cause: database error")
        }
    }
}
```

**Output:**
```
queryUser(42): database error
→ Root cause: database error
```

The `%w` verb in `fmt.Errorf` wraps the error. `errors.Is` unwraps the chain to find a match.

---

## Custom Error Types

For richer errors (with extra fields), implement the `error` interface:

```go
package main

import "fmt"

type ValidationError struct {
    Field   string
    Message string
}

func (e *ValidationError) Error() string {
    return fmt.Sprintf("validation error on field %q: %s", e.Field, e.Message)
}

func validateAge(age int) error {
    if age < 0 {
        return &ValidationError{Field: "age", Message: "must be non-negative"}
    }
    if age > 150 {
        return &ValidationError{Field: "age", Message: "unrealistic value"}
    }
    return nil
}

func main() {
    err := validateAge(-5)
    if err != nil {
        fmt.Println(err)

        // Extract the concrete type
        var ve *ValidationError
        if errors.As(err, &ve) {
            fmt.Println("Field:", ve.Field)
        }
    }
}
```

**Output:**
```
validation error on field "age": must be non-negative
Field: age
```

`errors.As` unwraps the error chain to find a value of the target type — the counterpart of `errors.Is`.

---

## errors.Is vs errors.As

| Function | Use When |
|---|---|
| `errors.Is(err, target)` | Checking for a specific error *value* |
| `errors.As(err, &target)` | Extracting a specific error *type* |

---

## Sentinel Errors

Sentinel errors are package-level error variables used as well-known error codes:

```go
var (
    ErrNotFound     = errors.New("not found")
    ErrUnauthorized = errors.New("unauthorized")
    ErrTimeout      = errors.New("request timed out")
)
```

Callers check them with `errors.Is`:

```go
if errors.Is(err, ErrNotFound) {
    // handle 404-like case
}
```

---

## Don't Ignore Errors

A common mistake in Go is discarding errors with `_`:

```go
result, _ := riskyOperation() // ❌ don't do this unless you're 100% sure
```

If you genuinely don't care (rare), document why. Otherwise, handle it.

---

## Quick Reference

- ✅ `errors.New("message")` — simple error
- ✅ `fmt.Errorf("context: %w", err)` — wrapped error with context
- ✅ `errors.Is(err, target)` — sentinel value check
- ✅ `errors.As(err, &target)` — concrete type extraction
- ✅ Custom error types: implement `Error() string`
- ⚠️ Don't ignore errors with `_` unless justified

---

> 🔗 Next up: **Chapter Fifteen — Defer, Panic & Recover** → [Read it here](/2025/02/25/golang-series-chapter-fifteen-defer-panic-recover.html)
