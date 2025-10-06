import { PrismaClient } from "@prisma/client";
const prisma = new PrismaClient();

// Create Unit
export const createUnit = async (req, res) => {
  try {
    const { name, weightPerUnit, unit_of_measure } = req.body;

    const unit = await prisma.unit.create({
      data: {
        name,
        weightPerUnit: weightPerUnit ? parseFloat(weightPerUnit) : null,
        unitOfMeasure: unit_of_measure, // <-- camelCase mapping
      },
    });

    res.status(201).json({ message: "Unit created successfully", unit });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Failed to create unit", error: error.message });
  }
};

// Get All Units
export const getAllUnits = async (req, res) => {
  try {
    const units = await prisma.unit.findMany({
      orderBy: { id: "desc" },
    });
    res.json(units);
  } catch (error) {
    res.status(500).json({ message: "Failed to fetch units", error: error.message });
  }
};

// Update Unit
export const updateUnit = async (req, res) => {
  try {
    const { id } = req.params;
    const { name, weightPerUnit, unit_of_measure } = req.body;

    const updated = await prisma.unit.update({
      where: { id: parseInt(id) },
      data: {
        name,
        weightPerUnit: weightPerUnit ? parseFloat(weightPerUnit) : null,
        unitOfMeasure: unit_of_measure, // <-- camelCase mapping
      },
    });

    res.json({ message: "Unit updated successfully", updated });
  } catch (error) {
    res.status(500).json({ message: "Failed to update unit", error: error.message });
  }
};

// Delete Unit
export const deleteUnit = async (req, res) => {
  try {
    const { id } = req.params;
    await prisma.unit.delete({ where: { id: parseInt(id) } });
    res.json({ message: "Unit deleted successfully" });
  } catch (error) {
    res.status(500).json({ message: "Failed to delete unit", error: error.message });
  }
};
