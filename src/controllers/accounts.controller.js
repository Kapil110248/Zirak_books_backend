// controllers/accounts.controller.js
import { PrismaClient } from "@prisma/client";
const prisma = new PrismaClient();

// Get all accounts
export const getAccounts = async (req, res) => {
  try {
    const accounts = await prisma.accounts.findMany({
      include: {
        children: true,
        voucher_entries: true,
        transactions: true,
        bills: true,
      },
    });
    res.json(accounts);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Error fetching accounts" });
  }
};

// Get single account by ID
export const getAccountById = async (req, res) => {
  const { id } = req.params;
  try {
    const account = await prisma.accounts.findUnique({
      where: { id: BigInt(id) },
      include: { children: true, transactions: true },
    });
    if (!account) return res.status(404).json({ message: "Account not found" });
    res.json(account);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Error fetching account" });
  }
};

// Create new account
export const createAccount = async (req, res) => {
  const { subgroup_id, parent_id, account_name, opening_balance, gst_number, status } = req.body;
  try {
    const account = await prisma.accounts.create({
      data: {
        subgroup_id: BigInt(subgroup_id),
        parent_id: parent_id ? BigInt(parent_id) : null,
        account_name,
        opening_balance,
        gst_number,
        status,
      },
    });
    res.status(201).json(account);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Error creating account" });
  }
};

// Update account
export const updateAccount = async (req, res) => {
  const { id } = req.params;
  const { subgroup_id, parent_id, account_name, opening_balance, gst_number, status } = req.body;
  try {
    const account = await prisma.accounts.update({
      where: { id: BigInt(id) },
      data: {
        subgroup_id: subgroup_id ? BigInt(subgroup_id) : undefined,
        parent_id: parent_id ? BigInt(parent_id) : null,
        account_name,
        opening_balance,
        gst_number,
        status,
      },
    });
    res.json(account);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Error updating account" });
  }
};

// Delete account
export const deleteAccount = async (req, res) => {
  const { id } = req.params;
  try {
    await prisma.accounts.delete({ where: { id: BigInt(id) } });
    res.json({ message: "Account deleted successfully" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Error deleting account" });
  }
};
