export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.5"
  }
  public: {
    Tables: {
      coupons: {
        Row: {
          code: string | null
          conditions_summary: string | null
          created_at: string
          currency: string | null
          description: string | null
          discount_type: string
          discount_value: number | null
          ends_at: string | null
          id: string
          max_discount_amount: number | null
          merchant_id: string | null
          metadata: Json
          min_spend_amount: number | null
          source_id: string
          starts_at: string | null
          status: string
          title: string
          updated_at: string
          validation_level: string
        }
        Insert: {
          code?: string | null
          conditions_summary?: string | null
          created_at?: string
          currency?: string | null
          description?: string | null
          discount_type?: string
          discount_value?: number | null
          ends_at?: string | null
          id?: string
          max_discount_amount?: number | null
          merchant_id?: string | null
          metadata?: Json
          min_spend_amount?: number | null
          source_id: string
          starts_at?: string | null
          status?: string
          title: string
          updated_at?: string
          validation_level?: string
        }
        Update: {
          code?: string | null
          conditions_summary?: string | null
          created_at?: string
          currency?: string | null
          description?: string | null
          discount_type?: string
          discount_value?: number | null
          ends_at?: string | null
          id?: string
          max_discount_amount?: number | null
          merchant_id?: string | null
          metadata?: Json
          min_spend_amount?: number | null
          source_id?: string
          starts_at?: string | null
          status?: string
          title?: string
          updated_at?: string
          validation_level?: string
        }
        Relationships: [
          {
            foreignKeyName: "coupons_merchant_id_fkey"
            columns: ["merchant_id"]
            isOneToOne: false
            referencedRelation: "merchants"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "coupons_source_id_fkey"
            columns: ["source_id"]
            isOneToOne: false
            referencedRelation: "sources"
            referencedColumns: ["id"]
          },
        ]
      }
      merchants: {
        Row: {
          active: boolean
          country_code: string | null
          created_at: string
          id: string
          metadata: Json
          name: string
          slug: string
          updated_at: string
          website_url: string | null
        }
        Insert: {
          active?: boolean
          country_code?: string | null
          created_at?: string
          id?: string
          metadata?: Json
          name: string
          slug: string
          updated_at?: string
          website_url?: string | null
        }
        Update: {
          active?: boolean
          country_code?: string | null
          created_at?: string
          id?: string
          metadata?: Json
          name?: string
          slug?: string
          updated_at?: string
          website_url?: string | null
        }
        Relationships: []
      }
      offer_benefits: {
        Row: {
          amount: number | null
          benefit_type: string
          created_at: string
          currency: string | null
          delayed: boolean
          description: string | null
          eligibility: Json
          id: string
          offer_id: string
          percentage: number | null
        }
        Insert: {
          amount?: number | null
          benefit_type: string
          created_at?: string
          currency?: string | null
          delayed?: boolean
          description?: string | null
          eligibility?: Json
          id?: string
          offer_id: string
          percentage?: number | null
        }
        Update: {
          amount?: number | null
          benefit_type?: string
          created_at?: string
          currency?: string | null
          delayed?: boolean
          description?: string | null
          eligibility?: Json
          id?: string
          offer_id?: string
          percentage?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "offer_benefits_offer_id_fkey"
            columns: ["offer_id"]
            isOneToOne: false
            referencedRelation: "offers"
            referencedColumns: ["id"]
          },
        ]
      }
      offer_conditions: {
        Row: {
          condition_key: string
          coupon_id: string | null
          created_at: string
          description: string | null
          id: string
          mandatory: boolean
          offer_id: string | null
          operator: string
          value: Json | null
        }
        Insert: {
          condition_key: string
          coupon_id?: string | null
          created_at?: string
          description?: string | null
          id?: string
          mandatory?: boolean
          offer_id?: string | null
          operator?: string
          value?: Json | null
        }
        Update: {
          condition_key?: string
          coupon_id?: string | null
          created_at?: string
          description?: string | null
          id?: string
          mandatory?: boolean
          offer_id?: string | null
          operator?: string
          value?: Json | null
        }
        Relationships: [
          {
            foreignKeyName: "offer_conditions_coupon_id_fkey"
            columns: ["coupon_id"]
            isOneToOne: false
            referencedRelation: "coupons"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "offer_conditions_offer_id_fkey"
            columns: ["offer_id"]
            isOneToOne: false
            referencedRelation: "offers"
            referencedColumns: ["id"]
          },
        ]
      }
      offer_coupons: {
        Row: {
          coupon_id: string
          created_at: string
          is_required: boolean
          offer_id: string
        }
        Insert: {
          coupon_id: string
          created_at?: string
          is_required?: boolean
          offer_id: string
        }
        Update: {
          coupon_id?: string
          created_at?: string
          is_required?: boolean
          offer_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "offer_coupons_coupon_id_fkey"
            columns: ["coupon_id"]
            isOneToOne: false
            referencedRelation: "coupons"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "offer_coupons_offer_id_fkey"
            columns: ["offer_id"]
            isOneToOne: false
            referencedRelation: "offers"
            referencedColumns: ["id"]
          },
        ]
      }
      offer_validations: {
        Row: {
          confidence: number | null
          coupon_id: string | null
          created_at: string
          evidence: Json
          expires_at: string | null
          id: string
          method: string
          offer_id: string | null
          result: string
          user_id: string | null
          validated_at: string
          validation_level: string
        }
        Insert: {
          confidence?: number | null
          coupon_id?: string | null
          created_at?: string
          evidence?: Json
          expires_at?: string | null
          id?: string
          method: string
          offer_id?: string | null
          result: string
          user_id?: string | null
          validated_at?: string
          validation_level: string
        }
        Update: {
          confidence?: number | null
          coupon_id?: string | null
          created_at?: string
          evidence?: Json
          expires_at?: string | null
          id?: string
          method?: string
          offer_id?: string | null
          result?: string
          user_id?: string | null
          validated_at?: string
          validation_level?: string
        }
        Relationships: [
          {
            foreignKeyName: "offer_validations_coupon_id_fkey"
            columns: ["coupon_id"]
            isOneToOne: false
            referencedRelation: "coupons"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "offer_validations_offer_id_fkey"
            columns: ["offer_id"]
            isOneToOne: false
            referencedRelation: "offers"
            referencedColumns: ["id"]
          },
        ]
      }
      offers: {
        Row: {
          availability_context: Json
          available: boolean | null
          base_price: number | null
          canonical_url: string | null
          cashback_amount: number | null
          coupon_required: boolean
          created_at: string
          currency: string
          description: string | null
          discount_percentage: number | null
          effective_cost_amount: number | null
          ends_at: string | null
          external_id: string | null
          fees_amount: number | null
          fetched_at: string
          id: string
          instant_discount_amount: number | null
          last_verified_at: string | null
          merchant_id: string | null
          metadata: Json
          pay_now_amount: number | null
          product_service_id: string | null
          source_id: string
          starts_at: string | null
          status: string
          title: string
          updated_at: string
          validation_level: string
        }
        Insert: {
          availability_context?: Json
          available?: boolean | null
          base_price?: number | null
          canonical_url?: string | null
          cashback_amount?: number | null
          coupon_required?: boolean
          created_at?: string
          currency?: string
          description?: string | null
          discount_percentage?: number | null
          effective_cost_amount?: number | null
          ends_at?: string | null
          external_id?: string | null
          fees_amount?: number | null
          fetched_at?: string
          id?: string
          instant_discount_amount?: number | null
          last_verified_at?: string | null
          merchant_id?: string | null
          metadata?: Json
          pay_now_amount?: number | null
          product_service_id?: string | null
          source_id: string
          starts_at?: string | null
          status?: string
          title: string
          updated_at?: string
          validation_level?: string
        }
        Update: {
          availability_context?: Json
          available?: boolean | null
          base_price?: number | null
          canonical_url?: string | null
          cashback_amount?: number | null
          coupon_required?: boolean
          created_at?: string
          currency?: string
          description?: string | null
          discount_percentage?: number | null
          effective_cost_amount?: number | null
          ends_at?: string | null
          external_id?: string | null
          fees_amount?: number | null
          fetched_at?: string
          id?: string
          instant_discount_amount?: number | null
          last_verified_at?: string | null
          merchant_id?: string | null
          metadata?: Json
          pay_now_amount?: number | null
          product_service_id?: string | null
          source_id?: string
          starts_at?: string | null
          status?: string
          title?: string
          updated_at?: string
          validation_level?: string
        }
        Relationships: [
          {
            foreignKeyName: "offers_merchant_id_fkey"
            columns: ["merchant_id"]
            isOneToOne: false
            referencedRelation: "merchants"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "offers_product_service_id_fkey"
            columns: ["product_service_id"]
            isOneToOne: false
            referencedRelation: "products_services"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "offers_source_id_fkey"
            columns: ["source_id"]
            isOneToOne: false
            referencedRelation: "sources"
            referencedColumns: ["id"]
          },
        ]
      }
      prices: {
        Row: {
          available: boolean | null
          base_price: number | null
          cashback_amount: number | null
          currency: string
          effective_cost_amount: number | null
          fees_amount: number | null
          id: string
          observed_at: string
          offer_id: string
          pay_now_amount: number | null
        }
        Insert: {
          available?: boolean | null
          base_price?: number | null
          cashback_amount?: number | null
          currency: string
          effective_cost_amount?: number | null
          fees_amount?: number | null
          id?: string
          observed_at?: string
          offer_id: string
          pay_now_amount?: number | null
        }
        Update: {
          available?: boolean | null
          base_price?: number | null
          cashback_amount?: number | null
          currency?: string
          effective_cost_amount?: number | null
          fees_amount?: number | null
          id?: string
          observed_at?: string
          offer_id?: string
          pay_now_amount?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "prices_offer_id_fkey"
            columns: ["offer_id"]
            isOneToOne: false
            referencedRelation: "offers"
            referencedColumns: ["id"]
          },
        ]
      }
      products_services: {
        Row: {
          active: boolean
          attributes: Json
          brand: string | null
          canonical_key: string | null
          category_path: string[]
          created_at: string
          id: string
          kind: string
          model: string | null
          title: string
          updated_at: string
        }
        Insert: {
          active?: boolean
          attributes?: Json
          brand?: string | null
          canonical_key?: string | null
          category_path?: string[]
          created_at?: string
          id?: string
          kind: string
          model?: string | null
          title: string
          updated_at?: string
        }
        Update: {
          active?: boolean
          attributes?: Json
          brand?: string | null
          canonical_key?: string | null
          category_path?: string[]
          created_at?: string
          id?: string
          kind?: string
          model?: string | null
          title?: string
          updated_at?: string
        }
        Relationships: []
      }
      search_intents: {
        Row: {
          attributes: Json
          category: string | null
          created_at: string
          destination: string | null
          end_at: string | null
          id: string
          intent_kind: string
          location: string | null
          origin: string | null
          quantity: number | null
          query_id: string
          start_at: string | null
        }
        Insert: {
          attributes?: Json
          category?: string | null
          created_at?: string
          destination?: string | null
          end_at?: string | null
          id?: string
          intent_kind: string
          location?: string | null
          origin?: string | null
          quantity?: number | null
          query_id: string
          start_at?: string | null
        }
        Update: {
          attributes?: Json
          category?: string | null
          created_at?: string
          destination?: string | null
          end_at?: string | null
          id?: string
          intent_kind?: string
          location?: string | null
          origin?: string | null
          quantity?: number | null
          query_id?: string
          start_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "search_intents_query_id_fkey"
            columns: ["query_id"]
            isOneToOne: false
            referencedRelation: "search_queries"
            referencedColumns: ["id"]
          },
        ]
      }
      search_queries: {
        Row: {
          country_code: string | null
          created_at: string
          currency: string | null
          id: string
          locale: string | null
          raw_query: string
          user_id: string | null
        }
        Insert: {
          country_code?: string | null
          created_at?: string
          currency?: string | null
          id?: string
          locale?: string | null
          raw_query: string
          user_id?: string | null
        }
        Update: {
          country_code?: string | null
          created_at?: string
          currency?: string | null
          id?: string
          locale?: string | null
          raw_query?: string
          user_id?: string | null
        }
        Relationships: []
      }
      sources: {
        Row: {
          active: boolean
          base_url: string | null
          capabilities: Json
          created_at: string
          id: string
          merchant_id: string | null
          metadata: Json
          name: string
          source_type: string
          trust_score: number
          updated_at: string
        }
        Insert: {
          active?: boolean
          base_url?: string | null
          capabilities?: Json
          created_at?: string
          id?: string
          merchant_id?: string | null
          metadata?: Json
          name: string
          source_type: string
          trust_score?: number
          updated_at?: string
        }
        Update: {
          active?: boolean
          base_url?: string | null
          capabilities?: Json
          created_at?: string
          id?: string
          merchant_id?: string | null
          metadata?: Json
          name?: string
          source_type?: string
          trust_score?: number
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "sources_merchant_id_fkey"
            columns: ["merchant_id"]
            isOneToOne: false
            referencedRelation: "merchants"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends (DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never) = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends (DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never) = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends (PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never) = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {},
  },
} as const
