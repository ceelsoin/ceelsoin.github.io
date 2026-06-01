---
layout: post
title:  "Golang series: Chapter Ten - Structs"
description: Go doesn't have classes — it has structs. Learn how to model your data with Go's powerful struct type.
tags: golang structs tutorial
lang: en
---

# Structs in Go: Modeling Your Data Without Classes

If you're coming from an object-oriented language like Java or Python, one of the first things you'll notice about Go is: **there are no classes**. Instead, Go uses **structs** — and once you understand them, you'll realize they're more than enough.

Structs let you group related fields into a single type. Combined with methods (Chapter 12), they cover everything classes do — without the inheritance complexity.

> 🧠 Missed Chapter 9? [Check it out here](/2024/10/05/golang-series-chapter-nine-maps.html) to learn about maps first.

---

## Declaring a Struct

```go
type Person struct {
    Name string
    Age  int
    Email string
}
```

This defines a new type called `Person` with three fields.

---

## Creating a Struct Instance

### Using a Struct Literal

```go
package main

import "fmt"

type Person struct {
    Name  string
    Age   int
    Email string
}

func main() {
    p := Person{
        Name:  "Celso",
        Age:   29,
        Email: "celso@example.com",
    }

    fmt.Println(p)
    fmt.Println(p.Name)
}
```

**Output:**
```
{Celso 29 celso@example.com}
Celso
```

### Zero Value

Like all types in Go, a struct has a zero value — all fields set to their zero values:

```go
var p Person
fmt.Println(p) // { 0 }
```

---

## Accessing and Modifying Fields

Use dot notation:

```go
p.Age = 30
fmt.Println(p.Age) // 30
```

---

## Pointers to Structs

When you pass a struct to a function, Go copies it by default. To modify the original, use a pointer:

```go
package main

import "fmt"

type Counter struct {
    Value int
}

func increment(c *Counter) {
    c.Value++
}

func main() {
    c := Counter{Value: 0}
    increment(&c)
    increment(&c)
    fmt.Println(c.Value) // 2
}
```

**Output:**
```
2
```

Go automatically dereferences struct pointers with dot notation — you write `c.Value`, not `(*c).Value`.

---

## Anonymous Structs

For one-off use cases, you can define a struct inline without giving it a name:

```go
package main

import "fmt"

func main() {
    config := struct {
        Host string
        Port int
    }{
        Host: "localhost",
        Port: 8080,
    }

    fmt.Printf("Connecting to %s:%d\n", config.Host, config.Port)
}
```

**Output:**
```
Connecting to localhost:8080
```

Useful in tests or temporary data groupings.

---

## Struct Embedding

Go's answer to inheritance is **embedding** — including one struct inside another:

```go
package main

import "fmt"

type Animal struct {
    Name string
}

func (a Animal) Speak() string {
    return a.Name + " makes a sound"
}

type Dog struct {
    Animal        // embedded struct
    Breed string
}

func main() {
    d := Dog{
        Animal: Animal{Name: "Rex"},
        Breed:  "Labrador",
    }

    fmt.Println(d.Name)    // promoted field
    fmt.Println(d.Speak()) // promoted method
    fmt.Println(d.Breed)
}
```

**Output:**
```
Rex
Rex makes a sound
Labrador
```

Fields and methods from the embedded struct are **promoted** — they appear as if they belong to the outer struct. This is composition, not inheritance, and it's much cleaner.

---

## Struct Tags

Struct tags are metadata strings attached to fields. They're commonly used with the `encoding/json` package for JSON serialization:

```go
package main

import (
    "encoding/json"
    "fmt"
)

type User struct {
    Name  string `json:"name"`
    Email string `json:"email"`
    Age   int    `json:"age,omitempty"`
}

func main() {
    u := User{Name: "Celso", Email: "celso@example.com"}

    data, _ := json.Marshal(u)
    fmt.Println(string(data))
}
```

**Output:**
```json
{"name":"Celso","email":"celso@example.com"}
```

`omitempty` means the field is omitted from JSON if it's the zero value — very handy for optional API fields.

---

## Comparing Structs

Two structs of the same type are equal if all their fields are equal (as long as all field types are comparable):

```go
p1 := Person{Name: "Ana", Age: 25}
p2 := Person{Name: "Ana", Age: 25}
p3 := Person{Name: "Bob", Age: 30}

fmt.Println(p1 == p2) // true
fmt.Println(p1 == p3) // false
```

---

## Quick Reference

- ✅ `type Name struct { Field Type }` — declare a struct type
- ✅ `p := Name{Field: value}` — struct literal
- ✅ `p.Field` — access/modify fields
- ✅ Use pointer `*Name` to modify the original across function calls
- ✅ Embedding promotes fields and methods from inner structs
- ✅ Struct tags (backtick strings) control encoding/decoding behavior

---

> 🔗 Next up: **Chapter Eleven — Pointers** → [Read it here](/2024/11/20/golang-series-chapter-eleven-pointers.html)
