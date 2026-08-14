import prisma from './prisma'

/**
 * Safely synchronizes the verified Supabase Auth UUID to the Prisma public.User table.
 * Idempotent: will not overwrite existing fields or roles if the user already exists.
 *
 * @param userId - Securely verified Supabase Auth UUID
 * @param email - Securely verified email address
 */
export async function syncUserToDatabase(userId: string, email: string) {
  // Use Prisma upsert to safely create the user if absent, or do nothing if present.
  // We do not overwrite 'role' to ensure application roles aren't reset on login.
  await prisma.user.upsert({
    where: { id: userId },
    update: {}, // Explicitly do nothing on update to preserve existing fields
    create: {
      id: userId,
      email: email,
      // role defaults to STUDENT based on Prisma schema @default
    },
  })
}
