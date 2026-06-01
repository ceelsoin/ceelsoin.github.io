---
layout: post
title:  "Golang series: Chapter Twenty - Final Project: Building a REST API"
description: Put everything together — build a complete REST API in Go using only the standard library.
tags: golang rest-api http tutorial
lang: en
---

# Final Project: Building a REST API in Go

We made it! This is the final chapter of the Golang series, and we're going to put everything we've learned together into something real: a **REST API** built with Go's standard library — no external frameworks needed.

If you've followed along from Chapter 1, you now have everything you need to write production-quality Go. Let's use it.

> 🧠 Missed Chapter 19? [Check it out here](/2025/05/22/golang-series-chapter-nineteen-testing.html) — testing is part of what we'll build today.

---

## What We're Building

A simple **Task Manager API** with full CRUD:

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/tasks` | List all tasks |
| `GET` | `/tasks/{id}` | Get a specific task |
| `POST` | `/tasks` | Create a new task |
| `PUT` | `/tasks/{id}` | Update a task |
| `DELETE` | `/tasks/{id}` | Delete a task |

---

## Project Structure

```
taskapi/
  go.mod
  main.go
  task/
    task.go
    store.go
    handler.go
  task/
    handler_test.go
```

---

## Step 1: The Task Model

**task/task.go:**
```go
package task

import "time"

type Task struct {
    ID        int       `json:"id"`
    Title     string    `json:"title"`
    Done      bool      `json:"done"`
    CreatedAt time.Time `json:"created_at"`
}
```

---

## Step 2: In-Memory Store

**task/store.go:**
```go
package task

import (
    "errors"
    "sync"
    "time"
)

var ErrNotFound = errors.New("task not found")

type Store struct {
    mu     sync.RWMutex
    tasks  map[int]Task
    nextID int
}

func NewStore() *Store {
    return &Store{
        tasks:  make(map[int]Task),
        nextID: 1,
    }
}

func (s *Store) Create(title string) Task {
    s.mu.Lock()
    defer s.mu.Unlock()

    t := Task{ID: s.nextID, Title: title, CreatedAt: time.Now()}
    s.tasks[s.nextID] = t
    s.nextID++
    return t
}

func (s *Store) GetAll() []Task {
    s.mu.RLock()
    defer s.mu.RUnlock()

    tasks := make([]Task, 0, len(s.tasks))
    for _, t := range s.tasks {
        tasks = append(tasks, t)
    }
    return tasks
}

func (s *Store) GetByID(id int) (Task, error) {
    s.mu.RLock()
    defer s.mu.RUnlock()

    t, ok := s.tasks[id]
    if !ok {
        return Task{}, ErrNotFound
    }
    return t, nil
}

func (s *Store) Update(id int, title string, done bool) (Task, error) {
    s.mu.Lock()
    defer s.mu.Unlock()

    t, ok := s.tasks[id]
    if !ok {
        return Task{}, ErrNotFound
    }

    t.Title = title
    t.Done = done
    s.tasks[id] = t
    return t, nil
}

func (s *Store) Delete(id int) error {
    s.mu.Lock()
    defer s.mu.Unlock()

    if _, ok := s.tasks[id]; !ok {
        return ErrNotFound
    }
    delete(s.tasks, id)
    return nil
}
```

Notice:
- **`sync.RWMutex`** — allows multiple concurrent reads, exclusive writes
- **`defer s.mu.Unlock()`** — ensures we never forget to unlock

---

## Step 3: HTTP Handlers

**task/handler.go:**
```go
package task

import (
    "encoding/json"
    "errors"
    "net/http"
    "strconv"
    "strings"
)

type Handler struct {
    store *Store
}

func NewHandler(store *Store) *Handler {
    return &Handler{store: store}
}

func (h *Handler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
    // Route: /tasks or /tasks/{id}
    parts := strings.Split(strings.Trim(r.URL.Path, "/"), "/")

    if len(parts) == 1 && parts[0] == "tasks" {
        switch r.Method {
        case http.MethodGet:
            h.listTasks(w, r)
        case http.MethodPost:
            h.createTask(w, r)
        default:
            http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
        }
        return
    }

    if len(parts) == 2 && parts[0] == "tasks" {
        id, err := strconv.Atoi(parts[1])
        if err != nil {
            http.Error(w, "Invalid task ID", http.StatusBadRequest)
            return
        }
        switch r.Method {
        case http.MethodGet:
            h.getTask(w, r, id)
        case http.MethodPut:
            h.updateTask(w, r, id)
        case http.MethodDelete:
            h.deleteTask(w, r, id)
        default:
            http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
        }
        return
    }

    http.NotFound(w, r)
}

