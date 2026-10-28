# Guía de construcción — V0.34

> Traducción al castellano de [build-guide.md](build-guide.md). La versión en inglés es la de referencia; si las dos difieren, vale la inglesa.

Esta guía lleva a quien construye desde este repositorio hasta un mando y una base terminados en la moto. Da el orden del trabajo, las decisiones que hay que tomar y los problemas encontrados hasta ahora. Los detalles están en los documentos enlazados: la [lista de materiales](bom.es.md), la [guía de montaje de la electrónica](electronics-assembly.es.md), las [notas mecánicas](mechanical-concept.es.md) y el [README del firmware](../firmware/xiao-nrf52840/README.es.md).

**Estado: todavía no se ha construido ningún mando.** Cada paso sale del CAD, de las hojas de datos y de pruebas de banco de piezas sueltas. Ninguno se ha probado en un montaje completo. Esta guía se corregirá después del primero.

## Índice

0. [Antes de empezar](#before-you-start)
1. [Pedidos](#orders)
2. [Mientras llegan los pedidos](#while-the-orders-arrive)
3. [Electrónica](#electronics)
4. [Preparar las piezas](#preparing-the-parts)
5. [Montaje del mando](#remote-assembly)
6. [Base en la moto](#base-on-the-bike)
7. [Primer uso](#first-use)
8. [Avisos y puntos abiertos](#catches-and-open-points)

<a id="before-you-start"></a>
## Antes de empezar

### Coste

El primer mando con su base cuesta unos 470–510 €, sin las piezas del prototipo de banco ([estimación](bom.es.md#estimated-cost)). Un mando de rally comercial cuesta unos 150 € (precio no comprobado aquí). Unos 275 € del primer montaje se pagan una sola vez: pedidos mínimos, packs, envíos y aduana. Cada mando más cuesta unos 187–214 €, sobre todo por las piezas impresas. Construirlo uno mismo sale más barato que uno comercial solo si varios mandos comparten pedido, por ejemplo en una compra en grupo ([coste según el número de mandos](bom.es.md#cost-by-number-of-remotes)).

### Habilidades y herramientas

- **Soldar**, si se piden las placas sin montar: componentes 0603, encapsulados SOT-23 y conectores de 1,0 mm de paso. La [guía de electrónica](electronics-assembly.es.md#antes-de-empezar) da las herramientas.
- **OpenSCAD 2026.x**, para poner tus medidas y exportar los archivos de impresión. Todavía no hay un paquete de impresión preparado.
- **Arduino IDE 2**, para cargar el firmware ([entorno de desarrollo](development-environment.md)). El firmware compilado se publicará como [releases de GitHub](../firmware/xiao-nrf52840/README.es.md#releases); todavía no hay ninguna.
- **Herramientas de mano:**
  - un polímetro;
  - un calibre;
  - un cúter afilado y una regla metálica, para la espuma;
  - brocas de 1,6 mm y 3,4 mm, giradas a mano;
  - un destornillador hexagonal recto de 1,3 mm con unos 75 mm de alcance, para los tornillos de la placa USB-C;
  - una llave hexagonal de 0,9 mm, para el prisionero del pomo;
  - una galga de 0,9 mm para colocar el pomo: una tarjeta bancaria (0,76 mm) y una hoja de papel de 80 g/m², con una ranura cortada en las dos para el pasador.

  Las dos medidas de hexágono salen de las normas de los tornillos (ISO 7380 M2 y DIN 913 M2). Todavía no se han comprobado en los tornillos comprados.

### Decisiones

- **Placas: sin montar o montadas.** Esta guía sigue las placas sin montar, soldadas a mano, que es lo más barato. Los fabricantes de placas también las montan, a un precio mucho mayor; ver [Pedidos](#orders).
- **Material de impresión.** Todavía no está elegido. El [estudio de materiales](materials-study.es.md#recommendation) recomienda PA11 por MJF para el mando (ASA por FDM es la alternativa), PA12 por MJF para la base y TPU cerca de 85A para el teclado.

<a id="orders"></a>
## Pedidos

Los proveedores de abajo son los que usamos o con los que pedimos presupuesto, con los precios que encontramos en octubre de 2026. Son una sugerencia, no una obligación: sirve cualquier proveedor que cumpla la especificación. Los precios, el stock y los cargos de importación cambian.

Haz todos los pedidos a la vez. Algunos vienen de fuera de la UE y tardan semanas. Pide las piezas impresas al final (ver [Mientras llegan los pedidos](#while-the-orders-arrive)).

| Qué | Especificación | Lo que usamos | Avisos |
|---|---|---|---|
| Tres placas de circuito | 2 capas. Placas de control y de joystick de 1,6 mm; placa USB-C de **1,2 mm**. Archivos en la carpeta `fab/` de cada placa | JLCPCB, sin montar: 22,86 € las tres, más unos 10 € de envío y 31,56 € de cargos de importación | JLCPCB fabrica un mínimo de 5 de cada placa, así que un pedido cubre 5 mandos. Los fabricantes de la UE consultados (Eurocircuits, Aisler) no hacen la placa de 1,2 mm a un precio razonable ([puntos abiertos](mechanical-concept.es.md#open-unknowns-before-printing)). |
| Componentes de las placas | [`electronics/lcsc-parts.csv`](../electronics/lcsc-parts.csv), cargado en la herramienta de BOM de LCSC | LCSC: 55,02 € con envío y aduana, para dos mandos con repuestos | LCSC redondea algunas cantidades a su pedido mínimo. La UE cobra 3 € de aduana por cada clase arancelaria en cada paquete, y un segundo pedido la vuelve a pagar. El transportista puede cobrar el IVA de importación al entregar. Los interruptores sellados KSC221JLFS solo los venden distribuidores. |
| Conector USB-C sellado | GCT USB4736-GF-A-**KIT**, con su junta USBTJ-06 | TME: tres por 18,63 €, casi todo envío | No está en LCSC. La pieza de JLCPCB es el conector sin la junta. DigiKey España cobra 25 € de envío por debajo de 75 €. |
| Dos cables | Tipo JST SH, 1 mm de paso, hembra–hembra, directos (pin 1 a pin 1), 10 cm: uno de 5 pines y uno de 3 | AliExpress: 10 de cada por 12,53 € | Elige `same direction`. Comprueba cada cable con el polímetro: pin 1 a pin 1. |
| XIAO | Seeed XIAO nRF52840 **con pines soldados** (`102010631`), no el modelo Sense | Kiwi Electronics, 9,99 € sin IVA | |
| Batería | Bolsa LiPo con placa de protección y cable JST PH 2,0, como mucho 6 × 20 × 54 mm, tipo 600 mAh (602045, 602050) | Tienda, 5–10 € | El cable debe salir por el extremo de la placa de protección y medir al menos unos 35 mm. Comprueba su polaridad antes de enchufarlo. |
| Tornillos, tuercas y pasadores | La [lista de tornillería](bom.es.md#hardware), mando y base | AliExpress: 11 packs de una sola medida, 35,47 € con cargos de importación tras una promoción | Cada pack trae 10–100 piezas y cubre al menos cinco mandos. Los cargos de importación parecieron ir por anuncio, no por clase arancelaria (no confirmado): sin la promoción el pedido costaría unos 63 €. |
| Lámina de espuma | Neopreno o EPDM de celda cerrada, adhesiva, blanda | Amazon.es, 300 mm × 3 m, 19,99 € | Se vende como de 1,5 mm y mide unos 1,15 mm. Las juntas llevan dos capas. Mide la tuya (ver abajo). |
| Parche de ventilación | ePTFE adhesivo, Ø7.6–8 mm, zona transpirable de al menos Ø3 mm | AliExpress, 100 por 15,89 € más unos 3 € de cargos de importación | No se encontraron sueltos. La protección IP67 es lo que dice el vendedor. |
| Muelle del cierre | 0,5 × 5 × 10 mm, inoxidable | Amazon.es, 5 por 6,49 € | Uno de 6 mm de diámetro exterior no cabe. |
| Consumibles | Barniz de protección, epoxi transparente de dos componentes; para placas sin montar, flux, estaño de 0,5 mm, malla desoldadora y alcohol isopropílico | Plastik 70 22,27 €, epoxi fischer 8,86 € (Amazon.es) | |
| Fijatornillos, opcional | Fuerza media (azul), por ejemplo Loctite 243 | RS, 5 ml, unos 9,38 € con IVA (sin confirmar) | Para la rosca del cierre; el epoxi también sirve, pero no se puede deshacer. |
| Cámara de bici | Butilo, unos 0,8–1,2 mm de pared | Una vieja | Para las tiras antivibración de la base y, si se quiere, su forro de la abrazadera. |

**Placas montadas.** JLCPCB monta un mínimo de 2 de cada placa ([pedir las placas](bom.es.md#ordering-the-boards)). Presupuestos del 15-10-2026, sin envío ni cargos de importación:
- **Montaje económico, una cara:** 86,27 € las tres placas. Aun así hay que soldar los 7 interruptores, las dos tiras de pines del XIAO y el USB4736.
- **Montaje completo a doble cara:** unos 134 € solo las placas de control y de joystick. No hay que soldar nada, salvo el USB4736 si JLCPCB no lo consigue.

Otros fabricantes de placas también las montan; no se han comparado.

<a id="while-the-orders-arrive"></a>
## Mientras llegan los pedidos

### Medir

| Medida | Con | Fija | Por qué |
|---|---|---|---|
| El manillar en la abrazadera | Calibre | `bar_diameter` | Los manillares de menos de 25,4 mm llevan el casquillo impreso. Un manillar de 7/8 in pintado puede medir 0,3 mm más de 22,2 mm. |
| La pared de la cámara | Calibre | `strip_t`, y `liner_radial` si el forro se corta de la cámara | La profundidad del hueco de las tiras antivibración sigue a `strip_t`. Sirve una cámara desde 0,78 mm. |
| La lámina de espuma | Calibre, sobre una pila de cinco | Nada todavía; compárala con 1,15 mm | Las juntas están pensadas para dos capas de una lámina de 1,15 mm ([espuma en dos capas](mechanical-concept.es.md#two-layer-foam)). Con otro grosor hay que revisar el CAD. |

### Exportar los archivos de impresión

Pon las medidas en `mechanical/cad/complete-remote-v0.34.scad`, o pásalas con `-D`, y exporta cada pieza con su modo `part_to_render`. Por ejemplo:

```sh
openscad -o housing.stl -D 'part_to_render="print_housing"' mechanical/cad/complete-remote-v0.34.scad
openscad -o base_front.stl -D 'part_to_render="print_base_front"' -D 'strip_t=0.9' mechanical/cad/complete-remote-v0.34.scad
```

Las piezas, los modos, las orientaciones y las notas de impresión están en [Impresión](mechanical-concept.es.md#printing). Ninguna pieza necesita soportes. La carcasa y la tapa necesitan borde de adherencia (brim).

### Pedir las piezas impresas

Las piezas impresas son el mayor coste de cada mando: 170–196 € el mando y la base, en talleres de la UE ([piezas impresas](bom.es.md#printed-parts)). Pídelas cuando la electrónica funcione (paso 3), para que un problema en una placa no te deje con piezas que no puedes usar.
- **Piezas rígidas:** pide paredes macizas: relleno del 100 %, o al menos cinco perímetros en FDM. Las paredes de la carcasa tienen que parar el agua.
- **Teclado:** TPU blando (85A o más blando). Su lámina de 0,8 mm está por debajo de la pared mínima de 1 mm que dan los servicios de TPU en FDM: pregunta antes al taller.
- **Talleres de fuera de la UE:** dieron precios más bajos, pero suman aduana.

<a id="electronics"></a>
## Electrónica

Sigue la [guía de montaje de la electrónica](electronics-assembly.es.md). Cubre, en este orden:
1. soldar las placas de joystick, de control y USB-C;
2. los cables;
3. las pruebas de alimentación sin el XIAO;
4. el XIAO, la carga del firmware y una prueba de funcionamiento;
5. el barniz de protección, al final, cuando todo funcione.

Carga el firmware desde Arduino IDE 2 ([README del firmware](../firmware/xiao-nrf52840/README.es.md#carga)). En los Mac con Apple Silicon sin Rosetta, el compilador y la herramienta de carga del paquete de placas no funcionan; el [README del firmware](../firmware/xiao-nrf52840/README.es.md#comprobación-de-compilación) da una solución.

**El firmware es de banco.** Su README dice que no sirve para usarlo mientras se conduce. Por ahora es el único firmware.

<a id="preparing-the-parts"></a>
## Preparar las piezas

1. **Revisa las piezas impresas.** Busca capas mal unidas, agujeros en las paredes y caras deformadas. Prueba el ajuste a presión del pasador en la bola (agujero de Ø2.95 mm).
2. **Repasa los agujeros guía** con las brocas giradas a mano: diez de Ø1.6 mm en las torretas de los tornillos de la carcasa, y dos de Ø3.4 mm en la parte frontal de la base. Los agujeros impresos salen pequeños.
3. **Corta la espuma.** Imprime `mechanical/cad/tools/foam-templates-v0.34.scad` al 100 % en A4. Comprueba su barra de 40 mm con una regla. Tiene todas las piezas de espuma y cuántas cortar de cada una. Corta la junta de la tapa como un solo anillo: dóblala sobre el pliegue, no la cortes ahí.
4. **Prueba de estanqueidad, opcional.** Antes de meter la electrónica, cierra la carcasa solo con la placa USB-C, la tapa con el teclado y las dos placas impresas, las juntas de espuma y la tapa de la batería. Sumérgela unos centímetros durante 30 minutos con papel de cocina seco dentro ([la prueba](mechanical-concept.es.md#open-unknowns-before-printing)). Si te la saltas, no sabes si el conector USB-C necesita encapsulado, y una fuga llega a la electrónica barnizada en la moto. El primer montaje del proyecto la hará, para comprobar el diseño.

<a id="remote-assembly"></a>
## Montaje del mando

Sigue el [Montaje](mechanical-concept.es.md#assembly), pasos 1 a 11. El [vídeo de montaje](videos/complete-remote-v0.34-assembly.mp4) enseña el orden. El [vídeo de la placa USB-C](videos/usbc-mount-v0.34.es.mp4) enseña el paso 2 en detalle. Avisos:
- **Placa USB-C (paso 2).** Empuja la placa hacia la pared hasta que su junta haga resistencia, y luego aprieta los dos tornillos. La junta fija su propia compresión. La fuerza con que hay que empujar no está medida.
- **Epoxi en el conector.** Encapsula la parte de atrás del conector solo si la prueba de estanqueidad muestra agua entrando por él. Hazlo sobre la mesa, antes de meter la placa (paso 2). El encapsulado hace que la placa no se pueda reparar.
- **Batería (paso 8).** Enchufa la bolsa en J5 antes de cerrar la carcasa. El cable debería llegar con la carcasa a unos 14 mm de su sitio; es una estimación. Comprueba antes la polaridad.
- **Tornillos de la tapa (paso 9).** Se hacen su propia rosca. Atorníllalos despacio la primera vez y apriétalos en cruz.
- **Holgura del pomo (paso 11).** La holgura entre el cubo del pomo y la tapa fija los dos topes del pomo, y solo vale de 0,70 a 1,08 mm. Por debajo de 0,70 mm, el pomo para el empuje antes de que disparen todos los interruptores del centro. Por encima de 1,08 mm, el disco del joystick toca su placa antes de que el borde del pomo toque la tapa, así que una inclinación fuerte carga el disco y el pasador, y el prisionero agarra menos pasador. Mide la tarjeta y el papel con el calibre: de 0,80 a 1,0 mm. La tarjeta sola, de 0,76 mm, deja poco margen.

<a id="base-on-the-bike"></a>
## Base en la moto

Sigue los pasos de la base en el [Montaje](mechanical-concept.es.md#assembly). La rosca del cierre se fija con fijatornillos de fuerza media, o con el epoxi transparente si no tienes: comprueba antes el tirón y la suelta. El fijatornillos se suelta con herramientas de mano; el epoxi no. En un manillar de 22,2 mm, pon primero las dos mitades del casquillo alrededor del manillar.

Para poner el mando, tira del pomo del cierre, apoya el mando en la plataforma 9 mm por debajo de su posición de uso y deslízalo hacia arriba hasta que el cierre haga clic.

<a id="first-use"></a>
## Primer uso

El [manual de usuario](user-manual.es.md) cubre todo el uso del mando. Los primeros pasos:

1. Carga el mando con cualquier cargador USB-C. El LED rojo junto al puerto de carga se enciende mientras la batería carga.
2. Empareja **Open Rally Remote** desde los ajustes de Bluetooth del teléfono.
3. Elige un perfil: mantén pulsado el centro del joystick 5 s, suéltalo y pulsa A (TerraPirata), B (teclado, para DMD2) o C (gestos, para OsmAnd) ([perfiles](../firmware/xiao-nrf52840/README.es.md#perfiles)). La placa guarda el perfil al apagarse.
4. Las teclas que envía cada perfil están en el [mapa de controles](control-mapping.es.md).

Las actualizaciones de firmware se hacen por BLE desde el teléfono ([actualización por BLE](../firmware/xiao-nrf52840/README.es.md#actualizacion-ble)), así que no hace falta abrir el mando. Abrirlo afecta a las juntas.

<a id="catches-and-open-points"></a>
## Avisos y puntos abiertos

- Todavía no se ha construido nada. Los puntos abiertos del diseño están en [Incógnitas antes de imprimir](mechanical-concept.es.md#open-unknowns-before-printing).
- Los pedidos mínimos y los packs cubren unos cinco mandos: quien construye uno solo paga piezas que servirían para cuatro más.
- El grosor de 1,2 mm de la placa USB-C obliga a fabricarla fuera de la UE. Para su próxima revisión se prevé una placa de 1,6 mm, aún sin diseñar.
- Las medidas de hexágono de 1,3 mm y 0,9 mm no se han comprobado en los tornillos comprados.
- El alcance del cable de la batería en el paso 8 es una estimación.
- No se ha comprobado lo blanda que es la espuma ni cómo pega su adhesivo en dos capas.
- La protección IP67 del parche de ventilación es lo que dice el vendedor.
- El firmware es de banco y no se ha probado conduciendo.
- El LED de perfil del XIAO está dentro de la carcasa, así que el piloto no ve qué perfil está activo. El perfil se elige directamente con un botón (ver [Primer uso](#first-use)), así que el piloto sabe cuál ha elegido.
