\# Scholar Mate — Project Specification



\## 1. Product Identity



\*\*Product Name:\*\* Scholar Mate



\*\*One-Line Pitch:\*\*



> Providing students the exact and direct link to the scholarships they are eligible for.



Scholar Mate is a scholarship discovery and eligibility platform designed to help students in India find scholarships they are genuinely eligible for and reach the correct official application page directly.



\---



\## 2. Problem



Students often miss scholarships because:



\- Scholarship information is scattered across many websites.

\- Eligibility criteria are difficult to understand.

\- Students don't know which scholarships they actually qualify for.

\- Search results contain outdated, duplicate, or unofficial information.

\- Students waste time searching through unrelated scholarship listings.

\- The actual application link can be difficult to find.



Scholar Mate solves this by centralizing scholarship information and matching students against eligibility requirements.



\---



\## 3. Primary Goal



The primary goal is:



> A student provides their academic, demographic, financial, and other relevant information, and Scholar Mate identifies scholarships they are eligible for and provides the correct official application link.



The system must prioritize \*\*accuracy, trust, simplicity, and usefulness\*\* over feature quantity.



\---



\## 4. Target Users



\### Primary Users



Indian students looking for scholarships.



\### Initial Focus



Students studying in undergraduate programs, especially students who may have difficulty discovering scholarships because of financial or informational constraints.



\### Geographic Scope



India.



The initial implementation may contain Karnataka-focused scholarship data, but the architecture must allow expansion to other Indian states.



\---



\## 5. Core Product Features



\### 5.1 Student Profile



Students can provide information relevant to scholarship eligibility, including where applicable:



\- State

\- District

\- Education level

\- Course

\- College/university

\- Academic year

\- Category

\- Family income

\- Academic performance

\- Gender

\- Disability status

\- Other scholarship-specific eligibility attributes



Only information actually required by eligibility rules should be collected.



\---



\### 5.2 Scholarship Database



Scholar Mate maintains structured scholarship records containing information such as:



\- Scholarship name

\- Provider

\- Description

\- Eligibility criteria

\- Academic requirements

\- Income requirements

\- Category requirements

\- Gender requirements

\- State requirements

\- Education-level requirements

\- Course requirements

\- Application deadline

\- Scholarship benefits

\- Official application URL

\- Verification/source information

\- Active/inactive status



\---



\### 5.3 Eligibility Engine



The eligibility engine is a core part of Scholar Mate.



It must evaluate a student's profile against structured scholarship eligibility rules.



The system should distinguish between:



\- Eligible

\- Not eligible

\- Potentially eligible / requires verification

\- Missing information



Eligibility logic must be deterministic, explainable, and testable.



The system must never claim that a student is eligible when required information is missing or contradictory.



\---



\### 5.4 Scholarship Discovery



Students should be able to:



\- View scholarships

\- Search scholarships

\- Filter scholarships

\- Sort scholarships

\- View scholarship details

\- Understand eligibility requirements

\- Access the official application page



\---



\### 5.5 Direct Official Application Links



Scholar Mate's core value is providing the student with the correct application destination.



Application links should preferably point directly to the official scholarship/provider website.



Third-party scholarship aggregators should not be presented as official application destinations.



\---



\### 5.6 Saved Scholarships



Students should eventually be able to save scholarships for later reference.



\---



\## 6. Trust Principles



Scholar Mate is a trust-focused product.



\### Official Information First



Scholarship information should be sourced from official government, university, institutional, corporate, or scholarship-provider sources wherever possible.



\### No Fake Links



Scholar Mate must never invent application URLs.



\### No Unsupported Eligibility Claims



The eligibility engine must not make assumptions that are not represented in the scholarship's structured rules.



\### Transparent Matching



Where practical, users should be able to understand why they matched or did not match a scholarship.



\### Data Freshness



Scholarships should have mechanisms for tracking verification and update status.



\---



\## 7. Technology Stack



\### Frontend



\- Next.js

\- React

\- TypeScript

\- App Router

\- Tailwind CSS

\- shadcn/ui where appropriate

\- Lucide React



\### Backend



\- Next.js server-side capabilities

\- TypeScript

\- Service-layer architecture



\### Database



\- PostgreSQL

\- Supabase PostgreSQL



\### ORM



\- Prisma



\### Forms and Validation



\- React Hook Form

\- Zod



\### Authentication



\- Supabase Auth



\### Development Quality



\- ESLint

\- Prettier

\- TypeScript strict mode

\- Git

\- GitHub



\### UI/UX



