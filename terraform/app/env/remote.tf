terraform {
  backend "remote" {
    hostname     = "terraform.lululemon.app"
    organization = "lululemon"

    workspaces {
      prefix = "tes-app-"
    }
  }
}
