// Reads the public Supabase settings the browser needs. Pure, so it can be unit-tested.
// Only the project URL and the anon (publishable) key belong here: RLS is the security boundary.
// The service_role key must never be given a VITE_ name, because Vite bundles those into the page.

export type SupabaseConfig =
  | { ok: true; url: string; anonKey: string }
  | { ok: false; error: string }

type Env = Record<string, string | boolean | undefined>

export function readSupabaseConfig(env: Env): SupabaseConfig {
  const url = typeof env.VITE_SUPABASE_URL === 'string' ? env.VITE_SUPABASE_URL.trim() : ''
  const anonKey =
    typeof env.VITE_SUPABASE_ANON_KEY === 'string' ? env.VITE_SUPABASE_ANON_KEY.trim() : ''

  const missing = [
    url ? null : 'VITE_SUPABASE_URL',
    anonKey ? null : 'VITE_SUPABASE_ANON_KEY',
  ].filter((name): name is string => name !== null)
  if (missing.length > 0) {
    return { ok: false, error: `missing ${missing.join(' and ')} (see .env.example)` }
  }

  let parsed: URL
  try {
    parsed = new URL(url)
  } catch {
    return { ok: false, error: 'VITE_SUPABASE_URL is not a valid URL' }
  }
  const isLocal = parsed.hostname === 'localhost' || parsed.hostname === '127.0.0.1'
  if (parsed.protocol !== 'https:' && !(isLocal && parsed.protocol === 'http:')) {
    return { ok: false, error: 'VITE_SUPABASE_URL must use https' }
  }

  if (isSecretKey(anonKey)) {
    return {
      ok: false,
      error: 'VITE_SUPABASE_ANON_KEY holds a secret (service_role) key. Use the anon or publishable key.',
    }
  }

  return { ok: true, url, anonKey }
}

// True for keys that bypass RLS: new-style secret keys, and legacy JWTs whose role is service_role.
function isSecretKey(key: string): boolean {
  if (key.startsWith('sb_secret_')) return true
  const parts = key.split('.')
  if (parts.length !== 3) return false
  try {
    const base64 = parts[1].replace(/-/g, '+').replace(/_/g, '/')
    const payload: unknown = JSON.parse(atob(base64.padEnd(Math.ceil(base64.length / 4) * 4, '=')))
    return typeof payload === 'object' && payload !== null && 'role' in payload && payload.role === 'service_role'
  } catch {
    return false
  }
}
