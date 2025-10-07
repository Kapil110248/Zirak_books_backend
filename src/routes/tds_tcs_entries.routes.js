import express from "express";
import {
  createEntry,
  getAllEntries,
  getEntryById,
  updateEntry,
  deleteEntry,
} from "../controllers/tds_tcs_entries.controller.js";

const router = express.Router();

// CRUD routes
router.post("/", createEntry);
router.get("/", getAllEntries);
router.get("/:id", getEntryById);
router.put("/:id", updateEntry);
router.delete("/:id", deleteEntry);

export default router;
