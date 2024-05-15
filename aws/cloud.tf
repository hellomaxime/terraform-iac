terraform {
  cloud {
    organization = "MyOrg-02"

    workspaces {
      name = "aws-ws"
    }
  }
}