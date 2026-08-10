# Scholar Mate — Architecture

## 1. Overview

Scholar Mate is built as a monolithic Next.js application using the App Router, designed for strong typing, strict layer separation, and high performance. It uses a Service-Layer architecture to ensure business logic (such as the Eligibility Engine) remains independent of the UI and presentation layers.

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
- The **Eligibility Engine** resides in this layer.

### 3.4. Validation Layer
- Zod schemas define the shape and constraints of all external inputs and internal boundaries.
- Validation occurs before data reaches the database or service mutations.

### 3.5. Data Access Layer
- Prisma Client handles database interactions.
- Queries are typed and parameterized to prevent injection.
- Centralized query logic to avoid scattered DB calls across the application.

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
