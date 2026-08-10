# Scholar Mate — Database Schema

## 1. Design Philosophy

The Scholar Mate database is designed around relational integrity, strict typing, and determinism. Every table serves a specific product requirement focused on scholarship matching and eligibility. We use PostgreSQL features (via Prisma) including foreign keys, indexes, and native enums. 

We avoid JSON columns for structured domain logic (like eligibility rules) to ensure queries remain performant, queryable, and relationally sound.

## 2. Core Domains & Tables

### 2.1. User & Identity
- **User**: Managed primarily through Supabase Auth, but extended in our database.
  - `id` (UUID, PK) -> Links to Supabase Auth UUID
  - `email` (String, Unique)
  - `role` (Enum: STUDENT, ADMIN)
  - `createdAt`, `updatedAt`

### 2.2. Student Profile
Contains the demographic, academic, and financial information required for the Eligibility Engine.
- **StudentProfile**
  - `id` (UUID, PK)
  - `userId` (UUID, FK -> User, Unique)
  - `gender` (Enum: MALE, FEMALE, OTHER, PREFER_NOT_TO_SAY)
  - `category` (Enum: GENERAL, SC, ST, OBC, EWS, etc.)
  - `disabilityStatus` (Boolean)
  - `familyIncome` (Decimal/Int - Annual income in INR)
  - `stateId` (UUID, FK -> State)
  - `districtId` (UUID, FK -> District)
  - `educationLevelId` (UUID, FK -> EducationLevel)
  - `courseId` (UUID, FK -> Course)
  - `academicYear` (Int)
  - `academicPerformance` (Decimal - Percentage/CGPA)

### 2.3. Academic & Geographic Taxonomy
Lookup tables to standardize student inputs and scholarship rules.
- **State** (`id`, `name`, `code`)
- **District** (`id`, `stateId`, `name`)
- **EducationLevel** (`id`, `name`) (e.g., Undergraduate, Postgraduate, High School)
- **Course** (`id`, `educationLevelId`, `name`) (e.g., B.Tech, B.Com, MBBS)
- **Discipline** (`id`, `name`) (e.g., Engineering, Medical, Arts)

### 2.4. Scholarships & Providers
- **ScholarshipProvider**
  - `id` (UUID, PK)
  - `name` (String)
  - `type` (Enum: GOVERNMENT, CORPORATE, NGO, UNIVERSITY)
  - `websiteUrl` (String)

- **Scholarship**
  - `id` (UUID, PK)
  - `providerId` (UUID, FK -> ScholarshipProvider)
  - `name` (String)
  - `description` (Text)
  - `officialApplicationUrl` (String) - MUST be the direct official link.
  - `deadline` (DateTime, Nullable)
  - `status` (Enum: ACTIVE, INACTIVE, DRAFT)
  - `verificationStatus` (Enum: VERIFIED, UNVERIFIED)
  - `createdAt`, `updatedAt`

- **ScholarshipBenefit**
  - `id` (UUID, PK)
  - `scholarshipId` (UUID, FK -> Scholarship)
  - `type` (Enum: FULL_TUITION, PARTIAL_TUITION, STIPEND, LAPTOP, etc.)
  - `amount` (Decimal, Nullable)
  - `description` (Text)

### 2.5. Eligibility Rules
Instead of a single unstructured JSON block, rules are structured relationally to allow the Eligibility Engine to explicitly query and match profiles.
- **ScholarshipEligibilityRule**
  - `id` (UUID, PK)
  - `scholarshipId` (UUID, FK -> Scholarship, Unique)
  - `minFamilyIncome`, `maxFamilyIncome` (Decimal, Nullable)
  - `minAcademicPerformance` (Decimal, Nullable)
  - `requiredGender` (Enum, Nullable)
  - `requiresDisability` (Boolean, Nullable)

*(Relational matching requirements)*
- **ScholarshipRequiredState** (`scholarshipId`, `stateId`)
- **ScholarshipRequiredCategory** (`scholarshipId`, `category`)
- **ScholarshipRequiredEducationLevel** (`scholarshipId`, `educationLevelId`)
- **ScholarshipRequiredCourse** (`scholarshipId`, `courseId`)

### 2.6. User Engagement
- **SavedScholarship**
  - `id` (UUID, PK)
  - `studentProfileId` (UUID, FK -> StudentProfile)
  - `scholarshipId` (UUID, FK -> Scholarship)
  - `savedAt` (DateTime)

## 3. Database Principles
1. **No Fake Data**: Test data can exist in dev, but production data must be heavily audited.
2. **Proper Indexes**: Indexes on `StudentProfile.userId`, `Scholarship.deadline`, and lookup tables to ensure rapid eligibility matching.
3. **Data Freshness**: Scholarships use `status` and `verificationStatus` to prevent students from applying to outdated links.
