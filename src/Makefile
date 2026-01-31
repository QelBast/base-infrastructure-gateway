SHELL := pwsh.exe
.SHELLFLAGS := -Command

TF = terraform
PROXY = http://localhost:34822

# --- Variables file (git ignore)
TFVARS = -var-file='.\terraform.tfvars'

KEYSPATH = ../keys

# --- Proxy environment (for Terraform registry access) ---
export HTTP_PROXY=$(PROXY)
export HTTPS_PROXY=$(PROXY)

# --- Logging
export TF_LOG=TRACE
export TF_LOG_PATH=./tf.log

.PHONY: init plan apply all

all: init valid plan apply

init:
	$(TF) init

valid:
	$(TF) validate

plan:
	helm repo add argo https://argoproj.github.io/argo-helm
	helm repo update
	helm search repo argo/argo-cd
	$(TF) plan

apply:
	$(TF) apply $(TFVARS)