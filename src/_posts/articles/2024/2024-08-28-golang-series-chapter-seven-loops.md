---
layout: post
title:  "Golang series: Chapter Seven - Loops: The Only Loop You Need"
description: Go has just one loop keyword — for. But it does everything. Learn every form of Go's for loop.
tags: golang loops tutorial
lang: en
---

# Loops in Go: The Only Loop You Need

Here's something that surprises most developers coming to Go: there is **only one loop keyword** — `for`. No `while`, no `do-while`, no `foreach`. Just `for`, doing all the heavy lifting.

And honestly? Once you get used to it, you'll wonder why other languages bothered with so many variants.

> 🧠 Missed Chapter 6? [Check it out here](/2024/08/10/golang-series-chapter-six-control-flow.html) to learn about if/else and switch first.

---

## The Classic for Loop

The standard C-style loop with three components: init, condition, post.

```go
package main

import "fmt"

func main() {
    for i := 0; i < 5; i++ {
        fmt.Println(i)
    }
}
```

**Output:**
```
0
1
2
3
4
```

---

## The while-Style Loop

Drop the init and post — and `for` becomes a `while`:

```go
package main

import "fmt"

func main() {
    n := 1

    for n < 100 {
        n *= 2
    }

    fmt.Println(n)
}
```

**Output:**
```
128
```

---

## The Infinite Loop

No condition at all — runs forever until you `break` or `return`:

```go
package main

import "fmt"

func main() {
    count := 0

    for {
        count++
        if count == 5 {
            break
        }
    }

    fmt.Println("Stopped at:", count)
}
```

**Output:**
```
Stopped at: 5
```

This pattern is common in server loops, background workers, and event listeners.

---

## break and continue

- **`break`** — exits the loop immediately
- **`continue`** — skips the rest of the current iteration and moves to the next

```go
package main

import "fmt"

func main() {
    for i := 0; i < 10; i++ {
        if i == 3 {
            continue // skip 3
        }
        if i == 7 {
            break // stop at 7
        }
        fmt.Println(i)
    }
}
```

**Output:**
```
0
1
2
4
5
6
```

---

## The range Keyword

`range` is how you iterate over slices, arrays, maps, strings, and channels. It returns the index and value in each iteration:

### Ranging Over a Slice

```go
package main

import "fmt"

func main() {
    languages := []string{"Go", "Python", "JavaScript"}

    for i, lang := range languages {
        fmt.Printf("%d: %s\n", i, lang)
    }
}
```

**Output:**
```
0: Go
1: Python
2: JavaScript
```

### Ignoring the Index

Use `_` (blank identifier) to discard what you don't need:

```go
for _, lang := range languages {
    fmt.Println(lang)
}
```

### Ranging Over a Map

```go
package main

import "fmt"

func main() {
    scores := map[string]int{
        "Alice": 95,
        "Bob":   87,
        "Carol": 92,
    }

    for name, score := range scores {
        fmt.Printf("%s: %d\n", name, score)
    }
}
```

**Output:**
```
Alice: 95
Bob: 87
Carol: 92
```

> ⚠️ Map iteration order is **not guaranteed** in Go. Don't rely on it being consistent.

### Ranging Over a String

`range` on a string iterates over **runes** (Unicode code points), not bytes:

```go
package main

import "fmt"

func main() {
    for i, ch := range "Go! 🐹" {
        fmt.Printf("index %d: %c\n", i, ch)
    }
}
```

**Output:**
```
index 0: G
index 1: o
index 2: !
index 3:  
index 4: 🐹
```

---

## Labeled Loops

When you have nested loops, `break` and `continue` only affect the innermost loop. Labels let you target an outer loop:

```go
package main

import "fmt"

func main() {
outer:
    for i := 0; i < 3; i++ {
        for j := 0; j < 3; j++ {
            if i == 1 && j == 1 {
                break outer
            }
            fmt.Printf("i=%d j=%d\n", i, j)
        }
    }
    fmt.Println("Done")
}
```

**Output:**
```
i=0 j=0
i=0 j=1
i=0 j=2
i=1 j=0
Done
```

---

## Quick Reference

| Form | Equivalent |
|---|---|
| `for init; cond; post {}` | C-style for |
| `for cond {}` | while |
| `for {}` | infinite loop |
| `for i, v := range slice {}` | foreach |
| `break` / `continue` | exit / skip iteration |
| `break label` | exit outer loop |

---

> 🔗 Next up: **Chapter Eight — Arrays & Slices** → [Read it here](/2024/09/15/golang-series-chapter-eight-arrays-and-slices.html)
