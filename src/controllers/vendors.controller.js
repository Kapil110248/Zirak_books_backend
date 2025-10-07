import { PrismaClient } from "@prisma/client";
import cloudinary from "../config/cloudinary.js";
import fs from "fs";

const prisma = new PrismaClient();

// Helper to safely parse numbers
const safeParseFloat = (value) => (value !== undefined && value !== null && value !== "" ? parseFloat(value) : undefined);
const safeParseInt = (value) => (value !== undefined && value !== null && value !== "" ? parseInt(value) : undefined);

// ✅ Enum valid values from Prisma schema
const validAccountTypes = ["Sundry_Creditors", "Other"]; // match schema
const validBalanceTypes = ["Debit", "Credit"];           // match schema

// 🟢 Create Vendor
export const createVendor = async (req, res) => {
  try {
    const {
      company_id,
      account_id,
      name_en,
      name_ar,
      company_name,
      google_location,
      account_type,
      balance_type,
      account_balance,
      creation_date,
      bank_account_number,
      bank_ifsc,
      bank_name_branch,
      country,
      state,
      pincode,
      address,
      state_code,
      shipping_address,
      phone,
      email,
      credit_period,
      is_enabled,
    } = req.body;

    // ✅ Enum validation
    if (account_type && !validAccountTypes.includes(account_type)) {
      return res.status(400).json({ error: `Invalid account_type. Allowed: ${validAccountTypes.join(", ")}` });
    }
    if (balance_type && !validBalanceTypes.includes(balance_type)) {
      return res.status(400).json({ error: `Invalid balance_type. Allowed: ${validBalanceTypes.join(", ")}` });
    }

    let id_card_url = null;
    let file_url = null;

    if (req.files?.id_card_url) {
      const upload = await cloudinary.uploader.upload(req.files.id_card_url.tempFilePath, {
        folder: "vendors/id_cards",
        resource_type: "auto",
      });
      id_card_url = upload.secure_url;
      fs.unlinkSync(req.files.id_card_url.tempFilePath);
    }

    if (req.files?.file_url) {
      const upload = await cloudinary.uploader.upload(req.files.file_url.tempFilePath, {
        folder: "vendors/files",
        resource_type: "auto",
      });
      file_url = upload.secure_url;
      fs.unlinkSync(req.files.file_url.tempFilePath);
    }

    const vendor = await prisma.vendors.create({
      data: {
        company_id: company_id ? BigInt(company_id) : null,
        account_id: account_id ? BigInt(account_id) : null,
        name_en,
        name_ar,
        company_name,
        google_location,
        id_card_url,
        file_url,
        account_type,
        balance_type,
        account_balance: safeParseFloat(account_balance),
        creation_date: creation_date ? new Date(creation_date) : undefined,
        bank_account_number,
        bank_ifsc,
        bank_name_branch,
        country,
        state,
        pincode,
        address,
        state_code,
        shipping_address,
        phone,
        email,
        credit_period: safeParseInt(credit_period),
        is_enabled: is_enabled === "true" || is_enabled === true,
      },
    });

    // ✅ Convert BigInt to string for JSON
    const vendorSafe = {
      ...vendor,
      id: vendor.id.toString(),
      company_id: vendor.company_id?.toString(),
      account_id: vendor.account_id?.toString(),
    };

    res.status(201).json({ message: "Vendor created successfully", vendor: vendorSafe });
  } catch (error) {
    console.error("Error creating vendor:", error);
    if (error.code === "P2003" && error.meta?.constraint?.includes("company_id")) {
      return res.status(400).json({ error: "Invalid company_id. Ensure the company exists in the companies table." });
    }
    if (error.code === "P2003" && error.meta?.constraint?.includes("account_id")) {
      return res.status(400).json({ error: "Invalid account_id. Ensure the account exists in the accounts table." });
    }
    res.status(500).json({ error: "Failed to create vendor" });
  }
};

