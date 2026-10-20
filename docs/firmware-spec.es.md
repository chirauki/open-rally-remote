# Especificación del firmware — Primer prototipo BLE HID

> Traducción al castellano de [firmware-spec.md](firmware-spec.md). La versión en inglés es la de referencia; si las dos difieren, vale la inglesa.

**Estado:** contrato de implementación propuesto para el prototipo de banco. El emparejamiento BLE, el envío de teclas, los tiempos de los gestos y cada perfil de app siguen sin validar hasta probarlos con la XIAO comprada y teléfonos reales.

## 1. Objetivo y alcance

El primer firmware debe demostrar que la XIAO nRF52840 puede leer los interruptores provisionales y funcionar como mando Bluetooth con Android e iOS. Ofrecerá una entrada de teclado estándar para que las apps compatibles reciban eventos de tecla conocidos. No dependerá de una app de acompañamiento en el teléfono ni de un servicio GATT propio del proyecto.

Es un prototipo de banco. No está listo para rodar y no demuestra resistencia a la intemperie ni a las vibraciones, ni compatibilidad con las apps.

## Requisito de producto: actualizaciones inalámbricas del firmware

El mando terminado lo tiene que poder actualizar su dueño desde un teléfono Android o iOS por Bluetooth LE, sin conectarlo a un ordenador. El USB sigue siendo la entrada de alimentación; no debe hacer falta como conexión de datos para las actualizaciones normales.

El hardware y el firmware finales deben ofrecer:

- Un bootloader BLE DFU y un proceso de actualización desde el teléfono, documentado para Android e iOS.
- Una forma deliberada de entrar en modo actualización, con la conexión normal del mando HID suspendida durante la actualización.
- Paquetes de actualización firmados, comprobaciones de versión y de producto, y un diseño de actualización que permita volver atrás (preferiblemente de doble banco: conservar la última imagen que funciona hasta que la nueva arranque bien).
- Un comportamiento de recuperación ante una transferencia interrumpida o un corte de alimentación. El dispositivo no debe quedar inutilizable si se interrumpe una actualización; compruébalo experimentalmente antes de publicar.
- Paquetes de firmware descargables públicamente y notas de versión claras. Una app propia aún no es un requisito si una app DFU existente y mantenida funciona en las dos plataformas con el bootloader elegido.

### Comprobación importante del bootloader de la XIAO

La XIAO es la placa adecuada para el primer prototipo HID, pero no des por hecho que su bootloader de fábrica puede hacer actualizaciones BLE OTA. En una respuesta pública de 2025, Seeed dijo que no tenía una solución ni documentación oficial para Bluetooth DFU en la XIAO nRF52840. Trata el OTA en esta XIAO como una investigación, no como una función disponible. Antes de elegir el controlador final, comprueba juntos el bootloader, el formato del paquete de actualización, la app de Android, la app de iOS, la autenticación de la imagen y el camino de recuperación.

