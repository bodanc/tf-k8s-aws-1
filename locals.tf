locals {
  tags_common = {
    created_by  = "terraform"
    company     = var.company
    project     = var.project
    environment = var.environment
  }
  prefix = "${var.project}-${var.environment}"
}
