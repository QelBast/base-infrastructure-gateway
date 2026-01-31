terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.4"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.8.1"
    }
    
    kubernetes = { source = "hashicorp/kubernetes", version = "~> 3.0.1" }
    helm       = { source = "hashicorp/helm",       version = "~> 3.1.1" }
  }
}