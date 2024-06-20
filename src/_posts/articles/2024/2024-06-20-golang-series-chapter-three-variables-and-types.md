---
layout: post
title:  "Golang series: Chapter Three - A Complete Guide to use variables"
description: Lets build your own hello world in Go!
tags: golang introduction tutorial
lang: en
# image: 
---

Welcome to the third tutorial in our Golang series! In this part, we’ll dive deep into **variables in Go**, including declaration styles, type inference, shorthand syntax, and some **pro tips** to help you master variable handling in Go.

> 🧠 Missed Part 2? [Check it out here](/2024/06/12/golang-series-chapter-two-hello-world.html) to learn how to install Go and run your first Hello World program.

---

##  What is a Variable?
A **variable** is a named storage in memory that holds a value of a specific **type**. Go is a statically typed language, meaning each variable has a fixed type that cannot change.

---

##  Declaring a Single Variable

```go
var name type
```

### Example
```go
package main
import "fmt"

func main() {
    var age int // declaration without initialization
    fmt.Println("My initial age is", age)
}
```
**Output:**
```
My initial age is 0
```

Go initializes variables with a **zero value** if no value is assigned:
- `int` → 0
- `string` → ""
- `bool` → false
- `pointer` → nil

### Assigning Values Later
```go
package main
import "fmt"

func main() {
    var age int
    fmt.Println("Initial age:", age)
    age = 29
    fmt.Println("Updated age:", age)
    age = 54
    fmt.Println("Second update:", age)
}
```

---

## ✍️ Declaring and Initializing Together
```go
var name type = value
```

### Example
```go
var age int = 29
```

---

## 🤖 Type Inference
Go can **infer the type** from the value:
```go
var age = 29 // Inferred as int
```

---

## 📦 Declaring Multiple Variables
You can declare multiple variables of the same type:
```go
var price, quantity int = 5000, 100
```
Or use type inference:
```go
var price, quantity = 5000, 100
```

### Without Initialization
```go
var price, quantity int
fmt.Println(price, quantity) // Output: 0 0
```

---

## 🧩 Mixed-Type Declaration Block
```go
var (
    name   = "Naveen"
    age    = 38
    height int // zero value
)
```

---

##  Short Hand Declaration
```go
name := value
```
Go infers the type automatically.

### Example
```go
count := 10
```

### Multiple Values
```go
name, age := "Naveen", 29
```

### Gotcha: All values must be initialized
```go
name, age := "Naveen" //  Error: mismatch, only one value
```

### Reusing Variables
```go
a, b := 20, 30
b, c := 40, 50 // c is new, so it’s valid
b, c = 80, 90 // reassign existing variables
```

Invalid if all variables are already declared:
```go
a, b := 20, 30
a, b := 40, 50 //  Error: no new variables
```

---

## Runtime Assignment Example
```go
package main
import (
    "fmt"
    "math"
)

func main() {
    a, b := 145.8, 543.8
    c := math.Min(a, b)
    fmt.Println("Minimum value is", c)
}
```

---

## Type Safety in Go
Go is **strongly typed**. You cannot assign a value of a different type:
```go
age := 29
age = "Naveen" //  Error: cannot use string as int
```

---

##  Bonus: Tips and Tricks for Variables in Go

###  Use Shorthand for Local Variables
Use `:=` when declaring inside functions. It’s cleaner and concise.

```go
message := "Hello Go"
```

###  Group Declarations for Readability
Group related variables using `var ()` blocks:
```go
var (
    username = "admin"
    isAdmin  = true
    id       = 101
)
```

###  Swap Variables Without Temp
Go supports value swapping out of the box:
```go
a, b := 1, 2
a, b = b, a
```

###  Check Zero Values Intelligently
Zero values can help reduce code if you know what to expect:
```go
var str string // ""
var n int      // 0
if str == "" && n == 0 {
    fmt.Println("Defaults confirmed")
}
```

###  Use Constants When Values Don't Change
Use `const` for unchanging values:
```go
const pi = 3.14
```

###  Declare But Don’t Use? Go Will Complain
Unused variables will cause compile-time errors. This encourages cleaner code.
```go
var unused string //  Error if not used
```

---

##  What’s Next?
In the next tutorial, we’ll explore **data types in Go**, including numeric types, strings, booleans, and complex types like arrays and structs.

Stay tuned and keep coding with Go! 

> If this was helpful, share it with your dev circle on Twitter or LinkedIn!

