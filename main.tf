resource "oci_core_instance" "OL74-FromTerraform-jhan" {
  count=3
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  compartment_id = "${var.compartment_ocid}"
  image = "${lookup(data.oci_core_images.OLImageOCID.images[0], "id")}"
  shape = "${var.InstanceShape}"
  display_name="OL74-FromTerraform-${count.index}"
  hostname_label="OL74-FromTerraform-${count.index}"

  create_vnic_details {
    subnet_id = "${var.subnet_id}"
    display_name = "primaryvnic"
    assign_public_ip = true
  }

  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    user_data = "${base64encode(file(var.BootStrapFile))}"
  }

  timeouts {
    create = "60m"
  }
}
