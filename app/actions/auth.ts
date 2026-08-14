'use server'

import { createClient } from '@/lib/supabase/server'
import prisma from '@/lib/prisma'
import { syncUserToDatabase } from '@/lib/auth-sync'

export async function signUp(formData: FormData) {
  const email = formData.get('email') as string
  const password = formData.get('password') as string

  if (!email || !password) {
    return { error: 'Email and password are required' }
  }

  if (password.length < 8) {
    return { error: 'Password must be at least 8 characters long' }
  }

  const supabase = await createClient()

  const siteUrl = process.env.NEXT_PUBLIC_SITE_URL || 'http://localhost:3000'
  const emailRedirectTo = `${siteUrl.replace(/\/$/, '')}/auth/callback`

  const { error, data } = await supabase.auth.signUp({
    email,
    password,
    options: {
      emailRedirectTo,
    },
  })

  if (error) {
    // Return a safe error message.
    return { error: error.message }
  }

  // If Supabase is configured to require email confirmation (default),
  // a session will NOT be returned immediately.
  if (!data.session) {
    return { success: 'Please check your email to confirm your account.' }
  }

  // If email confirmation is disabled and session is created immediately:
  if (data.user) {
    await syncUserToDatabase(data.user.id, data.user.email!)
    return { redirect: '/onboarding' } // New signups will not have a StudentProfile yet
  }

  return { error: 'An unexpected error occurred during signup' }
}

export async function signIn(formData: FormData) {
  const email = formData.get('email') as string
  const password = formData.get('password') as string

  if (!email || !password) {
    return { error: 'Email and password are required' }
  }

  const supabase = await createClient()

  const { error } = await supabase.auth.signInWithPassword({
    email,
    password,
  })

  if (error) {
    // Safe generic message to prevent email enumeration
    return { error: 'Invalid login credentials' }
  }

  // Identity MUST be verified by a secure server-side call, not by unverified session data
  const { data: { user }, error: userError } = await supabase.auth.getUser()

  if (userError || !user) {
    return { error: 'Failed to verify identity' }
  }

  // Ensure application user exists
  await syncUserToDatabase(user.id, user.email!)

  // Check if StudentProfile exists to determine routing
  const profile = await prisma.studentProfile.findUnique({
    where: { userId: user.id },
    select: { id: true },
  })

  if (profile) {
    return { redirect: '/dashboard' }
  } else {
    return { redirect: '/onboarding' }
  }
}
