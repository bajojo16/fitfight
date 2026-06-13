export type Json = string | number | boolean | null | { [key: string]: Json } | Json[]

export interface Database {
  public: {
    Tables: {
      profiles: {
        Row: {
          id: string
          username: string | null
          weight_kg: number | null
          weight_class: string | null
          goal: 'cut' | 'maintain' | 'bulk' | null
          focus: string[]
          created_at: string
        }
        Insert: Omit<Database['public']['Tables']['profiles']['Row'], 'created_at'>
        Update: Partial<Database['public']['Tables']['profiles']['Insert']>
      }
      workout_sessions: {
        Row: {
          id: string
          user_id: string
          date: string
          type: 'strength' | 'cardio' | 'mixed'
          duration_min: number | null
          notes: string | null
          effort: number | null
          created_at: string
        }
        Insert: Omit<Database['public']['Tables']['workout_sessions']['Row'], 'id' | 'created_at'>
        Update: Partial<Database['public']['Tables']['workout_sessions']['Insert']>
      }
      workout_exercises: {
        Row: {
          id: string
          session_id: string
          name: string
          sets: number | null
          reps: number | null
          weight_kg: number | null
          duration_sec: number | null
          distance_km: number | null
        }
        Insert: Omit<Database['public']['Tables']['workout_exercises']['Row'], 'id'>
        Update: Partial<Database['public']['Tables']['workout_exercises']['Insert']>
      }
      boxing_sessions: {
        Row: {
          id: string
          user_id: string
          date: string
          type: 'bag' | 'sparring' | 'padwork' | 'shadow' | 'other'
          rounds: number
          round_min: number
          rest_min: number
          combos: string[] | null
          sparring_partner: string | null
          effort: number | null
          technical: number | null
          notes: string | null
          created_at: string
        }
        Insert: Omit<Database['public']['Tables']['boxing_sessions']['Row'], 'id' | 'created_at'>
        Update: Partial<Database['public']['Tables']['boxing_sessions']['Insert']>
      }
      meals: {
        Row: {
          id: string
          user_id: string
          date: string
          name: string
          calories: number | null
          protein_g: number | null
          carbs_g: number | null
          fat_g: number | null
          notes: string | null
          created_at: string
        }
        Insert: Omit<Database['public']['Tables']['meals']['Row'], 'id' | 'created_at'>
        Update: Partial<Database['public']['Tables']['meals']['Insert']>
      }
      meal_items: {
        Row: {
          id: string
          meal_id: string
          food_name: string
          quantity_g: number | null
          calories: number | null
          protein_g: number | null
          carbs_g: number | null
          fat_g: number | null
        }
        Insert: Omit<Database['public']['Tables']['meal_items']['Row'], 'id'>
        Update: Partial<Database['public']['Tables']['meal_items']['Insert']>
      }
      daily_weights: {
        Row: {
          id: string
          user_id: string
          date: string
          weight_kg: number
          created_at: string
        }
        Insert: Omit<Database['public']['Tables']['daily_weights']['Row'], 'id' | 'created_at'>
        Update: Partial<Database['public']['Tables']['daily_weights']['Insert']>
      }
    }
  }
}
