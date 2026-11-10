import { supabaseConfig } from './lib/supabase.ts'

// Placeholder home page until the first real screens land (#5 sign-in, #7 reading log).
// The config gate stays at the root: when settings are bad, nothing else mounts.
export default function App() {
  if (!supabaseConfig.ok) {
    return (
      <main className="placeholder">
        <h1>Reading Rangers</h1>
        <p role="alert" className="error">
          Setup problem: {supabaseConfig.error}
        </p>
      </main>
    )
  }

  return (
    <main className="placeholder">
      <h1>Reading Rangers</h1>
      <p>The district read-a-thon. Coming April 2027.</p>
    </main>
  )
}
