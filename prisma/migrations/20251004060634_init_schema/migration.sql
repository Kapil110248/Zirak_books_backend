-- CreateTable
CREATE TABLE `companies` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `email` VARCHAR(191) NOT NULL,
    `status` ENUM('Active', 'Inactive') NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `users` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `email` VARCHAR(191) NOT NULL,
    `role` ENUM('Admin', 'Accountant', 'Auditor', 'Viewer') NOT NULL,
    `password` VARCHAR(191) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `users_email_key`(`email`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `groups` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NOT NULL,
    `group_name` VARCHAR(191) NOT NULL,
    `description` VARCHAR(191) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `subgroups` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `group_id` BIGINT NOT NULL,
    `subgroup_name` VARCHAR(191) NOT NULL,
    `description` VARCHAR(191) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `accounts` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `subgroup_id` BIGINT NOT NULL,
    `parent_id` BIGINT NULL,
    `account_name` VARCHAR(191) NOT NULL,
    `opening_balance` DECIMAL(15, 2) NOT NULL,
    `gst_number` VARCHAR(191) NULL,
    `status` ENUM('Active', 'Inactive') NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `financial_years` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NOT NULL,
    `start_date` DATE NOT NULL,
    `end_date` DATE NOT NULL,
    `status` ENUM('Open', 'Closed') NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `vouchers` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NOT NULL,
    `voucher_type` ENUM('Sales', 'Purchase', 'Payment', 'Receipt', 'Journal', 'Contra', 'CreditNote', 'DebitNote') NOT NULL,
    `voucher_no` VARCHAR(191) NOT NULL,
    `voucher_date` DATE NOT NULL,
    `narration` VARCHAR(191) NULL,
    `created_by` BIGINT NOT NULL,
    `financial_year_id` BIGINT NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `voucher_entries` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `voucher_id` BIGINT NOT NULL,
    `account_id` BIGINT NOT NULL,
    `debit` DECIMAL(15, 2) NOT NULL,
    `credit` DECIMAL(15, 2) NOT NULL,
    `narration` VARCHAR(191) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `transactions` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `voucher_entry_id` BIGINT NOT NULL,
    `account_id` BIGINT NOT NULL,
    `txn_date` DATE NOT NULL,
    `debit` DECIMAL(15, 2) NOT NULL,
    `credit` DECIMAL(15, 2) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `taxes` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NOT NULL,
    `tax_name` VARCHAR(191) NOT NULL,
    `tax_type` ENUM('GST', 'TDS', 'VAT', 'Other') NOT NULL,
    `rate` DECIMAL(5, 2) NOT NULL,
    `description` VARCHAR(191) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `discounts` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `voucher_entry_id` BIGINT NOT NULL,
    `discount_type` ENUM('Allowed', 'Received') NOT NULL,
    `amount` DECIMAL(15, 2) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `bills` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `vendor_id` BIGINT NOT NULL,
    `voucher_id` BIGINT NOT NULL,
    `total_amount` DECIMAL(15, 2) NOT NULL,
    `outstanding_amount` DECIMAL(15, 2) NOT NULL,
    `due_date` DATE NOT NULL,
    `status` ENUM('Open', 'Partial', 'Closed') NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `bill_settlements` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `bill_voucher_id` BIGINT NOT NULL,
    `payment_voucher_id` BIGINT NOT NULL,
    `amount_paid` DECIMAL(15, 2) NOT NULL,
    `discount_applied` DECIMAL(15, 2) NOT NULL,
    `tds_deducted` DECIMAL(15, 2) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `billsId` BIGINT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `items` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NOT NULL,
    `item_name` VARCHAR(191) NOT NULL,
    `sku` VARCHAR(191) NOT NULL,
    `hsn_code` VARCHAR(191) NULL,
    `unit` VARCHAR(191) NOT NULL,
    `opening_stock` DECIMAL(15, 2) NOT NULL,
    `rate` DECIMAL(15, 2) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `voucher_items` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `voucher_id` BIGINT NOT NULL,
    `item_id` BIGINT NOT NULL,
    `qty` DECIMAL(15, 3) NOT NULL,
    `rate` DECIMAL(15, 2) NOT NULL,
    `discount` DECIMAL(15, 2) NOT NULL,
    `tax_id` BIGINT NOT NULL,
    `tax_amount` DECIMAL(15, 2) NOT NULL,
    `total_amount` DECIMAL(15, 2) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `inventory_movements` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `item_id` BIGINT NOT NULL,
    `voucher_id` BIGINT NOT NULL,
    `movement_type` ENUM('In', 'Out', 'Adjustment') NOT NULL,
    `qty` DECIMAL(15, 3) NOT NULL,
    `rate` DECIMAL(15, 2) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `attachments` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `voucher_id` BIGINT NOT NULL,
    `file_url` VARCHAR(191) NOT NULL,
    `file_type` VARCHAR(191) NOT NULL,
    `uploaded_by` BIGINT NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `audit_logs` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL,
    `table_name` VARCHAR(191) NOT NULL,
    `record_id` BIGINT NOT NULL,
    `action` ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    `old_value` VARCHAR(191) NULL,
    `new_value` VARCHAR(191) NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `approvals` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `voucher_id` BIGINT NOT NULL,
    `approver_id` BIGINT NOT NULL,
    `status` ENUM('Pending', 'Approved', 'Rejected') NOT NULL,
    `remarks` VARCHAR(191) NULL,
    `approved_at` DATETIME(3) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `workflows` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NOT NULL,
    `voucher_type` ENUM('Sales', 'Purchase', 'Payment', 'Receipt', 'Journal', 'Contra', 'CreditNote', 'DebitNote') NOT NULL,
    `min_amount` DECIMAL(15, 2) NOT NULL,
    `approver_role` VARCHAR(191) NOT NULL,
    `level` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `recurring_entries` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NOT NULL,
    `voucher_template_id` BIGINT NOT NULL,
    `frequency` ENUM('Daily', 'Weekly', 'Monthly', 'Yearly') NOT NULL,
    `next_run` DATE NOT NULL,
    `end_date` DATE NOT NULL,
    `status` ENUM('Active', 'Stopped') NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `notifications` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NOT NULL,
    `user_id` BIGINT NOT NULL,
    `message` VARCHAR(191) NOT NULL,
    `type` ENUM('Alert', 'Reminder', 'Approval', 'Renewal') NOT NULL,
    `is_read` BOOLEAN NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `plans` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `plan_name` VARCHAR(191) NOT NULL,
    `currency` VARCHAR(3) NOT NULL,
    `base_price` DECIMAL(10, 2) NOT NULL,
    `total_price` DECIMAL(10, 2) NOT NULL,
    `invoice_limit` INTEGER NOT NULL,
    `user_limit` INTEGER NOT NULL,
    `storage_capacity` VARCHAR(191) NOT NULL,
    `billing_cycle` ENUM('Monthly', 'Yearly') NOT NULL,
    `status` ENUM('Active', 'Inactive') NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `requested_plans` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NOT NULL,
    `plan_id` BIGINT NOT NULL,
    `billing` ENUM('Monthly', 'Yearly') NOT NULL,
    `request_date` DATE NOT NULL,
    `status` ENUM('Pending', 'Approved', 'Rejected') NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `payment_gateway_settings` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NOT NULL,
    `gateway_name` VARCHAR(191) NOT NULL,
    `status` ENUM('Active', 'Inactive') NOT NULL,
    `api_key` VARCHAR(191) NOT NULL,
    `publishable_key` VARCHAR(191) NOT NULL,
    `secret_key` VARCHAR(191) NOT NULL,
    `webhook_url` VARCHAR(191) NOT NULL,
    `environment` ENUM('Test', 'Live') NOT NULL,
    `updated_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `trial_balance` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NOT NULL,
    `financial_year_id` BIGINT NOT NULL,
    `account_id` BIGINT NOT NULL,
    `total_debit` DECIMAL(15, 2) NOT NULL,
    `total_credit` DECIMAL(15, 2) NOT NULL,
    `closing_balance` DECIMAL(15, 2) NOT NULL,
    `balance_type` ENUM('Debit', 'Credit') NOT NULL,
    `generated_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `profit_loss` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NOT NULL,
    `financial_year_id` BIGINT NOT NULL,
    `period` VARCHAR(191) NOT NULL,
    `total_income` DECIMAL(15, 2) NOT NULL,
    `total_expense` DECIMAL(15, 2) NOT NULL,
    `net_result` DECIMAL(15, 2) NOT NULL,
    `generated_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `balance_sheet` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NOT NULL,
    `financial_year_id` BIGINT NOT NULL,
    `as_on_date` DATE NOT NULL,
    `total_assets` DECIMAL(15, 2) NOT NULL,
    `total_liabilities` DECIMAL(15, 2) NOT NULL,
    `total_equity` DECIMAL(15, 2) NOT NULL,
    `generated_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `cash_flow` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NOT NULL,
    `financial_year_id` BIGINT NOT NULL,
    `period` VARCHAR(191) NOT NULL,
    `cash_in` DECIMAL(15, 2) NOT NULL,
    `cash_out` DECIMAL(15, 2) NOT NULL,
    `net_cash_flow` DECIMAL(15, 2) NOT NULL,
    `generated_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `customer_ledger` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `customer_id` BIGINT NOT NULL,
    `voucher_id` BIGINT NOT NULL,
    `date` DATE NOT NULL,
    `particulars` VARCHAR(191) NOT NULL,
    `vch_no` VARCHAR(191) NOT NULL,
    `vch_type` ENUM('Sales', 'Receipt', 'SalesReturn', 'Payment', 'Adjustment') NOT NULL,
    `debit` DECIMAL(15, 2) NOT NULL,
    `credit` DECIMAL(15, 2) NOT NULL,
    `running_balance` DECIMAL(15, 2) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `vendor_ledger` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `vendor_id` BIGINT NOT NULL,
    `voucher_id` BIGINT NOT NULL,
    `date` DATE NOT NULL,
    `particulars` VARCHAR(191) NOT NULL,
    `vch_no` VARCHAR(191) NOT NULL,
    `vch_type` ENUM('Purchase', 'Payment', 'DebitNote', 'CreditNote', 'Adjustment') NOT NULL,
    `debit` DECIMAL(15, 2) NOT NULL,
    `credit` DECIMAL(15, 2) NOT NULL,
    `running_balance` DECIMAL(15, 2) NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `dashboard_summary` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `company_id` BIGINT NOT NULL,
    `total_sales` DECIMAL(15, 2) NOT NULL,
    `total_purchases` DECIMAL(15, 2) NOT NULL,
    `total_receivables` DECIMAL(15, 2) NOT NULL,
    `total_payables` DECIMAL(15, 2) NOT NULL,
    `total_expenses` DECIMAL(15, 2) NOT NULL,
    `top_customer` VARCHAR(191) NULL,
    `low_stock_items` INTEGER NOT NULL,
    `created_at` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `users` ADD CONSTRAINT `users_company_id_fkey` FOREIGN KEY (`company_id`) REFERENCES `companies`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `groups` ADD CONSTRAINT `groups_company_id_fkey` FOREIGN KEY (`company_id`) REFERENCES `companies`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `subgroups` ADD CONSTRAINT `subgroups_group_id_fkey` FOREIGN KEY (`group_id`) REFERENCES `groups`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `accounts` ADD CONSTRAINT `accounts_subgroup_id_fkey` FOREIGN KEY (`subgroup_id`) REFERENCES `subgroups`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `accounts` ADD CONSTRAINT `accounts_parent_id_fkey` FOREIGN KEY (`parent_id`) REFERENCES `accounts`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `financial_years` ADD CONSTRAINT `financial_years_company_id_fkey` FOREIGN KEY (`company_id`) REFERENCES `companies`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `vouchers` ADD CONSTRAINT `vouchers_company_id_fkey` FOREIGN KEY (`company_id`) REFERENCES `companies`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `vouchers` ADD CONSTRAINT `vouchers_created_by_fkey` FOREIGN KEY (`created_by`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `vouchers` ADD CONSTRAINT `vouchers_financial_year_id_fkey` FOREIGN KEY (`financial_year_id`) REFERENCES `financial_years`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `voucher_entries` ADD CONSTRAINT `voucher_entries_voucher_id_fkey` FOREIGN KEY (`voucher_id`) REFERENCES `vouchers`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `voucher_entries` ADD CONSTRAINT `voucher_entries_account_id_fkey` FOREIGN KEY (`account_id`) REFERENCES `accounts`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `transactions` ADD CONSTRAINT `transactions_voucher_entry_id_fkey` FOREIGN KEY (`voucher_entry_id`) REFERENCES `voucher_entries`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `transactions` ADD CONSTRAINT `transactions_account_id_fkey` FOREIGN KEY (`account_id`) REFERENCES `accounts`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `taxes` ADD CONSTRAINT `taxes_company_id_fkey` FOREIGN KEY (`company_id`) REFERENCES `companies`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `discounts` ADD CONSTRAINT `discounts_voucher_entry_id_fkey` FOREIGN KEY (`voucher_entry_id`) REFERENCES `voucher_entries`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `bills` ADD CONSTRAINT `bills_vendor_id_fkey` FOREIGN KEY (`vendor_id`) REFERENCES `accounts`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `bills` ADD CONSTRAINT `bills_voucher_id_fkey` FOREIGN KEY (`voucher_id`) REFERENCES `vouchers`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `bill_settlements` ADD CONSTRAINT `bill_settlements_bill_voucher_id_fkey` FOREIGN KEY (`bill_voucher_id`) REFERENCES `vouchers`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `bill_settlements` ADD CONSTRAINT `bill_settlements_payment_voucher_id_fkey` FOREIGN KEY (`payment_voucher_id`) REFERENCES `vouchers`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `bill_settlements` ADD CONSTRAINT `bill_settlements_billsId_fkey` FOREIGN KEY (`billsId`) REFERENCES `bills`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `items` ADD CONSTRAINT `items_company_id_fkey` FOREIGN KEY (`company_id`) REFERENCES `companies`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `voucher_items` ADD CONSTRAINT `voucher_items_voucher_id_fkey` FOREIGN KEY (`voucher_id`) REFERENCES `vouchers`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `voucher_items` ADD CONSTRAINT `voucher_items_item_id_fkey` FOREIGN KEY (`item_id`) REFERENCES `items`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `voucher_items` ADD CONSTRAINT `voucher_items_tax_id_fkey` FOREIGN KEY (`tax_id`) REFERENCES `taxes`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `inventory_movements` ADD CONSTRAINT `inventory_movements_item_id_fkey` FOREIGN KEY (`item_id`) REFERENCES `items`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `inventory_movements` ADD CONSTRAINT `inventory_movements_voucher_id_fkey` FOREIGN KEY (`voucher_id`) REFERENCES `vouchers`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `attachments` ADD CONSTRAINT `attachments_voucher_id_fkey` FOREIGN KEY (`voucher_id`) REFERENCES `vouchers`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `attachments` ADD CONSTRAINT `attachments_uploaded_by_fkey` FOREIGN KEY (`uploaded_by`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `audit_logs` ADD CONSTRAINT `audit_logs_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `approvals` ADD CONSTRAINT `approvals_voucher_id_fkey` FOREIGN KEY (`voucher_id`) REFERENCES `vouchers`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `approvals` ADD CONSTRAINT `approvals_approver_id_fkey` FOREIGN KEY (`approver_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `workflows` ADD CONSTRAINT `workflows_company_id_fkey` FOREIGN KEY (`company_id`) REFERENCES `companies`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `recurring_entries` ADD CONSTRAINT `recurring_entries_company_id_fkey` FOREIGN KEY (`company_id`) REFERENCES `companies`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `recurring_entries` ADD CONSTRAINT `recurring_entries_voucher_template_id_fkey` FOREIGN KEY (`voucher_template_id`) REFERENCES `vouchers`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `notifications` ADD CONSTRAINT `notifications_company_id_fkey` FOREIGN KEY (`company_id`) REFERENCES `companies`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `notifications` ADD CONSTRAINT `notifications_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `requested_plans` ADD CONSTRAINT `requested_plans_company_id_fkey` FOREIGN KEY (`company_id`) REFERENCES `companies`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `requested_plans` ADD CONSTRAINT `requested_plans_plan_id_fkey` FOREIGN KEY (`plan_id`) REFERENCES `plans`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `payment_gateway_settings` ADD CONSTRAINT `payment_gateway_settings_company_id_fkey` FOREIGN KEY (`company_id`) REFERENCES `companies`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `trial_balance` ADD CONSTRAINT `trial_balance_company_id_fkey` FOREIGN KEY (`company_id`) REFERENCES `companies`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `trial_balance` ADD CONSTRAINT `trial_balance_financial_year_id_fkey` FOREIGN KEY (`financial_year_id`) REFERENCES `financial_years`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `trial_balance` ADD CONSTRAINT `trial_balance_account_id_fkey` FOREIGN KEY (`account_id`) REFERENCES `accounts`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `profit_loss` ADD CONSTRAINT `profit_loss_company_id_fkey` FOREIGN KEY (`company_id`) REFERENCES `companies`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `profit_loss` ADD CONSTRAINT `profit_loss_financial_year_id_fkey` FOREIGN KEY (`financial_year_id`) REFERENCES `financial_years`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `balance_sheet` ADD CONSTRAINT `balance_sheet_company_id_fkey` FOREIGN KEY (`company_id`) REFERENCES `companies`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `balance_sheet` ADD CONSTRAINT `balance_sheet_financial_year_id_fkey` FOREIGN KEY (`financial_year_id`) REFERENCES `financial_years`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `cash_flow` ADD CONSTRAINT `cash_flow_company_id_fkey` FOREIGN KEY (`company_id`) REFERENCES `companies`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `cash_flow` ADD CONSTRAINT `cash_flow_financial_year_id_fkey` FOREIGN KEY (`financial_year_id`) REFERENCES `financial_years`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `customer_ledger` ADD CONSTRAINT `customer_ledger_customer_id_fkey` FOREIGN KEY (`customer_id`) REFERENCES `accounts`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `customer_ledger` ADD CONSTRAINT `customer_ledger_voucher_id_fkey` FOREIGN KEY (`voucher_id`) REFERENCES `vouchers`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `vendor_ledger` ADD CONSTRAINT `vendor_ledger_vendor_id_fkey` FOREIGN KEY (`vendor_id`) REFERENCES `accounts`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `vendor_ledger` ADD CONSTRAINT `vendor_ledger_voucher_id_fkey` FOREIGN KEY (`voucher_id`) REFERENCES `vouchers`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `dashboard_summary` ADD CONSTRAINT `dashboard_summary_company_id_fkey` FOREIGN KEY (`company_id`) REFERENCES `companies`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
