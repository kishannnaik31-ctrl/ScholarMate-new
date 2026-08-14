import { NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { syncUserToDatabase } from '@/lib/auth-sync'
import prisma from '@/lib/prisma'

export async function GET(request: Request) {
  const { searchParams, origin } = new URL(request.url)
  const code = searchParams.get('code')

  if (code) {
    const supabase = await createClient()
    
    // Exchange the PKCE code for a secure SSR session
    const { error } = await supabase.auth.exchangeCodeForSession(code)
    
    if (!error) {
      // Securely verify identity
      const { data: { user }, error: userError } = await supabase.auth.getUser()
      
      if (!userError && user) {
        // Idempotent synchronization of authenticated UUID to public.User
        await syncUserToDatabase(user.id, user.email!)
        
        // Lookup profile safely via the verified ID
        const profile = await prisma.studentProfile.findUnique({
          where: { userId: user.id },
          select: { id: true },
        })
        
        const nextUrl = profile ? '/dashboard' : '/onboarding'
        return NextResponse.redirect(`${origin}${nextUrl}`)
      }
    }
  }

  // Return a safe error state without exposing internal Supabase or Prisma errors
  return NextResponse.redirect(`${origin}/?error=auth-callback-failed`)
}
