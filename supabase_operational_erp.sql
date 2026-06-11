-- ERP operativo Importaciones Juanita / 3.6 Capital
-- Script idempotente para ejecutar en Supabase SQL Editor.

create extension if not exists pgcrypto;

create table if not exists public.productos_marketplace (
  id uuid primary key default gen_random_uuid(),
  sku text not null unique,
  codigo_barras text,
  descripcion text,
  talla text,
  imagen_url text,
  stock_actual numeric not null default 0,
  activo boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.productos_marketplace add column if not exists codigo_barras text;
alter table public.productos_marketplace add column if not exists descripcion text;
alter table public.productos_marketplace add column if not exists talla text;
alter table public.productos_marketplace add column if not exists imagen_url text;
alter table public.productos_marketplace add column if not exists stock_actual numeric not null default 0;
alter table public.productos_marketplace add column if not exists activo boolean not null default true;
alter table public.productos_marketplace add column if not exists updated_at timestamptz not null default now();
create unique index if not exists productos_marketplace_sku_uidx on public.productos_marketplace (sku);
create index if not exists productos_marketplace_barcode_idx on public.productos_marketplace (codigo_barras);

create table if not exists public.marketplace_guias (
  id uuid primary key default gen_random_uuid(),
  guia text not null unique,
  marketplace text,
  pedido_externo text,
  estatus text not null default 'pendiente',
  total_items numeric not null default 0,
  fecha_surtida timestamptz,
  fecha_empacada timestamptz,
  fecha_entregada timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.marketplace_guias add column if not exists marketplace text;
alter table public.marketplace_guias add column if not exists pedido_externo text;
alter table public.marketplace_guias add column if not exists estatus text not null default 'pendiente';
alter table public.marketplace_guias add column if not exists total_items numeric not null default 0;
alter table public.marketplace_guias add column if not exists fecha_surtida timestamptz;
alter table public.marketplace_guias add column if not exists fecha_empacada timestamptz;
alter table public.marketplace_guias add column if not exists fecha_entregada timestamptz;
alter table public.marketplace_guias add column if not exists updated_at timestamptz not null default now();
create unique index if not exists marketplace_guias_guia_uidx on public.marketplace_guias (guia);

create table if not exists public.marketplace_items (
  id uuid primary key default gen_random_uuid(),
  guia text not null,
  pedido_externo text,
  marketplace text,
  sku text not null,
  descripcion text,
  talla text not null default '',
  imagen_url text,
  cantidad numeric not null default 1,
  cantidad_surtida numeric not null default 0,
  completo boolean not null default false,
  es_set boolean not null default false,
  procesado_inventario boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.marketplace_items add column if not exists pedido_externo text;
alter table public.marketplace_items add column if not exists marketplace text;
alter table public.marketplace_items add column if not exists descripcion text;
alter table public.marketplace_items add column if not exists talla text not null default '';
alter table public.marketplace_items add column if not exists imagen_url text;
alter table public.marketplace_items add column if not exists cantidad numeric not null default 1;
alter table public.marketplace_items add column if not exists cantidad_surtida numeric not null default 0;
alter table public.marketplace_items add column if not exists completo boolean not null default false;
alter table public.marketplace_items add column if not exists es_set boolean not null default false;
alter table public.marketplace_items add column if not exists procesado_inventario boolean not null default false;
alter table public.marketplace_items add column if not exists updated_at timestamptz not null default now();
create unique index if not exists marketplace_items_guia_sku_talla_uidx on public.marketplace_items (guia, sku, talla);
create index if not exists marketplace_items_guia_idx on public.marketplace_items (guia);

create table if not exists public.inventario_movimientos_marketplace (
  id uuid primary key default gen_random_uuid(),
  sku text not null,
  tipo text not null,
  cantidad numeric not null default 0,
  stock_antes numeric not null default 0,
  stock_despues numeric not null default 0,
  referencia text,
  motivo text,
  created_at timestamptz not null default now()
);
alter table public.inventario_movimientos_marketplace add column if not exists referencia text;
alter table public.inventario_movimientos_marketplace add column if not exists motivo text;
create index if not exists inventario_movimientos_sku_idx on public.inventario_movimientos_marketplace (sku);
create index if not exists inventario_movimientos_fecha_idx on public.inventario_movimientos_marketplace (created_at desc);

create table if not exists public.ordenes_produccion_marketplace (
  id uuid primary key default gen_random_uuid(),
  folio text not null unique,
  sku text not null,
  descripcion text,
  talla text,
  imagen_url text,
  cantidad numeric not null default 1,
  cantidad_producida numeric not null default 0,
  prioridad text not null default 'normal',
  area_responsable text not null default 'corte',
  fecha_entrega date,
  estatus text not null default 'pendiente',
  notas text,
  notas_cierre text,
  fecha_terminado timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.ordenes_produccion_marketplace add column if not exists descripcion text;
alter table public.ordenes_produccion_marketplace add column if not exists talla text;
alter table public.ordenes_produccion_marketplace add column if not exists imagen_url text;
alter table public.ordenes_produccion_marketplace add column if not exists cantidad numeric not null default 1;
alter table public.ordenes_produccion_marketplace add column if not exists cantidad_producida numeric not null default 0;
alter table public.ordenes_produccion_marketplace add column if not exists prioridad text not null default 'normal';
alter table public.ordenes_produccion_marketplace add column if not exists area_responsable text not null default 'corte';
alter table public.ordenes_produccion_marketplace add column if not exists fecha_entrega date;
alter table public.ordenes_produccion_marketplace add column if not exists estatus text not null default 'pendiente';
alter table public.ordenes_produccion_marketplace add column if not exists notas text;
alter table public.ordenes_produccion_marketplace add column if not exists notas_cierre text;
alter table public.ordenes_produccion_marketplace add column if not exists fecha_terminado timestamptz;
alter table public.ordenes_produccion_marketplace add column if not exists updated_at timestamptz not null default now();
create unique index if not exists ordenes_produccion_folio_uidx on public.ordenes_produccion_marketplace (folio);
create index if not exists ordenes_produccion_sku_idx on public.ordenes_produccion_marketplace (sku);

create table if not exists public.produccion_historial (
  id uuid primary key default gen_random_uuid(),
  orden_id uuid references public.ordenes_produccion_marketplace(id) on delete cascade,
  estatus text not null,
  area text,
  cantidad numeric,
  notas text,
  created_at timestamptz not null default now()
);
create index if not exists produccion_historial_orden_idx on public.produccion_historial (orden_id);

create table if not exists public.pod_surtido_historial (
  id uuid primary key default gen_random_uuid(),
  guia text not null,
  sku text,
  resultado text not null,
  detalle text,
  created_at timestamptz not null default now()
);
create index if not exists pod_historial_guia_idx on public.pod_surtido_historial (guia);
create index if not exists pod_historial_fecha_idx on public.pod_surtido_historial (created_at desc);

create table if not exists public.pod_problemas (
  id uuid primary key default gen_random_uuid(),
  guia text not null,
  sku text,
  motivo text not null,
  detalle text,
  resuelto boolean not null default false,
  fecha_resuelto timestamptz,
  created_at timestamptz not null default now()
);
alter table public.pod_problemas add column if not exists sku text;
alter table public.pod_problemas add column if not exists detalle text;
alter table public.pod_problemas add column if not exists resuelto boolean not null default false;
alter table public.pod_problemas add column if not exists fecha_resuelto timestamptz;
create index if not exists pod_problemas_guia_idx on public.pod_problemas (guia);

create table if not exists public.proveedores (
  id uuid primary key default gen_random_uuid(),
  nombre text not null,
  contacto text,
  telefono text,
  email text,
  notas text,
  activo boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.compras (
  id uuid primary key default gen_random_uuid(),
  proveedor_id uuid references public.proveedores(id),
  item text not null,
  cantidad numeric not null default 0,
  unidad text,
  costo numeric(14,2) not null default 0,
  fecha date not null default current_date,
  estatus text not null default 'solicitada',
  notas text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.compras add column if not exists proveedor_id uuid references public.proveedores(id);
alter table public.compras add column if not exists item text;
alter table public.compras add column if not exists cantidad numeric not null default 0;
alter table public.compras add column if not exists unidad text;
alter table public.compras add column if not exists costo numeric(14,2) not null default 0;
alter table public.compras add column if not exists fecha date not null default current_date;
alter table public.compras add column if not exists estatus text not null default 'solicitada';
alter table public.compras add column if not exists notas text;
alter table public.compras add column if not exists updated_at timestamptz not null default now();
create index if not exists compras_proveedor_idx on public.compras (proveedor_id);

create table if not exists public.finanzas_movimientos (
  id uuid primary key default gen_random_uuid(),
  tipo text not null check (tipo in ('ingreso','gasto')),
  concepto text not null,
  categoria text,
  monto numeric(14,2) not null check (monto >= 0),
  fecha date not null default current_date,
  metodo_pago text,
  notas text,
  created_at timestamptz not null default now()
);
create index if not exists finanzas_movimientos_fecha_idx on public.finanzas_movimientos (fecha desc);

-- El prototipo actual usa la clave anon sin autenticación. Mantener RLS desactivado
-- temporalmente; habilitar políticas antes de pasar a producción.
alter table public.productos_marketplace disable row level security;
alter table public.marketplace_guias disable row level security;
alter table public.marketplace_items disable row level security;
alter table public.inventario_movimientos_marketplace disable row level security;
alter table public.ordenes_produccion_marketplace disable row level security;
alter table public.produccion_historial disable row level security;
alter table public.pod_surtido_historial disable row level security;
alter table public.pod_problemas disable row level security;
alter table public.proveedores disable row level security;
alter table public.compras disable row level security;
alter table public.finanzas_movimientos disable row level security;