Nordic ofrece una app móvil de DFU para Android e iOS para los bootloaders del nRF5 SDK. Su documentación distingue ese flujo del firmware hecho con el nRF Connect SDK, que usa la app nRF Connect Device Manager. El bootloader nRF52 de Adafruit es otra referencia técnica: describe BLE OTA, actualizaciones firmadas y actualizaciones opcionales de doble banco, pero la XIAO no está entre sus placas soportadas oficialmente. Por eso puede ser necesario portar un bootloader o cambiar el controlador final. Mira la [app móvil DFU de Nordic](https://www.nordicsemi.com/Products/Development-tools/nRF-Device-Firmware-Update), la [guía FOTA de Nordic](https://nrfconnectdocs.nordicsemi.com/ncs/latest/nrf/app_dev/device_guides/nrf52/fota_update.html), la [discusión de Seeed sobre el bootloader de la XIAO](https://github.com/Seeed-Studio/wiki-documents/discussions/2071) y el [bootloader nRF52 de Adafruit](https://github.com/adafruit/Adafruit_nRF52_Bootloader).

Una prueba de banco el 14-10-2026 comprobó el bootloader de fábrica de la placa comprada. Es el bootloader Adafruit UF2 0.6.1 (compilado el 12-11-2021, Board-ID `Seeed_XIAO_nRF52840_Sense`) con SoftDevice S140 7.3.0, y contiene el modo BLE OTA antiguo de Adafruit. Con el servicio `BLEDfu` del sketch, nRF Connect para Android actualizó la aplicación por BLE sin ordenador, tras cambiar un ajuste. Los detalles, los ajustes y los fallos están en el [README del firmware](../firmware/xiao-nrf52840/README.es.md#actualizacion-ble). Esto no cumple el requisito de producto de arriba: el bootloader de fábrica acepta imágenes sin firmar, actualiza en un solo banco y deja la placa sin aplicación tras una transferencia fallida. iOS no se ha probado.

No sustituyas ni modifiques el bootloader de la XIAO durante la puesta en marcha inicial del BLE HID. Primero deja establecido el comportamiento de las entradas y la navegación, y después prueba el OTA en una placa de desarrollo de repuesto, para que un experimento fallido con el bootloader no pare el prototipo principal.

## 2. Entorno de desarrollo y carga

El primer firmware se escribirá y cargará con **Arduino IDE 2** en un ordenador. La XIAO se conecta con un cable USB-C de datos; no hace falta un programador aparte. Arduino IDE compila el sketch para la placa XIAO elegida y lo carga por USB. Su Monitor Serie puede mostrar diagnósticos de los GPIO y del BLE durante el desarrollo.

1. Instala y abre [Arduino IDE](https://www.arduino.cc/en/software/).
2. En los ajustes del IDE, añade la URL del índice de placas de Seeed: `https://files.seeedstudio.com/arduino/package_seeeduino_boards_index.json`.
3. Abre el Boards Manager, busca **Seeed nRF52 Boards** e instálalo. Seeed recomienda este paquete para las funciones Bluetooth de la XIAO; usa el paquete nRF52 estándar, no el de mbed, para este prototipo BLE.
4. Conecta la XIAO con pines soldados al ordenador con un cable USB-C **de datos**.
5. Elige **Seeed XIAO nRF52840** entre las placas Seeed nRF52 y el puerto que aparece para la placa.
6. Abre el sketch `.ino` del proyecto, usa **Verify** para compilar y luego **Upload** para cargarlo. Empareja el mando desde los ajustes de Bluetooth del teléfono cuando el firmware HID esté funcionando.

El sketch de banco está en [firmware/xiao-nrf52840/open-rally-remote.ino](../firmware/xiao-nrf52840/open-rally-remote.ino). Usa el paquete de placas Seeed nRF52 y la API HID de Bluefruit que trae. Implementa el acorde central y los tres perfiles de la sección 7, y se ha probado en la XIAO comprada con un teléfono Android.

La [guía de la XIAO nRF52840](https://wiki.seeedstudio.com/XIAO_BLE/) de Seeed documenta la instalación de Arduino IDE y el paquete de placas. El [tutorial del gestor de placas de IDE 2](https://docs.arduino.cc/software/ide-v2/tutorials/ide-v2-board-manager/) de Arduino explica cómo instalar paquetes de soporte de placas.

## 3. Transporte Bluetooth

- Implementar el **HID over GATT Profile (HOGP)** del Bluetooth SIG como periférico BLE.
- Presentarse como un dispositivo HID de teclado estándar; el teléfono hace de central BLE y de host HID.
- Usar el protocolo estándar de informe de teclado, con informes de tecla pulsada y soltada. No enviar cadenas de texto ni paquetes propios de una app.
- Empezar con un único teléfono vinculado a la vez. Reconectar con el último host vinculado al encender. Ofrecer una forma documentada de borrar el vínculo durante el desarrollo; el gesto físico de reinicio se decide tras la primera prueba de banco.
- Usar un nombre de dispositivo estable y reconocible, como `Open Rally Remote`, y una cadena de fabricante y producto propia si la librería elegida lo permite.
- La clase `BLEHidAdafruit` de Seeed/Bluefruit usa un descriptor HID estándar que incluye colecciones de teclado, Consumer Control y ratón. El sketch solo envía informes de teclado; desde el firmware 0.9.0 ningún perfil envía informes Consumer Control (teclas de medios), y tampoco envía datos de ratón ni de mando de juegos. Si las colecciones extra anunciadas afectan al emparejamiento o a la compatibilidad con las apps, sustituye esta clase por un descriptor HID solo de teclado antes de dar el transporte por validado. No añadas un servicio GATT propio en la primera versión.

HOGP es el perfil del Bluetooth SIG para ofrecer entradas HID por BLE/GATT. Android documenta el soporte de central BLE y GATT, y OsmAnd documenta la entrada de teclado en Android e iOS. Eso hace que este sea un primer camino razonable, pero no garantiza que cada tecla o gesto funcione igual en todos los teléfonos. Mira [HOGP del Bluetooth SIG](https://www.bluetooth.com/specifications/specs/hid-over-gatt-profile-hogp/), la [introducción a BLE de Android](https://developer.android.com/develop/connectivity/bluetooth/ble/ble-overview) y los [dispositivos de entrada externos de OsmAnd](https://www.osmand.net/docs/user/map/interact-with-map/).

## 4. Entradas y comportamiento eléctrico

V0.26 (la [placa de control](../electronics/control-pcb/README.md), opción de firmware `BOARD_V026`):

| Pin de la XIAO | Uso |
|---|---|
| D0 (A0) | Tensión de la batería, divisor de 1 MΩ / 1 MΩ |
| D1, D2, D3 | Botones A, B, C (interruptor a GND) |
| D4, D5, D6, D7 | Joystick arriba, abajo, izquierda, derecha (interruptor a GND) |
| D8 | STAT del cargador a través de un divisor: bajo mientras carga, alto al terminar |
| D9 | VBUS del puerto de carga a través de un divisor; despierta de System OFF |
| D10 | Libre |
| 3V3 | Entrada de alimentación, desde el regulador de la placa de control |

V0.25 y la protoboard:

| Pin de la XIAO | Entrada | Suelto | Pulsado |
|---|---|---|---|
| D0 | Botón A | HIGH | LOW |
| D1 | Botón B | HIGH | LOW |
| D2 | Botón C | HIGH | LOW |
| D3 | Joystick arriba | HIGH | LOW |
| D4 | Joystick abajo | HIGH | LOW |
| D5 | Joystick izquierda | HIGH | LOW |
| D6 | Joystick derecha | HIGH | LOW |
| D7 | Sin uso (reservado) | — | — |
| D8 | Salida del LED de carga (V0.24), activa a nivel alto | — | — |

Configura cada entrada conectada como `INPUT_PULLUP`. Un interruptor cerrado une la entrada a GND. No conectes ninguna entrada de interruptor a 3,3 V ni a 5 V. D7 no está conectado en el hardware V0.22/V0.23 y hay que ignorarlo.

El joystick no tiene interruptor central aparte. Su palanca se apoya en cuatro interruptores C&K KSC2 (mira la [placa del joystick](../electronics/joystick-pcb/README.md)); al inclinarla se cierra un interruptor, o dos contiguos en diagonal, y al empujarla hacia dentro se cierran los cuatro. El pomo solo llega a su tope de empuje cuando todos los interruptores se han accionado, así que un empuje completo siempre cierra los cuatro. El firmware deduce la entrada central de ese acorde (sección 5).

D8 maneja el LED de carga de la [placa de carga USB-C](../electronics/usbc-pcb/README.md) a través de una resistencia de 1 kΩ; es una salida, no una entrada. Solo está a nivel alto mientras hay un cargador conectado y la señal `CHG` del cargador (P0.17, activa a nivel bajo) indica que carga. El apagado, el apagado automático, el despertar y el LED de carga se especifican en el [estudio de la batería](battery-study.md#firmware).

El hardware final puede usar otro mapa de pines. Mantén las asignaciones de pines en una sola tabla de configuración, para poder cambiarlas sin reescribir la lógica de entradas y de HID.

## 5. Procesado de entradas y reglas de gestos

Estos valores son ajustes iniciales modificables, no decisiones ergonómicas definitivas:

| Ajuste | Valor inicial | Comportamiento |
|---|---:|---|
| Intervalo de lectura | 5–10 ms | Leer todas las entradas desde un bucle no bloqueante o una tarea equivalente. |
| Antirrebote | 30 ms | Aceptar un nuevo estado estable solo cuando no cambia durante este intervalo. |
| Umbral de pulsación larga | 600 ms; 2 s en los botones de TerraPirata | Enviar una acción de pulsación larga cuando el control sigue pulsado este tiempo. Las pulsaciones largas de TerraPirata ponen un contador a cero, así que duran más. |
| Ventana de doble pulsación | 300 ms | Dos pulsaciones cortas del mismo control dentro de la ventana dan una acción de doble pulsación. |

En el perfil de teclado, los botones A, B y C no usan gestos: cada uno mantiene una tecla mientras está pulsado (sección 7). DMD2 mide él mismo las pulsaciones cortas y largas, y un gesto del firmware enviado como tecla aparte no le servía. Los perfiles TerraPirata y de gestos, y la entrada central deducida, usan esta máquina de estados:

1. Al detectar una pulsación sin rebote, apuntar la hora de inicio; si se está distinguiendo entre corta y doble, no enviar todavía ninguna tecla.
2. Si el control sigue pulsado al llegar al umbral de pulsación larga, enviar una vez su acción larga. Suprimir las acciones corta y doble de esa pulsación.
3. Si se suelta antes del umbral, esperar la ventana de doble pulsación. Una segunda pulsación sin rebote del mismo control dentro de la ventana cancela la acción corta pendiente y envía una acción doble cuando se suelta esa segunda pulsación (salvo que se convierta en larga).
4. Si la ventana vence sin segunda pulsación, enviar una acción corta.
5. Una segunda pulsación de otro control no cancela la acción corta pendiente del primero.

Esto significa que una acción corta se puede retrasar hasta la duración de la ventana de doble pulsación. Un control sin acción doble en el perfil elegido envía su acción corta al soltarlo (el botón C de TerraPirata). Apunta cualquier excepción propia de un perfil en la tabla de asignaciones.

Acorde central: considera el centro pulsado cuando hay al menos tres entradas de dirección cerradas, y suelto cuando no hay ninguna. Cuando se cierra la primera dirección, retén su tecla durante una ventana de acorde (al principio 40 ms, ajustable). Si se cierran tres o más direcciones dentro de la ventana, informa en su lugar de la pulsación central y no envíes teclas de dirección hasta que se suelten las cuatro. Si no, envía las direcciones mantenidas como siempre. Dos direcciones opuestas cerradas a la vez solo pueden venir de un empuje, así que también suprimen las teclas de dirección. La ventana retrasa la tecla de dirección hasta su duración; mide si se nota en el hardware.

Las direcciones del joystick son entradas mantenidas: envía la tecla asignada pulsada mientras la dirección está mantenida, y la tecla soltada correspondiente al soltarla. No generes en el firmware informes repetidos de tecla pulsada. El host o la app pueden repetir una tecla mantenida; prueba si eso da un desplazamiento del mapa útil y documenta el comportamiento de cada dispositivo. Dos direcciones opuestas pulsadas a la vez se anulan. Otras direcciones simultáneas no deben estropear el informe HID.

No bloquees la lectura de entradas mientras esperas a que venza un gesto. Lleva un estado y un temporizador aparte para cada control con gestos, para que los botones se puedan usar de forma independiente.

## 6. Comportamiento y fiabilidad de los informes HID

- Cada acción discreta es una pulsación completa de tecla seguida de su liberación. No dejes nunca una tecla pulsada lógicamente después de un toque.
- Envía un informe de liberación tras cada pulsación discreta. Envía un informe con todas las teclas soltadas tras una desconexión, un cambio de perfil, un reinicio o cualquier recuperación del estado de las entradas.
- Para las direcciones mantenidas del joystick, sigue cada dirección mantenida y envía el conjunto actual de teclas, no pulsaciones sueltas una tras otra.
- Usa un informe de teclado estándar con al menos seis teclas simultáneas. Normalmente los controles no necesitan más de cuatro teclas de dirección a la vez, pero comprueba las combinaciones y gestiona con cuidado el límite del informe.
- No envíes una tecla repetidamente mientras un botón o una dirección siguen mantenidos. Una tecla mantenida es un único informe de pulsación; el host puede repetirla, y TerraPirata lo usa para ajustar el trip más deprisa con el joystick.
- Ignora las entradas mientras el BLE está desconectado y sigue con normalidad tras reconectar. No acumules acciones antiguas para enviarlas después.
- Evita escrituras innecesarias en la flash. Guarda el perfil y la configuración solo cuando cambian.

## 7. Perfiles y asignaciones

Las pruebas de banco del 14-10-2026 y del 20-10-2026 con Android mostraron que un único mapa de teclas no sirve para todas las apps:

- TerraPirata reacciona a las flechas, a las teclas de medios (Consumer Control) y a algunas letras y teclas de función: `x` bloquea la pantalla, `r` abre el reset del trip, `z` y Play/Pause ponen a cero el total, F6/F7 mueven el roadbook y subir/bajar volumen ajustan el trip (mira el [mapa de controles](control-mapping.es.md#teclas-a-las-que-reacciona-terrapirata)). No reaccionó a Avance/Retroceso de página. Espacio abrió su diálogo "Borrar datos del mapa".
- OsmAnd solo acepta teclas de teclado en sus asignaciones, no teclas de medios.
- DMD2 mide él mismo las pulsaciones largas: necesita la tecla mantenida, no una tecla aparte para la pulsación larga.

Por eso el firmware tiene tres perfiles. En todos ellos, las direcciones del joystick envían flechas mantenidas.

| Perfil | LED | Botones A, B, C | Centro del joystick |
|---|---|---|---|
| TerraPirata | Verde | A larga (2 s): `r` (reset del trip, se confirma en la pantalla); B larga (2 s): `z` (reset del total); C corta: `x` (bloqueo de pantalla); las pulsaciones cortas y dobles de A y B no envían nada | Nada |
| Teclado, para DMD2 | Azul | Mantenidas: `A`, `B`, `C`; la app mide corta y larga | `D` en pulsación corta o doble |
| Gestos, para OsmAnd | Blanco | A: `D` / `N` larga / `P` doble; B: `-` / `S` larga; C: `=` / `x` larga (bloqueo de pantalla); las teclas del tipo "Keyboard" de OsmAnd | Corta `C`, al soltar |

Mantener el centro del joystick 5 s selecciona el siguiente perfil (verde, azul, blanco y otra vez verde), lo guarda en la flash y reinicia la placa. El centro no tiene acción larga en ningún perfil, porque mantenerlo cambia de perfil. El LED de la XIAO parpadea 100 ms cada 10 s con el color del perfil. El nombre BLE no cambia: Android conserva el nombre que vio al emparejar, así que un nombre por perfil no se veía.

En el perfil TerraPirata, el joystick ajusta el trip (izquierda/derecha) y mueve el roadbook (arriba/abajo) con flechas mantenidas.

Evita Espacio, Enter y Tab en todos los perfiles: Android las usa para pulsar el control que tiene el foco en pantalla. Evita también las teclas de medios: llegan a la app que esté delante y cambian el volumen o la reproducción del teléfono. El firmware 0.8.0 las usaba en el perfil TerraPirata; la 0.9.0 no.

### Límites de las asignaciones que hay que respetar

- **TerraPirata:** el reset del trip abre un diálogo que se acepta en la pantalla; no se ha encontrado ninguna tecla que lo acepte. La tecla para ocultar las centenas es desconocida. El modo de mando dedicado de TerraPirata no está documentado públicamente; las teclas usadas aquí funcionan sin cambiar ningún ajuste.
- **OsmAnd:** asigna una acción por tecla, así que el perfil de gestos envía una tecla distinta para cada gesto: las de su tipo "Keyboard" integrado, que no necesita asignaciones pero no se puede cambiar, más `x` para el bloqueo de pantalla, que necesita un tipo propio. La pulsación corta de A se retrasa por la ventana de doble pulsación de 300 ms; B, C y el centro no tienen doble pulsación y envían al soltar. Con teclas mantenidas, Android repite la tecla y una acción de activar/desactivar puede repetirse; usa en su lugar el perfil de gestos.
- **DMD² / DMD Next:** las acciones corta y larga de cada tecla se configuran en el mapa "Generic Remote" de DMD; con teclas mantenidas, DMD² reconoció la pulsación larga en el banco. No prometas el comportamiento nativo de doble toque. Según su FAQ actual, DMD² es solo para Android.
- **iOS** queda para más adelante. Puede necesitar otras teclas: iOS gestiona él mismo las teclas de volumen, y seguramente por eso TerraPirata pide a los usuarios de iPhone un modo de mando dedicado o su modo de compatibilidad.

El cambio de perfil se acordó para el prototipo de banco. Mantener 5 s es difícil de hacer sin querer, pero pruébalo en la moto antes de darlo por seguro conduciendo. La carcasa tiene que dejar ver el LED, o el piloto no puede saber el perfil; mira las [notas mecánicas](mechanical-concept.es.md).

## 8. Fases iniciales de implementación

1. **Prueba de GPIO y BLE:** carga el [sketch de diagnóstico inicial](../firmware/xiao-nrf52840/README.es.md), empareja Android e iOS por separado y confirma que cada interruptor conectado envía la tecla esperada. Valida el funcionamiento activo a nivel bajo, el acorde central y la liberación de teclas.
2. **Prueba de gestos:** mide el reconocimiento de corta, larga y doble con los interruptores provisionales. Ajusta los tiempos solo después de observar los valores iniciales en el hardware.
3. **Prueba de fiabilidad:** prueba la reconexión, las flechas mantenidas, la anulación de direcciones opuestas y la liberación tras una desconexión.
4. **Asignaciones por app:** implementa perfiles por función y asigna a cada acción usos HID ya probados. Mantén marcadas como experimentales las asignaciones sin verificar.
5. **Compatibilidad en banco:** completa la [matriz de validación](control-mapping.es.md#matriz-de-validación-en-banco) y apunta el teléfono, el sistema, la versión de la app, el perfil, la tecla recibida y el resultado.

## 9. Lista de validación

| Área | Condición para pasar | Android | iOS |
|---|---|---|---|
| Emparejamiento | Aparece como teclado/mando HID, se empareja y se reconecta al teléfono vinculado | Pendiente | Pendiente |
| Lectura de entradas | Cada una de D0–D6 funciona una vez; D7 se ignora | Pendiente | Pendiente |
| Antirrebote | Una pulsación da un evento; el rebote del interruptor no da duplicados | Pendiente | Pendiente |
| Liberación HID | Cada tecla discreta tiene su liberación; una desconexión no puede dejar una tecla atascada | Pendiente | Pendiente |
| Direcciones | Las flechas mantenidas desplazan como se espera; al soltar se para; las direcciones opuestas se anulan | Pendiente | Pendiente |
| Gestos | Corta, larga y doble se distinguen con los umbrales elegidos; ninguna acción se pierde ni se duplica | Pendiente | Pendiente |
| TerraPirata | Cada acción asignada funciona | Pasa, firmware 0.9.0 (20-10-2026) | Pendiente |
| OsmAnd | Cada acción asignada funciona | Pasa, firmware 0.10.0 (20-10-2026) | Pendiente |
| DMD² | A seguimiento, B acercar, C alejar y el desplazamiento con el joystick funcionan con el mapa "Generic Remote" | Pendiente | No aplica |
| Acorde central | Un empuje recto da un evento central y ninguna tecla de dirección; las inclinaciones y diagonales no dan evento central | Pendiente | Pendiente |
| Apagado | A + B + C mantenidos 3 s duermen la placa al soltar, sin eventos de gesto; después cualquier botón la despierta | Pasa en banco con USB, 14-10-2026; la tecla del primer botón sale en el perfil de teclado (teclas mantenidas) | Pendiente |
| Apagado automático | Se duerme tras 6 h sin entradas y sin cargador (probar con un tiempo acortado) | Pasa en banco con USB y un tiempo de 60 s, 14-10-2026 | Pendiente |
| LED de carga | Con cargador: despierta de System OFF y el LED se enciende; el LED se apaga al terminar la carga y al quitar el cargador | Pendiente | Pendiente |

## Lista de validación del OTA de producto

| Prueba | Condición para pasar | Android | iOS |
|---|---|---|---|
| Actualización solo con el teléfono | Instalar un paquete publicado por BLE, sin ordenador ni conexión de datos USB | Pasa en banco con el bootloader de fábrica, 14-10-2026 | Pendiente |
| Autenticación de la imagen | Rechazar una imagen sin firmar, corrupta o de otro producto | Falla con el bootloader de fábrica: aceptó una imagen sin firmar | Pendiente |
| Transferencia interrumpida | Cortar el BLE o la alimentación durante la transferencia; recuperar solo el estado anterior o el listo para actualizar | Falla con el bootloader de fábrica: dos transferencias paradas dejaron la placa sin aplicación; se recuperó por USB | Pendiente |
| Primer arranque fallido | Una nueva imagen de aplicación rota vuelve al firmware anterior que funcionaba | Pendiente | Pendiente |
| Gestión de versiones | Rechazar una versión anterior o incompatible, salvo con un procedimiento de recuperación deliberado | Pendiente | Pendiente |
| Uso normal tras actualizar | Reconectar como mando HID y conservar el perfil y los ajustes del usuario | El HID se reconectó sin volver a emparejar; no se ha probado si conserva el perfil tras un OTA | Pendiente |

## Referencias

- [Seeed Studio: instalación de Arduino y ejemplos de la XIAO nRF52840](https://wiki.seeedstudio.com/XIAO_BLE/)
- [Arduino: tutorial del gestor de placas de IDE 2](https://docs.arduino.cc/software/ide-v2/tutorials/ide-v2-board-manager/)
- [Nordic: app móvil nRF Device Firmware Update](https://www.nordicsemi.com/Products/Development-tools/nRF-Device-Firmware-Update)
- [Nordic: actualización FOTA en nRF52](https://nrfconnectdocs.nordicsemi.com/ncs/latest/nrf/app_dev/device_guides/nrf52/fota_update.html)
- [Seeed: discusión pública sobre Bluetooth DFU en la XIAO nRF52840](https://github.com/Seeed-Studio/wiki-documents/discussions/2071)
- [Adafruit: bootloader nRF52 y funciones OTA](https://github.com/adafruit/Adafruit_nRF52_Bootloader)
- [Bluetooth SIG: HID over GATT Profile](https://www.bluetooth.com/specifications/specs/hid-over-gatt-profile-hogp/)
- [Android Developers: introducción a Bluetooth Low Energy](https://developer.android.com/develop/connectivity/bluetooth/ble/ble-overview)
- [OsmAnd: dispositivos de entrada externos y asignación de teclas](https://www.osmand.net/docs/user/map/interact-with-map/)
- [TerraPirata: compatibilidad de mandos Bluetooth](https://terrapirata.com/bluetooth-remotes/)
- [Manual de usuario de HesaParts NAVCOMM](https://hesaparts.com/wp-content/uploads/2025/02/EN/NAVCOMM%20USER%20MANUAL.pdf)
- [DMD²: dispositivos y mandos genéricos](https://docs.dmdnavigation.com/dmdnext/devices/)
- [DMD² FAQ: comportamiento de los mandos genéricos](https://docs.dmdnavigation.com/faq/)
