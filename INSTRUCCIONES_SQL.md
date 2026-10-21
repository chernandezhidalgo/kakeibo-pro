# Cómo aplicar el arreglo de la base (KakeiboPro)

Esto lo hace una persona. No hace falta saber programar.
Los datos de la Familia Piloto no se borran.

El archivo que se pega es `supabase_fixes.sql`.
Está en la carpeta principal del proyecto, junto a este instructivo.

`supabase_rls.sql` es el mismo arreglo, por si alguien abre el archivo viejo.
Ejecuta solo uno de los dos. Con una vez alcanza.

## Paso 0. Copia de seguridad

Haz esto antes de pegar cualquier arreglo.

1. Entra a [https://supabase.com/dashboard](https://supabase.com/dashboard).
2. Abre el proyecto de KakeiboPro.
3. En el menú de la izquierda, entra a **Database**.
4. Entra a **Backups**.
5. Si ves un botón **Backup now** o **Create backup**, púlsalo y espera a que diga que terminó.
6. Si no ves ese botón, busca la fecha de la última copia en la lista y anótala. Esa copia es la que existe hoy. No borres nada de esa pantalla.
7. No sigas al paso siguiente hasta haber abierto Backups.

## Paso 1. Consulta previa (solo lee, no cambia nada)

1. En el menú de la izquierda, entra a **SQL Editor**.
2. Pulsa **New query** (consulta nueva).
3. Borra lo que haya en el cuadro blanco.
4. Copia y pega exactamente esto:

```sql
SELECT table_name, column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
  AND (
    (
      table_name = 'transactions'
      AND column_name IN (
        'registered_by',
        'created_by_user_id',
        'created_by',
        'user_id',
        'author_id',
        'owner_id',
        'member_id',
        'family_id',
        'account_id'
      )
    )
    OR (
      table_name = 'savings_goals'
      AND column_name IN (
        'registered_by',
        'created_by_user_id',
        'created_by',
        'user_id',
        'author_id',
        'owner_id',
        'member_id',
        'family_id'
      )
    )
    OR (
      table_name = 'recurring_rules'
      AND column_name IN (
        'registered_by',
        'created_by_user_id',
        'created_by',
        'user_id',
        'author_id',
        'owner_id',
        'member_id',
        'family_id',
        'envelope_id',
        'account_id'
      )
    )
    OR (
      table_name = 'family_members'
      AND column_name IN (
        'user_id',
        'family_id',
        'role',
        'is_active',
        'invitation_token',
        'invited_by'
      )
    )
    OR (
      table_name = 'accounts'
      AND column_name IN ('family_id', 'owner_member_id')
    )
    OR (
      table_name = 'envelopes'
      AND column_name IN ('family_id', 'assigned_member_id')
    )
    OR (
      table_name IN (
        'families',
        'user_profiles',
        'kakeibo_reflections',
        'sync_queue'
      )
      AND column_name IN ('id', 'family_id', 'member_id', 'user_id', 'name')
    )
  )
ORDER BY table_name, column_name;
```

5. Pulsa **Run**.
6. Tiene que salir una tabla con nombres de columnas. No tiene que salir un error rojo.
7. Si `transactions` / `registered_by` no aparece, está bien. La app a veces usa `created_by_user_id`. El arreglo no se cae por una columna que no existe.
8. Si `user_profiles` no aparece, también está bien. En este proyecto esa tabla no existe y el arreglo la salta.
8. Copia el resultado y guárdalo (un pantallazo alcanza) antes de seguir. Así se sabe qué columnas había.
9. Esta consulta no guarda ni borra nada. Puedes cerrar ese cuadro.

## Paso 2. Pegar y ejecutar el arreglo

1. En tu computadora abre el archivo `supabase_fixes.sql`.
2. Selecciona todo (Ctrl+A) y cópialo (Ctrl+C).
3. En el SQL Editor, abre un cuadro nuevo (**New query**).
4. Borra lo que haya en el cuadro blanco.
5. Pega el texto (Ctrl+V).
6. Pulsa el botón **Run** (o Ctrl+Enter).
7. Espera a que termine. Puede tardar unos segundos. No lo pulses otra vez.

## Qué tienes que ver si salió bien

Al final de los resultados tiene que aparecer una fila que dice:

**KakeiboPro RLS OK**

También verás una lista de tablas. En la columna `rls_activo` todas deben decir `true`.

Si ves eso, ya quedó. Si lo ejecutas otra vez no pasa nada malo: no borra los datos de la familia.

## Si aparece un error

1. No pulses Run otra vez.
2. No ejecutes ningún otro archivo.
3. Lee el mensaje rojo. Si el script se detuvo a la mitad, **no se guardó ningún cambio**. La Familia Piloto sigue como estaba.
4. Copia el mensaje completo y envíaselo a quien está desarrollando la app.
5. No intentes corregir el texto a mano.

Errores que ya tienen sentido:

- Si dice que falta una tabla, envía el mensaje. No borres nada.
- Si dice que hay una persona repetida en la familia, envía el mensaje. No se cambió nada.

## Cómo deshacer, solo si la app dejó de abrir la familia

Usa esto únicamente si viste **KakeiboPro RLS OK** y después la app falló.

1. Abre `supabase_rls_rollback.sql`.
2. Cópialo entero en un cuadro nuevo del SQL Editor.
3. Pulsa **Run**.
4. Tiene que decir: **Rollback listo**.
5. Los datos de la familia siguen. Las invitaciones, crear una familia nueva y el botón de eliminar cuenta dejan de funcionar hasta que alguien vuelva a ejecutar `supabase_fixes.sql`.

Si el primer script falló con un error, no hace falta este paso.

## Qué no hay que hacer

- No ejecutes copias viejas de estos archivos que tengas guardadas en el correo o en Descargas.
- No borres tablas.
- No compartas la clave `service_role`. Esa clave no va dentro de la app.
