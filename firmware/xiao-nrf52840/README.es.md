# Firmware de banco para la XIAO nRF52840

> Traducción al castellano de [README.md](README.md). La versión en inglés es la de referencia; si las dos difieren, vale la inglesa.

Esta carpeta contiene el firmware de banco para la Seeed XIAO nRF52840. Lee los interruptores y funciona como teclado BLE HID, con un perfil TerraPirata, un perfil de teclado con teclas mantenidas para DMD2 y un perfil de gestos para OsmAnd. Es solo para pruebas en el banco y no sirve para usarlo conduciendo.

## Carga

Sigue la [guía del entorno de desarrollo](../../docs/development-environment.md) y abre `open-rally-remote.ino` en Arduino IDE 2. Elige **Seeed XIAO nRF52840** y el puerto USB de la XIAO, y pulsa **Verify** y **Upload**.

El sketch usa el paquete `Seeed nRF52 Boards` y la librería Adafruit Bluefruit BLE HID que trae. También incluye `Adafruit_TinyUSB.h` para el diagnóstico por el puerto serie USB de la XIAO con este paquete.

## Conexiones

Conecta cada interruptor normalmente abierto entre su GPIO y GND:

| Pin de la XIAO | Entrada | Perfil TerraPirata (corta / larga, 2 s) | Perfil de teclado | Perfil de gestos, para OsmAnd (corta / larga / doble) |
|---|---|---|---|---|
| D0 | Botón A | — / `r` (diálogo de reset del trip) | Mantiene `A` | `D` orientación / `N` navegación / `P` perfil de app siguiente |
| D1 | Botón B | — / `z` (reset del total) | Mantiene `B` | `-` alejar / `S` búsqueda / — |
| D2 | Botón C | `x` (bloquea o desbloquea la pantalla) / — | Mantiene `C` | `=` acercar / `x` bloqueo de pantalla / — |
| D3 | Joystick arriba | Mantiene flecha arriba | Mantiene flecha arriba | Mantiene flecha arriba |
| D4 | Joystick abajo | Mantiene flecha abajo | Mantiene flecha abajo | Mantiene flecha abajo |
| D5 | Joystick izquierda | Mantiene flecha izquierda | Mantiene flecha izquierda | Mantiene flecha izquierda |
| D6 | Joystick derecha | Mantiene flecha derecha | Mantiene flecha derecha | Mantiene flecha derecha |
| — | Centro del joystick: tres o más direcciones cerradas a la vez, sin pin propio | Nada | `D` en pulsación corta o doble | `C` mi posición |

