# Mapa de controles — Borrador

> Traducción al castellano de [control-mapping.md](control-mapping.md). La versión en inglés es la de referencia; si las dos difieren, vale la inglesa.

**Estado:** modelo de entradas propuesto; las asignaciones en cada app y el comportamiento del hardware aún hay que validarlos en el banco.

Este documento separa los gestos físicos de las acciones de cada app. El firmware debería permitir elegir un perfil y cambiar las teclas asignadas; la tabla de abajo es un punto de partida, no una garantía de que cada app acepte cada gesto.

## Modelo de entradas físicas

El orden de controles propuesto es de tres botones encima de un joystick.

| Control | Entradas que reconoce el firmware |
|---|---|
| Botón A (arriba) | Pulsación corta, larga y doble |
| Botón B (en medio) | Pulsación corta, larga y doble |
| Botón C (el botón de abajo) | Pulsación corta, larga y doble |
| Joystick | Arriba, abajo, izquierda, derecha y pulsación central |
| Pulsación central del joystick | Corta, larga y doble, si el joystick elegido tiene interruptor central |

Las direcciones del joystick son eventos de dirección, no gestos de botón. Una variante de joystick sin interruptor central simplemente no tiene esos tres gestos centrales.

## Perfiles de app propuestos

### TerraPirata Rally Roadbooks

