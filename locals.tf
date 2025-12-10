locals {
  tags_common = {
    created_by  = var.created_by
    company     = var.company
    project     = var.project
    environment = var.environment
  }
  prefix = "${var.project}-${var.environment}"
}
