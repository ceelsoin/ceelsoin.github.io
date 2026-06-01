---
layout: post
title:  "Golang series: Chapter Thirteen - Interfaces"
description: Go interfaces enable powerful polymorphism through implicit implementation — learn how duck typing works in Go.
tags: golang interfaces tutorial
lang: en
---

# Interfaces in Go: Implicit, Powerful, Elegant

Happy New Year, Gophers! 🎉 We're moving into 2025 with one of Go's most elegant features: **interfaces**.

If you've worked with Java or C#, you know interfaces — but Go's version works differently. There's no `implements` keyword. A type satisfies an interface simply by having the right methods. This is called **duck typing**: *if it walks like a duck and quacks like a duck, it's a duck*.

> 🧠 Missed Chapter 12? [Check it out here](/2024/12/10/golang-series-chapter-twelve-methods.html) to learn about methods — interfaces are built on top of them.

---

## Declaring an Interface

An interface defines a set of method signatures:

```go
type Shape interface {
    Area() float64
    Perimeter() float64
}
```

Any type that has both `Area()` and `Perimeter()` methods automatically satisfies this interface — no declaration needed.

---

## Implicit Implementation

```go
package main

import (
    "fmt"
    "math"
)

type Shape interface {
    Area() float64
    Perimeter() float64
}

type Rectangle struct {
    Width, Height float64
}

func (r Rectangle) Area() float64 {
    return r.Width * r.Height
}

func (r Rectangle) Perimeter() float64 {
    return 2 * (r.Width + r.Height)
}

type Circle struct {
    Radius float64
}

func (c Circle) Area() float64 {
    return math.Pi * c.Radius * c.Radius
}

func (c Circle) Perimeter() float64 {
    return 2 * math.Pi * c.Radius
}

func printShape(s Shape) {
    fmt.Printf("Area: %.2f | Perimeter: %.2f\n", s.Area(), s.Perimeter())
}

func main() {
    r := Rectangle{Width: 10, Height: 5}
    c := Circle{Radius: 7}

    printShape(r)
    printShape(c)
}
```

**Output:**
```
Area: 50.00 | Perimeter: 30.00
Area: 153.94 | Perimeter: 43.98
```

`Rectangle` and `Circle` never explicitly say "I implement Shape" — they just do. The compiler figures it out.

---

## Interfaces Enable Polymorphism

Interfaces let you write functions that work with any type that satisfies the contract:

```go
package main

import "fmt"

type Stringer interface {
    String() string
}

type Dog struct{ Name string }
type Cat struct{ Name string }

func (d Dog) String() string { return "Dog: " + d.Name }
func (c Cat) String() string { return "Cat: " + c.Name }

func describe(s Stringer) {
    fmt.Println(s.String())
}

func main() {
    describe(Dog{Name: "Rex"})
    describe(Cat{Name: "Whiskers"})
}
```

**Output:**
```
Dog: Rex
Cat: Whiskers
```

---

## The Empty Interface

`interface{}` (or `any` in Go 1.18+) accepts any value at all — it has no required methods:

```go
package main

import "fmt"

func printAnything(v any) {
    fmt.Printf("Value: %v | Type: %T\n", v, v)
}

func main() {
    printAnything(42)
    printAnything("hello")
    printAnything(true)
    printAnything([]int{1, 2, 3})
}
```

**Output:**
```
Value: 42 | Type: int
Value: hello | Type: string
Value: true | Type: bool
Value: [1 2 3] | Type: []int
```

Use `any` sparingly — you lose type safety. It's most useful for generic containers and serialization code.

---

## Type Assertion

When you have an interface value and need the underlying concrete type, use a **type assertion**:

```go
package main

import "fmt"

func main() {
    var i any = "hello"

    // Safe assertion (returns ok)
    s, ok := i.(string)
    if ok {
        fmt.Println("String value:", s)
    }

    // Panics if wrong type — use sparingly
    // n := i.(int) // panic!
}
```

**Output:**
```
String value: hello
```

### Type Switch

When you have multiple possible types, use a type switch (we previewed this in Chapter 6):

```go
func describe(i any) {
    switch v := i.(type) {
    case int:
        fmt.Printf("Integer: %d\n", v)
    case string:
        fmt.Printf("String: %q\n", v)
    case Shape:
        fmt.Printf("Shape with area: %.2f\n", v.Area())
    default:
        fmt.Printf("Unknown: %T\n", v)
    }
}
```

---

## Interface Composition

Interfaces can embed other interfaces:

```go
type Reader interface {
    Read(p []byte) (n int, err error)
}

type Writer interface {
    Write(p []byte) (n int, err error)
}

type ReadWriter interface {
    Reader
    Writer
}
```

This is exactly how `io.ReadWriter` is defined in Go's standard library.

---

## Common Standard Library Interfaces

Getting familiar with these will make you a much better Go developer:

| Interface | Package | Methods |
|---|---|---|
| `fmt.Stringer` | `fmt` | `String() string` |
| `error` | builtin | `Error() string` |
| `io.Reader` | `io` | `Read(p []byte) (n int, err error)` |
| `io.Writer` | `io` | `Write(p []byte) (n int, err error)` |
| `io.Closer` | `io` | `Close() error` |
| `sort.Interface` | `sort` | `Len()`, `Less()`, `Swap()` |

---

## Quick Reference

- ✅ Interfaces are satisfied **implicitly** — no `implements` keyword
- ✅ A type satisfies an interface by having all its methods
- ✅ `any` / `interface{}` — accepts any value
- ✅ `val, ok := i.(Type)` — safe type assertion
- ✅ Type switch: `switch v := i.(type) { case T: ... }`
- ✅ Interfaces can embed other interfaces

---

> 🔗 Next up: **Chapter Fourteen — Error Handling** → [Read it here](/2025/02/05/golang-series-chapter-fourteen-error-handling.html)
