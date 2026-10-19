variable "name" {
  description = "GitHub repository name."
  type        = string
}

variable "description" {
  description = "GitHub repository description."
  type        = string
}

variable "homepage_url" {
  description = "GitHub repository homepage URL."
  type        = string
  default     = "https://tuxcrate.com"
}

variable "topics" {
  description = "GitHub repository topics, in addition to tuxcrate."
  type        = set(string)
  default     = []
}

variable "required_checks" {
  description = "Required GitHub Actions checks for the default branch."
  type        = set(string)
  default     = []
}
