package main

import (
	"fmt"
	"net/http"
)

func helloWorld(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Testing change in hello world!")
}

func main() {
	fmt.Println("Starting Hello World")
	http.HandleFunc("/", helloWorld)
	http.ListenAndServe(":8090", nil)
}
