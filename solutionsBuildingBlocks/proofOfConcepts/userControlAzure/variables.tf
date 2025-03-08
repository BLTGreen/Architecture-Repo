variable "target_subscription_id" {
 type = string
 description = "The subscription ID to give the users access to"
}

variable "users" {
 type = map(map(any))
 description = "A map of read-only users to create"
}