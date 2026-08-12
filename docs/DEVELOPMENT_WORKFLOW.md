# Scholar Mate — Development Workflow

## 1. Engineering Philosophy

Build Scholar Mate as a real production application. Quality, security, and data integrity take precedence over speed. 
Every feature implementation must follow a strict, phase-based workflow to ensure architectural compliance and safety.

## 2. Standard Task Workflow

For **EVERY** major task, developers and AI agents must follow these phases strictly:

### PHASE A — UNDERSTAND
- Read the relevant documentation in `/docs`.
- Inspect the current code and repository state (`git status`, file reads).
- Identify dependencies, affected files, and risks.
- **Rule**: If an instruction conflicts with `PROJECT_SPEC.md` or `ARCHITECTURE.md`, STOP and report the conflict.

### PHASE B — PLAN
- Determine what needs to change, why, and how to verify it.
- Identify what must remain unchanged.
- **Rule**: Do not design solutions that require unapproved stack changes or random dependencies. (e.g., No Redis, Kafka, Microservices, or separate caching infrastructure without explicit approval).

### PHASE C — IMPLEMENT
- Write the smallest, cleanest implementation that satisfies the requirement.
- Ensure strict typing (no `any`).
- Follow modular, test-driven principles.
- **Rule**: Do not modify unrelated files or delete working functionality without explicit approval.

### PHASE D — VERIFY
- Run necessary checks before finalizing:
  - `npm run lint` (ESLint)
  - `npm run build` (TypeScript/Next.js build)
  - `npm test` (if tests are written)
  - Database schema validations (if Prisma is modified)
  - For major milestones, validation must also include **Scalability and Production Readiness** checks (load testing, query profiling, connection pressure testing) before claiming concurrency support.

### PHASE E — REPORT
- Document exactly what was created, modified, or deleted.
- Report any commands executed and the validation results.
- Note any remaining issues or follow-ups.

### PHASE F — CHECKPOINT
- A task is only complete after verification.
- **Commit strategy**: Create clean, atomic commits after a verified phase. Never commit broken work.

## 3. Git & Safety Rules

- **Git is the Safety System**: Always run `git status` before major work.
- **No Force Pushing**: Never `git push --force`.
- **No History Rewrites**: Never modify Git history without explicit instructions.
- **Protect Secrets**: NEVER commit `.env`, `.env.local`, API keys, database credentials, or Supabase service-role keys.
- **Destructive Operations**: Before deleting files, resetting branches, dropping tables, or reverting migrations, STOP and ask for confirmation.

## 4. Documentation-First Approach

Any new major domain or architectural pattern must be documented in `/docs` *before* the code is written. Code should represent the documented architecture, not the other way around.

## 5. Dealing with Ambiguity

If requirements regarding database schema, eligibility logic, authentication, or product behavior are unclear:
1. **STOP**. Do not guess.
2. Explain the ambiguity to the project lead/user.
3. Present the smallest reasonable set of choices.
4. Wait for clarification before implementing.
