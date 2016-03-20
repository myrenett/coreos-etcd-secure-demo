variable "do_token" {
	type = "string"
}

provider "digitalocean" {
	# https://cloud.digitalocean.com/settings/applications
	# generate a new token and replace below
	token  = "${var.do_token}"
}
