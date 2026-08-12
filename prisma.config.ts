import 'dotenv/config';
import { defineConfig, env } from 'prisma/config';

export default defineConfig({
  schema: './prisma/schema.prisma',
  migrations: { path: './prisma/migrations' },
  datasource: {
    // Migrations in Supabase must use the direct database connection
    // bypassing the transaction pooler.
    url: env('DIRECT_URL'),
  }
});
