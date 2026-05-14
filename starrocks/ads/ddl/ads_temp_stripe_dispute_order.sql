CREATE TABLE `ads_temp_stripe_dispute_order` (
  `id` varchar(30) NOT NULL COMMENT "id",
  `description` varchar(30) NULL COMMENT "description",
  `dispute_created` datetime NULL COMMENT "dispute_created",
  `charge_created` datetime NULL COMMENT "charge_created",
  `dispute_amount` double NULL COMMENT "dispute_amount",
  `dispute_currency` varchar(5) NULL COMMENT "dispute_currency",
  `charge_amount` double NULL COMMENT "charge_amount",
  `charge_currency` varchar(5) NULL COMMENT "charge_currency",
  `charge_id` varchar(30) NULL COMMENT "charge_id",
  `card_fingerprint` varchar(20) NULL COMMENT "card_fingerprint",
  `card_brand` varchar(20) NULL COMMENT "card_brand",
  `card_funding` varchar(10) NULL COMMENT "card_funding",
  `customer_email` varchar(50) NULL COMMENT "customer_email",
  `customer_id` varchar(20) NULL COMMENT "customer_id",
  `reason` varchar(25) NULL COMMENT "reason",
  `status` varchar(25) NULL COMMENT "status",
  `due_by` datetime NULL COMMENT "due_by",
  `past_due` boolean NULL COMMENT "past_due",
  `has_evidence` boolean NULL COMMENT "has_evidence",
  `submission_count` int(11) NULL COMMENT "submission_count",
  `is_charge_refundable` boolean NULL COMMENT "is_charge_refundable",
  `amount_refunded` double NULL COMMENT "amount_refunded",
  `is_visa_rapid_dispute_resolution` boolean NULL COMMENT "is_visa_rapid_dispute_resolution",
  `visa_compelling_evidence_3_status` varchar(20) NULL COMMENT "visa_compelling_evidence_3_status",
  `visa_compliance_status` varchar(20) NULL COMMENT "visa_compliance_status",
  `payment_method_type` varchar(10) NULL COMMENT "payment_method_type",
  `payment_intent` varchar(30) NULL COMMENT "payment_intent",
  `account_id` varchar(30) NULL COMMENT "account_id"
) ENGINE=OLAP 
DUPLICATE KEY(`id`)
COMMENT "临时-Stripe Dispute订单"
DISTRIBUTED BY HASH(`id`)
PROPERTIES (
"replication_num" = "3",
"in_memory" = "false",
"enable_persistent_index" = "true",
"replicated_storage" = "true",
"compression" = "LZ4"
);