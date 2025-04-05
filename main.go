package main

import (
	"flag"
	"fmt"

	"github.com/joho/godotenv"
)

func main() {
	startupRun := flag.Bool("startup", false, "Run startup script")

	flag.Parse()

	fmt.Println(*startupRun)

	err := godotenv.Load(".env")
	if err != nil {
		panic(err)
	}

	
}