// 🟡 Get All Vendors
export const getAllVendors = async (req, res) => {
  try {
    const vendors = await prisma.vendors.findMany({ orderBy: { id: "desc" } });

    // ✅ Convert BigInt fields
    const vendorsSafe = vendors.map(v => ({
      ...v,
      id: v.id.toString(),
      company_id: v.company_id?.toString(),
      account_id: v.account_id?.toString(),
    }));

    res.status(200).json(vendorsSafe);
  } catch (error) {
    console.error("Error fetching vendors:", error);
    res.status(500).json({ error: "Failed to fetch vendors" });
  }
};

// 🟠 Get Single Vendor
export const getVendorById = async (req, res) => {
  try {
    const { id } = req.params;
    const vendor = await prisma.vendors.findUnique({ where: { id: BigInt(id) } });
    if (!vendor) return res.status(404).json({ error: "Vendor not found" });

    const vendorSafe = {
      ...vendor,
      id: vendor.id.toString(),
      company_id: vendor.company_id?.toString(),
      account_id: vendor.account_id?.toString(),
    };

    res.status(200).json(vendorSafe);
  } catch (error) {
    console.error("Error fetching vendor:", error);
    res.status(500).json({ error: "Failed to fetch vendor" });
  }
};

// 🔵 Update Vendor
export const updateVendor = async (req, res) => {
  try {
    const { id } = req.params;
    const existingVendor = await prisma.vendors.findUnique({ where: { id: BigInt(id) } });
    if (!existingVendor) return res.status(404).json({ error: "Vendor not found" });

    let id_card_url = existingVendor.id_card_url;
    let file_url = existingVendor.file_url;

    if (req.files?.id_card_url) {
      const upload = await cloudinary.uploader.upload(req.files.id_card_url.tempFilePath, {
        folder: "vendors/id_cards",
        resource_type: "auto",
      });
      id_card_url = upload.secure_url;
      fs.unlinkSync(req.files.id_card_url.tempFilePath);
    }

    if (req.files?.file_url) {
      const upload = await cloudinary.uploader.upload(req.files.file_url.tempFilePath, {
        folder: "vendors/files",
        resource_type: "auto",
      });
      file_url = upload.secure_url;
      fs.unlinkSync(req.files.file_url.tempFilePath);
    }

    // ✅ Enum validation for update
    const { account_type, balance_type } = req.body;
    if (account_type && !validAccountTypes.includes(account_type)) {
      return res.status(400).json({ error: `Invalid account_type. Allowed: ${validAccountTypes.join(", ")}` });
    }
    if (balance_type && !validBalanceTypes.includes(balance_type)) {
      return res.status(400).json({ error: `Invalid balance_type. Allowed: ${validBalanceTypes.join(", ")}` });
    }

    const updatedVendor = await prisma.vendors.update({
      where: { id: BigInt(id) },
      data: {
        ...req.body,
        account_balance: safeParseFloat(req.body.account_balance),
        credit_period: safeParseInt(req.body.credit_period),
        id_card_url,
        file_url,
      },
    });

    const vendorSafe = {
      ...updatedVendor,
      id: updatedVendor.id.toString(),
      company_id: updatedVendor.company_id?.toString(),
      account_id: updatedVendor.account_id?.toString(),
    };

    res.json({ message: "Vendor updated successfully", updatedVendor: vendorSafe });
  } catch (error) {
    console.error("Error updating vendor:", error);
    res.status(500).json({ error: "Failed to update vendor" });
  }
};

// 🔴 Delete Vendor
export const deleteVendor = async (req, res) => {
  try {
    const { id } = req.params;
    const vendor = await prisma.vendors.findUnique({ where: { id: BigInt(id) } });
    if (!vendor) return res.status(404).json({ error: "Vendor not found" });

    await prisma.vendors.delete({ where: { id: BigInt(id) } });
    res.json({ message: "Vendor deleted successfully" });
  } catch (error) {
    console.error("Error deleting vendor:", error);
    res.status(500).json({ error: "Failed to delete vendor" });
  }
};
