-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.oils_meta (
  id bigint NOT NULL DEFAULT nextval('oils_meta_id_seq'::regclass),
  ingredient_id bigint NOT NULL UNIQUE,
  penetration text,
  fatty_acids text,
  comedogenicity text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT oils_meta_pkey PRIMARY KEY (id),
  CONSTRAINT oils_meta_ingredient_id_fkey FOREIGN KEY (ingredient_id) REFERENCES public.ingredients(id)
);
CREATE TABLE public.subgroups (
  id bigint NOT NULL DEFAULT nextval('subgroups_id_seq'::regclass),
  group text NOT NULL,
  subgroup text,
  subgroup2 text,
  description text,
  name_hint text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT subgroups_pkey PRIMARY KEY (id)
);
CREATE TABLE public.ingredients_backup_pre_v3 (
  id bigint,
  inci_name text,
  ru_name text,
  group text,
  subgroup text,
  description text,
  created_at timestamp with time zone,
  subgroup2 text,
  aliases text,
  is_verified boolean,
  is_eu_allergen boolean
);
CREATE TABLE public.ingredients (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  inci_name text NOT NULL UNIQUE,
  ru_name text,
  aliases text,
  description text,
  is_verified boolean DEFAULT false,
  is_eu_allergen boolean DEFAULT false,
  created_at timestamp with time zone DEFAULT now(),
  is_avoid boolean DEFAULT false,
  is_good boolean DEFAULT false,
  ingredient_id text UNIQUE,
  canonical_name text,
  CONSTRAINT ingredients_pkey PRIMARY KEY (id)
);
CREATE TABLE public.ingredient_groups (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  ingredient_id bigint NOT NULL,
  group text NOT NULL,
  subgroup text,
  subgroup2 text,
  is_primary boolean DEFAULT false,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT ingredient_groups_pkey PRIMARY KEY (id),
  CONSTRAINT ingredient_groups_ingredient_id_fkey FOREIGN KEY (ingredient_id) REFERENCES public.ingredients(id)
);
CREATE TABLE public.products (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  name text NOT NULL,
  brand text,
  image_url text,
  product_type text,
  analytical_type text,
  skin_type text,
  price_rub integer,
  is_selected boolean DEFAULT false,
  source_sheet text,
  source_row integer,
  attr_moisture smallint,
  attr_nutrition smallint,
  attr_repair smallint,
  attr_protection smallint,
  attr_curls smallint,
  attr_film smallint,
  attr_uva_chem smallint,
  attr_uvb_chem smallint,
  attr_spf_physical smallint,
  created_at timestamp with time zone DEFAULT now(),
  notes text,
  is_top boolean DEFAULT false,
  application_area text,
  product_id text UNIQUE,
  name_display text,
  product_type_path text,
  description text,
  skin_type_primary text,
  skin_type_alternative text,
  price_category text,
  brand_id text,
  flag_complex boolean DEFAULT false,
  flag_super_formula boolean DEFAULT false,
  validation_flag text,
  ingredient_count integer DEFAULT 0,
  created_by uuid DEFAULT auth.uid(),
  status text NOT NULL DEFAULT 'pending'::text CHECK (status = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text])),
  reviewed_at timestamp with time zone,
  reject_reason text,
  CONSTRAINT products_pkey PRIMARY KEY (id),
  CONSTRAINT products_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id)
);
CREATE TABLE public.product_ingredients (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  product_id bigint NOT NULL,
  ingredient_id bigint,
  position integer,
  raw_inci_name text,
  legacy_functions_text text,
  bg_color_hex text,
  font_color_hex text,
  warn_flag boolean DEFAULT false,
  source_sheet text,
  match_source text,
  CONSTRAINT product_ingredients_pkey PRIMARY KEY (id),
  CONSTRAINT product_ingredients_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id),
  CONSTRAINT product_ingredients_ingredient_id_fkey FOREIGN KEY (ingredient_id) REFERENCES public.ingredients(id)
);
CREATE TABLE public.patented_formulas (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  name text NOT NULL UNIQUE,
  brand_holder text,
  description text,
  created_at timestamp with time zone DEFAULT now(),
  is_uncertain boolean DEFAULT false,
  CONSTRAINT patented_formulas_pkey PRIMARY KEY (id)
);
CREATE TABLE public.formula_ingredients (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  formula_id bigint NOT NULL,
  ingredient_id bigint NOT NULL,
  is_optional boolean DEFAULT false,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT formula_ingredients_pkey PRIMARY KEY (id),
  CONSTRAINT formula_ingredients_formula_id_fkey FOREIGN KEY (formula_id) REFERENCES public.patented_formulas(id),
  CONSTRAINT formula_ingredients_ingredient_id_fkey FOREIGN KEY (ingredient_id) REFERENCES public.ingredients(id)
);
CREATE TABLE public.skin_types (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  code text NOT NULL UNIQUE,
  name_ru text NOT NULL,
  description text,
  signs text,
  sensations text,
  care_hint text,
  created_at timestamp with time zone DEFAULT now(),
  area text,
  CONSTRAINT skin_types_pkey PRIMARY KEY (id)
);
CREATE TABLE public.hair_types (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  type_number integer NOT NULL,
  type_name text NOT NULL,
  subtype text NOT NULL,
  subtype_name text,
  description text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT hair_types_pkey PRIMARY KEY (id)
);
CREATE TABLE public.hair_conditions (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  code text NOT NULL UNIQUE,
  name_ru text NOT NULL,
  signs text,
  how_to_identify text,
  care_focus text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT hair_conditions_pkey PRIMARY KEY (id)
);
CREATE TABLE public.product_types_ref (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  code text NOT NULL UNIQUE,
  name_ru text NOT NULL,
  category text,
  main_function text,
  key_components text,
  application_notes text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT product_types_ref_pkey PRIMARY KEY (id)
);
CREATE TABLE public.mask_types_ref (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  code text NOT NULL UNIQUE,
  name_ru text NOT NULL,
  function text,
  key_components text,
  suitable_for text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT mask_types_ref_pkey PRIMARY KEY (id)
);
CREATE TABLE public.curly_method_ingredients (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  rule text NOT NULL,
  group text NOT NULL,
  examples text,
  reason text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT curly_method_ingredients_pkey PRIMARY KEY (id)
);
CREATE TABLE public.product_skin_types (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  product_id bigint NOT NULL,
  skin_type_id bigint NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT product_skin_types_pkey PRIMARY KEY (id),
  CONSTRAINT product_skin_types_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id),
  CONSTRAINT product_skin_types_skin_type_id_fkey FOREIGN KEY (skin_type_id) REFERENCES public.skin_types(id)
);
CREATE TABLE public.brands (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  brand_id text NOT NULL UNIQUE,
  brand_name text NOT NULL,
  country text,
  website text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT brands_pkey PRIMARY KEY (id)
);
CREATE TABLE public.ingredients_dictionary (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  ingredient_id text NOT NULL UNIQUE,
  canonical_name text NOT NULL,
  aliases text,
  product_count integer DEFAULT 0,
  occurrence_count integer DEFAULT 0,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT ingredients_dictionary_pkey PRIMARY KEY (id)
);
CREATE TABLE public.profiles (
  id uuid NOT NULL,
  tariff text NOT NULL DEFAULT 'free'::text CHECK (tariff = ANY (ARRAY['free'::text, 'pro'::text])),
  pro_until timestamp with time zone,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT profiles_pkey PRIMARY KEY (id),
  CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id)
);
CREATE TABLE public.usage_events (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  user_id uuid NOT NULL,
  kind text NOT NULL CHECK (kind = ANY (ARRAY['search'::text, 'analysis'::text])),
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT usage_events_pkey PRIMARY KEY (id),
  CONSTRAINT usage_events_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);
CREATE TABLE public.payments (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  user_id uuid NOT NULL,
  email text,
  amount numeric NOT NULL,
  status text NOT NULL DEFAULT 'pending'::text CHECK (status = ANY (ARRAY['pending'::text, 'success'::text, 'fail'::text])),
  is_init boolean NOT NULL DEFAULT false,
  provider text NOT NULL DEFAULT 'robokassa'::text,
  raw jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT payments_pkey PRIMARY KEY (id),
  CONSTRAINT payments_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);
CREATE TABLE public.subscriptions (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  user_id uuid NOT NULL UNIQUE,
  email text,
  status text NOT NULL DEFAULT 'active'::text CHECK (status = ANY (ARRAY['active'::text, 'past_due'::text, 'cancelled'::text])),
  amount numeric NOT NULL,
  first_invoice_id bigint NOT NULL,
  last_invoice_id bigint,
  pro_until timestamp with time zone,
  next_charge_at timestamp with time zone,
  recurring boolean NOT NULL DEFAULT true,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT subscriptions_pkey PRIMARY KEY (id),
  CONSTRAINT subscriptions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);