import { supabaseConfig } from './lib/supabase.ts'

// Placeholder home page until the first real screens land (#5 sign-in, #7 reading log).
// It shows whether the Supabase settings are present so a broken deploy is obvious.
export default function App() {
  return (
    <main className="placeholder">
      <h1>Reading Rangers</h1>
      <p>The district read-a-thon. Coming April 2027.</p>
      {supabaseConfig.ok ? null : (
        <p role="alert" className="error">
          Setup problem: {supabaseConfig.error}
        </p>
      )}
    </main>
  )
}
