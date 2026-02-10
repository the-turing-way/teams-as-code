terraform {
  backend "gcs" {
    bucket             = "teams-as-code-tfstate"
    prefix             = "the-turing-way"
    kms_encryption_key = "projects/supple-tracker-380219/locations/europe-west2/keyRings/tfstate-encryption/cryptoKeys/tfstate-encryption-key"
  }

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "github" {
  token = var.github_token
  owner = var.github_organization
}
