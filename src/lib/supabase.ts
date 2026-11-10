import { createClient, type SupabaseClient } from '@supabase/supabase-js'
import { readSupabaseConfig } from './env.ts'

export const supabaseConfig = readSupabaseConfig(import.meta.env)

if (!supabaseConfig.ok) {
  console.error(`Supabase is not configured: ${supabaseConfig.error}`)
}

let client: SupabaseClient | null = null

// The one Supabase client for the app. It acts as the signed-in user, so every read and write is
// limited by RLS. App renders only the setup-error screen when settings are bad, so pages can call
// this without null checks; if that gate is ever bypassed, this throws instead of failing quietly.
export function getSupabase(): SupabaseClient {
  if (!supabaseConfig.ok) {
    throw new Error(`Supabase is not configured: ${supabaseConfig.error}`)
  }
  client ??= createClient(supabaseConfig.url, supabaseConfig.anonKey)
  return client
}
