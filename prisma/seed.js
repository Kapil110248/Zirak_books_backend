// prisma/seed.js
import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

async function main() {
  console.log("🌱 Seeding database...");

  // Unit create
  const unit = await prisma.unit.create({
    data: {
      name: "Kilogram",
      weightPerUnit: 1,
      unitOfMeasure: "Weight", // <-- camelCase field name
      // createdAt aur updatedAt optional hai, Prisma default handle karega
    },
  });

  console.log("Unit created:", unit);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });

