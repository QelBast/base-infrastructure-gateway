locals {
  ssh_private_key = file("${path.root}/${var.key_path}")
  ssh_public_key  = trimspace(file("${path.root}/${var.key_path}.pub"))
}

# Step 1: Install MicroK8s via SSH remote-exec
resource "null_resource" "install_microk8s" {
  connection {
    type        = "ssh"
    host        = var.machine_ip
    user        = var.init_user
    password    = var.init_password
  }

  provisioner "remote-exec" {
    scripts = [ 
      templatefile("${path.root}/scripts/prepare-system.sh.tmpl", {
        username        = var.username
        ssh_public_key  = local.ssh_public_key
      }),
      templatefile("${path.root}/scripts/prepare-microk8s.sh.tmpl", {
        username        = var.username
      }),
    ]
  }
}

# Step 2: Fetch kubeconfig to local machine
resource "null_resource" "fetch_kubeconfig" {
  depends_on = [null_resource.install_microk8s]

  provisioner "local-exec" {
    command = "scp -i ${local.ssh_private_key} ${var.username}@${var.machine_ip}:/home/${var.username}/kubeconfig ~/.kube/config-microk8s"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ~/.kube/config-microk8s"
  }
}

# Step 3: Wait for MicroK8s to be ready
resource "time_sleep" "wait_microk8s_ready" {
  depends_on      = [null_resource.fetch_kubeconfig]
  create_duration = "30s" # MicroK8s API может стартовать не мгновенно
}

# Use fetched kubeconfig
locals {
  kubeconfig_path = "~/.kube/config-microk8s"
}

# Step 4: Deploy ArgoCD via Helm
resource "helm_release" "argocd" {
  depends_on = [time_sleep.wait_microk8s_ready]

  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "9.2.3"
  namespace        = "argocd"
  create_namespace = true

  set = [
    {
      name  = "server.service.type"
      value = "NodePort" # Или LoadBalancer, если есть внешний IP
    },
    # Bootstrap root app
    {
      name  = "configs.cm.create"
      value = "true"
    },
    {
      name  = "server.config.oidc.config"
      value = "name: Zitadel\nissuer: http://zitadel.public-ns.svc:8080\nclientID: your-client-id\nclientSecret: $oidc.clientSecret" # Интеграция с Zitadel
    }
  ]

  set_sensitive = [
    {
      name  = "configs.secret.argocdServerAdminPassword"
      value = bcrypt(var.argocd_admin_password) # Hash password
    }
  ]
}