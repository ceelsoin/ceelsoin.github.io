---
layout: post
title:  "Golang series: Chapter Two - Writing and Running Your First Go Program (Hello World)"
description: Lets build your own hello world in Go!
tags: golang introduction tutorial
lang: en
# image: 
---
# Golang Tutorial Part 2: Writing and Running Your First Go Program

Welcome to the second installment of our Go tutorial series! If you haven’t yet read [Part 1: Introduction and Installation](/2024/06/02/golang-series-chapter-one-installation.html), we highly recommend starting there to learn what Go is and how to install it on your system.

Now, let’s get hands-on and write your very first Go program.

---

## How to Set Up Your Go Development Environment

Start by creating a directory for your Hello World program. Open your terminal and run:

```bash
mkdir ~/golang-hello
```

This creates a folder named `golang-hello` in your home directory. You can use another location if preferred.

---

## Initializing a Go Module

Navigate into your new directory and initialize a Go module. Modules help manage dependencies in Go projects.

```bash
cd ~/golang-hello
go mod init module-hello
```

Expected output:

```
go: creating new go.mod: module module-hello
```

Your `go.mod` file should contain:

```go
module module-hello

go 1.21.0
```

This defines the module name and the Go version.

---

## Writing Your First Go Program

Inside the `golang-hello` directory, create a new file named `main.go` and add the following code:

```go
package main

import "fmt"

func main() {
	fmt.Println("Hello World")
}
```

This is the standard structure for a simple Go program.

---

## How to Run a Go Program

There are multiple ways to execute your Go code. Let’s explore the most common options.

### 1. Using `go install`

```bash
cd ~/golang-hello
go install
```

If you see an error such as:

```
go install: no install location for directory ... outside GOPATH
```

Set the `GOBIN` environment variable:

```bash
export GOBIN=~/go/bin/
```

Then run:

```bash
go install
```

Now execute the binary:

```bash
~/go/bin/module-hello
```

Output:

```
Hello World
```

Add this to your shell’s PATH for easier access:

```bash
export PATH=$PATH:~/go/bin
```

Now you can just type:

```bash
module-hello
```

### 2. Using `go build`

This method compiles the code and outputs a binary in the current directory:

```bash
cd ~/golang-hello
go build
./module-hello
```

Output:

```
Hello World
```

### 3. Using `go run`

This is the quickest way to run your code during development:

```bash
cd ~/golang-hello
go run main.go
```

Output:

```
Hello World
```

To view the temporary build directory:

```bash
go run --work main.go
```

Sample output:

```
WORK=/tmp/go-build199689936
Hello World
```

### 4. Using Go Playground

[Go Playground](https://go.dev/play/) is an online environment where you can write, run, and share Go code. Try the Hello World example there!

---

## Which Go Run Method Should You Use?

- **Go Playground**: Best for sharing or testing small snippets.
- **go run**: Perfect for rapid development and debugging.
- **go build**: Great when you want a local binary for testing.
- **go install**: Ideal for globally installing CLI tools.

---

## Breakdown of the `main.go` File

```go
package main

import "fmt"

func main() {
	fmt.Println("Hello World")
}
```

- `package main`: Defines the entry point of your application.
- `import "fmt"`: Imports Go’s standard formatting and I/O library.
- `func main()`: The main function where execution starts.
- `fmt.Println(...)`: Prints a line to the console.

---

## What’s Next in the Go Tutorial Series?

In the next chapter, we’ll explore **variables in Go**, covering how to declare, assign, and use them effectively.

Stay tuned and happy coding! 🚀


