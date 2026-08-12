-- CreateEnum
CREATE TYPE "Role" AS ENUM ('STUDENT', 'ADMIN');

-- CreateEnum
CREATE TYPE "Gender" AS ENUM ('MALE', 'FEMALE', 'OTHER', 'PREFER_NOT_TO_SAY');

-- CreateEnum
CREATE TYPE "Category" AS ENUM ('GENERAL', 'SC', 'ST', 'OBC', 'EWS');

-- CreateEnum
CREATE TYPE "ProviderType" AS ENUM ('GOVERNMENT', 'CORPORATE', 'NGO', 'UNIVERSITY');

-- CreateEnum
CREATE TYPE "ScholarshipStatus" AS ENUM ('ACTIVE', 'INACTIVE', 'DRAFT');

-- CreateEnum
CREATE TYPE "VerificationStatus" AS ENUM ('VERIFIED', 'UNVERIFIED');

-- CreateEnum
CREATE TYPE "BenefitType" AS ENUM ('FULL_TUITION', 'PARTIAL_TUITION', 'STIPEND', 'LAPTOP', 'OTHER');

-- CreateTable
CREATE TABLE "User" (
    "id" UUID NOT NULL,
    "email" TEXT NOT NULL,
    "role" "Role" NOT NULL DEFAULT 'STUDENT',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StudentProfile" (
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "gender" "Gender" NOT NULL,
    "category" "Category" NOT NULL,
    "disabilityStatus" BOOLEAN NOT NULL DEFAULT false,
    "familyIncome" INTEGER NOT NULL,
    "stateId" UUID NOT NULL,
    "districtId" UUID NOT NULL,
    "educationLevelId" UUID NOT NULL,
    "courseId" UUID NOT NULL,
    "academicYear" INTEGER NOT NULL,
    "academicPerformance" DECIMAL(5,2) NOT NULL,

    CONSTRAINT "StudentProfile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "State" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,

    CONSTRAINT "State_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "District" (
    "id" UUID NOT NULL,
    "stateId" UUID NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "District_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EducationLevel" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "EducationLevel_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Course" (
    "id" UUID NOT NULL,
    "educationLevelId" UUID NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Course_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Discipline" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Discipline_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ScholarshipProvider" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "type" "ProviderType" NOT NULL,
    "websiteUrl" TEXT NOT NULL,

    CONSTRAINT "ScholarshipProvider_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Scholarship" (
    "id" UUID NOT NULL,
    "providerId" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "officialApplicationUrl" TEXT NOT NULL,
    "deadline" TIMESTAMP(3),
    "status" "ScholarshipStatus" NOT NULL DEFAULT 'DRAFT',
    "verificationStatus" "VerificationStatus" NOT NULL DEFAULT 'UNVERIFIED',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Scholarship_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ScholarshipBenefit" (
    "id" UUID NOT NULL,
    "scholarshipId" UUID NOT NULL,
    "type" "BenefitType" NOT NULL,
    "amount" DECIMAL(10,2),
    "description" TEXT NOT NULL,

    CONSTRAINT "ScholarshipBenefit_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ScholarshipEligibilityRule" (
    "id" UUID NOT NULL,
    "scholarshipId" UUID NOT NULL,
    "minFamilyIncome" INTEGER,
    "maxFamilyIncome" INTEGER,
    "minAcademicPerformance" DECIMAL(5,2),
    "requiredGender" "Gender",
    "requiresDisability" BOOLEAN,

    CONSTRAINT "ScholarshipEligibilityRule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ScholarshipRequiredState" (
    "scholarshipId" UUID NOT NULL,
    "stateId" UUID NOT NULL,

    CONSTRAINT "ScholarshipRequiredState_pkey" PRIMARY KEY ("scholarshipId","stateId")
);

-- CreateTable
CREATE TABLE "ScholarshipRequiredCategory" (
    "scholarshipId" UUID NOT NULL,
    "category" "Category" NOT NULL,

    CONSTRAINT "ScholarshipRequiredCategory_pkey" PRIMARY KEY ("scholarshipId","category")
);

-- CreateTable
CREATE TABLE "ScholarshipRequiredEducationLevel" (
    "scholarshipId" UUID NOT NULL,
    "educationLevelId" UUID NOT NULL,

    CONSTRAINT "ScholarshipRequiredEducationLevel_pkey" PRIMARY KEY ("scholarshipId","educationLevelId")
);

-- CreateTable
CREATE TABLE "ScholarshipRequiredCourse" (
    "scholarshipId" UUID NOT NULL,
    "courseId" UUID NOT NULL,

    CONSTRAINT "ScholarshipRequiredCourse_pkey" PRIMARY KEY ("scholarshipId","courseId")
);

-- CreateTable
CREATE TABLE "SavedScholarship" (
    "id" UUID NOT NULL,
    "studentProfileId" UUID NOT NULL,
    "scholarshipId" UUID NOT NULL,
    "savedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SavedScholarship_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "StudentProfile_userId_key" ON "StudentProfile"("userId");

-- CreateIndex
CREATE INDEX "StudentProfile_userId_idx" ON "StudentProfile"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "State_name_key" ON "State"("name");

-- CreateIndex
CREATE UNIQUE INDEX "State_code_key" ON "State"("code");

-- CreateIndex
CREATE UNIQUE INDEX "District_stateId_name_key" ON "District"("stateId", "name");

-- CreateIndex
CREATE UNIQUE INDEX "EducationLevel_name_key" ON "EducationLevel"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Course_educationLevelId_name_key" ON "Course"("educationLevelId", "name");

-- CreateIndex
CREATE UNIQUE INDEX "Discipline_name_key" ON "Discipline"("name");

-- CreateIndex
CREATE INDEX "Scholarship_deadline_idx" ON "Scholarship"("deadline");

-- CreateIndex
CREATE INDEX "Scholarship_status_verificationStatus_idx" ON "Scholarship"("status", "verificationStatus");

-- CreateIndex
CREATE UNIQUE INDEX "ScholarshipEligibilityRule_scholarshipId_key" ON "ScholarshipEligibilityRule"("scholarshipId");

-- CreateIndex
CREATE UNIQUE INDEX "SavedScholarship_studentProfileId_scholarshipId_key" ON "SavedScholarship"("studentProfileId", "scholarshipId");

-- AddForeignKey
ALTER TABLE "StudentProfile" ADD CONSTRAINT "StudentProfile_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StudentProfile" ADD CONSTRAINT "StudentProfile_stateId_fkey" FOREIGN KEY ("stateId") REFERENCES "State"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StudentProfile" ADD CONSTRAINT "StudentProfile_districtId_fkey" FOREIGN KEY ("districtId") REFERENCES "District"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StudentProfile" ADD CONSTRAINT "StudentProfile_educationLevelId_fkey" FOREIGN KEY ("educationLevelId") REFERENCES "EducationLevel"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StudentProfile" ADD CONSTRAINT "StudentProfile_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "Course"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "District" ADD CONSTRAINT "District_stateId_fkey" FOREIGN KEY ("stateId") REFERENCES "State"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Course" ADD CONSTRAINT "Course_educationLevelId_fkey" FOREIGN KEY ("educationLevelId") REFERENCES "EducationLevel"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Scholarship" ADD CONSTRAINT "Scholarship_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "ScholarshipProvider"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScholarshipBenefit" ADD CONSTRAINT "ScholarshipBenefit_scholarshipId_fkey" FOREIGN KEY ("scholarshipId") REFERENCES "Scholarship"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScholarshipEligibilityRule" ADD CONSTRAINT "ScholarshipEligibilityRule_scholarshipId_fkey" FOREIGN KEY ("scholarshipId") REFERENCES "Scholarship"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScholarshipRequiredState" ADD CONSTRAINT "ScholarshipRequiredState_scholarshipId_fkey" FOREIGN KEY ("scholarshipId") REFERENCES "Scholarship"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScholarshipRequiredState" ADD CONSTRAINT "ScholarshipRequiredState_stateId_fkey" FOREIGN KEY ("stateId") REFERENCES "State"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScholarshipRequiredCategory" ADD CONSTRAINT "ScholarshipRequiredCategory_scholarshipId_fkey" FOREIGN KEY ("scholarshipId") REFERENCES "Scholarship"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScholarshipRequiredEducationLevel" ADD CONSTRAINT "ScholarshipRequiredEducationLevel_scholarshipId_fkey" FOREIGN KEY ("scholarshipId") REFERENCES "Scholarship"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScholarshipRequiredEducationLevel" ADD CONSTRAINT "ScholarshipRequiredEducationLevel_educationLevelId_fkey" FOREIGN KEY ("educationLevelId") REFERENCES "EducationLevel"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScholarshipRequiredCourse" ADD CONSTRAINT "ScholarshipRequiredCourse_scholarshipId_fkey" FOREIGN KEY ("scholarshipId") REFERENCES "Scholarship"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScholarshipRequiredCourse" ADD CONSTRAINT "ScholarshipRequiredCourse_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "Course"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SavedScholarship" ADD CONSTRAINT "SavedScholarship_studentProfileId_fkey" FOREIGN KEY ("studentProfileId") REFERENCES "StudentProfile"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SavedScholarship" ADD CONSTRAINT "SavedScholarship_scholarshipId_fkey" FOREIGN KEY ("scholarshipId") REFERENCES "Scholarship"("id") ON DELETE CASCADE ON UPDATE CASCADE;
