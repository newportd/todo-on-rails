terraform {
  required_providers {
    linode = {
      source = "linode/linode"
    }
  }
}

provider "linode" {
  # token = "$LINODE_TOKEN"
}

data "linode_instances" "app_todo" {
  filter {
    name = "tags"
    values = ["app:todo"]
  }
}

data "linode_domain" "newport_solutions" {
  domain = "newport.solutions"
}

resource "linode_domain_record" "todo_ipv4" {
  domain_id   = data.linode_domain.newport_solutions.id
  name        = "todo"
  record_type = "A"
  target      = tolist(data.linode_instances.app_todo.instances[0].ipv4)[0]
  ttl_sec     = 300
}

resource "linode_domain_record" "todo_ipv6" {
  domain_id   = data.linode_domain.newport_solutions.id
  name        = "todo"
  record_type = "AAAA"
  target      = trimsuffix(data.linode_instances.app_todo.instances[0].ipv6, "/128")
  ttl_sec     = 300
}

resource "null_resource" "configure" {
  depends_on = [
    data.linode_instances.app_todo
  ]
  triggers = {
    "playbooksha256" = filebase64sha256("playbooks/site.yml")
  }
  provisioner "local-exec" {
    command = "ansible-playbook playbooks/site.yml"      
  }
}