Probado en Android el 20-10-2026 con el firmware 0.9.0 (mira el [README del firmware](../firmware/xiao-nrf52840/README.es.md#perfiles-de-app)). TerraPirata muestra dos contadores: el trip, que el mando ajusta, y el total. El perfil TerraPirata del firmware envía:

| Entrada | Tecla enviada | Acción en TerraPirata | Estado |
|---|---|---|---|
| Joystick arriba/abajo | Flecha arriba/abajo, mantenida | Sube/baja el roadbook | Funciona |
| Joystick izquierda/derecha | Flecha izquierda/derecha, mantenida | Trip − / + (10 m por paso); más rápido si se mantiene | Funciona |
| Botón C, corta | Toque de `x` | Bloquea o desbloquea la pantalla | Funciona |
| Botón A, larga (2 s) | Toque de `r` | Abre el diálogo "reiniciar odómetro"; al aceptarlo en la pantalla, el trip vuelve a cero | Funciona |
| Botón B, larga (2 s) | Toque de `z` | Reset del total | Funciona |
| Botones A y B, corta o doble | Nada | — | A propósito, para que una pulsación sin querer no resetee nada |
| Centro del joystick | Nada | — | Mantenido 5 s, cambia de perfil |

Las pulsaciones largas duran 2 s (`RESET_LONG_PRESS_MS`), no los 600 ms de los otros perfiles, porque las dos ponen un contador a cero. El firmware 0.8.0 enviaba en cambio teclas de medios (Play/Pause en A, subir/bajar volumen en B y C); esas teclas llegan a la app que esté delante, así que la 0.9.0 no envía ninguna.

#### Teclas a las que reacciona TerraPirata

Encontradas el 20-10-2026 con la [prueba de teclas](../firmware/key-probe/README.es.md), que envía una tecla cada vez, y comprobadas con su registro serie. Las candidatas son las teclas que envía un mando de rally comercial. De su firmware ("offroad Zone V1.4", ESP32) solo se han leído los códigos de tecla: cada botón envía una tecla fija, a menudo una de medios y otra de teclado a la vez.

| Tecla | Acción en TerraPirata |
|---|---|
| `x` | Bloquea o desbloquea la pantalla |
| `r` | Abre el diálogo "reiniciar odómetro"; al aceptarlo, el trip vuelve a cero |
| `z` | Reset del total |
| Play/Pause (medios) | Reset del total |
| F6 | Baja el roadbook |
| F7 | Sube el roadbook |
| Subir / bajar volumen (medios) | Trip + / − |
| Flecha derecha / izquierda | Trip + / − (la izquierda no hace nada con el trip a cero) |
| `c`, `k` | Nada |

El diálogo "reiniciar odómetro" se confirma tocando la pantalla, por decisión: es un botón grande en pantalla, y Enter o Espacio podrían pulsar el control que tenga el foco. Aún no se ha encontrado: la tecla para ocultar las centenas. No se ha comprobado si estas teclas dependen de algún ajuste de TerraPirata, ni en iOS. TerraPirata recomienda su modo de mando dedicado, y en iOS exige ese modo o el modo de compatibilidad de la app; iOS queda para más adelante.

### OsmAnd (Android e iOS)

Probado en Android el 20-10-2026 con el firmware 0.10.0. El perfil de gestos del firmware envía las teclas del tipo de dispositivo "Keyboard" que trae OsmAnd ([OsmAnd: dispositivos de entrada externos](https://www.osmand.net/docs/user/map/interact-with-map/)), más `x` para el bloqueo de pantalla:

| Entrada | Tecla enviada | Acción en OsmAnd | Estado |
|---|---|---|---|
| Joystick arriba/abajo/izquierda/derecha | Flechas, mantenidas | Mover el mapa | Funciona |
| Centro del joystick, corta | `C`, al soltar | Ir a mi posición | Funciona |
| Botón A, corta / larga / doble | `D` / `N` / `P` | Cambiar la orientación del mapa / mostrar u ocultar la navegación / perfil de app siguiente | Funciona |
| Botón B, corta / larga | `-` al soltar / `S` | Alejar / mostrar u ocultar la búsqueda | Funciona |
| Botón C, corta / larga | `=` al soltar / `x` | Acercar / bloqueo de la pantalla táctil | Funciona; `x` necesita un tipo de dispositivo propio, abajo |
| Centro del joystick, larga | — | — | Mantenido 5 s, cambia el perfil del mando |

B y C no tienen doble pulsación, así que su zoom sale al soltar, sin la espera de 300 ms; varios toques seguidos hacen zoom paso a paso. Se usa `=` para acercar porque `+` necesita Mayúsculas.

Hay dos formas de configurar OsmAnd, en cada perfil de app que uses en moto (los ajustes van por perfil de app; no hay "aplicar a todos", solo copiar o exportar un perfil entero):

- **Tipo "Keyboard" integrado:** no hay que asignar nada, pero sus acciones no se pueden cambiar, así que `x` no hace nada: funciona todo menos el bloqueo de pantalla.
- **Tipo propio (Custom):** un tipo nuevo empieza vacío. Asigna cada tecla de arriba a su acción, y `x` a la acción rápida "Touch screen lock" (Interface). Funciona todo.

Android: *Menu → Configure profile → General settings → Other → External input devices*. iOS: *Menu → Settings → App profiles → General settings → External input devices*. OsmAnd no acepta teclas de medios en su asignación de teclas (probado el 14-10-2026). iOS no se ha probado.

### DMD² / DMD Next (solo Android)

| Entrada | Acción propuesta | Estado |
|---|---|---|
| Direcciones del joystick | Mover el mapa | DMD² documenta acciones de desplazamiento para mandos HID genéricos. |
| Centro del joystick | Toque de `D` (perfil de teclado), si se asigna | Evitar duplicar el seguimiento del mapa del botón A; lo puede configurar el usuario. |
| Botón A — corta | Activar/desactivar seguimiento del mapa | Candidata; configurar en el mapa "Generic Remote" de DMD². |
| Botón B — corta | Acercar | Candidata; configurar en el mapa "Generic Remote" de DMD². |
| Botón C — corta | Alejar | Candidata; configurar en el mapa "Generic Remote" de DMD². |
| Pulsación larga | Una acción de pulsación larga configurable por control | DMD² mide él mismo la pulsación larga: una tecla aparte para la pulsación larga del firmware no funcionó (14-10-2026). El perfil de teclado mantiene `A`, `B`, `C` mientras se pulsa cada botón, y así DMD² reconoció la pulsación larga. |
| Pulsación doble | No se da por disponible como gesto de mando genérico | La documentación de DMD² dice que los mandos genéricos no tienen las funciones de doble toque de los mandos DMD. Una tecla aparte solo funcionaría si la app ofrece una asignación para ella. |

El "Generic Remote Controller" de DMD² puede requerir una licencia de DMD. La app de navegación es solo para Android.

### Perfil de teclado genérico

El perfil genérico debería enviar un conjunto simple y documentado de teclas. Se pueden reasignar en las apps que admiten teclado externo. No puede dar acciones que la app receptora no ofrezca.

## Tiempos de gestos: valores de prototipo a evaluar

- Antirrebote: empezar a probar alrededor de 20–40 ms.
- Umbral de pulsación larga: empezar alrededor de 600 ms.
- Ventana de doble pulsación: empezar alrededor de 300 ms.

Son valores de partida para el prototipo, no requisitos fijos. Como una pulsación corta no se distingue de la primera mitad de una doble hasta que vence la ventana de doble pulsación, mide el retraso que se nota y deja que los umbrales se puedan ajustar en el firmware si es práctico.

## Matriz de validación en banco

Anota el modelo de teléfono o tablet, la versión del sistema, la versión de la app, el perfil elegido, la tecla recibida y la acción resultante.

| Prueba | Android | iOS |
|---|---|---|
| Emparejamiento BLE y reconexión automática | Pasa, también tras cambiar de perfil | Pendiente |
| Modo dedicado / modo de compatibilidad de TerraPirata | No probado; las teclas de arriba funcionan sin cambiar ningún ajuste | Pendiente |
| TerraPirata: trip +/−, reset del trip y del total, bloqueo de pantalla, desplazamiento del roadbook | Pasa con el firmware 0.9.0 (20-10-2026); el reset del trip hay que confirmarlo tocando la pantalla | Pendiente |
| OsmAnd: flechas, `C`, `D`, `N`, `=`, `-`, `x` (perfil de gestos) | Pasa con el firmware 0.10.0 (20-10-2026), `P` y `S` incluidas, con un tipo de dispositivo propio para `x` | Pendiente |
| OsmAnd: teclas asignadas por el usuario y Acciones rápidas | `x` asignada a "Touch screen lock" en un tipo propio: pasa | Pendiente |
| DMD²: mapa "Generic Remote" y pulsación larga | Pasa con teclas mantenidas (perfil de teclado); una tecla aparte para la pulsación larga falla | No aplica: la navegación de DMD² es solo para Android |
| Distinción entre corta, larga y doble, y comportamiento al mantener | Pendiente | Pendiente |
| Variante de joystick con interruptor central y sin él | Pendiente | Pendiente |

## Referencias

- [TerraPirata Rally Roadbooks: mandos, odómetro, odómetro parcial y bloqueo de pantalla](https://terrapirata.com/rally-roadbooks/)
- [TerraPirata: notas de compatibilidad de mandos Bluetooth](https://terrapirata.com/bluetooth-remotes/)
- [OsmAnd: dispositivos de entrada externos y acciones de teclado](https://www.osmand.net/docs/user/map/interact-with-map/)
- [OsmAnd: Acciones rápidas para teclas externas](https://osmand.net/docs/user/widgets/quick-action/)
- [DMD²: dispositivos y mandos genéricos](https://docs.dmdnavigation.com/dmdnext/devices/)
- [DMD² FAQ: limitaciones de los mandos genéricos y disponibilidad en iOS](https://docs.dmdnavigation.com/faq/)
