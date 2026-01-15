package main

import (
	"fmt"
	"os"

	"github.com/phamminhkhoa2k4/khoata-tool/internal/auth"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage: ag-quota <command>")
		fmt.Println("Commands:")
		fmt.Println("  login   - Login with Google account")
		fmt.Println("  status  - Check login status")
		fmt.Println("  logout  - Logout current account")
		return
	}

	command := os.Args[1]

	switch command {
	case "login":
		fmt.Println("Starting login flow...")
		if err := auth.Login(); err != nil {
			fmt.Printf("Login failed: %v\n", err)
			os.Exit(1)
		}
	case "status":
		token, err := auth.LoadToken()
		if err != nil {
			fmt.Printf("Not logged in: %v\n", err)
			os.Exit(1)
		}
		fmt.Printf("Logged in as: %s\n", token.Email)
		if token.IsValid() {
			fmt.Println("Token status: Valid")
		} else {
			fmt.Println("Token status: Expired")
		}
	case "logout":
		if err := auth.DeleteToken(); err != nil {
			fmt.Printf("Logout failed: %v\n", err)
			os.Exit(1)
		}
		fmt.Println("Logged out successfully")
	default:
		fmt.Printf("Unknown command: %s\n", command)
		os.Exit(1)
	}
}
