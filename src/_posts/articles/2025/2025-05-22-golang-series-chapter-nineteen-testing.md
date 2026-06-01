---
layout: post
title:  "Golang series: Chapter Nineteen - Testing in Go"
description: Go has testing built in. Learn how to write unit tests, table-driven tests, and benchmarks with the standard testing package.
tags: golang testing tutorial
lang: en
---

# Testing in Go: Built In and Battle-Tested

Testing in Go is not an afterthought — it's a first-class citizen of the language. There's no need to install a testing framework. No configuration files. Just write a function that starts with `Test`, and run `go test`.

At Globo we run tests on every pull request, and Go's built-in tooling makes it incredibly easy to write fast, reliable tests. Let me show you how.

> 🧠 Missed Chapter 18? [Check it out here](/2025/05/01/golang-series-chapter-eighteen-packages-and-modules.html) to understand packages first — tests live in the same package as the code they test.

---

## The testing Package

The `testing` package from the standard library provides everything you need. No `import "github.com/..."` required.

---

## Writing Your First Test

Test files must end with `_test.go`. Test functions must start with `Test` and accept `*testing.T`:

**math.go:**
```go
package math

func Add(a, b int) int {
    return a + b
}

func Divide(a, b float64) (float64, error) {
    if b == 0 {
        return 0, fmt.Errorf("cannot divide by zero")
    }
    return a / b, nil
}
```

**math_test.go:**
```go
package math

import "testing"

func TestAdd(t *testing.T) {
    result := Add(2, 3)
    expected := 5

    if result != expected {
        t.Errorf("Add(2, 3) = %d; want %d", result, expected)
    }
}
```

### Running Tests

```bash
go test ./...
```

**Output:**
```
ok      myproject/math    0.003s
```

---

## t.Fatal vs t.Error

- `t.Error(msg)` — marks the test as failed but continues execution
- `t.Fatal(msg)` — marks the test as failed and **stops** the current test immediately

```go
func TestDivide(t *testing.T) {
    result, err := Divide(10, 2)
    if err != nil {
        t.Fatalf("unexpected error: %v", err) // stop if error
    }
    if result != 5.0 {
        t.Errorf("Divide(10, 2) = %f; want 5.0", result)
    }
}
```

---

## Table-Driven Tests

This is the most idiomatic Go testing pattern. Define all your test cases as a slice of structs and loop over them:

```go
package math

import "testing"

func TestAddTableDriven(t *testing.T) {
    tests := []struct {
        name     string
        a, b     int
        expected int
    }{
        {"positive numbers", 2, 3, 5},
        {"with zero", 0, 5, 5},
        {"negative numbers", -1, -2, -3},
        {"mixed signs", -5, 10, 5},
    }

    for _, tc := range tests {
        t.Run(tc.name, func(t *testing.T) {
            result := Add(tc.a, tc.b)
            if result != tc.expected {
                t.Errorf("Add(%d, %d) = %d; want %d", tc.a, tc.b, result, tc.expected)
            }
        })
    }
}
```

**Output:**
```
--- PASS: TestAddTableDriven (0.00s)
    --- PASS: TestAddTableDriven/positive_numbers (0.00s)
    --- PASS: TestAddTableDriven/with_zero (0.00s)
    --- PASS: TestAddTableDriven/negative_numbers (0.00s)
    --- PASS: TestAddTableDriven/mixed_signs (0.00s)
PASS
```

`t.Run` creates subtests — each case gets its own name, making failures easy to identify.

---

## Testing Errors

When your function returns an error, test both the success and failure paths:

```go
func TestDivideErrors(t *testing.T) {
    tests := []struct {
        name      string
        a, b      float64
        wantErr   bool
        wantResult float64
    }{
        {"valid division", 10, 2, false, 5.0},
        {"divide by zero", 5, 0, true, 0},
    }

    for _, tc := range tests {
        t.Run(tc.name, func(t *testing.T) {
            result, err := Divide(tc.a, tc.b)
            if (err != nil) != tc.wantErr {
                t.Errorf("wantErr=%v, got err=%v", tc.wantErr, err)
                return
            }
            if !tc.wantErr && result != tc.wantResult {
                t.Errorf("got %f; want %f", result, tc.wantResult)
            }
        })
    }
}
```

---

## Useful go test Flags

```bash
go test ./...              # run all tests
go test -v ./...           # verbose output (see each test name)
go test -run TestAdd ./... # run only tests matching "TestAdd"
go test -count=1 ./...     # disable test caching
go test -race ./...        # enable race detector
go test -cover ./...       # show code coverage percentage
go test -coverprofile=coverage.out ./... && go tool cover -html=coverage.out
```

---

## Benchmarks

The `testing` package also supports benchmarks. Benchmark functions start with `Bench` and receive `*testing.B`:

```go
func BenchmarkAdd(b *testing.B) {
    for i := 0; i < b.N; i++ {
        Add(10, 20)
    }
}
```

Run benchmarks:

```bash
go test -bench=. ./...
```

**Output:**
```
BenchmarkAdd-8    1000000000    0.2757 ns/op
```

`b.N` is automatically adjusted by the framework until the benchmark produces a stable result.

---

## Test Helpers

Extract repeated setup into helper functions and call `t.Helper()` so error lines point to the call site, not the helper:

```go
func assertEqual(t *testing.T, got, want int) {
    t.Helper()
    if got != want {
        t.Errorf("got %d; want %d", got, want)
    }
}

func TestAddHelper(t *testing.T) {
    assertEqual(t, Add(2, 3), 5)
    assertEqual(t, Add(-1, 1), 0)
}
```

---

## Quick Reference

- ✅ Test files end in `_test.go`
- ✅ Test functions: `func TestXxx(t *testing.T)`
- ✅ `t.Error` / `t.Errorf` — fail, continue
- ✅ `t.Fatal` / `t.Fatalf` — fail, stop test
- ✅ `t.Run("name", func(t *testing.T) {})` — subtests
- ✅ Table-driven tests — the idiomatic Go pattern
- ✅ `go test -v -cover -race ./...` — most useful flags
- ✅ `func BenchmarkXxx(b *testing.B)` — for performance testing

---

> 🔗 Final chapter: **Chapter Twenty — Final Project: Building a REST API** → [Read it here](/2025/06/12/golang-series-chapter-twenty-final-project-rest-api.html)
