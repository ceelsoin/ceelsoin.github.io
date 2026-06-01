---
layout: post
title:  "Golang series: Chapter Nine - Maps"
description: Learn how to use maps in Go — Go's built-in key-value data structure for fast lookups.
tags: golang maps tutorial
lang: en
---

# Maps in Go: Key-Value Storage Done Right

Welcome back! If slices are Go's dynamic lists, **maps** are Go's key-value store. They let you associate one value with another — like a dictionary, a hash table, or a JSON object.

Maps are one of the most frequently used data structures in real-world Go code. At Globo, nearly every HTTP handler I write uses maps at some point — for routing, caching, grouping results. Let's dig in.

> 🧠 Missed Chapter 8? [Check it out here](/2024/09/15/golang-series-chapter-eight-arrays-and-slices.html) to learn about arrays and slices first.

---

## Declaring a Map

The syntax is `map[KeyType]ValueType`.

```go
package main

import "fmt"

func main() {
    var scores map[string]int // nil map
    fmt.Println(scores)
    fmt.Println(scores == nil) // true
}
```

**Output:**
```
map[]
true
```

> ⚠️ A nil map can be read from (returns zero values), but **writing to a nil map panics**. Always initialize before writing.

---

## Creating a Map with make

```go
package main

import "fmt"

func main() {
    scores := make(map[string]int)

    scores["Alice"] = 95
    scores["Bob"] = 87
    scores["Carol"] = 92

    fmt.Println(scores)
}
```

**Output:**
```
map[Alice:95 Bob:87 Carol:92]
```

---

## Map Literal

You can declare and initialize in one step:

```go
package main

import "fmt"

func main() {
    capital := map[string]string{
        "Brazil":  "Brasília",
        "France":  "Paris",
        "Japan":   "Tokyo",
    }

    fmt.Println(capital["Brazil"])
}
```

**Output:**
```
Brasília
```

---

## Reading from a Map

Accessing a key that doesn't exist returns the **zero value** for that type — no panic, no error:

```go
fmt.Println(capital["Germany"]) // ""
```

### Checking if a Key Exists

Use the two-value assignment to distinguish between "key not found" and "key exists with zero value":

```go
value, ok := capital["Germany"]
if ok {
    fmt.Println("Capital:", value)
} else {
    fmt.Println("Country not found")
}
```

**Output:**
```
Country not found
```

This `value, ok` idiom is idiomatic Go — you'll see it constantly.

---

## Updating a Value

Just assign to an existing key:

```go
scores["Alice"] = 100
fmt.Println(scores["Alice"]) // 100
```

---

## Deleting a Key

Use the built-in `delete` function:

```go
delete(scores, "Bob")
fmt.Println(scores)
```

**Output:**
```
map[Alice:100 Carol:92]
```

---

## Iterating Over a Map

Use `range`:

```go
package main

import "fmt"

func main() {
    ages := map[string]int{
        "Ana":   28,
        "Pedro": 34,
        "Lucas": 25,
    }

    for name, age := range ages {
        fmt.Printf("%s is %d years old\n", name, age)
    }
}
```

**Output:**
```
Ana is 28 years old
Pedro is 34 years old
Lucas is 25 years old
```

> ⚠️ Map iteration order is **random** in Go. Never rely on a specific order.

---

## Maps with Struct Values

Maps often store structs as values — a very common pattern:

```go
package main

import "fmt"

type User struct {
    Name  string
    Email string
}

func main() {
    users := map[string]User{
        "u001": {Name: "Celso", Email: "celso@example.com"},
        "u002": {Name: "Ana", Email: "ana@example.com"},
    }

    user, ok := users["u001"]
    if ok {
        fmt.Printf("Name: %s | Email: %s\n", user.Name, user.Email)
    }
}
```

**Output:**
```
Name: Celso | Email: celso@example.com
```

---

## Counting with Maps

A classic use case — counting occurrences:

```go
package main

import "fmt"

func main() {
    words := []string{"go", "is", "great", "go", "is", "fast", "go"}

    count := make(map[string]int)
    for _, word := range words {
        count[word]++
    }

    fmt.Println(count)
}
```

**Output:**
```
map[fast:1 go:3 great:1 is:2]
```

---

## Quick Reference

- ✅ `make(map[K]V)` — creates a ready-to-use map
- ✅ `m[key] = val` — set
- ✅ `val := m[key]` — get (zero value if key absent)
- ✅ `val, ok := m[key]` — safe get with existence check
- ✅ `delete(m, key)` — remove a key
- ✅ `for k, v := range m {}` — iterate
- ⚠️ Never write to a nil map

---

> 🔗 Next up: **Chapter Ten — Structs** → [Read it here](/2024/10/28/golang-series-chapter-ten-structs.html)
