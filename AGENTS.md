# AGENTS.md - Instrucciones del proyecto

## Proyecto

ERP web para Importaciones Juanita / 3.6 Capital.

## Tecnología actual

- Un solo archivo `index.html`.
- HTML + CSS + JavaScript vanilla.
- Supabase como backend.
- Deploy en GitHub Pages.
- No usar Node, Vite, React, Next.js ni frameworks por ahora.
- No agregar dependencias nuevas salvo que el usuario lo pida explícitamente.

## Reglas críticas

- Mantener todo en `index.html` por ahora.
- Mantener exactamente 2 tags `script`:
  1. CDN de Supabase.
  2. Código principal de la app.
- Todo el JavaScript debe estar dentro del segundo `script`.
- El archivo debe terminar con `</script></body></html>`.
- No usar template literals con HTML dentro de `win.document.write`.
- Si se generan imprimibles, usar strings concatenadas.
- Evitar funciones duplicadas como `cambiarModulo`/`cambiar`, `abrirPanel`, `addDis`, `rDis`.
- No romper la conexión existente con Supabase.
- No borrar el módulo de clientes funcional.
- No borrar el módulo básico de pedidos actual.
- No borrar la estructura visual base del ERP.
- Mantener el estilo verde salvia claro.
- Priorizar código simple, legible y estable.

## Flujo del ERP

- Módulos principales: Dashboard, Clientes, Pedidos, Muestras, Marketplace, Producción, Almacén, Inventarios, Compras, Finanzas, Reportes, Archivos y Configuración.
- Roles: Director, Administrador, Vendedor, Diseño, Almacén, Impresión, Calandra, Corte, Costura, POD y Entregas.
- Director ve todo.
- Administrador ve administración, cobranza, compras, pagos e inventarios, pero no utilidad.
- Vendedor ve clientes, pedidos, cobranza de sus clientes y estatus, pero no utilidad ni costos reales.
- Producción solo ve sus colas, PDFs y avance.
- Finanzas/utilidad solo para Director.

## Necesidades clave

- Pedidos completos por tipo.
- Muestras como módulo independiente.
- Marketplace con importación de ventas, guías, sets, faltantes, inventario y surtido.
- Administración tipo QuickBooks básico: cobranza, pagos de clientes, deudas, compras de insumos, pagos a proveedores, caja chica e inventarios.

## Notas importantes sobre pedidos

- El pedido real debe seleccionar cliente desde Supabase.
- Debe usar calendario para fecha de entrega.
- Debe permitir elegir origen de tela: tela propia o tela del cliente.
- Si es tela propia, debe seleccionar una tela desde inventario.
- Si es tela del cliente, debe capturar datos manuales.
- Las unidades deben cambiar según el tipo de pedido.
- El pedido debe permitir múltiples diseños.
- Cada diseño debe tener imagen, nombre/número, orientación, cantidad, unidad e indicaciones.
- Después se deben generar documentos como PDF completo, hoja viajera, packing list, orden de corte y orden de costura.

## Notas sobre marketplace

- El problema principal es saber qué lleva cada guía.
- El sistema debe importar ventas, registrar pedidos y guías, descontar inventario por SKU, desglosar sets, actualizar stock, detectar faltantes, generar reportes por SKU, controlar guías por escaneo y mostrar pantalla por guía con productos, cantidades, tallas e imágenes.
