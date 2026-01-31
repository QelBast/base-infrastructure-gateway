# Machine variables
variable "machine_ip" {
  type        = string
  description = "IP address or hostname of the target machine"
  sensitive   = true
}
variable "init_user" {
  type        = string
  description = "Initial user for the machine"
  default = "root"
}
variable "init_password" {
  type        = string
  description = "Password to SSH before key creation"
  sensitive   = true
}

# User variables
variable "username" {
  type        = string
  default     = "k8sadmin"
  description = "SSH username"
}
variable "key_path" {
  type        = string
  description = "Path to SSH private key file (e.g. ~/.ssh/id_ed25519)"
}

variable "git_repo_url" {
  type        = string
  description = "Git repo for ArgoCD apps"
}

variable "argocd_admin_password" {
  type        = string
  description = "Initial ArgoCD admin password"
  sensitive   = true
}

variable "idp_admin_password" {
  type      = string
  description = "Initial Identity Provider admin password"
  sensitive = true
}