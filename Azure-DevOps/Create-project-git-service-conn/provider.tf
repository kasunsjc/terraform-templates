terraform {
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">= 0.1.0"
    }
  }
}

provider "azuredevops" {
  org_service_url       = "https://dev.azure.com/infrakloud/"
  personal_access_token = "4bxm5iicuhfuvdzavapd3c3goitnfphhxf6gi4ryw5rz6osiriua"
}