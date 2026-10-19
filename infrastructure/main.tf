terraform {
  required_version = "~> 1.13"
  encryption {
    key_provider "pbkdf2" "my_key_provider_name" {
      passphrase = var.state_passphrase
    }
    method "aes_gcm" "my_method_name" {
      keys = key_provider.pbkdf2.my_key_provider_name
    }
    state {
      method   = method.aes_gcm.my_method_name
      enforced = true
    }
    plan {
      method   = method.aes_gcm.my_method_name
      enforced = true
    }
  }

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.13.0"
    }
  }
}

provider "github" {
  owner = "tuxcrate"
}
