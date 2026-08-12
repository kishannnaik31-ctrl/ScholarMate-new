# Scholar Mate — Architecture

## 1. Overview

Scholar Mate is built as a monolithic Next.js application using the App Router, designed for strong typing, strict layer separation, and high performance. It uses a Service-Layer architecture to ensure business logic (such as the Eligibility Engine) remains independent of the UI and presentation layers.

**Scalability Target:** The architecture must be designed so it can evolve toward supporting high concurrent student usage, including a future target of approximately 30,000 concurrent active users. *Note: This is a design target and future validation goal, not a claim of currently proven capacity.*

## 2. Technology Stack

- **Framework**: Next.js (App Router)
- **Language**: TypeScript (Strict Mode)
- **UI Library**: React
- **Styling**: Tailwind CSS
- **Components**: shadcn/ui, Lucide React
- **Database**: PostgreSQL (via Supabase)
- **ORM**: Prisma
- **Authentication**: Supabase Auth
- **Forms & Validation**: React Hook Form, Zod

## 3. Core Architectural Layers

The application strictly separates concerns into the following data flow:

`UI` → `Application Logic (Controllers/Actions)` → `Services (Business Logic)` → `Validation` → `Database Access (ORM)` → `PostgreSQL`

### 3.1. UI Layer (Presentation)
- Contains React components, pages, and layouts.
- **Rule**: Server Components by default. Use Client Components ONLY when user interaction or client-side hooks are strictly necessary.
- **Rule**: No direct database access or heavy business logic in UI components.

### 3.2. Application Logic Layer
- Comprises Next.js Server Actions and Route Handlers.
- Responsible for coordinating requests, invoking the correct services, and formatting the response.
- Manages authentication context passing.

### 3.3. Service Layer
- Contains the core domain operations (e.g., `evaluateEligibility`, `findScholarships`, `updateStudentProfile`).
- **Rule**: Services must be independently testable and agnostic of the HTTP context (they take standard TypeScript objects/primitives as input).
- **Rule**: Application services must remain stateless. No global in-memory state may be required for correctness. Heavy synchronous work must not be placed unnecessarily in request paths.
- **Rule**: Future expensive work must have a path toward asynchronous/background processing if measurements justify it. The architecture must not depend on one manually managed application server, ensuring future horizontal scaling remains possible.
- The **Eligibility Engine** resides in this layer.

### 3.4. Validation Layer
- Zod schemas define the shape and constraints of all external inputs and internal boundaries.
- Validation occurs before data reaches the database or service mutations.

### 3.5. Data Access Layer
- Prisma Client handles database interactions using **one reusable Prisma client architecture**; never create `PrismaClient` per request.
- Queries are typed and parameterized to prevent injection.
- Centralized query logic to avoid scattered DB calls across the application.
- **Prisma & DB Rules**:
  - No N+1 query patterns.
  - Fetch only fields actually required using `select`/`include` carefully.
  - Avoid unbounded `findMany` queries and loading large relational graphs unnecessarily.
  - Query patterns must be designed around indexed access paths. New indexes require justification based on actual query patterns.
  - Expensive queries must be identified before caching is introduced.
  - Connection pool configuration must not be increased blindly; pool sizing must be reviewed against the actual deployment model and database limits.
  - `DATABASE_URL` (pooled) and `DIRECT_URL` (direct) must retain their separate responsibilities. `DIRECT_URL` is for migration/admin tooling, not normal application request traffic.

## 4. Key Architectural Decisions

- **Supabase for PostgreSQL & Auth**: Selected for robust, secure RDBMS features and seamless auth integration, but we use Prisma as the primary ORM for type safety and migration management rather than the Supabase JS client for data fetching.
- **Deterministic Eligibility Engine**: The engine must never guess. If a profile lacks information, the result is `NEEDS_INFORMATION`.
- **Environment Management**: Hardcoding secrets is strictly forbidden. All DB URIs, API keys, and sensitive configs must use environment variables.

## 5. Security & Authorization
- **Authentication**: Managed via Supabase Auth (sessions/cookies).
- **Authorization**: Business logic must explicitly check if the authenticated user has rights to the requested resource (e.g., users can only view/edit their own profiles).
- **Service Role**: Supabase Service Role keys must NEVER be exposed to the client.

## 6. Directory Structure (Proposed)

```text
/app               # Next.js App Router pages and layouts
/components        # Reusable UI components (shadcn/ui, layout components)
/lib               # Utility functions, Prisma client instance, Supabase auth helpers
/services          # Business logic and domain services (e.g., Eligibility Engine)
/schemas           # Zod validation schemas
/prisma            # Prisma schema and migrations
/docs              # Project specification and documentation source of truth
```

## 7. API & Data Access Rules

- Public list endpoints must use pagination. Prefer cursor-based pagination where appropriate for large or frequently accessed datasets.
- Inputs must be validated before expensive database work.
- API/service queries must have bounded result sizes.
- Avoid duplicate database queries within one request.
- Rate limiting must be planned for public endpoints, but do not install a rate-limiting dependency yet unless already required by an approved phase.
- Error handling must avoid exposing internal database details.

## 8. Next.js & Performance

- Keep Server Components and server-side data access as the default where appropriate.
- Avoid unnecessary client-side JavaScript.
- Do not send large database payloads to the browser.
- Use caching deliberately and based on data freshness requirements. Do not introduce caching merely because it sounds scalable.
- Static or rarely changing public data should remain cache-friendly where appropriate.

## 9. Scalability Validation & Observability

Before production claims about high concurrency (e.g., 30,000 active users) are made, Scholar Mate must complete a dedicated **Scalability and Production Readiness** validation stage including:
- Realistic load testing and concurrent-user testing
- Database query profiling and slow-query investigation
- Connection/pool pressure testing
- Pagination verification
- Deployment-platform limit review and bottleneck identification
- Performance monitoring setup

A future production-readiness stage must formally measure request latency, database query performance, error rates, connection pressure, and memory/CPU usage where the deployment platform exposes it.

## 10. Anti-Overengineering Rules

Do **NOT** install or introduce any of the following without explicit architectural approval:
- Redis, Kafka, RabbitMQ, BullMQ
- Kubernetes, Docker changes, Microservices
- Separate caching infrastructure, Queues, Load balancers
- Additional databases or New deployment platforms
- Any new dependency
