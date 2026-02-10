variable "github_token" {
  type        = string
  description = "A GitHub PAT with repo and admin:org permissions"
}

variable "github_organization" {
  type        = string
  default     = "the-turing-way"
  description = "The name/slug of the GitHub organisation to operate within"
}
