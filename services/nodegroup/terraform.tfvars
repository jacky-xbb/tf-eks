instance_types = ["m5.large"]

disk_size = 40

scaling_config = {
  "desired_size" = 3
  "max_size"     = 5
  "min_size"     = 1
}
