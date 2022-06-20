import { createClient } from "@supabase/supabase-js"

const supabaseUrl = "https://jpvuqiyhlufwrmedesss.supabase.co"
const supabaseKey = process.env.SUPABASE_KEY

if (typeof supabaseKey !== "string") {
  throw new Error("Invalid key")
}

export const supabase = createClient(supabaseUrl, supabaseKey)
