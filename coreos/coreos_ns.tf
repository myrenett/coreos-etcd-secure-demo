variable "count" {
	type = "string"
 	default = 1
}

resource "template_file" "ns_user_data" {
	depends_on = ["etcdiscovery_token.default"]
	template = "${file("user_data/coreos.yml")}"
	count = "${var.count}"
	vars {
		hostname = "${format("ns-%03d", count.index + 1)}"
		metadata = "cloud=do,region=ams2,role=ns,mem=512mb"
		discovery_token = "${etcdiscovery_token.default.id}"
	}
}

resource "digitalocean_droplet" "coreos_ns" {
	depends_on = ["digitalocean_ssh_key.default"]
	count = "${var.count}"
	image = "coreos-alpha"
	name = "${format("ns-%03d", count.index + 1)}"
	region = "ams2"
	size = "512mb"
	ssh_keys = ["${digitalocean_ssh_key.default.id}"]
	private_networking = true
	user_data = "${element("template_file.ns_user_data.*.rendered", count.index)}"

	connection {
		user = "core"
		key_file = "secret/ssh/id_rsa"
	}
	provisioner "file" {
		source = "secret/tls/ca.crt"
		destination = "/home/core/ca.crt"

	}
	provisioner "file" {
		source = "secret/tls/coreos.host.crt"
		destination = "/home/core/client.host.crt"
	}
	provisioner "file" {
		source = "secret/tmp/coreos.key.insecure"
		destination = "/home/core/client.key"
	}
	provisioner "remote-exec" {
		inline = [
			"sudo mkdir -p /etc/ssl/etcd/certs",
			"sudo mkdir -p /etc/ssl/etcd/private",
			"sudo mv *.crt /etc/ssl/etcd/certs",
			"sudo mv *.key /etc/ssl/etcd/private",
		]
	}
}
