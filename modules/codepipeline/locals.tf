locals {
  project_name_slug = replace(lower(var.project_name), " ", "-")
}
