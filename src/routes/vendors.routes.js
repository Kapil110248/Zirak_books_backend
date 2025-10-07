import express from "express";
import fileUpload from "express-fileupload";
import {
  createVendor,
  getAllVendors,
  getVendorById,
  updateVendor,
  deleteVendor,
} from "../controllers/vendors.controller.js";

const router = express.Router();

// Enable file upload middleware
router.use(
  fileUpload({
    useTempFiles: true,
    tempFileDir: "./uploads/",
  })
);

router.post("/", createVendor);
router.get("/", getAllVendors);
router.get("/:id", getVendorById);
router.put("/:id", updateVendor);
router.delete("/:id", deleteVendor);

export default router;
