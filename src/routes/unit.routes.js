import express from "express";
import {
  createUnit,
  getAllUnits,
  updateUnit,
  deleteUnit,
} from "../controllers/unit.controller.js";
import { verifyToken } from "../middlewares/authMiddleware.js";

const router = express.Router();

// Protected Routes
router.post("/", createUnit);
router.get("/", getAllUnits);
router.put("/:id", updateUnit);
router.delete("/:id", deleteUnit);

export default router;
