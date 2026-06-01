---
layout: post
title:  "Golang series: Chapter Five - Functions in Go"
description: Learn how Go functions work, from basics to multiple return values and variadic parameters.
tags: golang functions tutorial
lang: en
---

# Functions in Go: The Building Blocks of Every Program

Hey everyone! Welcome back to the Go series. By now you know how to declare variables, use constants, and write a basic program. Today we're stepping things up with **functions** — the core building blocks of any Go application.

> 🧠 Missed Chapter 4? [Check it out here](/2024/07/03/golang-series-chapter-four-constants.html) to learn about constants before diving into functions.

---

## What Is a Function?

A **function** is a named, reusable block of code that performs a specific task. In Go, functions are first-class citizens — they can be passed around, assigned to variables, and returned from other functions.

---

## Declaring a Function

The basic syntax is simple:

```go
func functionName(parameters) returnType {
    // body
}
```

### Your First Function

```go
package main

import "fmt"

func greet(name string) {
    fmt.Println("Hello,", name)
}

func main() {
    greet("Celso")
    greet("Gopher")
}
```

**Output:**
```
Hello, Celso
Hello, Gopher
```

---

## Functions with Return Values

Functions can return values using the `return` keyword:

```go
package main

import "fmt"

func add(a int, b int) int {
    return a + b
}

func main() {
    result := add(10, 5)
    fmt.Println("Sum:", result)
}
```

**Output:**
```
Sum: 15
```

### Shorthand for Same-Type Parameters

When consecutive parameters share the same type, you can declare them together:

```go
func add(a, b int) int {
    return a + b
}
```

---

## Multiple Return Values

This is one of Go's most loved features. Functions can return **more than one value**:

```go
package main

import "fmt"

func divide(a, b float64) (float64, error) {
    if b == 0 {
        return 0, fmt.Errorf("cannot divide by zero")
    }
    return a / b, nil
}

func main() {
    result, err := divide(10, 3)
    if err != nil {
        fmt.Println("Error:", err)
        return
    }
    fmt.Printf("Result: %.2f\n", result)
}
```

**Output:**
```
Result: 3.33
```

This pattern — returning a result and an `error` — is the standard way Go handles errors. You'll see it everywhere in production code.

---

## Named Return Values

Go allows you to name return values in the function signature. They act as pre-declared variables and can be returned with a bare `return`:

```go
package main

import "fmt"

func minMax(nums []int) (min, max int) {
    min, max = nums[0], nums[0]
    for _, v := range nums {
        if v < min {
            min = v
        }
        if v > max {
            max = v
        }
    }
    return // bare return
}

func main() {
    min, max := minMax([]int{3, 1, 9, 4, 7})
    fmt.Println("Min:", min, "| Max:", max)
}
```

**Output:**
```
Min: 1 | Max: 9
```

> ⚠️ Use named returns sparingly. They improve readability in short functions but can make longer ones confusing.

---

## Variadic Functions

A **variadic function** accepts a variable number of arguments. You've already used one: `fmt.Println`!

```go
package main

import "fmt"

func sum(nums ...int) int {
    total := 0
    for _, n := range nums {
        total += n
    }
    return total
}

func main() {
    fmt.Println(sum(1, 2))
    fmt.Println(sum(1, 2, 3, 4, 5))
}
```

**Output:**
```
3
15
```

### Spreading a Slice into a Variadic Function

```go
numbers := []int{10, 20, 30}
fmt.Println(sum(numbers...)) // spread with ...
```

**Output:**
```
60
```

---

## Functions as Values

In Go, functions are values. You can store them in variables and pass them around:

```go
package main

import "fmt"

func apply(operation func(int, int) int, a, b int) int {
    return operation(a, b)
}

func main() {
    multiply := func(a, b int) int {
        return a * b
    }

    fmt.Println(apply(multiply, 4, 5))
}
```

**Output:**
```
20
```

---

## Anonymous Functions (Closures)

Functions without a name, defined inline:

```go
package main

import "fmt"

func main() {
    square := func(n int) int {
        return n * n
    }

    fmt.Println(square(6))
}
```

**Output:**
```
36
```

Closures can also capture variables from their surrounding scope — a powerful pattern for things like callbacks and middleware.

---

## Quick Reference

- ✅ `func name(params) returnType {}` — basic function
- ✅ `func name(a, b int) (int, error) {}` — multiple returns
- ✅ `func name(nums ...int) {}` — variadic
- ✅ `func(params) returnType {}` — anonymous function
- ⚠️ Bare `return` only makes sense with named return values

---

> 🔗 Next up: **Chapter Six — Control Flow: if, else & switch** → [Read it here](/2024/08/10/golang-series-chapter-six-control-flow.html)
