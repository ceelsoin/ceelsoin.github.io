---
layout: post
title:  "Golang series: Chapter Six - Control Flow: if, else & switch"
description: Master Go's control flow with if, else, and the surprisingly powerful switch statement.
tags: golang control-flow tutorial
lang: en
---

# Control Flow in Go: if, else & switch

Welcome back! Now that you know how functions work, it's time to make your programs actually *think*. Control flow is how you tell Go: "do this *if* that condition is true, otherwise do something else."

In this chapter we cover `if`, `else`, `else if`, and the underrated star of Go control flow — `switch`.

> 🧠 Missed Chapter 5? [Check it out here](/2024/07/20/golang-series-chapter-five-functions.html) to learn about functions first.

---

## The if Statement

The simplest form: run a block if a condition is true.

```go
package main

import "fmt"

func main() {
    temperature := 35

    if temperature > 30 {
        fmt.Println("It's hot outside!")
    }
}
```

**Output:**
```
It's hot outside!
```

> No parentheses around the condition — that's Go style. The linter will complain if you add them.

---

## if / else

```go
package main

import "fmt"

func main() {
    score := 72

    if score >= 90 {
        fmt.Println("Grade: A")
    } else if score >= 70 {
        fmt.Println("Grade: B")
    } else if score >= 50 {
        fmt.Println("Grade: C")
    } else {
        fmt.Println("Grade: F")
    }
}
```

**Output:**
```
Grade: B
```

---

## The if Short Statement

Go's `if` can execute a short statement before evaluating the condition. This is perfect for initializing a variable scoped only to the `if` block:

```go
package main

import (
    "fmt"
    "strconv"
)

func main() {
    if n, err := strconv.Atoi("42"); err == nil {
        fmt.Println("Parsed number:", n)
    } else {
        fmt.Println("Error:", err)
    }
    // n and err are not accessible here
}
```

**Output:**
```
Parsed number: 42
```

You'll see this pattern constantly in Go, especially with error checks. Get comfortable with it.

---

## The switch Statement

Go's `switch` is more flexible than in most languages. No `break` needed — cases don't fall through by default.

```go
package main

import "fmt"

func main() {
    day := "Wednesday"

    switch day {
    case "Monday", "Tuesday", "Wednesday", "Thursday", "Friday":
        fmt.Println("Weekday — time to work!")
    case "Saturday", "Sunday":
        fmt.Println("Weekend — time to rest!")
    default:
        fmt.Println("Unknown day")
    }
}
```

**Output:**
```
Weekday — time to work!
```

Notice you can group multiple values in a single case with a comma.

---

## switch Without a Condition

This is one of Go's hidden gems. A `switch` without a condition is equivalent to `switch true` — each case becomes an independent boolean expression:

```go
package main

import "fmt"

func classify(n int) string {
    switch {
    case n < 0:
        return "negative"
    case n == 0:
        return "zero"
    case n < 10:
        return "small"
    case n < 100:
        return "medium"
    default:
        return "large"
    }
}

func main() {
    fmt.Println(classify(-5))
    fmt.Println(classify(0))
    fmt.Println(classify(7))
    fmt.Println(classify(42))
    fmt.Println(classify(999))
}
```

**Output:**
```
negative
zero
small
medium
large
```

This is a clean replacement for long `if/else if` chains. I use this pattern all the time at Globo when routing request types or mapping status codes.

---

## Explicit Fallthrough

If you *do* want the C-style fallthrough behavior, Go gives you the `fallthrough` keyword — but it must be explicit:

```go
package main

import "fmt"

func main() {
    n := 2

    switch n {
    case 1:
        fmt.Println("one")
        fallthrough
    case 2:
        fmt.Println("two")
        fallthrough
    case 3:
        fmt.Println("three")
    case 4:
        fmt.Println("four")
    }
}
```

**Output:**
```
two
three
```

> ⚠️ `fallthrough` executes the next case unconditionally — it doesn't re-evaluate the condition. Use it rarely and document why.

---

## switch on Types

Go also has a type switch, useful when working with interfaces. We'll revisit this when we get to Chapter 13 on interfaces, but here's a sneak peek:

```go
package main

import "fmt"

func describe(i interface{}) {
    switch v := i.(type) {
    case int:
        fmt.Printf("Integer: %d\n", v)
    case string:
        fmt.Printf("String: %q\n", v)
    case bool:
        fmt.Printf("Boolean: %v\n", v)
    default:
        fmt.Printf("Unknown type: %T\n", v)
    }
}

func main() {
    describe(42)
    describe("hello")
    describe(true)
}
```

**Output:**
```
Integer: 42
String: "hello"
Boolean: true
```

---

## Quick Reference

- ✅ No parentheses around conditions
- ✅ `if init; condition {}` — short statement scopes the variable
- ✅ `switch` has no implicit fallthrough — much safer than C/Java
- ✅ `switch {}` (no condition) replaces long if/else chains
- ✅ `fallthrough` is available but explicit

---

> 🔗 Next up: **Chapter Seven — Loops: The Only Loop You Need** → [Read it here](/2024/08/28/golang-series-chapter-seven-loops.html)