En el perfil de teclado y en el joystick, una tecla mantenida se pulsa cuando se cierra el interruptor y se suelta cuando se abre; la app mide ella misma las pulsaciones cortas y largas. En los perfiles TerraPirata y de gestos, el firmware envía un toque de 50 ms de una tecla distinta para cada gesto de botón. En el perfil TerraPirata una pulsación larga dura 2 s (`RESET_LONG_PRESS_MS`), porque las dos pulsaciones largas ponen un contador a cero. Un control sin doble pulsación envía su toque corto en cuanto se suelta (la C de TerraPirata; B, C y el centro en el perfil de gestos); los demás esperan la ventana de doble pulsación de 300 ms. El perfil de gestos envía las teclas del tipo de dispositivo "Keyboard" que trae OsmAnd, más `x`, que en OsmAnd necesita un tipo propio; mira el [mapa de controles](../../docs/control-mapping.es.md#osmand-android-e-ios). Mantener el centro del joystick 5 s y soltarlo inicia la selección de perfil; mira [Perfiles](#perfiles).

El joystick no tiene interruptor central: al empujar la palanca hacia dentro se cierran los cuatro interruptores de dirección, y el sketch interpreta tres o más cerrados a la vez como pulsación central (mira la [especificación del firmware](../../docs/firmware-spec.es.md#5-procesado-de-entradas-y-reglas-de-gestos)). En la protoboard, pulsa tres interruptores de dirección a la vez. D7 no se lee. (El firmware 0.11.0 y anteriores tenían además una opción `CENTER_FROM_CHORD = false` para un interruptor central aparte en D7; la 0.11.1 la quitó.)

En modo acorde, la pulsación de una dirección se retiene durante la ventana de acorde de 40 ms (`CHORD_WINDOW_MS`) desde que se cierra la primera dirección:
- Si se cierran tres o más direcciones dentro de la ventana, el sketch lee la pulsación central y no envía ninguna flecha hasta que se sueltan todas.
- Si hay dos direcciones opuestas cerradas, no se envía ninguna flecha.
- Una inclinación soltada dentro de la ventana se envía como un toque de flecha.
- Un empuje más lento que la ventana envía primero la flecha del primer interruptor, luego la suelta y lee la pulsación central.

Todos los pines conectados usan `INPUT_PULLUP`: abierto o suelto se lee HIGH, pulsado se lee LOW. No conectes ninguna entrada a 3,3 V ni a 5 V.

## Primera prueba

1. Carga el sketch y abre el Monitor Serie a 115200 baudios.
2. En los 2 minutos siguientes al arranque, empareja **Open Rally Remote** desde los ajustes de Bluetooth del teléfono (desde la 0.13.0 los teléfonos nuevos ya no ven el mando después).
3. Cambia al perfil de gestos (LED blanco), abre un comprobador de teclado o un campo de texto inofensivo y pulsa cada control. Las teclas identifican los gestos; las direcciones del joystick envían flechas mantenidas.
4. En el joystick, comprueba que un empuje recto da una sola `C` central y ninguna flecha, y que las inclinaciones y diagonales no dan pulsación central.

Las pulsaciones cortas de los controles con doble pulsación se retrasan por la ventana de doble pulsación de 300 ms. Los tiempos iniciales son unos 30 ms de antirrebote, 600 ms de pulsación larga, 300 ms de doble pulsación, 40 ms de ventana de acorde y 50 ms de tecla pulsada en los toques. Con la ventana de acorde, una flecha sale unos 70 ms después del interruptor.

No pruebes este firmware en una app mientras conduces. Las actualizaciones por BLE funcionan en el banco; mira [Actualización por BLE](#actualizacion-ble).

<a id="perfiles"></a>
## Perfiles

El perfil se guarda en la flash de la XIAO (`/profile` en su sistema de ficheros interno) y se conserva al apagarla. El primer arranque usa el perfil TerraPirata.

- **Elegir:** mantén el centro del joystick 5 s (`PROFILE_SWITCH_MS`) y suéltalo; después, en 5 s (`PROFILE_SELECT_MS`), pulsa un botón y suéltalo: A para TerraPirata, B para teclado, C para gestos. Al soltarlo se elige, aunque hayan pasado los 5 s; la placa guarda ese perfil y se reinicia; el teléfono se reconecta sin volver a emparejar. Elegir el perfil actual termina la selección sin reiniciar. Si no se pulsa ningún botón en 5 s, o se pulsan dos, la selección termina sin cambios, y el apagado con A + B + C sigue funcionando. Durante la selección no se envía ninguna tecla. Si se suelta antes de 5 s, el centro no hace nada. Antes del firmware 0.11.0 mantenerlo pasaba al siguiente perfil, y el piloto no podía ver cuál ([diseño](../../docs/superpowers/specs/2026-10-20-profile-selection-design.es.md)).
- **Indicación:** el LED RGB de la XIAO, junto al conector USB-C, parpadea 100 ms cada 10 s: verde en TerraPirata, azul en teclado y blanco en gestos. El LED se enciende con nivel bajo.
- **Nombre:** todos los perfiles se anuncian como `Open Rally Remote`. Android conserva el nombre que vio al emparejar, así que un nombre por perfil no se mostraba.

El LED de conexión de la librería Bluefruit está desactivado: en esta placa maneja el LED azul con la polaridad contraria, así que nunca se encendía.

La elección de perfiles sale de las pruebas con apps de la [especificación del firmware](../../docs/firmware-spec.md#7-profiles-and-mappings) y del [mapa de controles](../../docs/control-mapping.es.md).

## Placa de control V0.26

`BOARD_V026` (por defecto `false`) selecciona la [placa de control V0.26](../../electronics/control-pcb/README.md), en la que la XIAO va pinchada en dos zócalos hembra y toma sus 3,3 V del regulador de la placa. El mapa de pines cambia:

| Pin de la XIAO | BOARD_V026 = false (protoboard, V0.25) | BOARD_V026 = true (V0.26) |
|---|---|---|
| D0 | Botón A | Tensión de la batería (A0, divisor de 1 MΩ / 1 MΩ) |
| D1–D3 | Botón B, botón C, joystick arriba | Botones A, B, C |
| D4–D6 | Joystick abajo, izquierda, derecha | Joystick arriba, abajo, izquierda |
| D7 | — | Joystick derecha |
| D8 | Salida del LED de carga | STAT del cargador a través de un divisor: bajo mientras carga, alto al terminar |
| D9 | — | VBUS del puerto de carga a través de un divisor; también despierta de System OFF |

Con `BOARD_V026 = true` el firmware no toca P0.13, P0.14 ni el cargador de la XIAO, no maneja ningún LED de carga (lo hace la salida STAT del cargador) y lee "cargador presente" en D9 en vez de usar la detección USB del nRF52840. Los dos valores compilaron el 14-10-2026 sin avisos del sketch; la versión `true` todavía no se ha ejecutado en una placa.

De la revisión de la placa del 15-10-2026: sin batería, la salida STAT del cargador queda en alta impedancia y el divisor de la placa lleva D8 a nivel bajo, así que `charging()` devuelve verdadero. Además, el cargador solo termina una carga cuando el consumo medio de la XIAO se queda por debajo de unos 5,6 mA, porque mide toda su corriente de salida (mira "Charge termination" en el [README de la placa de control](../../electronics/control-pcb/README.md)). Mide la corriente con la placa despierta y en USB antes de fiarte de que el LED de carga se apague.

## Alimentación y batería

Siguen el [estudio de la batería](../../docs/battery-study.md#firmware). Las constantes están cerca del principio del sketch.

- **Nivel de batería:** se lee cada 60 s en P0.31 (AIN7) con P0.14 a nivel bajo, como media de 8 muestras. El divisor es de 1 MΩ sobre 510 kΩ (`VBAT_DIVIDER`, del esquema de Seeed); calibra la lectura con un multímetro. El nivel llega al teléfono por el BLE Battery Service, añadido después del servicio HID para que no se muevan los identificadores de atributos existentes. Por debajo de 3,5 V el parpadeo del perfil pasa a rojo; por debajo de 3,3 V sin USB, la placa entra en System OFF.
- **P0.14:** se mantiene a nivel bajo desde la primera línea de `setup()`. El núcleo de Seeed lo pone alto al arrancar, y Seeed avisa de que entonces P0.31 puede llegar a su límite de 3,6 V mientras carga.
- **Carga, montaje en protoboard:** el cargador propio del XIAO, unos 50 mA por defecto; `HIGH_CHARGE_CURRENT` selecciona unos 100 mA. D8 maneja el LED de carga de la placa USB-C de la V0.24/V0.25 mientras hay USB y `CHG` (P0.17) está a nivel bajo.
- **Carga, placa de la V0.26 (`BOARD_V026`):** carga el MCP73831 de la placa de control, y su STAT maneja el LED de carga de la placa USB-C; el firmware solo lee STAT en D8. Sin cargador el LED no tiene alimentación, así que el firmware no puede usarlo como luz de estado (ver la [placa de control](../../electronics/control-pcb/README.md#next-revision)).
- **Apagado:** mantén A, B y C a la vez durante 3 s. El LED se queda en rojo fijo y la placa se duerme al soltar los tres. Mientras hay dos o más pulsados, los botones no envían nada, aunque en el perfil de teclado la tecla del primer botón ya ha salido. En el perfil TerraPirata no sale nada: A y B solo actúan a los 2 s, y C al soltarlo.
- **Apagado automático:** tras 6 h sin ninguna entrada (`AUTO_OFF_MS`).
- **Despertar:** cualquier interruptor que se suelta, por GPIO sense, o al conectar un cargador. La pulsación que la despierta no se envía.
- **USB:** mientras hay alimentación USB, la placa no se duerme (ni por apagado, ni automático, ni por batería baja). Para las pruebas de banco, `SLEEP_ON_USB = true` permite dormirla con USB.

<a id="releases"></a>
## Versiones publicadas

El workflow `firmware` (`.github/workflows/firmware.yml`) compila el sketch y ejecuta los tests de host en cada push a main y en cada pull request que toque esta carpeta. Guarda los archivos como artefacto del workflow.

Para publicar una versión:
1. Pon `FIRMWARE_VERSION` en el sketch y llévalo a main.
2. Sube una etiqueta `fw-v<versión>` en ese commit, por ejemplo `git tag -s fw-v0.11.1 && git push origin fw-v0.11.1`.
3. El workflow comprueba que la etiqueta coincide con `FIRMWARE_VERSION` y está en main, compila y crea una release en **borrador** con los archivos y las notas de `release/notes.md`.
4. Revisa el borrador en GitHub y publícalo.

Se usa un borrador creado desde una etiqueta, y no una release que dispare la compilación: los archivos y las comprobaciones llegan antes de que nadie vea la release, y una compilación fallida no publica nada.

Cada release tiene, para la placa V0.26 y para la protoboard, un `.uf2` (se copia a la unidad USB del XIAO tras pulsar reset dos veces), un `.zip` DFU (BLE o `adafruit-nrfutil`) y un `.hex`, más `SHA256SUMS`. `release/build.sh <carpeta>` genera los mismos archivos en local; en Apple Silicon, pon en `ARDUINO_CONFIG` una configuración cuyo core use Arm GNU 13.3 (ver [Comprobación de compilación](#comprobación-de-compilación)). La dirección de inicio del `.uf2` (0x27000, tras el SoftDevice S140) se comprobó el 27-10-2026; la carga por UF2 aún no se ha probado. Todavía no hay ninguna versión publicada.

## Comprobación de compilación

El sketch se compiló el 10-10-2026 con `arduino-cli` y Seeed nRF52 Boards 1.1.13 para `Seeeduino:nrf52:xiaonRF52840`, en los dos modos de pulsación central, sin avisos del sketch. El GCC 9 que trae el paquete es un binario Intel y no funcionaba en el Mac Apple Silicon sin Rosetta, así que la comprobación usó Arm GNU Toolchain 13.3. El Arduino IDE en una máquina que sí ejecute las herramientas del paquete puede mostrar otra cosa.

El sketch también se compila y se ejecuta en un ordenador, con interruptores, reloj y enlace BLE simulados: `make -C firmware/xiao-nrf52840/test` ejecuta pruebas de los perfiles, los gestos, el acorde del joystick, el cambio de perfil, el apagado y la reconexión en las dos placas. Mira el [README de las pruebas](test/README.es.md).

La herramienta de carga `adafruit-nrfutil` del paquete también es un binario Intel. En un Mac Apple Silicon sin Rosetta, instala la versión de Python (`pip install adafruit-nrfutil`; se usó la 0.5.3) e indica su ruta al paquete con un `platform.local.txt` junto a su `platform.txt`:

```text
tools.nrfutil.cmd.macosx=/path/to/venv/bin/adafruit-nrfutil
```

El firmware de fábrica de la placa no respondía a la petición de reinicio de la herramienta de carga. Abrir el puerto serie a 1200 baudios la puso en el bootloader, y después `adafruit-nrfutil dfu serial -pkg <sketch>.zip -p <port> -b 115200 --singlebank` la programó.

## Pruebas de banco

### Entradas y emparejamiento

Hechas el 13-10-2026 con una XIAO nRF52840 con pines ya soldados, los interruptores de 6×6 mm en una protoboard, en modo acorde, emparejada con un teléfono:

- Los botones A, B y C dieron las letras esperadas de corta, larga y doble (A–I) del mapa de diagnóstico de entonces.
- Las cuatro direcciones enviaron flechas.
- El acorde central, hecho apretando tres o cuatro interruptores de dirección con un objeto plano, dio J (corta), K (larga) y L (doble). Una doble pulsación necesita el segundo acorde antes de 300 ms desde que se sueltan todas las direcciones del primero; las pausas registradas fueron de unos 120 ms.

El bootloader de la placa se identifica como "XIAO nRF52840 Sense" (USB PID 0x0045), pero la placa es la XIAO nRF52840 normal: la etiqueta del blindaje dice "Model: XIAO-nRF52840", sin "Sense", y la huella del IMU de la cara superior está vacía. No se ha averiguado por qué el bootloader usa el nombre Sense. El sketch se compila para la XIAO nRF52840 normal; D0–D10 son iguales en las dos.

### Perfiles de app

El perfil TerraPirata cambió en el firmware 0.9.0; mira [Firmware 0.9.0](#firmware-090). Prueba hecha el 14-10-2026 con un teléfono Android. El firmware envió primero una tecla candidata distinta para cada gesto, y después teclas mantenidas en los botones:

| Tecla | TerraPirata |
|---|---|
| Flecha arriba / abajo | Desplaza el roadbook |
| Flecha izquierda / derecha | Ajusta el trip; más rápido si se mantiene |
| Subir / bajar volumen | Ajusta el trip; más rápido si se mantiene |
| Play/Pause | Pone a cero el total |
| Pista siguiente / anterior | Baja / sube el roadbook |
| Avance / retroceso de página | Nada |
| Silencio | El teléfono se silenció y volvió a sonar |
| Espacio | Abrió el diálogo "Borrar datos del mapa" |

OsmAnd no aceptó teclas de medios en su asignación de teclas; sí aceptó las letras del perfil de gestos. DMD2 medía él mismo las pulsaciones largas, así que no se podía usar una tecla aparte para la pulsación larga del firmware; con las teclas mantenidas del perfil de teclado, DMD2 reconoció la pulsación larga. Enter, Escape y Tab no se probaron: como Espacio, pueden pulsar el control que tiene el foco en pantalla. El teléfono se reconectó tras cada cambio de perfil, y el LED mostró el perfil guardado tras reiniciar, en los tres colores.

### Apagado y despertar

Hecho el 14-10-2026 con USB, sin batería, con `SLEEP_ON_USB = true` y `AUTO_OFF_MS` a 60 s:

- El apagado automático entró en System OFF 60 s después de la última entrada.
- B + C + A mantenidos 3 s armaron el apagado (LED rojo fijo), y la placa se durmió al soltar los botones.
- Un botón o un interruptor del joystick despertó la placa; la pulsación no se envió, y el teléfono se reconectó en alrededor de 1 s tras el reinicio.

Sin batería, la lectura de la batería flota (se registraron de 3,7 a 4,1 V) y no significa nada.

### Firmware 0.8.0

Hecho el 14-10-2026 con la versión de protoboard (`BOARD_V026 = false`): el firmware seguía funcionando en los dos perfiles probados. No se apuntó qué entradas se pulsaron, y el tercer perfil no se probó.

<a id="firmware-090"></a>
### Firmware 0.9.0

Hecho el 20-10-2026 con la versión de protoboard (`BOARD_V026 = false`), en el perfil TerraPirata, con un teléfono Android. El registro serie mostró cada gesto y su tecla:

- El joystick izquierda y derecha restó y sumó trip; arriba y abajo desplazaron el roadbook.
- C envió `x` y bloqueó, y luego desbloqueó, la pantalla.
- A mantenido 2 s envió `r` y abrió el diálogo "reiniciar odómetro"; al aceptarlo en la pantalla, el trip volvió a cero.
- B mantenido 2 s envió `z` y puso a cero el total.
- Las pulsaciones cortas y dobles de A y B no enviaron nada.

Las teclas salen de la [prueba de teclas](../key-probe/README.es.md); mira el [mapa de controles](../../docs/control-mapping.es.md#terrapirata-rally-roadbooks). Las dos versiones (`BOARD_V026` false y true) compilaron sin avisos del sketch.

### Firmware 0.10.0

Hecho el 20-10-2026 con la versión de protoboard, en el perfil de gestos, con OsmAnd en un teléfono Android y un tipo de dispositivo externo propio con las teclas asignadas. El registro serie mostró cada tecla: B y C alejaron y acercaron, C mantenido bloqueó y desbloqueó la pantalla (`x` asignada a "Touch screen lock"), el centro llevó el mapa a la posición, A corta y larga cambiaron la orientación y mostraron la navegación, y el joystick movió el mapa. A doble (`P`) pasó al perfil de app siguiente y B larga (`S`) abrió la búsqueda, en una prueba anterior.

### Firmware 0.11.0

La selección de perfil sustituye al cambio de perfil en ciclo. La cubren las pruebas en el ordenador (37 pruebas por placa, todas pasan), y las dos versiones compilaron sin avisos del sketch. El 20-10-2026, con la versión de protoboard y un teléfono Android: elegir B y luego A reinició en los perfiles de teclado (LED azul) y TerraPirata (verde), y el teléfono se reconectó; elegir el perfil actual, dejar que caducara la selección y mover el joystick durante ella no cambiaron nada ni enviaron ninguna tecla.

### Firmware 0.12.0

La actualización por BLE necesita un teléfono emparejado, un enlace cifrado y alimentación USB, y los emparejamientos nuevos solo se guardan en los 2 primeros minutos tras un arranque (ver [Actualización por BLE](#actualizacion-ble)). Los tests de host cubren las dos comprobaciones (45 tests por placa, pasan todos), y las dos versiones compilaron sin avisos del sketch el 27-10-2026. Con la versión de protoboard ese mismo día y un teléfono Android:
- Una actualización desde nRF Connect, con el teléfono emparejado y la placa en USB, terminó bien. Android cifró el enlace por sí solo, el bootloader validó la imagen y la placa la arrancó sin reset. La línea de registro "BLE update allowed" nunca llega al ordenador: la placa salta antes al bootloader. Tras la actualización, el puerto serie USB siguió mudo hasta volver a enchufar la placa.
- Un emparejamiento fuera de la ventana se borró y el teléfono se desconectó. Pero para el teléfono el emparejamiento había salido bien, así que guardó sus claves, se reconectó, emparejó otra vez y se rechazó otra vez, en bucle. La 0.13.0 lo corrige.
- El rechazo sin USB aún no se ha probado (necesita una celda).

### Firmware 0.13.0

Tras la ventana de emparejamiento, el mando solo se anuncia para sus teléfonos emparejados (`orr_whitelist.cpp`), así que un teléfono rechazado no puede reintentar. Los tests de host cubren el cambio (52 tests por placa, pasan todos), y las dos versiones compilaron sin avisos del sketch el 27-10-2026. Con la versión de protoboard ese mismo día y un teléfono Android: al cerrarse la ventana, el registro dijo "BLE advertising to bonded phones only"; el teléfono emparejado, que usa una dirección privada, se reconectó solo y sus teclas llegaron al teléfono; un Mac no mostró el mando.

La primera versión falló con `BLE_ERROR_GAP_DISCOVERABLE_WITH_WHITELIST` (0x3201): el SoftDevice no admite una lista blanca con un anuncio descubrible. Por eso el anuncio para emparejados pone los flags en "no descubrible", y los teléfonos nuevos ya no ven el mando. El sketch volvió entonces al anuncio abierto, como estaba previsto, y registró la llamada que falló.

### Firmware 0.11.1

Se quita el interruptor central aparte en D7 (`CENTER_FROM_CHORD = false`): ningún joystick del diseño lo tiene, y en la protoboard el centro también se hace con el acorde. Las pruebas en el ordenador pasan en las dos placas, sin cambios.

### Nombre BLE

El nombre anunciado salía cortado como `Open Rally Remo`: el paquete de anuncio solo cabe 15 caracteres de nombre después de los campos de flags, potencia de emisión, apariencia y servicio HID. Ahora el sketch envía el nombre en la respuesta de escaneo, y el teléfono mostró el nombre completo `Open Rally Remote` tras emparejar de nuevo.

<a id="actualizacion-ble"></a>
## Actualización por BLE

El sketch incluye el servicio DFU antiguo del bootloader de Adafruit. Una app del teléfono escribe en él y la placa se reinicia en el modo BLE OTA antiguo del bootloader, en el que se anuncia como `AdaDFU`. El bootloader no se cambia.

Desde el firmware 0.12.0 el servicio es `OrrDfu` (`orr_dfu.cpp`), una copia de `BLEDfu` de Bluefruit con los mismos UUID y características, porque `BLEDfu` no permite rechazar una actualización. La placa solo se reinicia en el bootloader si:
- el teléfono está emparejado y el enlace va cifrado (la característica de control exige cifrado, así que un teléfono emparejado cifra con sus claves guardadas), y
- hay alimentación USB: el puerto de carga queda bajo la base, así que el mando está fuera de la moto.

Si no, la escritura falla con "insufficient authorization" y el registro serie dice por qué.

Los emparejamientos nuevos solo se hacen en los 2 primeros minutos tras arrancar la placa (`PAIRING_WINDOW_MS`). Desde la 0.13.0, al cerrarse la ventana, el sketch para el anuncio de la librería y arranca el suyo (`orr_whitelist.cpp`). Carga los emparejamientos de la flash (hasta 8) y pasa al SoftDevice sus direcciones de identidad y sus IRK como lista blanca e identidades de dispositivo. El anuncio no es descubrible, y solo un teléfono de la lista blanca puede conectar; el SoftDevice resuelve su dirección privada con la IRK. Una conexión abierta al cerrarse la ventana sigue; el cambio espera a que termine. Sin ningún emparejamiento, el mando deja de anunciarse. Si falla una llamada del SoftDevice, el registro la nombra y el mando vuelve al anuncio abierto.

Un emparejamiento fuera de la ventana que no llega por la lista blanca (anuncio abierto tras un fallo, o una conexión hecha dentro de la ventana) se borra y el teléfono se desconecta. Un teléfono emparejado que empareja otra vez por la lista blanca conserva su emparejamiento. Los teléfonos ya emparejados se reconectan en cualquier momento. Para emparejar un teléfono nuevo, apaga y enciende el mando y empareja en menos de 2 minutos.

El bootloader de fábrica de la placa usada se leyó de la flash el 14-10-2026:

- Bootloader Adafruit UF2 0.6.1, compilado el 12-11-2021, Board-ID `Seeed_XIAO_nRF52840_Sense`.
- SoftDevice S140 7.3.0 (firmware ID `0x0123`).

El paquete es el `.zip` que `arduino-cli compile` escribe junto al `.hex`. Para actualizar desde un teléfono Android con nRF Connect for Mobile:

0. Enchufa el mando a un cargador USB; el teléfono tiene que ser el emparejado con él.
1. En **Settings > DFU options**, activa **Disable MTU Request**, **Packet receipt notification** con 8 paquetes y **Scan for bootloader in Legacy DFU**.
2. Desconecta el mando en los ajustes de Bluetooth del teléfono y conéctate a él desde nRF Connect.
3. Pulsa **DFU**, elige "Distribution packet (ZIP)" y selecciona el paquete.
4. Tras la actualización, refresca los servicios y lee Software Revision en Device Information.

El 14-10-2026 esto actualizó la aplicación de `0.3.0-diagnostic` a una versión de prueba, `0.3.0-ota-test`, con la placa en un cargador USB y sin ordenador. El teléfono se reconectó después como teclado sin volver a emparejar. Una segunda actualización, de vuelta a `0.3.0-diagnostic`, se hizo con la placa conectada por USB a un ordenador. La imagen de 115460 bytes tardó 35,8 s, unos 3,2 kB/s; la validación pasó y la placa arrancó la nueva aplicación sin reinicio manual. iOS no se ha probado.

Fallos conocidos, todos vistos en esta prueba:

- **MTU.** Por defecto la app sube la MTU a 247, y cada paquete de datos lleva hasta 244 bytes. El bootloader 0.6.1 pierde entonces datos: con notificaciones de recepción de paquetes la transferencia se paró en el 1 %; sin ellas llegó al 100 % y falló la validación. Con la petición de MTU desactivada, los paquetes llevan 20 bytes y la transferencia terminó. Coincide con el [problema #306 del bootloader de Adafruit](https://github.com/adafruit/Adafruit_nRF52_Bootloader/issues/306): un búfer de recepción demasiado pequeño.
- **Transferencia fallida.** La actualización es de un solo banco: el bootloader borra primero la aplicación. Tras una transferencia fallida, la placa arranca en el bootloader sin aplicación. Entonces aparece por USB como "XIAO nRF52840 Sense", y una carga por USB la recupera.
- **App aún en marcha.** Tras cancelar una actualización, el servicio DFU de nRF Connect seguía funcionando en el teléfono. Al volver a alimentar la placa, el teléfono la mandó otra vez al bootloader, y la placa no se anunciaba como `Open Rally Remote`. Fuerza el cierre de la app tras una actualización cancelada.
- **Caché GATT.** Android guarda en caché la tabla de atributos de un dispositivo vinculado. Si una versión añade o mueve un servicio, el teléfono lee identificadores equivocados. En nRF Connect, usa **Refresh services**. Un host HID con la caché desfasada también puede fallar; si pasa, vuelve a emparejar. Mantén la tabla de atributos igual entre versiones.
- **Imágenes sin firmar.** Hasta la 0.11.1, `BLEDfu` no necesitaba emparejamiento, así que cualquiera a su alcance podía reprogramar la placa. Desde la 0.12.0 solo un teléfono emparejado, con el mando alimentado por USB, puede iniciar una actualización (arriba). Una vez en el bootloader, la placa sigue aceptando cualquier imagen sin firmar; las imágenes firmadas necesitan otro bootloader, grabado por SWD.

El [fork OTAFIX del bootloader](https://github.com/oltaco/Adafruit_nRF52_Bootloader_OTAFIX) también indica que los bootloaders antiguos no arrancan la nueva aplicación tras una actualización OTA si el USB está conectado a un ordenador. No pasó con el bootloader 0.6.1 en la prueba de arriba.