func (h *Handler) listTasks(w http.ResponseWriter, r *http.Request) {
    tasks := h.store.GetAll()
    writeJSON(w, http.StatusOK, tasks)
}

func (h *Handler) createTask(w http.ResponseWriter, r *http.Request) {
    var body struct {
        Title string `json:"title"`
    }
    if err := json.NewDecoder(r.Body).Decode(&body); err != nil || body.Title == "" {
        http.Error(w, "Invalid request body", http.StatusBadRequest)
        return
    }
    t := h.store.Create(body.Title)
    writeJSON(w, http.StatusCreated, t)
}

func (h *Handler) getTask(w http.ResponseWriter, r *http.Request, id int) {
    t, err := h.store.GetByID(id)
    if errors.Is(err, ErrNotFound) {
        http.Error(w, "Task not found", http.StatusNotFound)
        return
    }
    writeJSON(w, http.StatusOK, t)
}

func (h *Handler) updateTask(w http.ResponseWriter, r *http.Request, id int) {
    var body struct {
        Title string `json:"title"`
        Done  bool   `json:"done"`
    }
    if err := json.NewDecoder(r.Body).Decode(&body); err != nil {
        http.Error(w, "Invalid request body", http.StatusBadRequest)
        return
    }
    t, err := h.store.Update(id, body.Title, body.Done)
    if errors.Is(err, ErrNotFound) {
        http.Error(w, "Task not found", http.StatusNotFound)
        return
    }
    writeJSON(w, http.StatusOK, t)
}

func (h *Handler) deleteTask(w http.ResponseWriter, r *http.Request, id int) {
    if err := h.store.Delete(id); errors.Is(err, ErrNotFound) {
        http.Error(w, "Task not found", http.StatusNotFound)
        return
    }
    w.WriteHeader(http.StatusNoContent)
}

func writeJSON(w http.ResponseWriter, status int, v any) {
    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(status)
    json.NewEncoder(w).Encode(v)
}
```

---

## Step 4: main.go

```go
package main

import (
    "fmt"
    "log"
    "net/http"

    "taskapi/task"
)

func main() {
    store := task.NewStore()
    handler := task.NewHandler(store)

    mux := http.NewServeMux()
    mux.Handle("/tasks", handler)
    mux.Handle("/tasks/", handler)

    addr := ":8080"
    fmt.Println("Task API running on", addr)
    log.Fatal(http.ListenAndServe(addr, mux))
}
```

---

## Step 5: Run It

```bash
go mod init taskapi
go run main.go
```

```
Task API running on :8080
```

### Test with curl

```bash
# Create a task
curl -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "Learn Go"}'

# List all tasks
curl http://localhost:8080/tasks

# Get one task
curl http://localhost:8080/tasks/1

# Update a task
curl -X PUT http://localhost:8080/tasks/1 \
  -H "Content-Type: application/json" \
  -d '{"title": "Learn Go", "done": true}'

# Delete a task
curl -X DELETE http://localhost:8080/tasks/1
```

---

## What We Used From This Series

| Concept | Where |
|---|---|
| Structs & tags | `Task` model, JSON encoding |
| Maps | In-memory store |
| Methods | Store and Handler methods |
| Pointers | Passing `*Store` and `*Handler` |
| Interfaces | `http.Handler` |
| Error handling | `ErrNotFound`, `errors.Is` |
| Defer | `defer s.mu.Unlock()` |
| Goroutines & sync | `sync.RWMutex` for concurrent access |
| Packages & modules | `task` package, `go.mod` |

---

## What's Next?

This is the end of the foundation series, but there's so much more to explore:

- 🗄️ Connecting to a real database (PostgreSQL with `pgx` or `database/sql`)
- 🔐 Adding authentication (JWT, sessions)
- ⚙️ Configuration management
- 🧪 Integration tests with `httptest`
- 🚀 Deploying on Cloud Run, Fly.io, or a Linux VPS
- 📦 Using a router like `chi` or `gorilla/mux` for cleaner routing

Thank you for following along! If you have questions, drop them in the comments below. See you in the next series. 🐹

---

> 🔗 Missed any chapter? [Start from Chapter One](/2024/06/02/golang-series-chapter-one-installation.html) and follow the full journey.
