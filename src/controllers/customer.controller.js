import prisma from "../config/prisma.js";
import { uploadToCloudinary } from "../utils/upload.js";

// Helper function to convert BigInt fields to string
const convertBigInt = (obj) =>
  JSON.parse(
    JSON.stringify(obj, (_, value) =>
      typeof value === "bigint" ? value.toString() : value
    )
  );

export const createCustomer = async (req, res) => {
  try {
    const {
      voucher_no,
      name_english,
      name_arabic,
      company_name,
      google_location,
      account_type,
      balance_type,
      account_name,
      opening_balance,
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
      gstin,
      credit_period_days,
      is_active,
    } = req.body;

    let id_card_image = null;
    let any_file = null;

    // Upload files if present
    if (req.files?.id_card_image) {
      id_card_image = await uploadToCloudinary(req.files.id_card_image.tempFilePath);
    }
    if (req.files?.any_file) {
      any_file = await uploadToCloudinary(req.files.any_file.tempFilePath);
    }

    const customer = await prisma.customers.create({
      data: {
        voucher_no: Number(voucher_no),
        name_english,
        name_arabic,
        company_name,
        google_location,
        id_card_image,
        any_file,
        account_type,
        balance_type,
        account_name,
        opening_balance: parseFloat(opening_balance || 0),
        creation_date: creation_date ? new Date(creation_date) : null,
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
        gstin,
        credit_period_days: Number(credit_period_days || 0),
        is_active: is_active ?? true,
      },
    });

    res.status(201).json({
      message: "Customer created successfully",
      customer: convertBigInt(customer), // BigInt fix
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Internal Server Error", error: error.message });
  }
};

export const getAllCustomers = async (req, res) => {
  try {
    const customers = await prisma.customers.findMany({
      orderBy: { id: "desc" },
    });
    res.status(200).json(convertBigInt(customers));
  } catch (error) {
    res.status(500).json({ message: "Failed to fetch customers" });
  }
};

export const getCustomerById = async (req, res) => {
  try {
    const { id } = req.params;
    const customer = await prisma.customers.findUnique({
      where: { id: BigInt(id) },
    });
    if (!customer) return res.status(404).json({ message: "Customer not found" });
    res.json(convertBigInt(customer));
  } catch (error) {
    res.status(500).json({ message: "Error fetching customer" });
  }
};

export const updateCustomer = async (req, res) => {
  try {
    const { id } = req.params;
    const data = req.body;
    let updateData = { ...data };

    if (req.files?.id_card_image)
      updateData.id_card_image = await uploadToCloudinary(req.files.id_card_image.tempFilePath);
    if (req.files?.any_file)
      updateData.any_file = await uploadToCloudinary(req.files.any_file.tempFilePath);

    const updated = await prisma.customers.update({
      where: { id: BigInt(id) },
      data: updateData,
    });

    res.json({
      message: "Customer updated successfully",
      updated: convertBigInt(updated),
    });
  } catch (error) {
    res.status(500).json({ message: "Error updating customer", error: error.message });
  }
};

export const deleteCustomer = async (req, res) => {
  try {
    const { id } = req.params;
    await prisma.customers.delete({ where: { id: BigInt(id) } });
    res.json({ message: "Customer deleted successfully" });
  } catch (error) {
    res.status(500).json({ message: "Error deleting customer" });
  }
};
