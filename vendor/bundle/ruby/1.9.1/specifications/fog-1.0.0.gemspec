# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{fog}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["geemus (Wesley Beary)"]
  s.date = %q{2011-09-29}
  s.default_executable = %q{fog}
  s.description = %q{The Ruby cloud services library. Supports all major cloud providers including AWS, Rackspace, Linode, Blue Box, StormOnDemand, and many others. Full support for most AWS services including EC2, S3, CloudWatch, SimpleDB, ELB, and RDS.}
  s.email = %q{geemus@gmail.com}
  s.executables = ["fog"]
  s.files = ["spec/core/current_machine_spec.rb", "spec/ecloud/bin_spec.rb", "spec/ecloud/models/backup_internet_service_spec.rb", "spec/ecloud/models/backup_internet_services_spec.rb", "spec/ecloud/models/internet_service_spec.rb", "spec/ecloud/models/internet_services_spec.rb", "spec/ecloud/models/ip_spec.rb", "spec/ecloud/models/ips_spec.rb", "spec/ecloud/models/network_spec.rb", "spec/ecloud/models/networks_spec.rb", "spec/ecloud/models/node_spec.rb", "spec/ecloud/models/nodes_spec.rb", "spec/ecloud/models/public_ip_spec.rb", "spec/ecloud/models/public_ips_spec.rb", "spec/ecloud/models/server_spec.rb", "spec/ecloud/models/vdc_spec.rb", "spec/ecloud/models/vdcs_spec.rb", "spec/ecloud/requests/add_backup_internet_service_spec.rb", "spec/ecloud/requests/add_internet_service_spec.rb", "spec/ecloud/requests/add_node_spec.rb", "spec/ecloud/requests/configure_internet_service_spec.rb", "spec/ecloud/requests/configure_network_ip_spec.rb", "spec/ecloud/requests/configure_node_spec.rb", "spec/ecloud/requests/configure_vapp_spec.rb", "spec/ecloud/requests/delete_internet_service_spec.rb", "spec/ecloud/requests/delete_node_spec.rb", "spec/ecloud/requests/delete_vapp_spec.rb", "spec/ecloud/requests/get_catalog_item_spec.rb", "spec/ecloud/requests/get_catalog_spec.rb", "spec/ecloud/requests/get_customization_options_spec.rb", "spec/ecloud/requests/get_internet_services_spec.rb", "spec/ecloud/requests/get_network_ip_spec.rb", "spec/ecloud/requests/get_network_ips_spec.rb", "spec/ecloud/requests/get_network_spec.rb", "spec/ecloud/requests/get_node_spec.rb", "spec/ecloud/requests/get_nodes_spec.rb", "spec/ecloud/requests/get_organization_spec.rb", "spec/ecloud/requests/get_public_ip_spec.rb", "spec/ecloud/requests/get_public_ips_spec.rb", "spec/ecloud/requests/get_vapp_spec.rb", "spec/ecloud/requests/get_vdc_spec.rb", "spec/ecloud/requests/get_versions_spec.rb", "spec/ecloud/requests/instantiate_vapp_template_spec.rb", "spec/ecloud/requests/login_spec.rb", "spec/ecloud/requests/power_off_spec.rb", "spec/ecloud/requests/power_on_spec.rb", "spec/ecloud/spec_helper.rb", "spec/ecloud/vcloud_spec.rb", "spec/spec_helper.rb", "tests/aws/models/auto_scaling/activities_tests.rb", "tests/aws/models/auto_scaling/configuration_test.rb", "tests/aws/models/auto_scaling/configurations_tests.rb", "tests/aws/models/auto_scaling/helper.rb", "tests/aws/models/auto_scaling/instances_tests.rb", "tests/aws/models/cloud_watch/metric_statistics_tests.rb", "tests/aws/models/cloud_watch/metrics_tests.rb", "tests/aws/models/compute/address_tests.rb", "tests/aws/models/compute/addresses_tests.rb", "tests/aws/models/compute/key_pair_tests.rb", "tests/aws/models/compute/key_pairs_tests.rb", "tests/aws/models/compute/security_group_tests.rb", "tests/aws/models/compute/security_groups_tests.rb", "tests/aws/models/compute/server_tests.rb", "tests/aws/models/compute/snapshot_tests.rb", "tests/aws/models/compute/snapshots_tests.rb", "tests/aws/models/compute/volume_tests.rb", "tests/aws/models/compute/volumes_tests.rb", "tests/aws/models/elasticache/cluster_tests.rb", "tests/aws/models/elasticache/parameter_groups_tests.rb", "tests/aws/models/elasticache/security_groups_tests.rb", "tests/aws/models/elb/model_tests.rb", "tests/aws/models/rds/helper.rb", "tests/aws/models/rds/parameter_group_tests.rb", "tests/aws/models/rds/parameter_groups_tests.rb", "tests/aws/models/rds/security_group_tests.rb", "tests/aws/models/rds/security_groups_tests.rb", "tests/aws/models/rds/server_tests.rb", "tests/aws/models/rds/servers_tests.rb", "tests/aws/models/rds/snapshot_tests.rb", "tests/aws/models/rds/snapshots_tests.rb", "tests/aws/requests/auto_scaling/auto_scaling_tests.rb", "tests/aws/requests/auto_scaling/helper.rb", "tests/aws/requests/auto_scaling/model_tests.rb", "tests/aws/requests/cloud_formation/stack_tests.rb", "tests/aws/requests/cloud_watch/get_metric_statistics_tests.rb", "tests/aws/requests/cloud_watch/list_metrics_test.rb", "tests/aws/requests/cloud_watch/put_metric_data_tests.rb", "tests/aws/requests/compute/address_tests.rb", "tests/aws/requests/compute/availability_zone_tests.rb", "tests/aws/requests/compute/helper.rb", "tests/aws/requests/compute/image_tests.rb", "tests/aws/requests/compute/instance_tests.rb", "tests/aws/requests/compute/key_pair_tests.rb", "tests/aws/requests/compute/placement_group_tests.rb", "tests/aws/requests/compute/region_tests.rb", "tests/aws/requests/compute/security_group_tests.rb", "tests/aws/requests/compute/snapshot_tests.rb", "tests/aws/requests/compute/spot_datafeed_subscription_tests.rb", "tests/aws/requests/compute/spot_instance_tests.rb", "tests/aws/requests/compute/spot_price_history_tests.rb", "tests/aws/requests/compute/tag_tests.rb", "tests/aws/requests/compute/volume_tests.rb", "tests/aws/requests/dns/dns_tests.rb", "tests/aws/requests/elasticache/cache_cluster_tests.rb", "tests/aws/requests/elasticache/describe_events.rb", "tests/aws/requests/elasticache/helper.rb", "tests/aws/requests/elasticache/parameter_group_tests.rb", "tests/aws/requests/elasticache/security_group_tests.rb", "tests/aws/requests/elb/helper.rb", "tests/aws/requests/elb/listener_tests.rb", "tests/aws/requests/elb/load_balancer_tests.rb", "tests/aws/requests/elb/policy_tests.rb", "tests/aws/requests/iam/access_key_tests.rb", "tests/aws/requests/iam/group_policy_tests.rb", "tests/aws/requests/iam/group_tests.rb", "tests/aws/requests/iam/helper.rb", "tests/aws/requests/iam/login_profile_tests.rb", "tests/aws/requests/iam/server_certificate_tests.rb", "tests/aws/requests/iam/user_policy_tests.rb", "tests/aws/requests/iam/user_tests.rb", "tests/aws/requests/rds/helper.rb", "tests/aws/requests/rds/instance_tests.rb", "tests/aws/requests/rds/parameter_group_tests.rb", "tests/aws/requests/rds/parameter_request_tests.rb", "tests/aws/requests/ses/helper.rb", "tests/aws/requests/ses/verified_email_address_tests.rb", "tests/aws/requests/simpledb/attributes_tests.rb", "tests/aws/requests/simpledb/domain_tests.rb", "tests/aws/requests/simpledb/helper.rb", "tests/aws/requests/sns/helper.rb", "tests/aws/requests/sns/subscription_tests.rb", "tests/aws/requests/sns/topic_tests.rb", "tests/aws/requests/sqs/helper.rb", "tests/aws/requests/sqs/message_tests.rb", "tests/aws/requests/sqs/queue_tests.rb", "tests/aws/requests/storage/bucket_tests.rb", "tests/aws/requests/storage/multipart_upload_tests.rb", "tests/aws/requests/storage/object_tests.rb", "tests/aws/signed_params_tests.rb", "tests/bluebox/requests/compute/block_tests.rb", "tests/bluebox/requests/compute/helper.rb", "tests/bluebox/requests/compute/product_tests.rb", "tests/bluebox/requests/compute/template_tests.rb", "tests/bluebox/requests/dns/dns_tests.rb", "tests/brightbox/requests/compute/account_tests.rb", "tests/brightbox/requests/compute/api_client_tests.rb", "tests/brightbox/requests/compute/cloud_ip_tests.rb", "tests/brightbox/requests/compute/helper.rb", "tests/brightbox/requests/compute/image_tests.rb", "tests/brightbox/requests/compute/interface_tests.rb", "tests/brightbox/requests/compute/load_balancer_tests.rb", "tests/brightbox/requests/compute/server_group_tests.rb", "tests/brightbox/requests/compute/server_tests.rb", "tests/brightbox/requests/compute/server_type_tests.rb", "tests/brightbox/requests/compute/user_tests.rb", "tests/brightbox/requests/compute/zone_tests.rb", "tests/compute/helper.rb", "tests/compute/models/flavors_tests.rb", "tests/compute/models/server_tests.rb", "tests/compute/models/servers_tests.rb", "tests/core/attribute_tests.rb", "tests/core/credential_tests.rb", "tests/core/parser_tests.rb", "tests/core/timeout_tests.rb", "tests/dns/helper.rb", "tests/dns/models/record_tests.rb", "tests/dns/models/records_tests.rb", "tests/dns/models/zone_tests.rb", "tests/dns/models/zones_tests.rb", "tests/dnsimple/requests/dns/dns_tests.rb", "tests/dnsmadeeasy/requests/dns/dns_tests.rb", "tests/dynect/requests/dns/dns_tests.rb", "tests/glesys/requests/compute/helper.rb", "tests/glesys/requests/compute/ip_tests.rb", "tests/glesys/requests/compute/server_tests.rb", "tests/glesys/requests/compute/template_tests.rb", "tests/go_grid/requests/compute/image_tests.rb", "tests/google/requests/storage/bucket_tests.rb", "tests/google/requests/storage/object_tests.rb", "tests/helper.rb", "tests/helpers/collection_helper.rb", "tests/helpers/compute/flavors_helper.rb", "tests/helpers/compute/server_helper.rb", "tests/helpers/compute/servers_helper.rb", "tests/helpers/formats_helper.rb", "tests/helpers/formats_helper_tests.rb", "tests/helpers/mock_helper.rb", "tests/helpers/model_helper.rb", "tests/helpers/responds_to_helper.rb", "tests/helpers/succeeds_helper.rb", "tests/linode/requests/compute/datacenter_tests.rb", "tests/linode/requests/compute/distribution_tests.rb", "tests/linode/requests/compute/helper.rb", "tests/linode/requests/compute/kernel_tests.rb", "tests/linode/requests/compute/linode_tests.rb", "tests/linode/requests/compute/linodeplans_tests.rb", "tests/linode/requests/compute/stackscripts_tests.rb", "tests/linode/requests/dns/dns_tests.rb", "tests/lorem.txt", "tests/ninefold/models/storage/file_update_tests.rb", "tests/ninefold/models/storage/nested_directories_tests.rb", "tests/ninefold/requests/compute/address_tests.rb", "tests/ninefold/requests/compute/async_job_tests.rb", "tests/ninefold/requests/compute/helper.rb", "tests/ninefold/requests/compute/list_tests.rb", "tests/ninefold/requests/compute/nat_tests.rb", "tests/ninefold/requests/compute/network_tests.rb", "tests/ninefold/requests/compute/template_tests.rb", "tests/ninefold/requests/compute/virtual_machine_tests.rb", "tests/openstack/requests/compute/flavor_tests.rb", "tests/openstack/requests/compute/helper.rb", "tests/openstack/requests/compute/image_tests.rb", "tests/openstack/requests/compute/server_tests.rb", "tests/rackspace/helper.rb", "tests/rackspace/load_balancer_tests.rb", "tests/rackspace/models/access_list_tests.rb", "tests/rackspace/models/access_lists_tests.rb", "tests/rackspace/models/load_balancer_tests.rb", "tests/rackspace/models/load_balancers_tests.rb", "tests/rackspace/models/node_tests.rb", "tests/rackspace/models/nodes_tests.rb", "tests/rackspace/models/virtual_ip_tests.rb", "tests/rackspace/models/virtual_ips_tests.rb", "tests/rackspace/requests/compute/address_tests.rb", "tests/rackspace/requests/compute/flavor_tests.rb", "tests/rackspace/requests/compute/helper.rb", "tests/rackspace/requests/compute/image_tests.rb", "tests/rackspace/requests/compute/resize_tests.rb", "tests/rackspace/requests/compute/server_tests.rb", "tests/rackspace/requests/dns/dns_tests.rb", "tests/rackspace/requests/dns/helper.rb", "tests/rackspace/requests/dns/records_tests.rb", "tests/rackspace/requests/load_balancers/access_list_tests.rb", "tests/rackspace/requests/load_balancers/algorithm_tests.rb", "tests/rackspace/requests/load_balancers/connection_logging_tests.rb", "tests/rackspace/requests/load_balancers/connection_throttling_tests.rb", "tests/rackspace/requests/load_balancers/helper.rb", "tests/rackspace/requests/load_balancers/load_balancer_tests.rb", "tests/rackspace/requests/load_balancers/load_balancer_usage_tests.rb", "tests/rackspace/requests/load_balancers/monitor_tests.rb", "tests/rackspace/requests/load_balancers/node_tests.rb", "tests/rackspace/requests/load_balancers/protocol_tests.rb", "tests/rackspace/requests/load_balancers/session_persistence_tests.rb", "tests/rackspace/requests/load_balancers/usage_tests.rb", "tests/rackspace/requests/load_balancers/virtual_ip_tests.rb", "tests/rackspace/requests/storage/container_tests.rb", "tests/rackspace/requests/storage/large_object_tests.rb", "tests/rackspace/requests/storage/object_tests.rb", "tests/rackspace/url_encoding_tests.rb", "tests/slicehost/requests/compute/backup_tests.rb", "tests/slicehost/requests/compute/flavor_tests.rb", "tests/slicehost/requests/compute/image_tests.rb", "tests/slicehost/requests/compute/slice_tests.rb", "tests/slicehost/requests/dns/dns_tests.rb", "tests/storage/helper.rb", "tests/storage/models/directories_tests.rb", "tests/storage/models/directory_test.rb", "tests/storage/models/file_tests.rb", "tests/storage/models/files_tests.rb", "tests/storm_on_demand/requests/compute/server_tests.rb", "tests/vcloud/models/compute/helper.rb", "tests/vcloud/models/compute/servers_tests.rb", "tests/vcloud/requests/compute/disk_configure_tests.rb", "tests/voxel/requests/compute/image_tests.rb", "tests/voxel/requests/compute/server_tests.rb", "tests/vsphere/compute_tests.rb", "tests/vsphere/models/compute/server_tests.rb", "tests/vsphere/models/compute/servers_tests.rb", "tests/vsphere/requests/compute/current_time_tests.rb", "tests/vsphere/requests/compute/find_vm_by_ref_tests.rb", "tests/vsphere/requests/compute/list_virtual_machines_tests.rb", "tests/vsphere/requests/compute/vm_clone_tests.rb", "tests/vsphere/requests/compute/vm_destroy_tests.rb", "tests/vsphere/requests/compute/vm_power_off_tests.rb", "tests/vsphere/requests/compute/vm_power_on_tests.rb", "tests/vsphere/requests/compute/vm_reboot_tests.rb", "tests/watchr.rb", "tests/zerigo/requests/dns/dns_tests.rb", "bin/fog"]
  s.homepage = %q{http://github.com/geemus/fog}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{fog}
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{brings clouds to you}
  s.test_files = ["spec/core/current_machine_spec.rb", "spec/ecloud/bin_spec.rb", "spec/ecloud/models/backup_internet_service_spec.rb", "spec/ecloud/models/backup_internet_services_spec.rb", "spec/ecloud/models/internet_service_spec.rb", "spec/ecloud/models/internet_services_spec.rb", "spec/ecloud/models/ip_spec.rb", "spec/ecloud/models/ips_spec.rb", "spec/ecloud/models/network_spec.rb", "spec/ecloud/models/networks_spec.rb", "spec/ecloud/models/node_spec.rb", "spec/ecloud/models/nodes_spec.rb", "spec/ecloud/models/public_ip_spec.rb", "spec/ecloud/models/public_ips_spec.rb", "spec/ecloud/models/server_spec.rb", "spec/ecloud/models/vdc_spec.rb", "spec/ecloud/models/vdcs_spec.rb", "spec/ecloud/requests/add_backup_internet_service_spec.rb", "spec/ecloud/requests/add_internet_service_spec.rb", "spec/ecloud/requests/add_node_spec.rb", "spec/ecloud/requests/configure_internet_service_spec.rb", "spec/ecloud/requests/configure_network_ip_spec.rb", "spec/ecloud/requests/configure_node_spec.rb", "spec/ecloud/requests/configure_vapp_spec.rb", "spec/ecloud/requests/delete_internet_service_spec.rb", "spec/ecloud/requests/delete_node_spec.rb", "spec/ecloud/requests/delete_vapp_spec.rb", "spec/ecloud/requests/get_catalog_item_spec.rb", "spec/ecloud/requests/get_catalog_spec.rb", "spec/ecloud/requests/get_customization_options_spec.rb", "spec/ecloud/requests/get_internet_services_spec.rb", "spec/ecloud/requests/get_network_ip_spec.rb", "spec/ecloud/requests/get_network_ips_spec.rb", "spec/ecloud/requests/get_network_spec.rb", "spec/ecloud/requests/get_node_spec.rb", "spec/ecloud/requests/get_nodes_spec.rb", "spec/ecloud/requests/get_organization_spec.rb", "spec/ecloud/requests/get_public_ip_spec.rb", "spec/ecloud/requests/get_public_ips_spec.rb", "spec/ecloud/requests/get_vapp_spec.rb", "spec/ecloud/requests/get_vdc_spec.rb", "spec/ecloud/requests/get_versions_spec.rb", "spec/ecloud/requests/instantiate_vapp_template_spec.rb", "spec/ecloud/requests/login_spec.rb", "spec/ecloud/requests/power_off_spec.rb", "spec/ecloud/requests/power_on_spec.rb", "spec/ecloud/spec_helper.rb", "spec/ecloud/vcloud_spec.rb", "spec/spec_helper.rb", "tests/aws/models/auto_scaling/activities_tests.rb", "tests/aws/models/auto_scaling/configuration_test.rb", "tests/aws/models/auto_scaling/configurations_tests.rb", "tests/aws/models/auto_scaling/helper.rb", "tests/aws/models/auto_scaling/instances_tests.rb", "tests/aws/models/cloud_watch/metric_statistics_tests.rb", "tests/aws/models/cloud_watch/metrics_tests.rb", "tests/aws/models/compute/address_tests.rb", "tests/aws/models/compute/addresses_tests.rb", "tests/aws/models/compute/key_pair_tests.rb", "tests/aws/models/compute/key_pairs_tests.rb", "tests/aws/models/compute/security_group_tests.rb", "tests/aws/models/compute/security_groups_tests.rb", "tests/aws/models/compute/server_tests.rb", "tests/aws/models/compute/snapshot_tests.rb", "tests/aws/models/compute/snapshots_tests.rb", "tests/aws/models/compute/volume_tests.rb", "tests/aws/models/compute/volumes_tests.rb", "tests/aws/models/elasticache/cluster_tests.rb", "tests/aws/models/elasticache/parameter_groups_tests.rb", "tests/aws/models/elasticache/security_groups_tests.rb", "tests/aws/models/elb/model_tests.rb", "tests/aws/models/rds/helper.rb", "tests/aws/models/rds/parameter_group_tests.rb", "tests/aws/models/rds/parameter_groups_tests.rb", "tests/aws/models/rds/security_group_tests.rb", "tests/aws/models/rds/security_groups_tests.rb", "tests/aws/models/rds/server_tests.rb", "tests/aws/models/rds/servers_tests.rb", "tests/aws/models/rds/snapshot_tests.rb", "tests/aws/models/rds/snapshots_tests.rb", "tests/aws/requests/auto_scaling/auto_scaling_tests.rb", "tests/aws/requests/auto_scaling/helper.rb", "tests/aws/requests/auto_scaling/model_tests.rb", "tests/aws/requests/cloud_formation/stack_tests.rb", "tests/aws/requests/cloud_watch/get_metric_statistics_tests.rb", "tests/aws/requests/cloud_watch/list_metrics_test.rb", "tests/aws/requests/cloud_watch/put_metric_data_tests.rb", "tests/aws/requests/compute/address_tests.rb", "tests/aws/requests/compute/availability_zone_tests.rb", "tests/aws/requests/compute/helper.rb", "tests/aws/requests/compute/image_tests.rb", "tests/aws/requests/compute/instance_tests.rb", "tests/aws/requests/compute/key_pair_tests.rb", "tests/aws/requests/compute/placement_group_tests.rb", "tests/aws/requests/compute/region_tests.rb", "tests/aws/requests/compute/security_group_tests.rb", "tests/aws/requests/compute/snapshot_tests.rb", "tests/aws/requests/compute/spot_datafeed_subscription_tests.rb", "tests/aws/requests/compute/spot_instance_tests.rb", "tests/aws/requests/compute/spot_price_history_tests.rb", "tests/aws/requests/compute/tag_tests.rb", "tests/aws/requests/compute/volume_tests.rb", "tests/aws/requests/dns/dns_tests.rb", "tests/aws/requests/elasticache/cache_cluster_tests.rb", "tests/aws/requests/elasticache/describe_events.rb", "tests/aws/requests/elasticache/helper.rb", "tests/aws/requests/elasticache/parameter_group_tests.rb", "tests/aws/requests/elasticache/security_group_tests.rb", "tests/aws/requests/elb/helper.rb", "tests/aws/requests/elb/listener_tests.rb", "tests/aws/requests/elb/load_balancer_tests.rb", "tests/aws/requests/elb/policy_tests.rb", "tests/aws/requests/iam/access_key_tests.rb", "tests/aws/requests/iam/group_policy_tests.rb", "tests/aws/requests/iam/group_tests.rb", "tests/aws/requests/iam/helper.rb", "tests/aws/requests/iam/login_profile_tests.rb", "tests/aws/requests/iam/server_certificate_tests.rb", "tests/aws/requests/iam/user_policy_tests.rb", "tests/aws/requests/iam/user_tests.rb", "tests/aws/requests/rds/helper.rb", "tests/aws/requests/rds/instance_tests.rb", "tests/aws/requests/rds/parameter_group_tests.rb", "tests/aws/requests/rds/parameter_request_tests.rb", "tests/aws/requests/ses/helper.rb", "tests/aws/requests/ses/verified_email_address_tests.rb", "tests/aws/requests/simpledb/attributes_tests.rb", "tests/aws/requests/simpledb/domain_tests.rb", "tests/aws/requests/simpledb/helper.rb", "tests/aws/requests/sns/helper.rb", "tests/aws/requests/sns/subscription_tests.rb", "tests/aws/requests/sns/topic_tests.rb", "tests/aws/requests/sqs/helper.rb", "tests/aws/requests/sqs/message_tests.rb", "tests/aws/requests/sqs/queue_tests.rb", "tests/aws/requests/storage/bucket_tests.rb", "tests/aws/requests/storage/multipart_upload_tests.rb", "tests/aws/requests/storage/object_tests.rb", "tests/aws/signed_params_tests.rb", "tests/bluebox/requests/compute/block_tests.rb", "tests/bluebox/requests/compute/helper.rb", "tests/bluebox/requests/compute/product_tests.rb", "tests/bluebox/requests/compute/template_tests.rb", "tests/bluebox/requests/dns/dns_tests.rb", "tests/brightbox/requests/compute/account_tests.rb", "tests/brightbox/requests/compute/api_client_tests.rb", "tests/brightbox/requests/compute/cloud_ip_tests.rb", "tests/brightbox/requests/compute/helper.rb", "tests/brightbox/requests/compute/image_tests.rb", "tests/brightbox/requests/compute/interface_tests.rb", "tests/brightbox/requests/compute/load_balancer_tests.rb", "tests/brightbox/requests/compute/server_group_tests.rb", "tests/brightbox/requests/compute/server_tests.rb", "tests/brightbox/requests/compute/server_type_tests.rb", "tests/brightbox/requests/compute/user_tests.rb", "tests/brightbox/requests/compute/zone_tests.rb", "tests/compute/helper.rb", "tests/compute/models/flavors_tests.rb", "tests/compute/models/server_tests.rb", "tests/compute/models/servers_tests.rb", "tests/core/attribute_tests.rb", "tests/core/credential_tests.rb", "tests/core/parser_tests.rb", "tests/core/timeout_tests.rb", "tests/dns/helper.rb", "tests/dns/models/record_tests.rb", "tests/dns/models/records_tests.rb", "tests/dns/models/zone_tests.rb", "tests/dns/models/zones_tests.rb", "tests/dnsimple/requests/dns/dns_tests.rb", "tests/dnsmadeeasy/requests/dns/dns_tests.rb", "tests/dynect/requests/dns/dns_tests.rb", "tests/glesys/requests/compute/helper.rb", "tests/glesys/requests/compute/ip_tests.rb", "tests/glesys/requests/compute/server_tests.rb", "tests/glesys/requests/compute/template_tests.rb", "tests/go_grid/requests/compute/image_tests.rb", "tests/google/requests/storage/bucket_tests.rb", "tests/google/requests/storage/object_tests.rb", "tests/helper.rb", "tests/helpers/collection_helper.rb", "tests/helpers/compute/flavors_helper.rb", "tests/helpers/compute/server_helper.rb", "tests/helpers/compute/servers_helper.rb", "tests/helpers/formats_helper.rb", "tests/helpers/formats_helper_tests.rb", "tests/helpers/mock_helper.rb", "tests/helpers/model_helper.rb", "tests/helpers/responds_to_helper.rb", "tests/helpers/succeeds_helper.rb", "tests/linode/requests/compute/datacenter_tests.rb", "tests/linode/requests/compute/distribution_tests.rb", "tests/linode/requests/compute/helper.rb", "tests/linode/requests/compute/kernel_tests.rb", "tests/linode/requests/compute/linode_tests.rb", "tests/linode/requests/compute/linodeplans_tests.rb", "tests/linode/requests/compute/stackscripts_tests.rb", "tests/linode/requests/dns/dns_tests.rb", "tests/lorem.txt", "tests/ninefold/models/storage/file_update_tests.rb", "tests/ninefold/models/storage/nested_directories_tests.rb", "tests/ninefold/requests/compute/address_tests.rb", "tests/ninefold/requests/compute/async_job_tests.rb", "tests/ninefold/requests/compute/helper.rb", "tests/ninefold/requests/compute/list_tests.rb", "tests/ninefold/requests/compute/nat_tests.rb", "tests/ninefold/requests/compute/network_tests.rb", "tests/ninefold/requests/compute/template_tests.rb", "tests/ninefold/requests/compute/virtual_machine_tests.rb", "tests/openstack/requests/compute/flavor_tests.rb", "tests/openstack/requests/compute/helper.rb", "tests/openstack/requests/compute/image_tests.rb", "tests/openstack/requests/compute/server_tests.rb", "tests/rackspace/helper.rb", "tests/rackspace/load_balancer_tests.rb", "tests/rackspace/models/access_list_tests.rb", "tests/rackspace/models/access_lists_tests.rb", "tests/rackspace/models/load_balancer_tests.rb", "tests/rackspace/models/load_balancers_tests.rb", "tests/rackspace/models/node_tests.rb", "tests/rackspace/models/nodes_tests.rb", "tests/rackspace/models/virtual_ip_tests.rb", "tests/rackspace/models/virtual_ips_tests.rb", "tests/rackspace/requests/compute/address_tests.rb", "tests/rackspace/requests/compute/flavor_tests.rb", "tests/rackspace/requests/compute/helper.rb", "tests/rackspace/requests/compute/image_tests.rb", "tests/rackspace/requests/compute/resize_tests.rb", "tests/rackspace/requests/compute/server_tests.rb", "tests/rackspace/requests/dns/dns_tests.rb", "tests/rackspace/requests/dns/helper.rb", "tests/rackspace/requests/dns/records_tests.rb", "tests/rackspace/requests/load_balancers/access_list_tests.rb", "tests/rackspace/requests/load_balancers/algorithm_tests.rb", "tests/rackspace/requests/load_balancers/connection_logging_tests.rb", "tests/rackspace/requests/load_balancers/connection_throttling_tests.rb", "tests/rackspace/requests/load_balancers/helper.rb", "tests/rackspace/requests/load_balancers/load_balancer_tests.rb", "tests/rackspace/requests/load_balancers/load_balancer_usage_tests.rb", "tests/rackspace/requests/load_balancers/monitor_tests.rb", "tests/rackspace/requests/load_balancers/node_tests.rb", "tests/rackspace/requests/load_balancers/protocol_tests.rb", "tests/rackspace/requests/load_balancers/session_persistence_tests.rb", "tests/rackspace/requests/load_balancers/usage_tests.rb", "tests/rackspace/requests/load_balancers/virtual_ip_tests.rb", "tests/rackspace/requests/storage/container_tests.rb", "tests/rackspace/requests/storage/large_object_tests.rb", "tests/rackspace/requests/storage/object_tests.rb", "tests/rackspace/url_encoding_tests.rb", "tests/slicehost/requests/compute/backup_tests.rb", "tests/slicehost/requests/compute/flavor_tests.rb", "tests/slicehost/requests/compute/image_tests.rb", "tests/slicehost/requests/compute/slice_tests.rb", "tests/slicehost/requests/dns/dns_tests.rb", "tests/storage/helper.rb", "tests/storage/models/directories_tests.rb", "tests/storage/models/directory_test.rb", "tests/storage/models/file_tests.rb", "tests/storage/models/files_tests.rb", "tests/storm_on_demand/requests/compute/server_tests.rb", "tests/vcloud/models/compute/helper.rb", "tests/vcloud/models/compute/servers_tests.rb", "tests/vcloud/requests/compute/disk_configure_tests.rb", "tests/voxel/requests/compute/image_tests.rb", "tests/voxel/requests/compute/server_tests.rb", "tests/vsphere/compute_tests.rb", "tests/vsphere/models/compute/server_tests.rb", "tests/vsphere/models/compute/servers_tests.rb", "tests/vsphere/requests/compute/current_time_tests.rb", "tests/vsphere/requests/compute/find_vm_by_ref_tests.rb", "tests/vsphere/requests/compute/list_virtual_machines_tests.rb", "tests/vsphere/requests/compute/vm_clone_tests.rb", "tests/vsphere/requests/compute/vm_destroy_tests.rb", "tests/vsphere/requests/compute/vm_power_off_tests.rb", "tests/vsphere/requests/compute/vm_power_on_tests.rb", "tests/vsphere/requests/compute/vm_reboot_tests.rb", "tests/watchr.rb", "tests/zerigo/requests/dns/dns_tests.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<builder>, [">= 0"])
      s.add_runtime_dependency(%q<excon>, ["~> 0.7.3"])
      s.add_runtime_dependency(%q<formatador>, ["~> 0.2.0"])
      s.add_runtime_dependency(%q<multi_json>, ["~> 1.0.3"])
      s.add_runtime_dependency(%q<mime-types>, [">= 0"])
      s.add_runtime_dependency(%q<net-scp>, ["~> 1.0.4"])
      s.add_runtime_dependency(%q<net-ssh>, ["~> 2.1.4"])
      s.add_runtime_dependency(%q<nokogiri>, ["~> 1.5.0"])
      s.add_runtime_dependency(%q<ruby-hmac>, [">= 0"])
      s.add_development_dependency(%q<jekyll>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 1.3.1"])
      s.add_development_dependency(%q<shindo>, ["~> 0.3.4"])
      s.add_development_dependency(%q<virtualbox>, ["~> 0.9.1"])
    else
      s.add_dependency(%q<builder>, [">= 0"])
      s.add_dependency(%q<excon>, ["~> 0.7.3"])
      s.add_dependency(%q<formatador>, ["~> 0.2.0"])
      s.add_dependency(%q<multi_json>, ["~> 1.0.3"])
      s.add_dependency(%q<mime-types>, [">= 0"])
      s.add_dependency(%q<net-scp>, ["~> 1.0.4"])
      s.add_dependency(%q<net-ssh>, ["~> 2.1.4"])
      s.add_dependency(%q<nokogiri>, ["~> 1.5.0"])
      s.add_dependency(%q<ruby-hmac>, [">= 0"])
      s.add_dependency(%q<jekyll>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rdoc>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 1.3.1"])
      s.add_dependency(%q<shindo>, ["~> 0.3.4"])
      s.add_dependency(%q<virtualbox>, ["~> 0.9.1"])
    end
  else
    s.add_dependency(%q<builder>, [">= 0"])
    s.add_dependency(%q<excon>, ["~> 0.7.3"])
    s.add_dependency(%q<formatador>, ["~> 0.2.0"])
    s.add_dependency(%q<multi_json>, ["~> 1.0.3"])
    s.add_dependency(%q<mime-types>, [">= 0"])
    s.add_dependency(%q<net-scp>, ["~> 1.0.4"])
    s.add_dependency(%q<net-ssh>, ["~> 2.1.4"])
    s.add_dependency(%q<nokogiri>, ["~> 1.5.0"])
    s.add_dependency(%q<ruby-hmac>, [">= 0"])
    s.add_dependency(%q<jekyll>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rdoc>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 1.3.1"])
    s.add_dependency(%q<shindo>, ["~> 0.3.4"])
    s.add_dependency(%q<virtualbox>, ["~> 0.9.1"])
  end
end
