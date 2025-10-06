import express from "express";
import fileUpload from "express-fileupload";
import {
  createCustomer,
  getAllCustomers,
  getCustomerById,
  updateCustomer,
  deleteCustomer,
} from "../controllers/customer.controller.js";
import { verifyToken } from "../middlewares/authMiddleware.js";

const router = express.Router();

router.use(fileUpload({ useTempFiles: true }));

// Authenticated routes
router.post("/",      createCustomer);
router.get("/", getAllCustomers);
router.get("/:id", getCustomerById);
router.put("/:id", updateCustomer);
router.delete("/:id", deleteCustomer);

export default router;
