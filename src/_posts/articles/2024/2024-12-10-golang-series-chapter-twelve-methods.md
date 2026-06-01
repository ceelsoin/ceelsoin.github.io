---
layout: post
title:  "Golang series: Chapter Twelve - Methods"
description: Learn how Go attaches behavior to types using methods — without classes.
tags: golang methods tutorial
lang: en
---

# Methods in Go: Adding Behavior to Your Types

Welcome to Chapter 12! We know how to model data with structs and understand how pointers work. Now it's time to give our types **behavior** — and that's what methods are for.

In Go, a **method** is just a function with a special receiver argument. That receiver binds the function to a specific type. Simple as that.

> 🧠 Missed Chapter 11? [Check it out here](/2024/11/20/golang-series-chapter-eleven-pointers.html) to understand pointers — they're essential for this chapter.

---

## Your First Method

```go
package main

import "fmt"

type Rectangle struct {
    Width  float64
    Height float64
}

func (r Rectangle) Area() float64 {
    return r.Width * r.Height
}

func main() {
    rect := Rectangle{Width: 10, Height: 5}
    fmt.Println("Area:", rect.Area())
}
```

**Output:**
```
Area: 50
```

The `(r Rectangle)` part before the function name is the **receiver**. It tells Go: "this `Area` function belongs to the `Rectangle` type."

---

## Value Receiver vs Pointer Receiver

This is the most important decision you make when writing methods.

### Value Receiver

The method receives a **copy** of the struct. Changes inside the method don't affect the original:

```go
func (r Rectangle) Scale(factor float64) Rectangle {
    return Rectangle{
        Width:  r.Width * factor,
        Height: r.Height * factor,
    }
}
```

### Pointer Receiver

The method receives a **pointer** to the original. Changes persist:

```go
func (r *Rectangle) ScaleInPlace(factor float64) {
    r.Width *= factor
    r.Height *= factor
}

func main() {
    rect := Rectangle{Width: 10, Height: 5}
    rect.ScaleInPlace(2)
    fmt.Println(rect) // {20 10}
}
```

**Output:**
```
{20 10}
```

Go automatically takes the address for you — you call `rect.ScaleInPlace(2)` even though `ScaleInPlace` has a pointer receiver. No need to write `(&rect).ScaleInPlace(2)`.

---

## When to Use Each

| Situation | Receiver |
|---|---|
| Method needs to modify the struct | Pointer `*T` |
| Struct is large (avoid copy overhead) | Pointer `*T` |
| Method only reads from the struct | Value `T` |
| Type is a primitive alias (e.g., `type Celsius float64`) | Value `T` |

> 🛠️ Pro tip: Be consistent. If *any* method on a type uses a pointer receiver, make *all* of them pointer receivers to avoid surprising behavior.

---

## Methods on Any Type

You can define methods on any type you define — not just structs. The type must be in the same package:

```go
package main

import "fmt"

type Celsius float64
type Fahrenheit float64

func (c Celsius) ToFahrenheit() Fahrenheit {
    return Fahrenheit(c*9/5 + 32)
}

func (f Fahrenheit) ToCelsius() Celsius {
    return Celsius((f - 32) * 5 / 9)
}

func main() {
    boiling := Celsius(100)
    fmt.Printf("%.1f°C = %.1f°F\n", boiling, boiling.ToFahrenheit())

    body := Fahrenheit(98.6)
    fmt.Printf("%.1f°F = %.1f°C\n", body, body.ToCelsius())
}
```

**Output:**
```
100.0°C = 212.0°F
98.6°F = 37.0°C
```

---

## A Complete Example: BankAccount

```go
package main

import "fmt"

type BankAccount struct {
    Owner   string
    Balance float64
}

func (a *BankAccount) Deposit(amount float64) {
    a.Balance += amount
}

func (a *BankAccount) Withdraw(amount float64) error {
    if amount > a.Balance {
        return fmt.Errorf("insufficient funds: balance is %.2f", a.Balance)
    }
    a.Balance -= amount
    return nil
}

func (a BankAccount) String() string {
    return fmt.Sprintf("Account[%s]: $%.2f", a.Owner, a.Balance)
}

func main() {
    acc := BankAccount{Owner: "Celso", Balance: 1000}

    acc.Deposit(500)
    fmt.Println(acc)

    if err := acc.Withdraw(200); err != nil {
        fmt.Println("Error:", err)
    }
    fmt.Println(acc)

    if err := acc.Withdraw(2000); err != nil {
        fmt.Println("Error:", err)
    }
}
```

**Output:**
```
Account[Celso]: $1500.00
Account[Celso]: $1300.00
Error: insufficient funds: balance is 1300.00
```

Notice the `String() string` method — Go's `fmt` package automatically calls it when printing a value. This is your first taste of how interfaces work in Go (coming up next!).

---

## Quick Reference

- ✅ `func (r ReceiverType) MethodName() ReturnType {}` — value receiver
- ✅ `func (r *ReceiverType) MethodName() {}` — pointer receiver (modifies original)
- ✅ Methods can be defined on any named type, not just structs
- ✅ Go auto-addresses/dereferences when calling methods
- ⚠️ Mix of value and pointer receivers on the same type causes issues with interfaces — pick one and stick with it

---

> 🔗 Next up: **Chapter Thirteen — Interfaces** → [Read it here](/2025/01/15/golang-series-chapter-thirteen-interfaces.html)
