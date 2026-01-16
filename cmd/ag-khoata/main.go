package main

import (
	"fmt"
	"os"

	"github.com/fatih/color"
	"github.com/phamminhkhoa2k4/khoata-tool/internal/api"
	"github.com/phamminhkhoa2k4/khoata-tool/internal/auth"
	"github.com/phamminhkhoa2k4/khoata-tool/internal/ui"
	"github.com/spf13/cobra"
)

var (
	Version    = "1.0.0"
	BuildTime  = "unknown"
	jsonOutput bool
)

func main() {
	rootCmd := &cobra.Command{
		Use:   "ag-khoata",
		Short: "Check Anti-Gravity (Claude Code) quota and usage",
		Long:  "A CLI tool to monitor your Anti-Gravity AI model quota and usage in real-time.",
		Run: func(cmd *cobra.Command, args []string) {
			runQuota(cmd, args)
		},
	}

	// Global flags
	rootCmd.PersistentFlags().BoolVarP(&jsonOutput, "json", "j", false, "Output in JSON format")

	// Login command
	loginCmd := &cobra.Command{
		Use:   "login",
		Short: "Login with Google account",
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Println("Starting login flow...")
			if err := auth.Login(); err != nil {
				ui.DisplayError("Login failed", err)
				os.Exit(1)
			}
		},
	}

	// Logout command
	logoutCmd := &cobra.Command{
		Use:   "logout",
		Short: "Logout current account",
		Run: func(cmd *cobra.Command, args []string) {
			if err := auth.DeleteToken(); err != nil {
				ui.DisplayError("Logout failed", err)
				os.Exit(1)
			}
			ui.DisplaySuccess("Logged out successfully")
		},
	}

	// Status command
	statusCmd := &cobra.Command{
		Use:   "status",
		Short: "Check authentication status",
		Run: func(cmd *cobra.Command, args []string) {
			token, err := auth.LoadToken()
			if err != nil {
				ui.DisplayNotLoggedIn()
				os.Exit(1)
			}

			fmt.Println()
			color.Cyan("Authentication Status")
			fmt.Println("====================")
			fmt.Println()

			if token.IsValid() {
				color.Green("✓ Logged in as: %s", token.Email)
				color.Green("✓ Token status: Valid")
			} else {
				color.Yellow("⚠ Logged in as: %s", token.Email)
				color.Yellow("⚠ Token status: Expired (will auto-refresh)")
			}
			fmt.Println()
		},
	}

	// Quota command
	quotaCmd := &cobra.Command{
		Use:   "quota",
		Short: "Check quota for all models",
		Run:   runQuota,
	}

	// Accounts parent command
	accountsCmd := &cobra.Command{
		Use:   "accounts",
		Short: "Manage saved accounts",
	}

	// Accounts list subcommand
	accountsListCmd := &cobra.Command{
		Use:   "list",
		Short: "List all saved accounts",
		Run: func(cmd *cobra.Command, args []string) {
			mgr, err := auth.NewAccountManager()
			if err != nil {
				ui.DisplayError("Failed to initialize account manager", err)
				os.Exit(1)
			}

			accounts, err := mgr.ListAccounts()
			if err != nil {
				ui.DisplayError("Failed to list accounts", err)
				os.Exit(1)
			}

			if len(accounts) == 0 {
				fmt.Println("No accounts saved. Run 'ag-khoata login' to add one.")
				return
			}

			fmt.Println()
			color.Cyan("Saved Accounts")
			fmt.Println("==============")
			fmt.Println()

			for _, acc := range accounts {
				prefix := "  "
				if acc.IsDefault {
					prefix = "* "
				}

				status := color.GreenString("valid")
				if !acc.TokenValid {
					status = color.YellowString("expired")
				}

				fmt.Printf("%s%s (%s)\n", prefix, acc.Email, status)
			}
			fmt.Println()
			fmt.Println("* = default account")
			fmt.Println()
		},
	}

	// Accounts switch subcommand
	accountsSwitchCmd := &cobra.Command{
		Use:   "switch [email]",
		Short: "Switch default account",
		Args:  cobra.ExactArgs(1),
		Run: func(cmd *cobra.Command, args []string) {
			email := args[0]
			mgr, err := auth.NewAccountManager()
			if err != nil {
				ui.DisplayError("Failed to initialize account manager", err)
				os.Exit(1)
			}

			if err := mgr.SetDefaultAccount(email); err != nil {
				ui.DisplayError("Failed to switch account", err)
				os.Exit(1)
			}

			ui.DisplaySuccess(fmt.Sprintf("Switched to %s", email))
		},
	}

	// Accounts remove subcommand
	accountsRemoveCmd := &cobra.Command{
		Use:   "remove [email]",
		Short: "Remove a saved account",
		Args:  cobra.ExactArgs(1),
		Run: func(cmd *cobra.Command, args []string) {
			email := args[0]
			mgr, err := auth.NewAccountManager()
			if err != nil {
				ui.DisplayError("Failed to initialize account manager", err)
				os.Exit(1)
			}

			if err := mgr.RemoveAccount(email); err != nil {
				ui.DisplayError("Failed to remove account", err)
				os.Exit(1)
			}

			ui.DisplaySuccess(fmt.Sprintf("Removed %s", email))
		},
	}

	// Version command
	versionCmd := &cobra.Command{
		Use:   "version",
		Short: "Show version information",
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Printf("ag-khoata version %s\n", Version)
			fmt.Printf("Build time: %s\n", BuildTime)
		},
	}

	// Add subcommands
	accountsCmd.AddCommand(accountsListCmd)
	accountsCmd.AddCommand(accountsSwitchCmd)
	accountsCmd.AddCommand(accountsRemoveCmd)

	rootCmd.AddCommand(loginCmd)
	rootCmd.AddCommand(logoutCmd)
	rootCmd.AddCommand(statusCmd)
	rootCmd.AddCommand(quotaCmd)
	rootCmd.AddCommand(accountsCmd)
	rootCmd.AddCommand(versionCmd)

	if err := rootCmd.Execute(); err != nil {
		os.Exit(1)
	}
}

func runQuota(cmd *cobra.Command, args []string) {
	// Check if logged in
	token, err := auth.LoadToken()
	if err != nil {
		ui.DisplayNotLoggedIn()
		os.Exit(1)
	}

	// Create API client
	client := api.NewClient()

	// Get quota info
	fmt.Printf("Fetching quota for %s...\n", token.Email)
	quotaSummary, err := client.GetQuotaInfo()
	if err != nil {
		ui.DisplayError("Failed to fetch quota", err)
		os.Exit(1)
	}

	// Display results
	if jsonOutput {
		if err := ui.DisplayQuotaSummaryJSON(quotaSummary); err != nil {
			ui.DisplayError("Failed to display JSON", err)
			os.Exit(1)
		}
	} else {
		ui.DisplayQuotaSummary(quotaSummary)
	}
}
