# Selección de perfil — Diseño

> Traducción al castellano de [2026-10-20-profile-selection-design.md](2026-10-20-profile-selection-design.md). La versión en inglés es la de referencia; si las dos difieren, vale la inglesa.

**Fecha:** 20-10-2026
**Estado:** aprobado el 20-10-2026.

## Objetivo

El piloto sabe en qué perfil está el mando después de cambiarlo, sin verlo y con guantes.

## El problema

El firmware 0.10.0 cambia el perfil en ciclo: mantener el centro del joystick 5 s selecciona el siguiente (TerraPirata, teclado, gestos y otra vez TerraPirata), lo guarda y reinicia la placa. La única indicación es el LED RGB de la XIAO, que parpadea cada 10 s con el color del perfil, dentro de la carcasa. El piloto no lo ve, así que tras un cambio no sabe a qué perfil ha llegado.

El LED de carga no sirve: lo maneja la patilla STAT del cargador, no el firmware, y en la moto la plataforma de la base tapa su ventana. Un LED nuevo en la placa de control necesitaría una revisión de la placa; las placas ya están pedidas.

El piloto cambia de perfil pocas veces: seguir un roadbook es TerraPirata toda la salida, y seguir un track es OsmAnd. Así que hay que saber el perfil al cambiarlo, no de un vistazo mientras se conduce.

## Diseño

El perfil se elige directamente, no en ciclo, así que el botón pulsado le dice al piloto qué perfil ha puesto.

### Funcionamiento

1. **Entrar.** Mantén el centro del joystick 5 s (`PROFILE_SWITCH_MS`) y suéltalo. Al soltarlo entra en la selección de perfil. Si se suelta antes, es una pulsación larga normal del centro, que no tiene acción en ningún perfil.
2. **Elegir.** En los 5 s siguientes a soltarlo (`PROFILE_SELECT_MS`), pulsa un botón:
   - A: TerraPirata;
   - B: teclado (DMD2);
   - C: gestos (OsmAnd).

   La pulsación actúa al pulsar el botón, no al soltarlo.
3. **Aplicar.** Un perfil distinto se guarda y la placa se reinicia, como en la 0.10.0. El perfil actual sale de la selección sin reiniciar: la conexión BLE sigue y los controles funcionan al momento.
4. **Cancelar.** Si no se pulsa ningún botón en 5 s, la selección termina y no cambia nada.

### Durante la selección

- No se envía ninguna tecla, ni de los botones ni del joystick. El botón que elige tampoco envía nada.
- Dos o más botones cerrados a la vez terminan la selección sin cambios; después el apagado con A + B + C funciona como antes.
- Las direcciones del joystick se ignoran; ni eligen ni cancelan.
- Una desconexión BLE termina la selección sin cambios.
- El LED mantiene su parpadeo de perfil.

### Arranque

La placa arranca en el perfil guardado, como en la 0.10.0. Un valor guardado desconocido arranca en TerraPirata.

### Límite conocido

No hay ninguna señal de que hayan pasado los 5 s. Si se suelta antes de tiempo, el centro no hace nada y no se entra en la selección; mantenlo algo más de 5 s. Aceptado: el cambio de perfil se hace parado, antes de salir.

## Pruebas

Pruebas en el ordenador (`firmware/xiao-nrf52840/test`), en las dos placas:

- Centro mantenido 5 s y soltado, luego A, B o C: se guarda el perfil correspondiente y la placa se reinicia; con el perfil actual no se reinicia.
- Centro soltado antes de 5 s: no hay selección; después un botón envía su tecla normal.
- Selección sin ningún botón durante 5 s: termina, no se guarda ningún perfil y después un botón envía su tecla normal.
- Durante la selección ningún informe HID lleva una tecla, tampoco del botón que elige ni del joystick.
- Dos botones durante la selección: ni cambio de perfil ni tecla.
- Soltar el botón que elige tras elegir el mismo perfil no envía nada.

En el banco: en la XIAO, elegir cada perfil y comprobar el color del LED tras el reinicio y que el teléfono se reconecta.

## Documentación

En inglés y castellano: el README del firmware (perfiles, notas de conexiones, primera prueba), la especificación del firmware (sección de perfiles), el mapa de controles (filas del centro del joystick) y la incógnita abierta "LED de perfil" de las notas mecánicas, que este diseño cierra.
