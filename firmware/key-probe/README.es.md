# Prueba de teclas

> Traducción al castellano de [README.md](README.md). La versión en inglés es la de referencia.

Un sketch de banco para la XIAO nRF52840 que envía por BLE HID una tecla candidata cada vez. Sirve para averiguar a qué teclas reacciona una app. Los primeros objetivos son el bloqueo de pantalla y el reset del odómetro parcial de TerraPirata ([mapa de controles](../../docs/control-mapping.md)).

Las candidatas son las teclas que envía un mando de rally comercial (el firmware "offroad Zone V1.4"), cada una por separado, más dos de sus combinaciones:

| # | Envía |
|---:|---|
| 1 | F6 |
| 2 | F7 |
| 3 | `c` |
| 4 | `z` |
| 5 | `k` |
| 6 | `x` |
| 7 | `r` |
| 8 | Bajar volumen y luego F6 |
| 9 | Play/Pause y luego `z` |
| 10 | Subir volumen |
| 11 | Bajar volumen |
| 12 | Flecha derecha |
| 13 | Flecha izquierda |

Las candidatas 10 a 13 mueven el trip, para apartarlo de cero antes de probar un reset.

## Conexiones y uso

La misma protoboard que el sketch principal: botón A en D0, B en D1 y C en D2, cada uno a GND.

- **A** envía la candidata seleccionada: tecla pulsada, 50 ms, tecla soltada.
- **B** selecciona la siguiente candidata y **C** la anterior.
- Tras cada selección, el LED azul parpadea tantas veces como el número de la candidata. Cada envío hace un destello verde. Mientras el LED parpadea no se leen los botones (5 s con la candidata 13), así que espera a que termine; el registro serie es la referencia fiable.
- Con el Monitor Serie abierto a 115200 baudios, el sketch también escribe cada selección y cada envío.

Se anuncia como **ORR Key Probe**. Si el teléfono sigue teniendo la placa del banco emparejada como "Open Rally Remote", puede que no conecte: olvida ese dispositivo y empareja de nuevo. Al terminar, vuelve a cargar el sketch principal y emparéjalo otra vez.

## Prueba

1. Abre TerraPirata con un roadbook y los dos odómetros en marcha.
2. Envía cada candidata una vez, de la 1 a la 9. Tras cada una, apunta qué ha hecho la app: nada, bloqueo de pantalla, reset del parcial o del total, u otra cosa.
3. Vuelve a enviar cada una para deshacer lo que haya hecho; por ejemplo, para desbloquear la pantalla.

Apunta los resultados en [control-mapping.md](../../docs/control-mapping.es.md).

## Resultados

Hecho el 20-10-2026 con un teléfono Android y TerraPirata. Una primera tanda guiada por el LED salió desplazada una candidata y se descartó. La segunda, la de abajo, se comprobó con el registro serie, que nombra cada tecla enviada.

| # | Tecla | TerraPirata |
|---:|---|---|
| 1 | F6 | Baja el roadbook |
| 2 | F7 | Sube el roadbook |
| 3 | `c` | Nada |
| 4 | `z` | Pone a cero el total |
| 5 | `k` | Nada |
| 6 | `x` | Bloquea la pantalla; una segunda `x` la desbloquea |
| 7 | `r` | Abre el diálogo "reiniciar odómetro"; al aceptarlo, el trip vuelve a cero |
| 8 | Bajar volumen y luego F6 | Baja el roadbook (el trip estaba a cero) |
| 9 | Play/Pause y luego `z` | Pone a cero el total |
| 10 | Subir volumen | Trip + |
| 11 | Bajar volumen | Trip − |
| 12 | Flecha derecha | Trip +, 10 m por toque |
| 13 | Flecha izquierda | Nada, con el trip a cero |

## Compilación

Igual que el sketch principal; mira su [README](../xiao-nrf52840/README.md). Compiló el 20-10-2026 con Seeed nRF52 Boards 1.1.13, sin avisos del sketch, y se ejecutó en la XIAO del banco para los resultados de arriba.
