instance_types = ["t2.medium"]

disk_size = 20

scaling_config = {
    "desired_size" = 3
    "max_size"     = 5
    "min_size"     = 1
}
