// prisma/seed.js
import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

async function main() {
  console.log("🌱 Seeding database...");

  // Example: Add a default company
  const company = await prisma.companies.create({
    data: {
      name: "Demo Company Pvt Ltd",
      email: "demo@company.com",
      status: "Active",
      created_at: new Date(),
    },
  });

  // Example: Add an admin user
  await prisma.users.create({
    data: {
      company_id: company.id,
      name: "Admin User",
      email: "admin@demo.com",
      role: "Admin",
      password: "hashed_password_here", // later hash it properly
      created_at: new Date(),
    },
  });

  console.log("✅ Seed data inserted successfully!");
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
