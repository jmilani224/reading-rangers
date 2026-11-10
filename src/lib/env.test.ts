import { describe, expect, it } from 'vitest'
import { readSupabaseConfig } from './env.ts'

const good = {
  VITE_SUPABASE_URL: 'https://abc.supabase.co',
  VITE_SUPABASE_ANON_KEY: 'anon-key',
}

describe('readSupabaseConfig', () => {
  it('accepts an https URL and a key', () => {
    expect(readSupabaseConfig(good)).toEqual({
      ok: true,
      url: 'https://abc.supabase.co',
      anonKey: 'anon-key',
    })
  })

  it('names every missing setting', () => {
    const result = readSupabaseConfig({})
    expect(result).toEqual({
      ok: false,
      error: 'missing VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY (see .env.example)',
    })
  })

  it('treats a blank value as missing', () => {
    const result = readSupabaseConfig({ ...good, VITE_SUPABASE_ANON_KEY: '  ' })
    expect(result.ok).toBe(false)
  })

  it('rejects a malformed URL', () => {
    const result = readSupabaseConfig({ ...good, VITE_SUPABASE_URL: 'abc.supabase.co' })
    expect(result).toEqual({ ok: false, error: 'VITE_SUPABASE_URL is not a valid URL' })
  })

  it('rejects plain http except for a local Supabase stack', () => {
    expect(readSupabaseConfig({ ...good, VITE_SUPABASE_URL: 'http://abc.supabase.co' }).ok).toBe(false)
    expect(readSupabaseConfig({ ...good, VITE_SUPABASE_URL: 'http://127.0.0.1:54321' }).ok).toBe(true)
    expect(readSupabaseConfig({ ...good, VITE_SUPABASE_URL: 'http://localhost:54321' }).ok).toBe(true)
  })

  it('rejects a new-style secret key', () => {
    const result = readSupabaseConfig({ ...good, VITE_SUPABASE_ANON_KEY: 'sb_secret_abc123' })
    expect(result.ok).toBe(false)
  })

  it('rejects a legacy service_role JWT but accepts an anon JWT', () => {
    const jwt = (role: string) =>
      ['eyJhbGciOiJIUzI1NiJ9', btoa(JSON.stringify({ role })).replace(/=+$/, ''), 'sig'].join('.')
    expect(readSupabaseConfig({ ...good, VITE_SUPABASE_ANON_KEY: jwt('service_role') }).ok).toBe(false)
    expect(readSupabaseConfig({ ...good, VITE_SUPABASE_ANON_KEY: jwt('anon') }).ok).toBe(true)
  })
})
