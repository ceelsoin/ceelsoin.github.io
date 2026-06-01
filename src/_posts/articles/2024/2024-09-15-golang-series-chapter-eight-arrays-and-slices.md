---
layout: post
title:  "Golang series: Chapter Eight - Arrays & Slices"
description: Understand the difference between arrays and slices in Go, and learn how to work with dynamic collections.
tags: golang arrays slices tutorial
lang: en
---

# Arrays & Slices in Go

Let's talk about collections. In Go, there are two closely related ways to store sequences of elements: **arrays** and **slices**. Understanding the difference between them is one of the most important steps to writing idiomatic Go.

Spoiler: you'll use slices almost exclusively. But understanding arrays first makes everything click.

> 🧠 Missed Chapter 7? [Check it out here](/2024/08/28/golang-series-chapter-seven-loops.html) to learn about loops before we iterate over collections.

---

## Arrays

An **array** in Go has a **fixed size**, defined at compile time. The size is part of its type — `[3]int` and `[5]int` are different types.

```go
package main

import "fmt"

func main() {
    var scores [3]int
    scores[0] = 90
    scores[1] = 85
    scores[2] = 92

    fmt.Println(scores)
    fmt.Println("Length:", len(scores))
}
```

**Output:**
```
[90 85 92]
Length: 3
```

### Array Literal

```go
primes := [5]int{2, 3, 5, 7, 11}
fmt.Println(primes)
```

**Output:**
```
[2 3 5 7 11]
```

### Let Go Count the Size

Use `...` to let the compiler count the elements:

```go
fruits := [...]string{"apple", "banana", "cherry"}
fmt.Println(len(fruits)) // 3
```

### Arrays Are Values

In Go, arrays are **value types**. When you assign or pass an array, a full copy is made:

```go
a := [3]int{1, 2, 3}
b := a       // b is a copy
b[0] = 99
fmt.Println(a) // [1 2 3] — a is unchanged
fmt.Println(b) // [99 2 3]
```

---

## Slices

A **slice** is a dynamic, flexible view into an array. It has no fixed size and can grow or shrink. In practice, slices are what you'll use every day.

### Declaring a Slice

```go
package main

import "fmt"

func main() {
    var nums []int // nil slice — zero value
    fmt.Println(nums)
    fmt.Println(len(nums), cap(nums))
}
```

**Output:**
```
[]
0 0
```

### Slice Literal

```go
langs := []string{"Go", "Python", "Rust"}
fmt.Println(langs)
```

**Output:**
```
[Go Python Rust]
```

### make

Use `make` to create a slice with a specific length and optional capacity:

```go
s := make([]int, 3, 5) // len=3, cap=5
fmt.Println(s)
fmt.Println(len(s), cap(s))
```

**Output:**
```
[0 0 0]
3 5
```

---

## Appending to a Slice

`append` returns a new slice with the element(s) added:

```go
package main

import "fmt"

func main() {
    fruits := []string{"apple", "banana"}
    fruits = append(fruits, "cherry")
    fruits = append(fruits, "date", "elderberry")

    fmt.Println(fruits)
}
```

**Output:**
```
[apple banana cherry date elderberry]
```

> Always reassign the result: `s = append(s, ...)`. `append` may allocate a new underlying array when capacity is exceeded.

---

## Slicing a Slice

You can extract a sub-slice using the `[low:high]` notation:

```go
package main

import "fmt"

func main() {
    nums := []int{10, 20, 30, 40, 50}

    fmt.Println(nums[1:3]) // index 1 up to (not including) 3
    fmt.Println(nums[:2])  // from start up to index 2
    fmt.Println(nums[3:])  // from index 3 to end
    fmt.Println(nums[:])   // full slice
}
```

**Output:**
```
[20 30]
[10 20]
[40 50]
[10 20 30 40 50]
```

> ⚠️ Sub-slices share the same underlying array as the original. Modifying one affects the other.

---

## Copying a Slice

Use `copy` to make an independent copy:

```go
package main

import "fmt"

func main() {
    original := []int{1, 2, 3}
    clone := make([]int, len(original))
    copy(clone, original)

    clone[0] = 99
    fmt.Println("Original:", original)
    fmt.Println("Clone:", clone)
}
```

**Output:**
```
Original: [1 2 3]
Clone: [99 2 3]
```

---

## Iterating with range

```go
package main

import "fmt"

func main() {
    scores := []int{88, 92, 76, 95}

    total := 0
    for _, s := range scores {
        total += s
    }

    fmt.Printf("Average: %.1f\n", float64(total)/float64(len(scores)))
}
```

**Output:**
```
Average: 87.8
```

---

## nil vs Empty Slice

```go
var s1 []int          // nil slice
s2 := []int{}         // empty slice (not nil)
s3 := make([]int, 0)  // also empty

fmt.Println(s1 == nil) // true
fmt.Println(s2 == nil) // false
fmt.Println(s3 == nil) // false
```

Both `len(s1)` and `len(s2)` are `0`. In most cases they behave the same, but `nil` checks matter when dealing with JSON encoding or API responses.

---

## Quick Reference

| Feature | Array | Slice |
|---|---|---|
| Size | Fixed at compile time | Dynamic |
| Type includes size | Yes (`[3]int`) | No (`[]int`) |
| Value or reference | Value (copy on assign) | Reference to underlying array |
| Can `append`? | No | Yes |
| When to use | Rarely, fixed-size data | Almost always |

---

> 🔗 Next up: **Chapter Nine — Maps** → [Read it here](/2024/10/05/golang-series-chapter-nine-maps.html)
