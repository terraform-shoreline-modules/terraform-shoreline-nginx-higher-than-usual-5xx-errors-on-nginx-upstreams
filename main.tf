terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "higher_than_usual_5xx_errors_for_nginx" {
  source    = "./modules/higher_than_usual_5xx_errors_for_nginx"

  providers = {
    shoreline = shoreline
  }
}