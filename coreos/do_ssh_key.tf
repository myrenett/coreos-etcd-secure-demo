resource "digitalocean_ssh_key" "default" {
    name = "Terraform Cluster"
    public_key = "${file("secret/ssh/id_rsa.pub")}"
}
