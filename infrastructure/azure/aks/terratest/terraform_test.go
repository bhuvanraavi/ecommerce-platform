package test

import (
	"fmt"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestAzureStorageAccount(t *testing.T) {
	// Set a timeout for the test duration
	timeout := time.After(20 * time.Minute)
	done := make(chan bool)
	success := false // Flag to track success

	// Define the options for the Terraform module (declared at main function scope)
	terraformOptions := &terraform.Options{
		TerraformDir: "../", // Adjust this based on your directory structure
		Vars: map[string]interface{}{
			"location": "East US",
		},
		NoColor: true,
	}

	go func() {
		// Log the initialization of Terraform
		fmt.Println("Initializing Terraform...")
		terraform.Init(t, terraformOptions)

		// Log the application of Terraform
		fmt.Println("Applying Terraform...")
		terraform.Apply(t, terraformOptions)

		// Validate your code works as expected
		storageAccount := terraform.Output(t, terraformOptions, "kubernetes_cluster_name") // Adjust if needed
		assert.Equal(t, "demo-tfraavibhuvan-aks", storageAccount, "The storage account name should match the expected value.")

		// If assertions pass, set success to true
		success = true

		// Log success message
		fmt.Println("Test completed successfully!")

		// Signal that the test has completed successfully
		done <- true

		// Defer cleanup of the Terraform resources at the end of the test
		//defer terraform.Destroy(t, terraformOptions)
	}()

	// Wait for either the test to finish or the timeout to occur
	select {
	case <-done:
		if success {
			// Only destroy if the test was successful
			terraform.Destroy(t, terraformOptions)
		}
	case <-timeout:
		t.Fatal("Test timed out after 20 minutes.")
	}
}
