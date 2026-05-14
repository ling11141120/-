CREATE TABLE `ads_temp_stripe_efw_new` (
  `id` varchar(30) NOT NULL COMMENT "id",
  `dispute_created` datetime NULL COMMENT "dispute_created",
  `disputed_amount` double NULL COMMENT "disputed_amount"
) ENGINE=OLAP 
DUPLICATE KEY(`id`)
COMMENT "临时-Stripe EFW"
DISTRIBUTED BY HASH(`id`)
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);