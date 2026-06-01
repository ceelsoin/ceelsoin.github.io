---
layout: post
title:  "Golang series: Chapter Eleven - Pointers"
description: Demystify Go pointers — learn what they are, when to use them, and how they differ from pass-by-value.
tags: golang pointers tutorial
lang: en
---

# Pointers in Go: Without the Pain

The word "pointer" scares a lot of developers — especially those coming from Python, JavaScript, or Ruby where memory management is completely hidden. Go brings pointers back, but in the most beginner-friendly way possible.

You don't need to allocate or free memory manually. You just need to understand two things: `&` and `*`.

> 🧠 Missed Chapter 10? [Check it out here](/2024/10/28/golang-series-chapter-ten-structs.html) to learn about structs — you'll need them in several pointer examples below.

---

## What Is a Pointer?

A **pointer** is a variable that holds the **memory address** of another variable.

Instead of storing a value like `42`, it stores *where* that `42` lives in memory.

---

## The & Operator (Address Of)

`&` gives you the memory address of a variable:

```go
package main

import "fmt"

func main() {
    x := 42
    p := &x // p is a pointer to x

    fmt.Println(x)  // 42
    fmt.Println(p)  // 0xc0000b4008 (some memory address)
    fmt.Println(&x) // same address
}
```

**Output:**
```
42
0xc0000b4008
0xc0000b4008
```

---

## The * Operator (Dereference)

`*` reads the value stored at a pointer's address:

```go
package main

import "fmt"

func main() {
    x := 42
    p := &x

    fmt.Println(*p) // read through the pointer → 42

    *p = 100        // write through the pointer
    fmt.Println(x)  // x is now 100
}
```

**Output:**
```
42
100
```

This is **dereferencing** — following the pointer to access what it points to.

---

## Pass by Value vs Pass by Pointer

Go is **pass by value** by default. When you pass a variable to a function, a copy is made:

```go
package main

import "fmt"

func double(n int) {
    n = n * 2 // modifies the copy, not the original
}

func main() {
    x := 5
    double(x)
    fmt.Println(x) // still 5
}
```

**Output:**
```
5
```

To modify the original, pass a pointer:

```go
package main

import "fmt"

func double(n *int) {
    *n = *n * 2
}

func main() {
    x := 5
    double(&x)
    fmt.Println(x) // 10
}
```

**Output:**
```
10
```

---

## When Should You Use Pointers?

There are three main reasons to use a pointer in Go:

### 1. Mutating a value in a called function

As shown above — when a function needs to modify the caller's variable.

### 2. Avoiding large copies

When a struct is large, passing a pointer is more efficient than copying the whole thing:

```go
type BigData struct {
    Records [100000]int
}

func process(b *BigData) {
    // works with original, no copy overhead
}
```

### 3. Signaling optionality (nil)

A pointer can be `nil`, which is useful to represent "value not provided":

```go
type Config struct {
    Timeout *int // nil means "use default"
}
```

---

## Pointers to Structs

Pointer fields on structs are dereferenced automatically with dot notation:

```go
package main

import "fmt"

type Point struct {
    X, Y int
}

func shift(p *Point, dx, dy int) {
    p.X += dx // Go auto-dereferences — no (*p).X needed
    p.Y += dy
}

func main() {
    pt := Point{X: 10, Y: 20}
    shift(&pt, 5, -3)
    fmt.Println(pt)
}
```

**Output:**
```
{15 17}
```

---

## The new Function

`new(T)` allocates a zeroed value of type `T` and returns a pointer to it:

```go
p := new(int)
fmt.Println(*p) // 0

*p = 99
fmt.Println(*p) // 99
```

In practice, `&T{}` struct literals are more common than `new` in Go codebases.

---

## Nil Pointers

A pointer's zero value is `nil`. Dereferencing a nil pointer causes a **panic**:

```go
var p *int
fmt.Println(p)   // <nil>
fmt.Println(*p)  // panic: runtime error: invalid memory address
```

Always check for nil before dereferencing when a pointer could be unset:

```go
if p != nil {
    fmt.Println(*p)
}
```

---

## Quick Reference

| Expression | Meaning |
|---|---|
| `&x` | Address of `x` (returns a pointer) |
| `*p` | Value at address `p` (dereference) |
| `var p *int` | Pointer variable, zero value is `nil` |
| `p := new(T)` | Allocate T, return pointer |
| `p.Field` | Auto-dereferenced struct field access |

---

> 🔗 Next up: **Chapter Twelve — Methods** → [Read it here](/2024/12/10/golang-series-chapter-twelve-methods.html)
