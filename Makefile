TF = tofu
# PROXY = http://localhost:34822

# --- Proxy environment (for Terraform registry access) ---
# export HTTP_PROXY=$(PROXY)
# export HTTPS_PROXY=$(PROXY)

tofu init
tofu providers mirror ~/opentofu-mirror

.PHONY: stage1 stage2 stage3 all

all: stage1 stage2 stage3

stage1:
	
stage2:
	rm $(KEYSPATH)/$(ST1KEY)*
	ssh-keygen -q -v -t ed25519 -f $(KEYSPATH)/$(ST1KEY) -N ""
	