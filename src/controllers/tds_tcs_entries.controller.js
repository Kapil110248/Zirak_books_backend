import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

// Helper functions
const safeParseFloat = (value) =>
  value !== undefined && value !== null && value !== "" ? parseFloat(value) : undefined;

// Helper to convert BigInt fields to string for JSON
const bigintToString = (obj) =>
  JSON.parse(
    JSON.stringify(obj, (key, value) =>
      typeof value === "bigint" ? value.toString() : value
    )
  );

// 🟢 Create Entry
export const createEntry = async (req, res) => {
  try {
    const { Type, Party, PAN, Amount, Rate, TaxAmount, EntryDate } = req.body;

    const entry = await prisma.tds_tcs_entries.create({
      data: {
        company_id: 1n, // default demo company, ensure it exists in DB
        type: Type,
        party_name: Party,
        pan: PAN,
        amount: safeParseFloat(Amount),
        rate_percent: safeParseFloat(Rate),
        tax_amount: safeParseFloat(TaxAmount),
        entry_date: EntryDate ? new Date(EntryDate) : new Date(),
        customer_id: null,
        vendor_id: null,
        reference_no: null,
        note: null,
      },
    });

    res
      .status(201)
      .json({ message: "Entry created successfully", entry: bigintToString(entry) });
  } catch (error) {
    console.error("Error creating entry:", error);

    if (error.code === "P2003" && error.meta?.constraint?.includes("company_id")) {
      return res
        .status(400)
        .json({ error: "Invalid CompanyId. Ensure it exists in companies table." });
    }

    res.status(500).json({ error: "Failed to create entry" });
  }
};

// 🟡 Get All Entries
export const getAllEntries = async (req, res) => {
  try {
    const entries = await prisma.tds_tcs_entries.findMany({
      orderBy: { entry_date: "desc" },
    });
    res.status(200).json(bigintToString(entries));
  } catch (error) {
    console.error("Error fetching entries:", error);
    res.status(500).json({ error: "Failed to fetch entries" });
  }
};

// 🟠 Get Single Entry by ID
export const getEntryById = async (req, res) => {
  try {
    const { id } = req.params;
    const entry = await prisma.tds_tcs_entries.findUnique({
      where: { id: BigInt(id) },
    });
    if (!entry) return res.status(404).json({ error: "Entry not found" });

    res.status(200).json(bigintToString(entry));
  } catch (error) {
    console.error("Error fetching entry:", error);
    res.status(500).json({ error: "Failed to fetch entry" });
  }
};

// 🔵 Update Entry
export const updateEntry = async (req, res) => {
  try {
    const { id } = req.params;
    const existingEntry = await prisma.tds_tcs_entries.findUnique({
      where: { id: BigInt(id) },
    });
    if (!existingEntry) return res.status(404).json({ error: "Entry not found" });

    const updatedEntry = await prisma.tds_tcs_entries.update({
      where: { id: BigInt(id) },
      data: {
        ...req.body,
        company_id: existingEntry.company_id, // fixed, demo company
        customer_id: null,
        vendor_id: null,
        amount: safeParseFloat(req.body.Amount),
        rate_percent: safeParseFloat(req.body.Rate),
        tax_amount: safeParseFloat(req.body.TaxAmount),
        entry_date: req.body.EntryDate ? new Date(req.body.EntryDate) : existingEntry.entry_date,
      },
    });

    res.json({ message: "Entry updated successfully", updatedEntry: bigintToString(updatedEntry) });
  } catch (error) {
    console.error("Error updating entry:", error);
    res.status(500).json({ error: "Failed to update entry" });
  }
};

// 🔴 Delete Entry
export const deleteEntry = async (req, res) => {
  try {
    const { id } = req.params;
    const existingEntry = await prisma.tds_tcs_entries.findUnique({
      where: { id: BigInt(id) },
    });
    if (!existingEntry) return res.status(404).json({ error: "Entry not found" });

    await prisma.tds_tcs_entries.delete({ where: { id: BigInt(id) } });
    res.json({ message: "Entry deleted successfully" });
  } catch (error) {
    console.error("Error deleting entry:", error);
    res.status(500).json({ error: "Failed to delete entry" });
  }
};