UI/UX will be developed as a later phase.



Lovable may be used for UI/UX exploration and design direction.



The final application remains a Next.js/React application.



\---



\## 8. Architecture Principles



Scholar Mate must be:



\- Production-ready

\- Type-safe

\- Maintainable

\- Modular

\- Reusable

\- Responsive

\- Accessible

\- Secure

\- Performant

\- Testable



\### Engineering Rules



1\. Do not introduce unnecessary dependencies.

2\. Do not duplicate business logic.

3\. Do not use `any` unless there is a documented technical reason.

4\. Do not hardcode secrets.

5\. Do not hardcode database credentials.

6\. Use environment variables for secrets and configuration.

7\. Validate user input at system boundaries.

8\. Keep business logic separate from UI components.

9\. Keep database access separate from presentation components.

10\. Prefer reusable services and utilities.

11\. Avoid premature abstraction.

12\. Avoid over-engineering.

13\. Do not create placeholder functionality that appears production-ready.

14\. Do not silently change the approved architecture.

15\. Any major architectural change must be explicitly reviewed before implementation.



\---



\## 9. Documentation Principle



The `/docs` directory is the project's documentation source of truth.



Important architectural, database, domain, and product decisions must be documented there.



AI coding agents must read the relevant documentation before making significant changes.



\---



\## 10. AI Coding Agent Rules



AI coding agents must:



1\. Inspect the existing project before modifying files.

2\. Read relevant files in `/docs`.

3\. Preserve existing approved architecture.

4\. Avoid deleting working functionality without explicit approval.

5\. Avoid changing the technology stack without explicit approval.

6\. Avoid creating duplicate implementations.

7\. Run appropriate validation after changes.

8\. Report what was changed.

9\. Report tests/build/typecheck results.

10\. Never claim a task is complete without verification.



\---



\## 11. UI/UX Direction



UI/UX is intentionally deferred until the core product architecture and functionality are established.



The eventual design should prioritize:



\- Trust

\- Clarity

\- Simplicity

\- Accessibility

\- Mobile-first usability

\- Fast scholarship discovery

\- Clear eligibility information

\- Clear official application actions



The interface should feel reliable and appropriate for students.



The design must not prioritize visual effects over usability.



\---



\## 12. Initial Development Strategy



Development will proceed in controlled phases.



\### Phase 1 — Foundation



\- Project architecture

\- Documentation

\- Development configuration

\- Environment configuration

\- Database architecture



\### Phase 2 — Database



\- Prisma

\- Supabase PostgreSQL

\- Schema

\- Migrations

\- Seed data

\- Database validation



\### Phase 3 — Backend



\- Services

\- APIs

\- Validation

\- Authentication

\- Eligibility engine



\### Phase 4 — Core Application



\- Student profile

\- Scholarship discovery

\- Scholarship details

\- Eligibility results

\- Saved scholarships

\- Official application links



\### Phase 5 — UI/UX



\- UX design

\- Lovable exploration where useful

\- Final Next.js implementation

\- Responsive behavior

\- Accessibility

\- Visual polish



\### Phase 6 — Production



\- Testing

\- Security review

\- Performance optimization

\- Error handling

\- Deployment

\- Production verification



\---



\## 13. Explicit Non-Goals



Scholar Mate will NOT initially attempt to become:



\- A social network

\- A student messaging platform

\- A payment platform

\- A scholarship application processing platform

\- A scholarship provider

\- A general education marketplace

\- An AI chatbot that invents scholarship information

\- A generic job portal



The product should remain focused on:



> Discovering scholarships a student may qualify for and directing them to the correct official application destination.



\---



\## 14. Definition of Success



Scholar Mate is successful when a student can:



1\. Create or provide their profile.

2\. Receive relevant scholarship matches.

3\. Understand why they match.

4\. See important scholarship details.

5\. Identify the official application destination.

6\. Reach the official application page quickly.



The system should make scholarship discovery significantly easier than manually searching across many websites.



\---



\## 15. Current Project Status



\*\*Status:\*\* Fresh rebuild



\*\*Repository:\*\* ScholarMate-new



\*\*Branch:\*\* main



\*\*Current Foundation:\*\*



\- Next.js project initialized

\- TypeScript configured

\- Tailwind CSS configured

\- ESLint configured

\- App Router configured

\- Git initialized

\- GitHub remote configured

\- Initial commit created

\- Production build verified successfully



\*\*Next major milestone:\*\*



> Establish the detailed project architecture and database/domain model before implementing application features.

