import { createClient, type SupabaseClient } from '@supabase/supabase-js'
import { readSupabaseConfig } from './env.ts'

export const supabaseConfig = readSupabaseConfig(import.meta.env)

// The one Supabase client for the app. It acts as the signed-in user, so every read and write is
// limited by RLS. It is null when settings are missing; App shows that as a setup error.
export const supabase: SupabaseClient | null = supabaseConfig.ok
  ? createClient(supabaseConfig.url, supabaseConfig.anonKey)
  : null
