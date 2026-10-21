# Cómo aplicar el arreglo de la base (KakeiboPro)

Esto lo hace una persona. No hace falta saber programar.
Los datos de la Familia Piloto no se borran.

El archivo que se pega es `supabase_fixes.sql`.
Está en la carpeta principal del proyecto, junto a este instructivo.

`supabase_rls.sql` es el mismo arreglo, por si alguien abre el archivo viejo.
Ejecuta solo uno de los dos. Con una vez alcanza.

## Antes de empezar

1. Entra a [https://supabase.com/dashboard](https://supabase.com/dashboard).
2. Abre el proyecto de KakeiboPro.
3. En el menú de la izquierda, entra a **SQL Editor**.

## Pegar y ejecutar

1. En tu computadora abre el archivo `supabase_fixes.sql`.
2. Selecciona todo (Ctrl+A) y cópialo (Ctrl+C).
3. En el SQL Editor, borra lo que haya en el cuadro blanco.
4. Pega el texto (Ctrl+V).
5. Pulsa el botón **Run** (o Ctrl+Enter).
6. Espera a que termine. Puede tardar unos segundos. No lo pulses otra vez.

## Qué tienes que ver si salió bien

Al final de los resultados tiene que aparecer una fila que dice:

**KakeiboPro RLS OK**

También verás una lista de tablas. En la columna `rls_activo` todas deben decir `true`.

Si ves eso, ya quedó. No ejecutes el archivo otra vez (si lo haces no pasa nada malo, pero no hace falta).

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
5. Los datos de la familia siguen. Las invitaciones y el botón de eliminar cuenta dejan de funcionar hasta que alguien vuelva a ejecutar `supabase_fixes.sql`.

Si el primer script falló con un error, no hace falta este paso.

## Qué no hay que hacer

- No ejecutes copias viejas de estos archivos que tengas guardadas en el correo o en Descargas.
- No borres tablas.
- No compartas la clave `service_role`. Esa clave no va dentro de la app.
