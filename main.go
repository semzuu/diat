package main

import (
	"fmt"
	"net/http"
	"os"
	"path/filepath"
	"strings"
)

const Port = 6969
const Root = "./www/"

func main() {
  programName := os.Args[0]
  args := os.Args[1:]
  if len(args) != 1 {
    fmt.Printf("<Usage>: %s /path-to-folder\n", programName)
    os.Exit(1)
  }

  path := args[0]

  http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
    var file string
    filePath := r.URL.Path
    file = filepath.Join(Root, filePath)
    if _, err := os.Stat(file); err == nil {
      http.ServeFile(w, r, file)
      return
    }
    file = filepath.Join(path, filePath)
    if _, err := os.Stat(filepath.Join(path, filePath)); err == nil {
      http.ServeFile(w, r, file)
      return
    }
  })

  http.HandleFunc("/slides", func(w http.ResponseWriter, r *http.Request) {
    files, _ := os.ReadDir(path);
    for _, file := range files {
      if strings.HasSuffix(file.Name(), ".md") {
        content, err := os.ReadFile(filepath.Join(path, file.Name()))
        if err == nil {
          w.Header().Set("Content-Type", "text/plain")
          w.Write(content)
          return
        }
      }
    }
    http.Error(w, "No File", http.StatusNotFound)
  })

  fmt.Printf("Serving Diat at http://localhost:%d\n", Port)
  err := http.ListenAndServe(":"+fmt.Sprintf("%d", Port), nil)
  if err != nil {
    fmt.Printf("Error while starting server at port %d\n", Port)
    os.Exit(1)
  }
}
