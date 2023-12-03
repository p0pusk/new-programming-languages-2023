package main

import (
	"fmt"
	"os"
	"path/filepath"
	"time"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: go run watcher.go /path/to/watched/directory")
		return
	}

	path := os.Args[1]

	// Map to store the last modification time for each file
	lastModified := make(map[string]time.Time)

	// Initial scan to record the current modification times
	err := filepath.Walk(path, func(filePath string, fileInfo os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		// Skip directories for simplicity
		if !fileInfo.IsDir() {
			lastModified[filePath] = fileInfo.ModTime()
		}

		return nil
	})

	if err != nil {
		fmt.Println("Error walking path:", err)
		return
	}

	fmt.Println("Watching for file changes in:", path)

	for {
		// Periodically check for file modifications
		time.Sleep(time.Second)

		err := filepath.Walk(path, func(filePath string, fileInfo os.FileInfo, err error) error {
			if err != nil {
				return err
			}

			// Skip directories for simplicity
			if !fileInfo.IsDir() {
				lastModTime, ok := lastModified[filePath]
				if !ok {
					// New file, record its modification time
					lastModified[filePath] = fileInfo.ModTime()
				} else if fileInfo.ModTime() != lastModTime {
					// File has been modified
					fmt.Println("File modified:", filePath)
					lastModified[filePath] = fileInfo.ModTime()
				}
			}

			return nil
		})
		if err != nil {
			fmt.Println("Error walking path:", err)
			return
		}
	}
}
