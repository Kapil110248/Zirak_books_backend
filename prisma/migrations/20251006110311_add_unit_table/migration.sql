-- CreateTable
CREATE TABLE `companies` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NULL,
    `email` VARCHAR(255) NULL,
    `status` ENUM('Active', 'Inactive') NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `users` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `name` VARCHAR(255) NULL,
    `email` VARCHAR(255) NULL,
    `phone` VARCHAR(20) NULL,
    `role` ENUM('Admin', 'Accountant', 'Auditor', 'Viewer') NULL,
    `status` ENUM('Active', 'Inactive') NULL,
    `password` VARCHAR(255) NULL,
    `profile_image` VARCHAR(255) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    UNIQUE INDEX `email`(`email`),
    INDEX `company_id`(`company_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `groups` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `group_name` VARCHAR(100) NULL,
    `description` TEXT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `company_id`(`company_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `subgroups` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `group_id` BIGINT NULL,
    `subgroup_name` VARCHAR(100) NULL,
    `description` TEXT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `group_id`(`group_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `accounts` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `parent_id` BIGINT NULL,
    `main_category` ENUM('Assets', 'Liabilities', 'Equity', 'Income', 'Expenses') NOT NULL,
    `subgroup` VARCHAR(100) NOT NULL,
    `account_name` VARCHAR(255) NOT NULL,
    `account_number` VARCHAR(50) NULL,
    `ifsc_code` VARCHAR(20) NULL,
    `bank_name_branch` VARCHAR(255) NULL,
    `is_active` BOOLEAN NULL DEFAULT true,
    `created_by` BIGINT NULL,
    `updated_by` BIGINT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `created_by`(`created_by`),
    INDEX `parent_id`(`parent_id`),
    INDEX `updated_by`(`updated_by`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `financial_years` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `start_date` DATE NULL,
    `end_date` DATE NULL,
    `status` ENUM('Open', 'Closed') NULL,

    INDEX `company_id`(`company_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `vouchers` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `voucher_type` ENUM('Expense', 'Income', 'Contra', 'Journal', 'Credit Note', 'Debit Note', 'Opening Balance', 'Current Balance', 'Closing Balance', 'Sales', 'Purchase', 'Delivery Challans') NULL,
    `company_name` VARCHAR(255) NULL,
    `company_logo` VARCHAR(255) NULL,
    `from_customer_id` BIGINT NULL,
    `to_name` VARCHAR(255) NULL,
    `receipt_number` VARCHAR(50) NULL,
    `voucher_number` VARCHAR(50) NULL,
    `voucher_date` DATE NULL,
    `subtotal` DECIMAL(15, 2) NULL,
    `total` DECIMAL(15, 2) NULL,
    `notes` TEXT NULL,
    `created_by` BIGINT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `company_id`(`company_id`),
    INDEX `created_by`(`created_by`),
    INDEX `from_customer_id`(`from_customer_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `voucher_entries` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `voucher_id` BIGINT NULL,
    `account_id` BIGINT NULL,
    `debit` DECIMAL(15, 2) NULL,
    `credit` DECIMAL(15, 2) NULL,
    `narration` TEXT NULL,

    INDEX `voucher_id`(`voucher_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `transactions` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `voucher_entry_id` BIGINT NULL,
    `account_id` BIGINT NULL,
    `txn_date` DATE NULL,
    `debit` DECIMAL(15, 2) NULL,
    `credit` DECIMAL(15, 2) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `account_id`(`account_id`),
    INDEX `voucher_entry_id`(`voucher_entry_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `taxes` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `tax_name` VARCHAR(100) NULL,
    `tax_type` ENUM('GST', 'TDS', 'VAT', 'Other') NULL,
    `rate` DECIMAL(5, 2) NULL,
    `description` TEXT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `company_id`(`company_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `discounts` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `voucher_entry_id` BIGINT NULL,
    `discount_type` ENUM('Allowed', 'Received') NULL,
    `amount` DECIMAL(15, 2) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `voucher_entry_id`(`voucher_entry_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `bills` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `vendor_id` BIGINT NULL,
    `voucher_id` BIGINT NULL,
    `total_amount` DECIMAL(15, 2) NULL,
    `outstanding_amount` DECIMAL(15, 2) NULL,
    `due_date` DATE NULL,
    `status` ENUM('Open', 'Partial', 'Closed') NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `vendor_id`(`vendor_id`),
    INDEX `voucher_id`(`voucher_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `bill_settlements` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `bill_id` BIGINT NULL,
    `payment_voucher_id` BIGINT NULL,
    `amount_paid` DECIMAL(15, 2) NULL,
    `discount_applied` DECIMAL(15, 2) NULL,
    `tds_deducted` DECIMAL(15, 2) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `bill_id`(`bill_id`),
    INDEX `payment_voucher_id`(`payment_voucher_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `items` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `item_name` VARCHAR(255) NULL,
    `sku` VARCHAR(100) NULL,
    `hsn_code` VARCHAR(50) NULL,
    `unit` VARCHAR(50) NULL,
    `opening_stock` DECIMAL(15, 2) NULL,
    `rate` DECIMAL(15, 2) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `company_id`(`company_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `voucher_items` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `voucher_id` BIGINT NULL,
    `item_id` BIGINT NULL,
    `qty` DECIMAL(15, 3) NULL,
    `rate` DECIMAL(15, 2) NULL,
    `discount` DECIMAL(15, 2) NULL,
    `tax_id` BIGINT NULL,
    `tax_amount` DECIMAL(15, 2) NULL,
    `total_amount` DECIMAL(15, 2) NULL,

    INDEX `item_id`(`item_id`),
    INDEX `tax_id`(`tax_id`),
    INDEX `voucher_id`(`voucher_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `attachments` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `voucher_id` BIGINT NULL,
    `quotation_id` BIGINT NULL,
    `order_id` BIGINT NULL,
    `return_id` BIGINT NULL,
    `file_url` VARCHAR(255) NULL,
    `file_type` VARCHAR(50) NULL,
    `uploaded_by` BIGINT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `uploaded_by`(`uploaded_by`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `audit_logs` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT NULL,
    `table_name` VARCHAR(100) NULL,
    `record_id` BIGINT NULL,
    `action` ENUM('INSERT', 'UPDATE', 'DELETE') NULL,
    `old_value` TEXT NULL,
    `new_value` TEXT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `user_id`(`user_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `approvals` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `voucher_id` BIGINT NULL,
    `approver_id` BIGINT NULL,
    `status` ENUM('Pending', 'Approved', 'Rejected') NULL,
    `remarks` TEXT NULL,
    `approved_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `approver_id`(`approver_id`),
    INDEX `voucher_id`(`voucher_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `workflows` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `voucher_type` ENUM('Sales', 'Purchase', 'Payment', 'Receipt', 'Journal', 'Contra', 'CreditNote', 'DebitNote') NULL,
    `min_amount` DECIMAL(15, 2) NULL,
    `approver_role` VARCHAR(100) NULL,
    `level` INTEGER NULL,

    INDEX `company_id`(`company_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `recurring_entries` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `voucher_template_id` BIGINT NULL,
    `frequency` ENUM('Daily', 'Weekly', 'Monthly', 'Yearly') NULL,
    `next_run` DATE NULL,
    `end_date` DATE NULL,
    `status` ENUM('Active', 'Stopped') NULL,

    INDEX `company_id`(`company_id`),
    INDEX `voucher_template_id`(`voucher_template_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `notifications` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `user_id` BIGINT NULL,
    `message` TEXT NULL,
    `type` ENUM('Alert', 'Reminder', 'Approval', 'Renewal') NULL,
    `is_read` BOOLEAN NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `company_id`(`company_id`),
    INDEX `user_id`(`user_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `plans` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `plan_name` VARCHAR(50) NULL,
    `currency` VARCHAR(3) NULL,
    `base_price` DECIMAL(10, 2) NULL,
    `total_price` DECIMAL(10, 2) NULL,
    `invoice_limit` INTEGER NULL,
    `user_limit` INTEGER NULL,
    `storage_capacity` VARCHAR(20) NULL,
    `billing_cycle` ENUM('Monthly', 'Yearly') NULL,
    `status` ENUM('Active', 'Inactive') NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `requested_plans` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `plan_id` BIGINT NULL,
    `billing` ENUM('Monthly', 'Yearly') NULL,
    `request_date` DATE NULL,
    `status` ENUM('Pending', 'Approved', 'Rejected') NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `company_id`(`company_id`),
    INDEX `plan_id`(`plan_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `payment_gateway_settings` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `gateway_name` VARCHAR(50) NULL,
    `status` ENUM('Active', 'Inactive') NULL,
    `api_key` VARCHAR(255) NULL,
    `publishable_key` VARCHAR(255) NULL,
    `secret_key` VARCHAR(255) NULL,
    `webhook_url` VARCHAR(255) NULL,
    `environment` ENUM('Test', 'Live') NULL,
    `updated_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `company_id`(`company_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `trial_balance` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `financial_year_id` BIGINT NULL,
    `account_id` BIGINT NULL,
    `total_debit` DECIMAL(15, 2) NULL,
    `total_credit` DECIMAL(15, 2) NULL,
    `closing_balance` DECIMAL(15, 2) NULL,
    `balance_type` ENUM('Debit', 'Credit') NULL,
    `generated_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `account_id`(`account_id`),
    INDEX `company_id`(`company_id`),
    INDEX `financial_year_id`(`financial_year_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `profit_loss` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `financial_year_id` BIGINT NULL,
    `period` VARCHAR(50) NULL,
    `total_income` DECIMAL(15, 2) NULL,
    `total_expense` DECIMAL(15, 2) NULL,
    `net_result` DECIMAL(15, 2) NULL,
    `generated_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `company_id`(`company_id`),
    INDEX `financial_year_id`(`financial_year_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `balance_sheet` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `financial_year_id` BIGINT NULL,
    `as_on_date` DATE NULL,
    `total_assets` DECIMAL(15, 2) NULL,
    `total_liabilities` DECIMAL(15, 2) NULL,
    `total_equity` DECIMAL(15, 2) NULL,
    `generated_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `company_id`(`company_id`),
    INDEX `financial_year_id`(`financial_year_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `cash_flow` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `financial_year_id` BIGINT NULL,
    `period` VARCHAR(50) NULL,
    `cash_in` DECIMAL(15, 2) NULL,
    `cash_out` DECIMAL(15, 2) NULL,
    `net_cash_flow` DECIMAL(15, 2) NULL,
    `generated_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `company_id`(`company_id`),
    INDEX `financial_year_id`(`financial_year_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `customer_ledger` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `customer_id` BIGINT NOT NULL,
    `date` DATE NOT NULL,
    `particulars` VARCHAR(255) NOT NULL,
    `vch_no` VARCHAR(30) NULL,
    `manual_voucher_no` VARCHAR(30) NULL,
    `vch_type` ENUM('Opening', 'Sales', 'Receipt', 'Sales Return', 'Payment', 'Adjustment') NULL,
    `debit` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `credit` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `running_balance` DECIMAL(15, 2) NOT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `idx_ledger_customer_date`(`customer_id`, `date`),
    INDEX `idx_ledger_type_date`(`customer_id`, `vch_type`, `date`),
    INDEX `idx_ledger_vchno`(`vch_no`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `vendor_ledger` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `vendor_id` BIGINT NULL,
    `voucher_id` BIGINT NULL,
    `date` DATE NULL,
    `particulars` VARCHAR(255) NULL,
    `vch_no` VARCHAR(50) NULL,
    `vch_type` ENUM('Purchase', 'Payment', 'DebitNote', 'CreditNote', 'Adjustment') NULL,
    `debit` DECIMAL(15, 2) NULL,
    `credit` DECIMAL(15, 2) NULL,
    `running_balance` DECIMAL(15, 2) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `vendor_id`(`vendor_id`),
    INDEX `voucher_id`(`voucher_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `dashboard_summary` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `total_sales` DECIMAL(15, 2) NULL,
    `total_purchases` DECIMAL(15, 2) NULL,
    `total_receivables` DECIMAL(15, 2) NULL,
    `total_payables` DECIMAL(15, 2) NULL,
    `total_expenses` DECIMAL(15, 2) NULL,
    `top_customer` VARCHAR(255) NULL,
    `low_stock_items` INTEGER NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `company_id`(`company_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `add_transactions` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `transaction_date` DATE NULL,
    `transaction_id` VARCHAR(50) NULL,
    `balance_type` ENUM('Receive', 'Pay') NULL,
    `voucher_type` ENUM('Sales', 'Purchase', 'Payment', 'Receipt', 'Journal', 'Contra', 'CreditNote', 'DebitNote') NULL,
    `voucher_no` VARCHAR(50) NULL,
    `amount` DECIMAL(15, 2) NULL,
    `from_account_id` BIGINT NULL,
    `to_account_id` BIGINT NULL,
    `customer_id` BIGINT NULL,
    `account_type` ENUM('Customer', 'Vendor', 'Bank', 'Cash', 'Other') NULL,
    `note` TEXT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    UNIQUE INDEX `transaction_id`(`transaction_id`),
    INDEX `company_id`(`company_id`),
    INDEX `customer_id`(`customer_id`),
    INDEX `from_account_id`(`from_account_id`),
    INDEX `to_account_id`(`to_account_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `bank_details` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `bank_name` VARCHAR(255) NOT NULL,
    `account_no` VARCHAR(100) NOT NULL,
    `account_holder` VARCHAR(255) NOT NULL,
    `ifsc_code` VARCHAR(50) NOT NULL,
    `notes` TEXT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    UNIQUE INDEX `account_no`(`account_no`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `categories` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `category_name` VARCHAR(100) NULL,
    `parent_id` BIGINT NULL,
    `description` TEXT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `company_id`(`company_id`),
    INDEX `parent_id`(`parent_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `company_settings` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_name` VARCHAR(255) NULL,
    `address` TEXT NULL,
    `contact` VARCHAR(50) NULL,
    `gstin` VARCHAR(20) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `contra_vouchers` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `auto_voucher_no` VARCHAR(50) NULL,
    `manual_voucher_no` VARCHAR(50) NULL,
    `voucher_date` DATE NULL,
    `account_from_id` BIGINT NULL,
    `account_to_id` BIGINT NULL,
    `amount` DECIMAL(15, 2) NULL,
    `upload_document` VARCHAR(255) NULL,
    `narration` TEXT NULL,
    `status` ENUM('Draft', 'Submitted', 'Approved', 'Rejected') NULL DEFAULT 'Draft',
    `created_by` BIGINT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `account_from_id`(`account_from_id`),
    INDEX `account_to_id`(`account_to_id`),
    INDEX `company_id`(`company_id`),
    INDEX `created_by`(`created_by`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `customer_balance_confirms` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `customer_id` BIGINT NOT NULL,
    `as_of_date` DATE NOT NULL,
    `opening_balance` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `total_debit` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `total_credit` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `current_balance` DECIMAL(15, 2) NOT NULL,
    `balance_type` ENUM('Debit', 'Credit') NULL,
    `letter_pdf_path` VARCHAR(500) NULL,
    `status` ENUM('draft', 'sent', 'confirmed') NULL DEFAULT 'draft',
    `confirmed_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `confirmed_by_user_id` BIGINT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT ('0000-00-00 00:00:00'),

    INDEX `idx_confirm_customer_date`(`customer_id`, `as_of_date`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `customer_ledger_items` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `ledger_id` BIGINT NOT NULL,
    `item_name` VARCHAR(255) NOT NULL,
    `qty` DECIMAL(10, 3) NOT NULL,
    `rate` DECIMAL(10, 2) NOT NULL,
    `discount_percent` DECIMAL(5, 2) NULL DEFAULT 0.00,
    `tax_percent` DECIMAL(5, 2) NULL DEFAULT 0.00,
    `tax_amount` DECIMAL(10, 2) NULL DEFAULT 0.00,
    `value` DECIMAL(10, 2) NOT NULL,
    `description` TEXT NULL,

    INDEX `idx_ledger_item`(`ledger_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `customers` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `voucher_no` INTEGER NOT NULL,
    `name_english` VARCHAR(255) NOT NULL,
    `name_arabic` VARCHAR(255) NULL,
    `company_name` VARCHAR(255) NULL,
    `google_location` VARCHAR(500) NULL,
    `id_card_image` VARCHAR(255) NULL,
    `any_file` VARCHAR(255) NULL,
    `account_type` ENUM('Sundry Debtors') NULL DEFAULT 'Sundry Debtors',
    `balance_type` ENUM('Debit', 'Credit') NULL DEFAULT 'Debit',
    `account_name` VARCHAR(100) NULL DEFAULT 'Accounts Receivable',
    `opening_balance` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `creation_date` DATE NULL,
    `bank_account_number` VARCHAR(50) NULL,
    `bank_ifsc` VARCHAR(20) NULL,
    `bank_name_branch` VARCHAR(255) NULL,
    `country` VARCHAR(100) NULL,
    `state` VARCHAR(100) NULL,
    `pincode` VARCHAR(10) NULL,
    `address` TEXT NULL,
    `state_code` VARCHAR(10) NULL,
    `shipping_address` TEXT NULL,
    `phone` VARCHAR(20) NULL,
    `email` VARCHAR(255) NULL,
    `gstin` VARCHAR(20) NULL,
    `credit_period_days` INTEGER NULL DEFAULT 0,
    `is_active` BOOLEAN NULL DEFAULT true,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` TIMESTAMP(0) NOT NULL DEFAULT ('0000-00-00 00:00:00'),

    UNIQUE INDEX `voucher_no`(`voucher_no`),
    INDEX `idx_cust_email`(`email`),
    INDEX `idx_cust_name`(`name_english`),
    INDEX `idx_cust_phone`(`phone`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `delivery_challan_items` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `challan_id` BIGINT NULL,
    `item_id` BIGINT NULL,
    `delivered_qty` DECIMAL(15, 3) NULL,
    `rate` DECIMAL(15, 2) NULL,
    `tax_percent` DECIMAL(5, 2) NULL,
    `discount` DECIMAL(15, 2) NULL,
    `amount` DECIMAL(15, 2) NULL,

    INDEX `challan_id`(`challan_id`),
    INDEX `item_id`(`item_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `delivery_challans` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `order_id` BIGINT NULL,
    `challan_no` VARCHAR(50) NULL,
    `manual_ref_no` VARCHAR(50) NULL,
    `challan_date` DATE NULL,
    `driver_name` VARCHAR(100) NULL,
    `driver_phone` VARCHAR(20) NULL,
    `vehicle_no` VARCHAR(50) NULL,
    `total_amount` DECIMAL(15, 2) NULL,
    `terms` TEXT NULL,
    `status` ENUM('Draft', 'Dispatched', 'Delivered', 'Returned') NULL,
    `created_by` BIGINT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `company_id`(`company_id`),
    INDEX `created_by`(`created_by`),
    INDEX `order_id`(`order_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `eway_bill_items` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `ewb_id` BIGINT NOT NULL,
    `product_id` BIGINT NULL,
    `product_name` VARCHAR(255) NOT NULL,
    `hsn_code` VARCHAR(20) NULL,
    `qty` DECIMAL(12, 3) NOT NULL,
    `uqc` VARCHAR(20) NULL,
    `taxable_value` DECIMAL(15, 2) NOT NULL,
    `cgst_percent` DECIMAL(5, 2) NULL DEFAULT 0.00,
    `sgst_percent` DECIMAL(5, 2) NULL DEFAULT 0.00,
    `igst_percent` DECIMAL(5, 2) NULL DEFAULT 0.00,
    `cgst_amount` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `sgst_amount` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `igst_amount` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `total_value` DECIMAL(15, 2) NULL,
    `remark` VARCHAR(255) NULL,

    INDEX `idx_ewb_items_header`(`ewb_id`),
    INDEX `product_id`(`product_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `eway_bills` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NOT NULL,
    `ewb_no` VARCHAR(20) NOT NULL,
    `generated_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `valid_from` TIMESTAMP(0) NOT NULL DEFAULT ('0000-00-00 00:00:00'),
    `valid_upto` TIMESTAMP(0) NOT NULL DEFAULT ('0000-00-00 00:00:00'),
    `doc_type` ENUM('INV', 'BILTI', 'CHALLAN', 'OTHERS') NULL,
    `doc_no` VARCHAR(50) NULL,
    `doc_date` DATE NULL,
    `from_gstin` VARCHAR(20) NULL,
    `from_trade_name` VARCHAR(255) NULL,
    `from_address1` VARCHAR(255) NULL,
    `from_address2` VARCHAR(255) NULL,
    `from_place` VARCHAR(100) NULL,
    `from_pincode` VARCHAR(10) NULL,
    `from_state_code` VARCHAR(5) NULL,
    `to_gstin` VARCHAR(20) NULL,
    `to_trade_name` VARCHAR(255) NULL,
    `to_address1` VARCHAR(255) NULL,
    `to_address2` VARCHAR(255) NULL,
    `to_place` VARCHAR(100) NULL,
    `to_pincode` VARCHAR(10) NULL,
    `to_state_code` VARCHAR(5) NULL,
    `transporter_id` VARCHAR(50) NULL,
    `transporter_name` VARCHAR(255) NULL,
    `transport_mode` ENUM('Road', 'Rail', 'Air', 'Ship') NOT NULL DEFAULT 'Road',
    `vehicle_no` VARCHAR(20) NULL,
    `distance_km` INTEGER NULL,
    `approx_value` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `taxable_value` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `igst_amount` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `cgst_amount` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `sgst_amount` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `status` ENUM('Active', 'Cancelled', 'Expired') NULL DEFAULT 'Active',
    `cancel_reason` VARCHAR(255) NULL,
    `cancelled_at` TIMESTAMP(0) NOT NULL DEFAULT ('0000-00-00 00:00:00'),
    `created_by_user` BIGINT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    UNIQUE INDEX `ewb_no`(`ewb_no`),
    INDEX `idx_ewb_company_date`(`company_id`, `generated_at`),
    INDEX `idx_ewb_from_gstin_date`(`from_gstin`, `generated_at`),
    INDEX `idx_ewb_to_gstin_date`(`to_gstin`, `generated_at`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `expense_voucher_filters` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `expense_voucher_id` BIGINT NULL,
    `filter_type` ENUM('PaymentNo', 'Account', 'PaidFrom', 'ManualReceiptNo') NULL,
    `filter_value` VARCHAR(255) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `expense_voucher_id`(`expense_voucher_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `expense_voucher_items` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `expense_voucher_id` BIGINT NULL,
    `account_id` BIGINT NULL,
    `amount` DECIMAL(15, 2) NULL,
    `narration` TEXT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `account_id`(`account_id`),
    INDEX `expense_voucher_id`(`expense_voucher_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `expense_vouchers` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `auto_receipt_no` VARCHAR(50) NULL,
    `manual_receipt_no` VARCHAR(50) NULL,
    `voucher_date` DATE NULL,
    `paid_from` ENUM('Cash', 'Bank Transfer', 'Credit Card', 'Paypal') NULL,
    `paid_to_account_id` BIGINT NULL,
    `total_amount` DECIMAL(15, 2) NULL,
    `voucher_narration` TEXT NULL,
    `status` ENUM('Draft', 'Submitted', 'Approved', 'Rejected') NULL,
    `created_by` BIGINT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `company_id`(`company_id`),
    INDEX `created_by`(`created_by`),
    INDEX `paid_to_account_id`(`paid_to_account_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `goods_receipt_items` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `goods_receipt_id` BIGINT NULL,
    `order_item_id` BIGINT NULL,
    `item_id` BIGINT NULL,
    `item_name` VARCHAR(255) NULL,
    `ordered_qty` DECIMAL(15, 3) NULL,
    `received_qty` DECIMAL(15, 3) NULL,
    `pending_qty` DECIMAL(15, 3) NULL,
    `rate` DECIMAL(15, 2) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `goods_receipt_id`(`goods_receipt_id`),
    INDEX `item_id`(`item_id`),
    INDEX `order_item_id`(`order_item_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `goods_receipts` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `purchase_order_id` BIGINT NULL,
    `grn_no` VARCHAR(50) NULL,
    `receipt_date` DATE NULL,
    `warehouse_id` BIGINT NULL,
    `grn_note` TEXT NULL,
    `received_by` BIGINT NULL,
    `signature_url` VARCHAR(255) NULL,
    `photo_url` VARCHAR(255) NULL,
    `status` ENUM('Draft', 'Received', 'PartiallyReceived', 'Cancelled') NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` TIMESTAMP(0) NOT NULL DEFAULT ('0000-00-00 00:00:00'),

    INDEX `company_id`(`company_id`),
    INDEX `purchase_order_id`(`purchase_order_id`),
    INDEX `received_by`(`received_by`),
    INDEX `warehouse_id`(`warehouse_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `gst_returns` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NOT NULL,
    `period` VARCHAR(20) NOT NULL,
    `return_type` ENUM('GSTR-1', 'GSTR-2A', 'GSTR-3B') NOT NULL,
    `due_date` DATE NOT NULL,
    `taxable_value` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `igst_amount` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `cgst_amount` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `sgst_amount` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `status` ENUM('Filed', 'Not Filed', 'In Progress', 'Error') NULL DEFAULT 'Not Filed',
    `filed_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `filed_by_user` BIGINT NULL,
    `remarks` VARCHAR(500) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    UNIQUE INDEX `ux_gst_period_type`(`company_id`, `period`, `return_type`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `income_voucher_filters` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `income_voucher_id` BIGINT NULL,
    `filter_type` ENUM('ReceiptNo', 'Account', 'DepositedTo') NULL,
    `filter_value` VARCHAR(255) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `income_voucher_id`(`income_voucher_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `income_voucher_items` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `income_voucher_id` BIGINT NULL,
    `income_account_id` BIGINT NULL,
    `amount` DECIMAL(15, 2) NULL,
    `row_narration` TEXT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `income_account_id`(`income_account_id`),
    INDEX `income_voucher_id`(`income_voucher_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `income_vouchers` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `auto_receipt_no` VARCHAR(50) NULL,
    `manual_receipt_no` VARCHAR(50) NULL,
    `voucher_date` DATE NULL,
    `deposited_to` ENUM('Cash', 'Bank Account', 'Credit Card', 'Online Payment') NULL,
    `received_from_id` BIGINT NULL,
    `total_amount` DECIMAL(15, 2) NULL,
    `voucher_narration` TEXT NULL,
    `status` ENUM('Draft', 'Submitted', 'Approved', 'Rejected') NULL,
    `created_by` BIGINT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `company_id`(`company_id`),
    INDEX `created_by`(`created_by`),
    INDEX `received_from_id`(`received_from_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `inventory_ledger` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `product_id` BIGINT NULL,
    `warehouse_id` BIGINT NULL,
    `transaction_type` ENUM('Purchase', 'Sale', 'Transfer', 'Adjustment') NULL,
    `ref_voucher_id` BIGINT NULL,
    `qty_in` DECIMAL(15, 3) NULL,
    `qty_out` DECIMAL(15, 3) NULL,
    `balance_qty` DECIMAL(15, 3) NULL,
    `rate` DECIMAL(15, 2) NULL,
    `value` DECIMAL(15, 2) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `product_id`(`product_id`),
    INDEX `ref_voucher_id`(`ref_voucher_id`),
    INDEX `warehouse_id`(`warehouse_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `invoice_items` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `invoice_id` BIGINT NULL,
    `product_name` VARCHAR(255) NULL,
    `price` DECIMAL(15, 2) NULL,
    `qty` INTEGER NULL,
    `tax_amount` DECIMAL(15, 2) NULL,
    `tax_rate` DECIMAL(5, 2) NULL,
    `discount_amount` DECIMAL(15, 2) NULL,
    `discount_type` ENUM('Flat', 'Percentage') NULL,
    `total_amount` DECIMAL(15, 2) NULL,

    INDEX `invoice_id`(`invoice_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `invoices` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `invoice_no` VARCHAR(50) NULL,
    `reference_no` VARCHAR(50) NULL,
    `customer_id` BIGINT NULL,
    `gross_amount` DECIMAL(15, 2) NULL,
    `invoice_date` DATE NULL,
    `due_date` DATE NULL,
    `terms` VARCHAR(255) NULL,
    `status` ENUM('Paid', 'Unpaid', 'Partial', 'Overdue') NULL,
    `payment_status` ENUM('Paid', 'Unpaid', 'Partial') NULL,
    `payment_method` ENUM('Cash', 'Card', 'BankTransfer', 'Online', 'Other') NULL,
    `notes` TEXT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    UNIQUE INDEX `invoice_no`(`invoice_no`),
    INDEX `customer_id`(`customer_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `itc_entries` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NOT NULL,
    `vendor_id` BIGINT NULL,
    `vendor_name` VARCHAR(255) NULL,
    `vendor_gstin` VARCHAR(20) NULL,
    `invoice_no` VARCHAR(50) NOT NULL,
    `invoice_date` DATE NOT NULL,
    `invoice_amount` DECIMAL(15, 2) NOT NULL,
    `cgst_amount` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `sgst_amount` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `igst_amount` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `total_itc` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `status` ENUM('Claimed', 'Pending') NULL DEFAULT 'Pending',
    `claimed_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `note` VARCHAR(255) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `idx_itc_status_date`(`company_id`, `status`, `invoice_date`),
    INDEX `vendor_id`(`vendor_id`),
    UNIQUE INDEX `ux_itc_vendor_invoice`(`company_id`, `vendor_gstin`, `invoice_no`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `ledger_entries` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `account_id` BIGINT NULL,
    `date` DATE NULL,
    `particulars` VARCHAR(255) NULL,
    `vch_no` VARCHAR(20) NULL,
    `ref_no` VARCHAR(20) NULL,
    `vch_type` ENUM('Sales', 'Payment', 'Receipt', 'Purchase', 'Adjustment') NULL,
    `debit` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `credit` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `running_balance` DECIMAL(15, 2) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `account_id`(`account_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `modules` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `module_name` VARCHAR(100) NULL,
    `description` TEXT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    UNIQUE INDEX `module_name`(`module_name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `order_headers` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `order_type` ENUM('Sales', 'Purchase') NOT NULL,
    `customer_id` BIGINT NULL,
    `vendor_id` BIGINT NULL,
    `order_no` VARCHAR(50) NULL,
    `manual_order_no` VARCHAR(50) NULL,
    `order_date` DATE NULL,
    `sub_total` DECIMAL(18, 2) NULL,
    `total_tax` DECIMAL(18, 2) NULL,
    `total_discount` DECIMAL(18, 2) NULL,
    `grand_total` DECIMAL(18, 2) NULL,
    `notes` TEXT NULL,
    `terms_conditions` TEXT NULL,
    `bank_name` VARCHAR(255) NULL,
    `account_number` VARCHAR(50) NULL,
    `account_holder` VARCHAR(255) NULL,
    `ifsc_code` VARCHAR(20) NULL,
    `status` ENUM('Draft', 'Confirmed', 'PartiallyDelivered', 'Delivered', 'Cancelled') NULL,
    `created_by` BIGINT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` TIMESTAMP(0) NOT NULL DEFAULT ('0000-00-00 00:00:00'),

    INDEX `company_id`(`company_id`),
    INDEX `created_by`(`created_by`),
    INDEX `customer_id`(`customer_id`),
    INDEX `vendor_id`(`vendor_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `order_items` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `order_id` BIGINT NULL,
    `item_id` BIGINT NULL,
    `item_name` VARCHAR(255) NULL,
    `qty` DECIMAL(15, 3) NULL,
    `rate` DECIMAL(15, 2) NULL,
    `tax_percent` DECIMAL(5, 2) NULL,
    `discount_percent` DECIMAL(5, 2) NULL,
    `discount_amount` DECIMAL(15, 2) NULL,
    `tax_amount` DECIMAL(15, 2) NULL,
    `amount` DECIMAL(18, 2) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `item_id`(`item_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `permissions` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NULL,
    `description` TEXT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `pos_order_items` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `order_id` BIGINT NOT NULL,
    `product_id` BIGINT NULL,
    `product_sku` VARCHAR(64) NULL,
    `product_name` VARCHAR(255) NULL,
    `uom` VARCHAR(50) NULL,
    `warehouse_id` BIGINT NOT NULL,
    `qty` DECIMAL(12, 3) NOT NULL,
    `unit_price` DECIMAL(15, 4) NOT NULL,
    `line_discount_pct` DECIMAL(5, 2) NULL DEFAULT 0.00,
    `line_discount_amt` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `line_subtotal` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `tax_percent` DECIMAL(5, 2) NULL DEFAULT 0.00,
    `tax_amount` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `line_total` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `remark` VARCHAR(255) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `idx_pos_items_order`(`order_id`),
    INDEX `idx_pos_items_wh_prod`(`warehouse_id`, `product_id`, `order_id`),
    INDEX `product_id`(`product_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `pos_orders` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `order_no` VARCHAR(30) NOT NULL,
    `order_datetime` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `customer_id` BIGINT NULL,
    `currency_code` VARCHAR(10) NULL,
    `subtotal` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `discount_total` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `tax_class_id` BIGINT NULL,
    `tax_percent` DECIMAL(5, 2) NULL DEFAULT 0.00,
    `tax_amount` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `round_off` DECIMAL(6, 2) NULL DEFAULT 0.00,
    `grand_total` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `amount_paid` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `amount_due` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `payment_status` ENUM('Due', 'Partial', 'Paid') NULL DEFAULT 'Due',
    `notes` TEXT NULL,
    `sales_invoice_id` BIGINT NULL,
    `created_by_user` BIGINT NULL,
    `updated_by_user` BIGINT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    UNIQUE INDEX `order_no`(`order_no`),
    INDEX `idx_pos_order_customer_date`(`customer_id`, `order_datetime`),
    INDEX `tax_class_id`(`tax_class_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `pos_payments` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `order_id` BIGINT NOT NULL,
    `method` ENUM('Cash', 'Card', 'UPI', 'Bank Transfer', 'Cheque', 'Wallet', 'Other') NOT NULL,
    `amount` DECIMAL(15, 2) NOT NULL,
    `paid_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `reference_no` VARCHAR(100) NULL,
    `status` ENUM('completed', 'refunded', 'void') NULL DEFAULT 'completed',
    `cash_tendered` DECIMAL(15, 2) NULL,
    `change_returned` DECIMAL(15, 2) NULL,
    `received_by_user` BIGINT NULL,
    `note` VARCHAR(255) NULL,

    INDEX `idx_pos_payment_order_date`(`order_id`, `paid_at`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `product_import_export_logs` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `file_name` VARCHAR(255) NULL,
    `action` ENUM('Import', 'Export', 'DownloadTemplate') NULL,
    `total_records` INTEGER NULL,
    `success_count` INTEGER NULL,
    `failed_count` INTEGER NULL,
    `processed_by` BIGINT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `company_id`(`company_id`),
    INDEX `processed_by`(`processed_by`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `products` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `warehouse_id` BIGINT NULL,
    `category_id` BIGINT NULL,
    `unit_id` BIGINT NULL,
    `product_name` VARCHAR(255) NULL,
    `sku` VARCHAR(100) NULL,
    `hsn_code` VARCHAR(50) NULL,
    `barcode` VARCHAR(100) NULL,
    `brand` VARCHAR(100) NULL,
    `model_no` VARCHAR(100) NULL,
    `color` VARCHAR(50) NULL,
    `material` VARCHAR(100) NULL,
    `size` VARCHAR(50) NULL,
    `stock_quantity` DECIMAL(15, 3) NULL,
    `reorder_level` DECIMAL(15, 3) NULL,
    `purchase_rate` DECIMAL(15, 2) NULL,
    `selling_rate` DECIMAL(15, 2) NULL,
    `tax_id` BIGINT NULL,
    `status` ENUM('InStock', 'OutOfStock', 'Inactive') NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `category_id`(`category_id`),
    INDEX `company_id`(`company_id`),
    INDEX `tax_id`(`tax_id`),
    INDEX `unit_id`(`unit_id`),
    INDEX `warehouse_id`(`warehouse_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `purchase_bills` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `vendor_id` BIGINT NULL,
    `bill_no` VARCHAR(50) NULL,
    `bill_date` DATE NULL,
    `due_date` DATE NULL,
    `total_amount` DECIMAL(18, 2) NULL,
    `outstanding_amount` DECIMAL(18, 2) NULL,
    `status` ENUM('Open', 'Partial', 'Closed') NULL,
    `notes` TEXT NULL,
    `terms_conditions` TEXT NULL,
    `attachment_urls` LONGTEXT NULL,
    `created_by` BIGINT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `company_id`(`company_id`),
    INDEX `created_by`(`created_by`),
    INDEX `vendor_id`(`vendor_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `purchase_quotations` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `vendor_id` BIGINT NULL,
    `reference_no` VARCHAR(50) NULL,
    `manual_ref_no` VARCHAR(50) NULL,
    `quotation_no` VARCHAR(50) NULL,
    `quotation_date` DATE NULL,
    `valid_till` DATE NULL,
    `sub_total` DECIMAL(18, 2) NULL,
    `total_tax` DECIMAL(18, 2) NULL,
    `total_discount` DECIMAL(18, 2) NULL,
    `grand_total` DECIMAL(18, 2) NULL,
    `notes` TEXT NULL,
    `terms_conditions` TEXT NULL,
    `bank_name` VARCHAR(255) NULL,
    `account_number` VARCHAR(50) NULL,
    `account_holder` VARCHAR(255) NULL,
    `ifsc_code` VARCHAR(20) NULL,
    `signature_url` VARCHAR(255) NULL,
    `photo_url` VARCHAR(255) NULL,
    `status` ENUM('Draft', 'Sent', 'Accepted', 'Rejected', 'Converted') NULL DEFAULT 'Draft',
    `created_by` BIGINT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` TIMESTAMP(0) NOT NULL DEFAULT ('0000-00-00 00:00:00'),

    INDEX `company_id`(`company_id`),
    INDEX `created_by`(`created_by`),
    INDEX `vendor_id`(`vendor_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `purchase_report` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `choose_date` DATE NULL,
    `vendor_id` BIGINT NULL,
    `category` VARCHAR(100) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `vendor_id`(`vendor_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `receipt_discounts` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `receipt_id` BIGINT NULL,
    `discount_type` ENUM('Basic Salary', 'Cartage', 'Commission Given', 'Currency Exchange Expenses', 'Customs Clearance', 'Discount on Sale', 'Employee State Insurance Corporation', 'Freight Charge', 'House Rent Allowance (HRA)', 'Indices CS Expenses', 'Medical Allowance (MA)', 'Rubber Expenses', 'Special Allowance (SA)') NULL,
    `discount_percent` DECIMAL(6, 3) NULL,
    `sub_total_before_discount` DECIMAL(15, 2) NULL,
    `discount_value` DECIMAL(15, 2) NULL,
    `sub_total_after_discount` DECIMAL(15, 2) NULL,
    `total_amount` DECIMAL(15, 2) NULL,
    `narration` TEXT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `receipt_id`(`receipt_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `receipt_invoice_payments` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `receipt_id` BIGINT NULL,
    `account_id` BIGINT NULL,
    `description` VARCHAR(255) NULL,
    `total_invoice_amount` DECIMAL(15, 2) NULL,
    `outstanding_amount` DECIMAL(15, 2) NULL,
    `pay_amount` DECIMAL(15, 2) NULL,
    `is_selected` BOOLEAN NULL,
    `advance_payment` DECIMAL(15, 2) NULL,
    `final_amount` DECIMAL(15, 2) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `account_id`(`account_id`),
    INDEX `receipt_id`(`receipt_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `receipt_taxes` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `receipt_id` BIGINT NULL,
    `tax_percent` DECIMAL(6, 3) NULL,
    `sub_total` DECIMAL(15, 2) NULL,
    `total_amount` DECIMAL(15, 2) NULL,
    `narration` TEXT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `receipt_id`(`receipt_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `received_from_customer` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `receipt_no_auto` VARCHAR(50) NULL,
    `receipt_no_manual` VARCHAR(50) NULL,
    `voucher_date` DATE NULL,
    `received_into` ENUM('Cash', 'Bank', 'Shop', 'Account') NULL,
    `received_from` BIGINT NULL,
    `upload_document` VARCHAR(255) NULL,
    `receipt_type` ENUM('Invoice', 'Discount', 'TaxDeducted') NULL,
    `narration` TEXT NULL,
    `sub_total` DECIMAL(15, 2) NULL,
    `total_amount` DECIMAL(15, 2) NULL,
    `created_by` BIGINT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `company_id`(`company_id`),
    INDEX `created_by`(`created_by`),
    INDEX `received_from`(`received_from`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `return_items` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `return_id` BIGINT NULL,
    `product_id` BIGINT NULL,
    `qty` DECIMAL(15, 2) NULL,
    `rate` DECIMAL(15, 2) NULL,
    `tax_id` BIGINT NULL,
    `tax_amount` DECIMAL(15, 2) NULL,
    `discount_amount` DECIMAL(15, 2) NULL,
    `discount_type` ENUM('Flat', 'Percentage') NULL,
    `total_amount` DECIMAL(15, 2) NULL,

    INDEX `product_id`(`product_id`),
    INDEX `return_id`(`return_id`),
    INDEX `tax_id`(`tax_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `returns` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `return_no` VARCHAR(50) NULL,
    `reference_no` VARCHAR(50) NULL,
    `invoice_no` VARCHAR(50) NULL,
    `return_date` DATE NULL,
    `return_type` ENUM('Sales', 'Purchase') NULL,
    `customer_id` BIGINT NULL,
    `vendor_id` BIGINT NULL,
    `warehouse_id` BIGINT NULL,
    `reason` TEXT NULL,
    `status` ENUM('Open', 'Processed', 'Closed') NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    UNIQUE INDEX `return_no`(`return_no`),
    INDEX `customer_id`(`customer_id`),
    INDEX `vendor_id`(`vendor_id`),
    INDEX `warehouse_id`(`warehouse_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `role_history` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `role_id` BIGINT NULL,
    `changed_by` BIGINT NULL,
    `old_permissions` TEXT NULL,
    `new_permissions` TEXT NULL,
    `changed_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `changed_by`(`changed_by`),
    INDEX `role_id`(`role_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `role_permissions` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `role_id` BIGINT NULL,
    `module_id` BIGINT NULL,
    `permission_id` BIGINT NULL,
    `granted` BOOLEAN NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `module_id`(`module_id`),
    INDEX `permission_id`(`permission_id`),
    INDEX `role_id`(`role_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `roles` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `role_name` VARCHAR(100) NULL,
    `role_type` ENUM('User', 'System') NULL,
    `status` ENUM('Active', 'Inactive') NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` TIMESTAMP(0) NOT NULL DEFAULT ('0000-00-00 00:00:00'),

    UNIQUE INDEX `role_name`(`role_name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `sales_attachments` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `reference_type` ENUM('Quotation', 'Order', 'Challan', 'Invoice', 'Payment') NULL,
    `reference_id` BIGINT NULL,
    `file_url` VARCHAR(255) NULL,
    `file_type` VARCHAR(50) NULL,
    `uploaded_by` BIGINT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `uploaded_by`(`uploaded_by`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `sales_invoice_items` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `invoice_id` BIGINT NULL,
    `item_id` BIGINT NULL,
    `qty` DECIMAL(15, 3) NULL,
    `rate` DECIMAL(15, 2) NULL,
    `tax_percent` DECIMAL(5, 2) NULL,
    `discount` DECIMAL(15, 2) NULL,
    `amount` DECIMAL(15, 2) NULL,

    INDEX `invoice_id`(`invoice_id`),
    INDEX `item_id`(`item_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `sales_invoices` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `order_id` BIGINT NULL,
    `challan_id` BIGINT NULL,
    `invoice_no` VARCHAR(50) NULL,
    `manual_ref_no` VARCHAR(50) NULL,
    `invoice_date` DATE NULL,
    `due_date` DATE NULL,
    `total_amount` DECIMAL(15, 2) NULL,
    `tax_amount` DECIMAL(15, 2) NULL,
    `discount_amount` DECIMAL(15, 2) NULL,
    `grand_total` DECIMAL(15, 2) NULL,
    `terms` TEXT NULL,
    `notes` TEXT NULL,
    `status` ENUM('Draft', 'Unpaid', 'PartiallyPaid', 'Paid', 'Cancelled') NULL,
    `created_by` BIGINT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `challan_id`(`challan_id`),
    INDEX `company_id`(`company_id`),
    INDEX `created_by`(`created_by`),
    INDEX `order_id`(`order_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `sales_order_items` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `order_id` BIGINT NULL,
    `item_id` BIGINT NULL,
    `qty` DECIMAL(15, 3) NULL,
    `rate` DECIMAL(15, 2) NULL,
    `tax_percent` DECIMAL(5, 2) NULL,
    `discount` DECIMAL(15, 2) NULL,
    `amount` DECIMAL(15, 2) NULL,

    INDEX `item_id`(`item_id`),
    INDEX `order_id`(`order_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `sales_orders` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `quotation_id` BIGINT NULL,
    `order_no` VARCHAR(50) NULL,
    `manual_ref_no` VARCHAR(50) NULL,
    `order_date` DATE NULL,
    `total_amount` DECIMAL(15, 2) NULL,
    `tax_amount` DECIMAL(15, 2) NULL,
    `discount_amount` DECIMAL(15, 2) NULL,
    `grand_total` DECIMAL(15, 2) NULL,
    `billing_name` VARCHAR(255) NULL,
    `billing_address` TEXT NULL,
    `shipping_name` VARCHAR(255) NULL,
    `shipping_address` TEXT NULL,
    `terms` TEXT NULL,
    `status` ENUM('Draft', 'Confirmed', 'PartiallyDelivered', 'Completed', 'Cancelled') NULL,
    `created_by` BIGINT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `company_id`(`company_id`),
    INDEX `created_by`(`created_by`),
    INDEX `quotation_id`(`quotation_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `sales_payments` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `invoice_id` BIGINT NULL,
    `payment_no` VARCHAR(50) NULL,
    `manual_ref_no` VARCHAR(50) NULL,
    `payment_date` DATE NULL,
    `payment_method` ENUM('Cash', 'UPI', 'BankTransfer', 'Card', 'Cheque', 'Other') NULL,
    `total_invoice_amount` DECIMAL(15, 2) NULL,
    `amount_received` DECIMAL(15, 2) NULL,
    `balance_amount` DECIMAL(15, 2) NULL,
    `notes` TEXT NULL,
    `status` ENUM('Pending', 'Completed', 'Failed') NULL,
    `created_by` BIGINT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `company_id`(`company_id`),
    INDEX `created_by`(`created_by`),
    INDEX `invoice_id`(`invoice_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `sales_quotation_items` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `quotation_id` BIGINT NULL,
    `item_id` BIGINT NULL,
    `qty` DECIMAL(15, 3) NULL,
    `rate` DECIMAL(15, 2) NULL,
    `tax_percent` DECIMAL(5, 2) NULL,
    `discount` DECIMAL(15, 2) NULL,
    `amount` DECIMAL(15, 2) NULL,

    INDEX `item_id`(`item_id`),
    INDEX `quotation_id`(`quotation_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `sales_quotations` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `customer_id` BIGINT NULL,
    `quotation_no` VARCHAR(50) NULL,
    `manual_ref_no` VARCHAR(50) NULL,
    `quotation_date` DATE NULL,
    `valid_till` DATE NULL,
    `total_amount` DECIMAL(15, 2) NULL,
    `tax_amount` DECIMAL(15, 2) NULL,
    `discount_amount` DECIMAL(15, 2) NULL,
    `grand_total` DECIMAL(15, 2) NULL,
    `notes` TEXT NULL,
    `terms` TEXT NULL,
    `status` ENUM('Draft', 'Sent', 'Accepted', 'Rejected', 'Converted') NULL,
    `created_by` BIGINT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `company_id`(`company_id`),
    INDEX `created_by`(`created_by`),
    INDEX `customer_id`(`customer_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `sales_report` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `choose_date` DATE NULL,
    `category` ENUM('All', 'Computers', 'Electronics', 'Shoe') NULL,
    `customer_id` BIGINT NULL,
    `product_id` BIGINT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `customer_id`(`customer_id`),
    INDEX `product_id`(`product_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `sales_return_audit` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `sales_return_id` BIGINT NULL,
    `action` ENUM('Created', 'Updated', 'Approved', 'Rejected', 'Deleted') NULL,
    `remarks` TEXT NULL,
    `user_id` BIGINT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `sales_return_id`(`sales_return_id`),
    INDEX `user_id`(`user_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `sales_return_items` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `sales_return_id` BIGINT NULL,
    `product_id` BIGINT NULL,
    `qty_returned` DECIMAL(15, 3) NULL,
    `unit_rate` DECIMAL(15, 2) NULL,
    `amount` DECIMAL(15, 2) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `product_id`(`product_id`),
    INDEX `sales_return_id`(`sales_return_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `sales_returns` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `reference_id` VARCHAR(50) NULL,
    `manual_voucher_no` VARCHAR(50) NULL,
    `auto_voucher_no` VARCHAR(50) NULL,
    `return_no` VARCHAR(50) NULL,
    `invoice_id` BIGINT NULL,
    `customer_id` BIGINT NULL,
    `warehouse_id` BIGINT NULL,
    `return_date` DATE NULL,
    `return_type` ENUM('Sales Return', 'Replacement', 'Other') NULL,
    `reason_for_return` TEXT NULL,
    `total_items` INTEGER NULL,
    `total_value` DECIMAL(15, 2) NULL,
    `status` ENUM('Draft', 'Pending Inspection', 'Approved', 'Rejected', 'Completed') NULL,
    `created_by` BIGINT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `company_id`(`company_id`),
    INDEX `created_by`(`created_by`),
    INDEX `customer_id`(`customer_id`),
    INDEX `invoice_id`(`invoice_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `services` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `service_name` VARCHAR(255) NULL,
    `sku` VARCHAR(100) NULL,
    `description` TEXT NULL,
    `unit` VARCHAR(50) NULL,
    `price` DECIMAL(15, 2) NULL,
    `default_tax_rate` DECIMAL(5, 2) NULL,
    `is_available_in_invoice` BOOLEAN NULL DEFAULT true,
    `remarks` TEXT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `company_id`(`company_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `stock_transfer_items` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `stock_transfer_id` BIGINT NULL,
    `item_id` BIGINT NULL,
    `source_warehouse_id` BIGINT NULL,
    `qty` DECIMAL(15, 3) NOT NULL,
    `rate` DECIMAL(15, 2) NOT NULL,
    `amount` DECIMAL(15, 2) NOT NULL,
    `narration` TEXT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `item_id`(`item_id`),
    INDEX `source_warehouse_id`(`source_warehouse_id`),
    INDEX `stock_transfer_id`(`stock_transfer_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `stock_transfers` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `system_voucher_no` VARCHAR(50) NOT NULL,
    `manual_voucher_no` VARCHAR(50) NULL,
    `voucher_date` DATE NOT NULL,
    `source_warehouse_id` BIGINT NULL,
    `destination_warehouse_id` BIGINT NULL,
    `narration` TEXT NULL,
    `additional_note` TEXT NULL,
    `total_amount` DECIMAL(15, 2) NULL DEFAULT 0.00,
    `status` ENUM('Draft', 'Saved', 'Approved', 'Completed') NULL DEFAULT 'Draft',
    `created_by` BIGINT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `voucher_id` BIGINT NULL,

    INDEX `company_id`(`company_id`),
    INDEX `created_by`(`created_by`),
    INDEX `destination_warehouse_id`(`destination_warehouse_id`),
    INDEX `source_warehouse_id`(`source_warehouse_id`),
    INDEX `voucher_id`(`voucher_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tax_classes` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `percent` DECIMAL(5, 2) NOT NULL,
    `is_active` BOOLEAN NULL DEFAULT true,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tds_tcs_entries` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NOT NULL,
    `type` ENUM('TDS', 'TCS') NOT NULL,
    `customer_id` BIGINT NULL,
    `vendor_id` BIGINT NULL,
    `party_name` VARCHAR(255) NULL,
    `pan` VARCHAR(15) NULL,
    `amount` DECIMAL(15, 2) NOT NULL,
    `rate_percent` DECIMAL(6, 3) NOT NULL,
    `tax_amount` DECIMAL(15, 2) NOT NULL,
    `entry_date` DATE NOT NULL,
    `reference_no` VARCHAR(50) NULL,
    `note` VARCHAR(255) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `customer_id`(`customer_id`),
    INDEX `idx_tds_date`(`company_id`, `entry_date`),
    INDEX `idx_tds_pan_date`(`pan`, `entry_date`),
    INDEX `idx_tds_type_date`(`type`, `entry_date`),
    INDEX `vendor_id`(`vendor_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `terms_conditions` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `invoice_id` BIGINT NULL,
    `condition_text` TEXT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `invoice_id`(`invoice_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `units` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `unit_name` VARCHAR(50) NULL,
    `short_code` VARCHAR(10) NULL,
    `description` TEXT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `company_id`(`company_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `vendor_payment_bills` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `vendor_payment_id` BIGINT NULL,
    `supplier_account_id` BIGINT NULL,
    `description` VARCHAR(255) NULL,
    `total_amount` DECIMAL(15, 2) NULL,
    `outstanding_amount` DECIMAL(15, 2) NULL,
    `amount_to_pay` DECIMAL(15, 2) NULL,
    `is_selected` BOOLEAN NULL DEFAULT false,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `supplier_account_id`(`supplier_account_id`),
    INDEX `vendor_payment_id`(`vendor_payment_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `vendor_payment_discounts` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `vendor_payment_id` BIGINT NULL,
    `discount_type` VARCHAR(100) NULL,
    `discount_percent` DECIMAL(7, 3) NULL,
    `sub_total_before` DECIMAL(15, 2) NULL,
    `discount_value` DECIMAL(15, 2) NULL,
    `sub_total_after` DECIMAL(15, 2) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `vendor_payment_id`(`vendor_payment_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `vendor_payment_tds` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `vendor_payment_id` BIGINT NULL,
    `tax_percentage` DECIMAL(5, 2) NULL,
    `tax_amount` DECIMAL(15, 2) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `vendor_payment_id`(`vendor_payment_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `vendor_payments` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `auto_payment_no` VARCHAR(50) NULL,
    `manual_payment_no` VARCHAR(50) NULL,
    `voucher_date` DATE NULL,
    `paid_from` ENUM('Cash In Hand', 'Bank Account', 'Credit Card', 'Online Transfer') NULL,
    `paid_to_id` BIGINT NULL,
    `upload_document` VARCHAR(255) NULL,
    `payment_mode` ENUM('BillPayment', 'DiscountReceived', 'TaxDeductedAtSource') NULL,
    `sub_total` DECIMAL(15, 2) NULL,
    `total_amount` DECIMAL(15, 2) NULL,
    `narration` TEXT NULL,
    `status` ENUM('Draft', 'Submitted', 'Approved', 'Rejected') NULL DEFAULT 'Draft',
    `created_by` BIGINT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `company_id`(`company_id`),
    INDEX `created_by`(`created_by`),
    INDEX `paid_to_id`(`paid_to_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `vendors` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `account_id` BIGINT NULL,
    `name_en` VARCHAR(255) NULL,
    `name_ar` VARCHAR(255) NULL,
    `company_name` VARCHAR(255) NULL,
    `google_location` VARCHAR(500) NULL,
    `id_card_url` VARCHAR(255) NULL,
    `file_url` VARCHAR(255) NULL,
    `account_type` ENUM('Sundry Creditors', 'Other') NULL,
    `balance_type` ENUM('Debit', 'Credit') NULL,
    `account_balance` DECIMAL(15, 2) NULL,
    `creation_date` DATE NULL,
    `bank_account_number` VARCHAR(50) NULL,
    `bank_ifsc` VARCHAR(20) NULL,
    `bank_name_branch` VARCHAR(255) NULL,
    `country` VARCHAR(100) NULL,
    `state` VARCHAR(100) NULL,
    `pincode` VARCHAR(20) NULL,
    `address` TEXT NULL,
    `state_code` VARCHAR(20) NULL,
    `shipping_address` TEXT NULL,
    `phone` VARCHAR(20) NULL,
    `email` VARCHAR(255) NULL,
    `credit_period` INTEGER NULL,
    `is_enabled` BOOLEAN NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `account_id`(`account_id`),
    INDEX `company_id`(`company_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `voucher_photos` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `voucher_id` BIGINT NULL,
    `photo_url` VARCHAR(255) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `voucher_id`(`voucher_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `voucher_products` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `voucher_id` BIGINT NULL,
    `product_name` VARCHAR(255) NULL,
    `rate` DECIMAL(15, 2) NULL,
    `quantity` DECIMAL(15, 3) NULL,
    `amount` DECIMAL(15, 2) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `voucher_id`(`voucher_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `voucher_references` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `voucher_id` BIGINT NULL,
    `file_url` VARCHAR(255) NULL,
    `file_type` VARCHAR(50) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `voucher_id`(`voucher_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `voucher_services` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `voucher_id` BIGINT NULL,
    `service_id` BIGINT NULL,
    `qty` DECIMAL(15, 3) NULL,
    `rate` DECIMAL(15, 2) NULL,
    `discount` DECIMAL(15, 2) NULL,
    `tax_id` BIGINT NULL,
    `tax_amount` DECIMAL(15, 2) NULL,
    `total_amount` DECIMAL(15, 2) NULL,

    INDEX `service_id`(`service_id`),
    INDEX `tax_id`(`tax_id`),
    INDEX `voucher_id`(`voucher_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `vouchers_master` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `voucher_type` ENUM('Expense', 'Income', 'Contra', 'Journal', 'Credit Note', 'Debit Note', 'Opening Balance', 'Current Balance', 'Closing Balance', 'Sales', 'Purchase', 'Delivery Challans') NULL,
    `company_name` VARCHAR(255) NULL,
    `company_logo` VARCHAR(255) NULL,
    `from_customer_id` BIGINT NULL,
    `to_name` VARCHAR(255) NULL,
    `receipt_number` VARCHAR(50) NULL,
    `voucher_number` VARCHAR(50) NULL,
    `voucher_date` DATE NULL,
    `subtotal` DECIMAL(15, 2) NULL,
    `total` DECIMAL(15, 2) NULL,
    `notes` TEXT NULL,
    `created_by` BIGINT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `company_id`(`company_id`),
    INDEX `created_by`(`created_by`),
    INDEX `from_customer_id`(`from_customer_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `warehouses` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NULL,
    `warehouse_name` VARCHAR(150) NULL,
    `location` VARCHAR(255) NULL,
    `contact_person` VARCHAR(100) NULL,
    `phone` VARCHAR(20) NULL,
    `status` ENUM('Active', 'Inactive') NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    INDEX `company_id`(`company_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Unit` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `weightPerUnit` DOUBLE NULL,
    `unitOfMeasure` VARCHAR(100) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `Unit_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
