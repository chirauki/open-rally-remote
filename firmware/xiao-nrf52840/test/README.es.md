# Pruebas en el ordenador del firmware de banco

> Traducción al castellano de [README.md](README.md). La versión en inglés es la de referencia; si las dos difieren, vale la inglesa.

Estas pruebas compilan `open-rally-remote.ino` en un ordenador y lo ejecutan con interruptores, reloj, enlace BLE y flash simulados. Cada prueba pulsa y suelta controles a lo largo del tiempo y comprueba los informes HID que envía el sketch. Se ejecutan con cada cambio, sin placa ni teléfono.

```sh
make -C firmware/xiao-nrf52840/test            # todas las pruebas, las dos placas
make -C firmware/xiao-nrf52840/test TEST=terrapirata   # las pruebas cuyo nombre contiene "terrapirata"
```

`make` compila el sketch dos veces, con `BOARD_V026` a false (protoboard) y a true (placa de control V0.26), y ejecuta todas las pruebas en cada una. Cada prueba se ejecuta en su propio proceso, así que las variables globales del sketch empiezan de cero. Solo hace falta un compilador de C++17; en macOS, las herramientas de línea de comandos de Xcode.

## Qué cubren

- **Perfil TerraPirata:** C envía `x` al soltarlo, sin esperar una doble pulsación; A y B mantenidos 2 s envían `r` y `z`; sus pulsaciones cortas y dobles, y las mantenidas menos de 2 s, no envían nada; el joystick mantiene las flechas; el centro no envía nada; ninguna tecla de medios.
- **Perfil de teclado:** los botones mantienen `A`, `B`, `C`; el centro envía `D` en pulsación corta o doble.
- **Perfil de gestos (OsmAnd):** las pulsaciones corta, larga y doble de A envían `D`, `N`, `P`, la corta tras la ventana de doble pulsación de 300 ms; B y C envían `-` y `=` al soltarlas, y `S` y `x` mantenidas; el centro envía `C` al soltarlo.
- **Joystick:** las direcciones opuestas no envían nada; el acorde central no envía flechas; una inclinación soltada dentro de la ventana de acorde es un toque de flecha.
- **Perfiles, alimentación y conexión:** selección de perfil: con el centro mantenido 5 s y soltado, un único botón guarda su perfil y reinicia (sin reinicio para el actual), y la selección termina sin cambios al caducar, con dos botones, con una desconexión o si se suelta antes de 5 s, sin enviar ninguna tecla; un perfil guardado desconocido arranca en TerraPirata; el apagado con A + B + C no envía ninguna tecla en TerraPirata; no se envía nada mientras está desconectado; un control mantenido al reconectar se ignora hasta soltarlo; el mensaje de arranque describe el mapa actual de TerraPirata.

- **Actualización por BLE y emparejamiento (0.12.0):** una actualización solo empieza desde un teléfono emparejado, con enlace cifrado y alimentación USB; un emparejamiento nuevo se guarda dentro de la ventana de 2 minutos y se borra fuera de ella; un emparejamiento fallido no se toca.
- **Anuncio tras la ventana de emparejamiento (0.13.0):** anuncio abierto dentro de la ventana; anuncio solo para emparejados cuando se cierra, o al terminar una conexión abierta en ese momento, y otra vez tras cada desconexión; sin anuncio si no hay emparejamientos; anuncio abierto otra vez, con los emparejamientos nuevos rechazados, si el SoftDevice se niega; un teléfono emparejado que empareja otra vez por la lista blanca conserva su emparejamiento.

No cubren: la lectura de la batería y la carga, el LED, la actualización por BLE en sí (el servicio DFU de `orr_dfu.cpp` no se compila en el host), las llamadas de lista blanca del SoftDevice en `orr_whitelist.cpp` (lo sustituye un stub en `stubs/host.h`), ni nada que no simulen los sustitutos de `stubs/host.h`. Esos sustitutos ocupan el lugar de las API del núcleo Arduino, Bluefruit, TinyUSB y LittleFS que usa el sketch; si el sketch llama a una API nueva, hay que añadir aquí su sustituto.

## Comprobaciones

Desde las comprobaciones de anuncio de la 0.13.0 hay 52 pruebas por placa (45 con las de actualización y emparejamiento de la 0.12.0, 37 con la selección de perfil de la 0.11.0, 20 al crearlas, 22 con el perfil de gestos de la 0.10.0). El 20-10-2026 pasaron todas en las dos placas, sin avisos del compilador. La primera ejecución encontró un mensaje de arranque desfasado, que todavía describía las teclas de TerraPirata de la 0.8.0; se corrigió. Se introdujeron a mano tres fallos en una copia del sketch y las pruebas detectaron los tres: una pulsación de reset de 600 ms (fallaron 2 pruebas), una acción doble en C (falló 1) y teclas mantenidas en el perfil TerraPirata (fallaron 5). El 27-10-2026 se quitó una a una cada condición de las comprobaciones de la 0.12.0 (alimentación USB, emparejamiento, ventana de emparejamiento, emparejamiento correcto), y cada vez falló una prueba. Ese mismo día se detectaron seis cambios en la lógica de anuncio de la 0.13.0: no conservar el emparejamiento por la lista blanca, no parar el anuncio abierto, no quitar su reinicio al desconectar, no reiniciar tras cada desconexión, no arrancar el anuncio de respaldo y no cambiar tras una conexión abierta al final de la ventana.
