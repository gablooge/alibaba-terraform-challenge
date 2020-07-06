resource "alicloud_instance" "instance_a" {
  count = 1
  security_groups = ["${alicloud_security_group.sg.id}"]
  instance_type        = "ecs.t5-lc1m1.small"
  availability_zone = "ap-southeast-5a"
  internet_charge_type = "PayByTraffic"
  system_disk_category = "cloud_efficiency"
  image_id             = "ubuntu_18_04_64_20G_alibase_20190624.vhd"
  instance_name        = "challenge_ecs_zone_a"
  vswitch_id = alicloud_vswitch.vsw_a.id
  password   = var.ecs_password
  internet_max_bandwidth_out = 10
  instance_charge_type = "PostPaid"
}
resource "alicloud_instance" "instance_b" {
  count = 1
  security_groups = ["${alicloud_security_group.sg.id}"]
  instance_type        = "ecs.t5-lc1m1.small"
  availability_zone = "ap-southeast-5b"
  internet_charge_type = "PayByTraffic"
  system_disk_category = "cloud_efficiency"
  image_id             = "ubuntu_18_04_64_20G_alibase_20190624.vhd"
  instance_name        = "challenge_ecs_zone_b"
  vswitch_id = alicloud_vswitch.vsw_b.id
  password   = var.ecs_password
  internet_max_bandwidth_out = 10
  instance_charge_type = "PostPaid"
}

resource "alicloud_slb" "default" {
  name       = "slbservergroupvpc"
  vswitch_id = alicloud_vswitch.vsw_a.id
}

resource "alicloud_slb_server_group" "default" {
  load_balancer_id = alicloud_slb.default.id
  name             = "slbservergroupvpc"
  servers {
    server_ids = ["${alicloud_instance.instance_a.0.id}"]
    port       = 80
    weight     = 10
  }
  servers {
    server_ids = ["${alicloud_instance.instance_b.0.id}"]
    port       = 80
    weight     = 100
  }
}