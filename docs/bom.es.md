# Lista de materiales — V0.34

> Traducción al castellano de [bom.md](bom.md). La versión en inglés es la de referencia; si las dos difieren, vale la inglesa.

Esta es la única lista de piezas del proyecto: el prototipo de banco y el mando extraíble con batería de la V0.34, con su base. La V0.34 es la V0.26 con la placa del joystick rev C, una sola base para los dos diámetros de manillar, la ventilación en la tapa de la batería, sin insertos roscados por calor, juntas de espuma en la tapa de controles y en la tapa de la batería, menos piezas distintas que comprar (V0.32) paredes de 2 mm, que hacen que el mando y la base midan 25 mm de ancho (V0.33), y una placa USB-C que desliza sobre dos tuercas cuadradas, con juntas de espuma de dos capas (V0.34). Las tres placas de circuito se unen con cables comprados ([diseño](superpowers/specs/2026-10-14-no-solder-assembly-design.md)). Se pueden pedir montadas, y entonces el montaje no necesita soldar, o desnudas, para que quien lo monte las suelde a mano por mucho menos dinero: mira [Pedido de las placas](#ordering-the-boards). Los detalles del diseño están en los documentos enlazados; esta página dice qué comprar.

**Estado:** nada de la lista de la V0.34 se ha construido ni probado. El material de impresión aún no está elegido ([estudio de materiales](materials-study.es.md)). La lista de la V0.25 está en el historial de git.

Preferencia de compra: primero las piezas que se pueden comprar en tiendas generalistas (por ejemplo Amazon). Las piezas que solo venden los distribuidores se usan solo donde ninguna pieza de tienda cumple el requisito, y se explica por qué.

<a id="estimated-cost"></a>
## Coste estimado

Cifras aproximadas para el primer mando y la primera base, en euros con IVA. Las líneas comprobadas incluyen el envío y, cuando la tienda lo cobró, los aranceles; el resto son estimaciones que no se han comprobado en una tienda. Muchas piezas solo se venden en paquetes, kits o pedidos mínimos, así que el primer montaje cuesta mucho más que cada uno de los siguientes: mira [Coste según el número de mandos](#cost-by-number-of-remotes).

| Sección | Estimación | Base |
|---|---:|---|
| [Prototipo de banco](#bench-prototype) | 22–29 € | Comprobado el 07-10-2026; mira la sección. |
| [Mando: electrónica](#electronics) | unos 170 € con placas desnudas soldadas a mano; más si van montadas | Placas desnudas, piezas de LCSC, kits USB4736 y cables comprobados el 19-10-2026 y el 20-10-2026, con envío y aranceles. Los presupuestos de placas montadas (15-10-2026) no incluyen aranceles. |
| [Mando: tornillería y piezas](#hardware) | unos 75 € | Comprobado el 20-10-2026: paquetes de una sola medida de AliExpress con todos los tornillos, tuercas y pasadores del mando y de la base (35,47 € con aranceles, tras una promoción de 27,90 €), la lámina de espuma (19,99 €) y 100 etiquetas de ventilación (15,89 € antes de aranceles). |
| [Piezas impresas, mando y base](#printed-parts) | 170–196 € | Presupuestos de Craftcloud del 21-10-2026, talleres de la UE, con envío: nylon MJF de un solo taller con un teclado de TPU FDM, o un mando en ASA, una base en PA12 y el teclado de tres talleres. Mira [Piezas impresas](#printed-parts). |
| [Base](#base-one-per-bike) | 6,49 € | El muelle, comprobado. Sus piezas impresas van en la línea de arriba; sus tornillos, tuercas y pasadores, en los paquetes de tornillería del mando. |
| [Consumibles](#consumables) | unos 31 €, más 15–30 € de material de soldadura para placas desnudas | Barniz y epoxi comprobados el 20-10-2026; material de soldadura sin comprobar. |
| **Primer mando y base, sin las piezas del banco** | **unos 470–510 €** | |

Con placas montadas, el pedido de las placas (sobre todo tasas fijas, tasas por piezas ampliadas y envío) es la partida más grande.

<a id="cost-by-number-of-remotes"></a>
### Coste según el número de mandos

Unos 275 € del primer montaje se pagan una sola vez, sea cual sea el número de mandos: el pedido de las placas (5 juegos de placas desnudas), las cantidades mínimas de LCSC, los aranceles y el envío de cada pedido, los paquetes de tornillería y los consumibles. Cada mando y base más necesita una XIAO (unos 12 €), una LiPo (5–10 €) y sus piezas impresas (170–192 € por un juego con los presupuestos del 21-10-2026; varios juegos en un mismo pedido seguramente salen más baratos cada uno, sin comprobar): unos 187–214 €.

| Mandos y bases | Total | Por mando |
|---:|---:|---:|
| 1 | unos 470–510 € | 470–510 € |
| 2 | unos 660–720 € | 330–360 € |
| 5 | unos 1.240–1.390 € | 250–280 € |

La línea de 5 mandos suma unos 20 € estimados por las cantidades mayores de LCSC y de USB4736 (sin comprobar); los paquetes de tornillería, los cables, el paquete de muelles, las etiquetas de ventilación y los consumibles cubren cinco. Las piezas impresas son el coste más grande por mando. Para un solo mando, montarlo uno mismo cuesta más que un mando de rally comercial, unos 150 € (precio sin comprobar aquí). Solo sale más barato cuando varios mandos comparten un pedido, por ejemplo en una compra en grupo.

<a id="bench-prototype"></a>
## Prototipo de banco

Para experimentos de firmware y BLE en una protoboard; mira la [guía de montaje en protoboard](breadboard-assembly.es.md). Precios y existencias comprobados el 07-10-2026, en España, con IVA cuando la tienda lo muestra y sin envío.

| Cant. | Pieza | Tienda de ejemplo | Precio comprobado | Notas |
|---:|---|---|---:|---|
| 1 | Seeed XIAO nRF52840, con pines soldados (MPN `102010631`) | [Kiwi Electronics](https://www.kiwi-electronics.com/en/seeed-studio-xiao-nrf52840-pre-soldered-20402) | 9,99 € sin IVA | El modelo sin Sense. La misma placa va al mando. |
| 1 | Protoboard sin soldadura de 400 puntos | [Conectrol](https://conectrol.com/producto/placa-protoboard-400-puntos-84x55x85mm/) | 2,00 € | Con raíles de alimentación laterales. |
| 1 juego | 40 cables Dupont macho-hembra, 20 cm | [Conectrol](https://conectrol.com/producto/kit-cables-dupont-1p-para-protoboard-m-h-40-unds/) | 3,00 € | Hacen falta nueve: ocho GPIO y una GND. |
| 1 juego | 65 cables Dupont macho-macho | [Conectrol](https://conectrol.com/producto/kit-cables-dupont-1p-para-protoboard-m-m-65-unds/) | 3,00 € | Hacen falta ocho, al raíl de masa. |
| 8 | Pulsador táctil de 6 × 6 × 5 mm, normalmente abierto, de inserción | [Conectrol](https://conectrol.com/producto/pulsador-tactil-off-on-no-6x6x5mm-pcb-rojo/) | 0,20 € cada uno | Solo para el banco. **No** sirven para la placa del joystick: necesita el C&K KSC2 sellado de montaje superficial (abajo), de 3,5 mm de alto en vez de 5 mm. |
| 1 | Cable de datos USB-A a USB-C | [Conectrol](https://conectrol.com/producto/cable-usb-3-0-tipo-a-usb-tipo-c-3-1-m-m-1mt/) | 6,90 € | Opcional; sirve cualquier cable con datos. |

Total estimado: unos 21,69 € sin el cable USB, o 28,59 € con él, sin envío; la cifra de la XIAO suma un 21 % de IVA estimado a los 9,99 € del vendedor.

Una alternativa más barata es la XIAO sin pines (MPN `102010448`), a 9,56 € con IVA en [Reichelt España](https://www.reichelt.com/es/es/shop/producto/xiao_nrf52840_bt5_0_sin_cabezal-358357); hay que soldarle dos tiras de 7 pines.

<a id="remote"></a>
## Mando

Mira las [notas mecánicas](mechanical-concept.es.md) para saber dónde va cada pieza, y los [pasos de montaje](mechanical-concept.es.md#assembly).

<a id="electronics"></a>
### Electrónica

| Cant. | Pieza | Tienda | Notas |
|---:|---|---|---|
| 1 | Seeed XIAO nRF52840 **con pines soldados** (MPN `102010631`) | [Kiwi Electronics](https://www.kiwi-electronics.com/en/seeed-studio-xiao-nrf52840-pre-soldered-20402), 9,99 € sin IVA | Se pincha en los zócalos de la placa de control. La misma placa que en la protoboard. |
| 1 | LiPo con placa de protección y cable JST-PH 2.0, como mucho 6 × 20 × 54 mm con la placa de protección | Tienda (por ejemplo Amazon) | La batería va con la placa de protección hacia arriba; el cable tiene que salir por ese extremo y medir al menos unos 35 mm (29 mm en el CAD con una celda de 46,8 mm). Clase de 600 mAh (602045, 602050); una celda 602045 midió 6,1 × 19,7 × 46,8 mm con un cable de 43,5 mm desde una esquina, y cabe. La placa de control protege contra el conector al revés; comprueba la polaridad de todas formas. |
| 1 | [Placa de control](../electronics/control-pcb/README.md), 21,4 × 49 × 1,6 mm | JLCPCB, desnuda o montada | Tres botones KSC2, zócalos de la XIAO, cargador MCP73831, regulador TPS70933, conectores. Gerbers, BOM y colocación en `electronics/control-pcb/fab/`. Piezas por las dos caras; los zócalos son de inserción. |
| 1 | [Placa del joystick rev C](../electronics/joystick-pcb-rev-c/README.md), 20,6 × 22,4 × 1,6 mm | JLCPCB, desnuda o montada | Cuatro interruptores KSC2 y un conector. Ficheros en `electronics/joystick-pcb-rev-c/fab/`. Con la rev B (V0.26) la carcasa no cierra. |
| 1 | [Placa USB-C rev B](../electronics/usbc-pcb-rev-b/README.md), 19 × 16 × **1,2** mm | JLCPCB, desnuda o montada | Pídela de 1,2 mm. Ficheros en `electronics/usbc-pcb-rev-b/fab/`. |
| 1 | GCT USB4736-GF-A-KIT: el receptáculo USB-C sellado con su junta USBTJ-06 | [TME](https://www.tme.com/in/en/details/usb4736-gf-a-kit/usb-ieee1394-connectors/gct/) o [DigiKey](https://www.digikey.sg/en/products/detail/gct/USB4736-GF-A-KIT/26795952), unos 1,7–1,8 USD | Se suelda a mano en la placa USB-C; la junta se pone después de soldar. La pieza C9900206672 de JLCPCB es el USB4736-GF-A **sin** la junta, y JLCPCB no pudo conseguirla el 15-10-2026. |
| 1 | Cable tipo JST SH, 5 pines, hembra-hembra, paso de 1 mm, recto (pin 1 a pin 1), 10 cm | [Pololu](https://www.pololu.com/category/350/5-pin-jst-sh-style-cables), o [AliExpress](https://es.aliexpress.com/item/1005011797428966.html) | De la placa del joystick a la placa de control. En AliExpress elige `same direction` (`reverse direction` seguramente une el pin 1 con el último; `single head` lleva cables pelados en un extremo), 100 mm. |
| 1 | Cable tipo JST SH, 3 pines, hembra-hembra, paso de 1 mm, recto, 10 cm | Pololu, o AliExpress como arriba | De la placa USB-C a la placa de control. |

La [guía de construcción](build-guide.es.md) da el orden del trabajo, desde estos pedidos hasta el mando terminado.

Las piezas de las placas, con sus números de LCSC, están en el README de cada placa y en `fab/*-bom.csv`. Los interruptores KSC221JLFS (LCSC C221726) son piezas de distribuidor: no se encontró ningún interruptor sellado de tienda con esta huella.

<a id="ordering-the-boards"></a>
#### Pedido de las placas

JLCPCB fabrica al menos 5 de cada placa y monta al menos 2. Hay tres formas de pedirlas, con presupuestos de JLCPCB del 15-10-2026. Incluyen el IVA pero no el envío, unos 10 € más. El 20-10-2026 un pedido de las tres placas desnudas pagó además 31,56 € de aranceles (sin desglose), así que las placas desnudas salieron por unos 64 €:

| Opción | Pedido a JLCPCB | Quien monta suelda | Presupuesto |
|---|---|---|---|
| **Placas desnudas** (la más barata) | Los tres `fab/*-gerbers.zip`, sin montaje | Todas las piezas, de [`electronics/lcsc-parts.csv`](../electronics/lcsc-parts.csv), más el kit USB4736 | 22,86 € por las tres placas |
| Montaje económico, solo la cara inferior | Control y joystick con `fab/economic-bottom/`; la cara superior de la placa USB-C con sus ficheros de `fab/`, sin marcar J1 | Los 7 interruptores KSC2, los 2 zócalos de la XIAO y el kit USB4736 | 86,27 € por las tres placas |
| Montaje estándar a dos caras | Control y joystick como el [panel](../electronics/panel-ctrl-joy/README.md) | Nada, salvo el USB4736 si JLCPCB no lo consigue | Unos 134 € solo por la de control y la del joystick |

La [guía de montaje de la electrónica](electronics-assembly.es.md) da el orden de soldadura y las pruebas para las placas desnudas.

`electronics/lcsc-parts.csv` se carga en la herramienta de BOM de LCSC. Su columna `Quantity` cubre dos mandos con repuestos, porque las piezas pequeñas se pierden; `Per remote` da la cantidad exacta. LCSC redondea algunas cantidades al alza hasta su pedido mínimo. Dos líneas con `Per remote` 0 son alternativas, compradas ya para no hacer un segundo pedido: los zócalos de 8,5 mm de la XIAO, por si los pines de la XIAO no van bien en los de 5,7 mm (mira la [placa de control](../electronics/control-pcb/README.md)), y una R1 de 6,8 kΩ para una corriente de carga de unos 150 mA (la de 5,1 kΩ de la lista da unos 200 mA). Desde el 1 de julio de 2026 la UE cobra 3 € de aranceles por clase arancelaria en los paquetes de menos de 150 € de fuera de la UE, no por pieza; el pago de LCSC cobró 21 € por esta lista el 19-10-2026, con o sin las dos alternativas, así que más piezas de una clase que ya está en el pedido no suman aranceles; un pedido posterior los vuelve a pagar. El total del pago de LCSC para la lista el 19-10-2026 fue de 55,02 €: 24,63 € de piezas, 10,07 € de envío, 21,00 € de aranceles, menos 0,68 € de descuento. Son unos 28 € por mando. El pago no cobró IVA, así que el transportista puede cobrar el IVA de importación (21 % en España) y una tasa de gestión en la entrega; sin comprobar. El kit USB4736 no está en LCSC.

Soldar a mano necesita un soldador de punta fina, flux sin limpieza, estaño con flux de 0,5–0,8 mm y malla desoldadora (mira [Consumibles](#consumables)). Las piezas difíciles son los cuatro conectores JST SH de paso de 1,0 mm, el LED de visión lateral y el USB4736; las piezas 0603 y los encapsulados SOT-23 necesitan flux. Suelda primero una placa de repuesto; la del joystick, con cuatro interruptores y un conector, es la más fácil. Comprueba con un polímetro BAT, 5V y 3V3 contra GND antes del primer encendido.

Coste estimado: unos 170 € para el primer mando con placas desnudas, con envío y aranceles; casi todo sirve también para un segundo mando. Las placas montadas cuestan más.

- XIAO con pines: 9,99 € sin IVA en Kiwi Electronics.
- LiPo: 5–10 €.
- Placas: los presupuestos de arriba, más unos 10 € de envío y los aranceles (31,56 € en el pedido de placas desnudas; mira [Pedido de las placas](#ordering-the-boards)).
- Piezas de LCSC: unos 28 € por mando con envío y aranceles (mira arriba).
- Kit USB4736: tres costaron 18,63 € en TME el 19-10-2026, casi todo envío. No desde DigiKey solo: DigiKey España cobra 25 € de envío por debajo de 75 €.
- Cables, presupuestos del 19-10-2026 por 5 de cada: Pololu 21,25 USD más 26,45 USD de envío, antes de aranceles e IVA de la UE; DigiKey (marketplace de Pololu) 20,25 € más 22,78 € de envío. El anuncio de AliExpress dio 12,53 € por 10 de cada, con envío y aranceles. Los cables de AliExpress no están comprobados: comprueba unos cuantos con un polímetro, pin 1 a pin 1, y que encajan en los conectores de las placas.

<a id="hardware"></a>
### Tornillería y piezas

| Cant. | Pieza | Tienda | Notas |
|---:|---|---|---|
| 10 | Tornillo avellanado M2 × 10, ISO 10642 | Tienda | Tapa de controles, a través de la placa de botones (cara superior) y de la placa del joystick (cara inferior). Se hacen su propia rosca en pilotos de Ø1,6 mm en los tetones. |
| 3 | Tornillo avellanado M2 × 8, ISO 10642 | Tienda | Tapa de la batería, en pilotos de Ø1,6 mm en la carcasa. |
| 2 | Tornillo de cabeza abombada M2 × 8, cabeza de como mucho Ø3,5 × 1,1 mm (estilo ISO 7380) | Tienda | Placa del joystick a los separadores de la placa impresa del joystick. |
| 4 | Tornillo de cabeza abombada M2 × 4, cabeza de como mucho Ø3,5 × 1,1 mm (estilo ISO 7380) | Tienda | Dos sujetan la placa de control a los separadores de la placa de botones (2,4 mm de rosca en un piloto de 3,7 mm; un M2 × 6 sobresaldría 0,7 mm por delante de la placa). Dos sujetan la placa USB-C a su nervio, en tuercas cuadradas (V0.34). |
| 1 | Pasador de acero de Ø3 × 12 mm, ISO 8734 | Tienda | Palanca del joystick. |
| 1 | Prisionero M2 × 4 | Tienda | Pomo del joystick. |
| 3 | Tuerca cuadrada M2, DIN 562 (4 × 1,2 mm) | Tienda | Una en el pomo del joystick, en la ranura de debajo, para el prisionero. Dos en el nervio de la placa USB-C, para sus tornillos (V0.34). |
| 1 | Etiqueta de ventilación adhesiva de ePTFE, Ø7,6–8 mm, zona transpirable de al menos Ø3 mm, para un agujero de Ø3 mm | Tienda | Dentro de la tapa de la batería (V0.28). La de Ø8 mm también esquiva la junta de la tapa y la carcasa (comprobación en el CAD, 20-10-2026), con 0,9 mm hasta los bordes de la abertura. |
| 1 | Lámina de espuma de célula cerrada, EPDM o neopreno, adhesiva, de 1,5 mm de grosor, unos 150 × 150 mm | Tienda (lámina o rollo ancho) | Las dos juntas y las tres almohadillas (V0.32), de una sola pieza: la tira de la tapa, cortada de 2 mm de ancho y unos 25 cm de largo en total, sobre el borde de la carcasa (V0.30), y la junta de la tapa de la batería (V0.31), cada una de dos capas desde la V0.34, cortadas alrededor de las plantillas de papel impresas al 100 % desde `mechanical/cad/tools/foam-templates-v0.34.scad`, que tiene todas las piezas de espuma (su barra de 40 mm comprueba la escala). De grado blando; la espuma dura necesita más fuerza de los tornillos. Las almohadillas son capas de la misma lámina: cuatro en la tapa de la batería, una en la pared trasera y seis entre la XIAO y la batería, que sujetan la XIAO en sus zócalos. |

Coste estimado: unos 75 €.

- Tornillos, tuercas y pasadores del mando y de la base: 28,10 € por 11 paquetes de una sola medida, de 10 a 100 unidades, en AliExpress, todo de acero inoxidable, precios del 20-10-2026 con envío gratis. AliExpress suma los aranceles al pagar: el 20-10-2026 estimó 35,27 € para los 11 paquetes, más que los propios paquetes (11 × 3 € son 33 €, así que parece cobrar por anuncio y no por clase arancelaria; sin confirmar), y descontó una promoción de AliExpress de 27,90 €, para un total de 35,47 €. Sin la promoción el pedido costaría unos 63 €. Los paquetes cubren al menos cinco mandos y bases. Los anuncios, por número de artículo en `aliexpress.com/item/<número>.html`:
  - ISO 7380 M2 × 4 y M2 × 8, 50 de cada: 1005002136729466, 1,86 € y 1,96 €.
  - DIN 7991 M2 × 8 y M2 × 10, 50 de cada: 32968097507 (HZYUEGOU), 2,06 € y 1,96 €. La DIN 7991 es la norma antigua de la cabeza ISO 10642.
  - Prisionero DIN 913 M2 × 4, 50: 33030596345 (HZYUEGOU), 2,42 €.
  - Tuerca cuadrada fina DIN 562 M2, 20: 1005001612157787, 2,69 €.
  - Pasadores, Ø1,5 × 4 (100) y Ø3 × 12 (20): 1005012569139327 (HZYUEGOU), 2,69 €, y 1005007023343232, 2,47 €. Son GB 119, la norma china de pasadores cilíndricos, no ISO 8734; sin comprobar frente a las tolerancias de la ISO 8734.
  - DIN 912 M4 × 16, 10, inoxidable con recubrimiento negro: 1005001785489704 (HZYUEGOU), 2,95 €.
  - DIN 912 M3 × 20, 50, inoxidable A4: 1005012860629584, 4,69 €.
  - Tuerca DIN 934 M3, 50, inoxidable con recubrimiento negro: 1005001639359312 (HZYUEGOU), 2,35 €. Algunos anuncios dicen "engrosada"; el alojamiento del pomo mide 2,6 mm de hondo para una tuerca de 2,4 mm.
- Los surtidos no compensan: tres surtidos M2/M3/M4 en Amazon.es sumaban unos 68 € el 19-10-2026 por unas 2.400 piezas, y no traían el pasador de Ø1,5 × 4 ni la tuerca cuadrada.
- Lámina de espuma: neopreno de célula cerrada, adhesivo, 1,5 mm, 300 mm × 3 m, 19,99 € en [Amazon.es](https://www.amazon.es/dp/B0HB4P5PN2) el 20-10-2026. El anuncio dice alta densidad; sin comprobar si es lo bastante blanda. Medida el 22-10-2026: unos 1,15 mm de grosor con su adhesivo (una pila de cinco, 5,8 mm), no 1,5 mm. V0.33 comprime la espuma a 1,0 mm, así que esta lámina sellaría con solo 0,15 mm de compresión; mira las incógnitas abiertas del [concepto mecánico](mechanical-concept.es.md#open-unknowns-before-printing).
- Etiqueta de ventilación: 100 etiquetas de ePTFE, Ø8 mm por fuera, Ø4 mm transpirable, 15,89 € con envío gratis en AliExpress (artículo 1005008646960056, variante OD8 ID4MM 100PCS) el 20-10-2026; el pago sumó algo más de 3 € de aranceles. El anuncio dice IP67 y 120 mbar de presión de entrada de agua; sin comprobar. No se encontró precio de tienda por unidad. Las ventilaciones adhesivas de Gore se venden en paquetes de 50 por unas 213 £ sin IVA ([RS UK](https://uk.rs-online.com/web/p/enclosure-ventilation/2842971)), demasiadas para un montaje. Las pegatinas de ventilación de ePTFE genéricas en paquetes pequeños hay que comprobar que tienen IP67 antes de usarlas. Takachi vende su VE8 (Ø7,6 mm) [en su web](https://takachi-enclosure.com/products/VE8); el precio y el tamaño del paquete para un montaje no están comprobados.

<a id="printed-parts"></a>
### Piezas impresas

| Cant. | Pieza | Grupo de material | Modo de impresión |
|---:|---|---|---|
| 1 | Carcasa | Mando, rígido | `print_housing` |
| 1 | Tapa de controles | Mando, rígido | `print_cover` |
| 1 | Placa del joystick | Mando, rígido | `print_joy_plate` |
| 1 | Bola y disco | Mando, rígido | `print_ball_disc` |
| 1 | Pomo del joystick | Mando, rígido | `print_knob` |
| 1 | Teclado y junta, una sola pieza con las tres teclas | Teclado: TPU blando (85A o más blando); ya no se puede cortar de lámina, porque las teclas salen de ella | `print_gasket` |
| 1 | Placa de botones | Mando, rígido | `print_button_plate` |
| 1 | Tapa de la batería | Mando, rígido | `print_battery_cap` |

Las piezas impresas de la base están en [Base](#base-one-per-bike). Los ajustes y las orientaciones de impresión están en las [notas mecánicas](mechanical-concept.es.md#printing).

Los materiales aún no están elegidos. El [estudio de materiales](materials-study.es.md) recomienda PA11 por MJF para las piezas rígidas del mando (el ASA por FDM es la alternativa), PA12 por MJF para las de la base y TPU cerca de 85A para el teclado. El PETG queda descartado: una pieza oscura al sol de España llega a su temperatura de flexión bajo carga.

Coste estimado, según presupuestos de Craftcloud del 21-10-2026 para los ficheros de la V0.33, solo talleres de la UE, con el envío a España, sin comprobar el IVA:

- Las 11 piezas rígidas del mando y de la base de un solo taller MJF: 143,84 € en PA12 teñido de negro, 161,49 € en PA11 teñido de negro (WAITKUS 360°, Alemania). Un mando en PA11 con una base en PA12 en un solo pedido debería quedar entre los dos; sin cotizar.
- Mando en ASA negro por FDM: 56,99 € con relleno del 20 % (Ľubomír Pavliš, Eslovaquia), unos 74 € al 100 %. La base en PA12 aparte: 91,97 € (Smart Factory, Lituania).
- Teclado en TPU FDM, Shore 81–90A: 26,14 € (Amber Layer, Lituania) o 30,19 € (Imagination 3D, Rumanía). Pregunta el filamento exacto; la lámina de 0,8 mm es más fina que la pared mínima de 1 mm que se da para el TPU FDM.

La lista completa está en el [estudio de materiales](materials-study.es.md#quotes). Los pedidos de fuera de la UE eran más baratos (desde unos 115 € por las piezas rígidas), pero pagan aranceles.

<a id="base-one-per-bike"></a>
## Base, una por moto

| Cant. | Pieza | Tienda | Notas |
|---:|---|---|---|
| 2 | Tornillo de cabeza cilíndrica M4 × 16, ISO 4762 | Tienda | Abrazadera. Se hace su propia rosca en pilotos de Ø3,4 mm en la parte delantera de la base. |
| 1 | Tornillo de cabeza cilíndrica M3 × 20, ISO 4762 | Tienda | Su cabeza es el pestillo del cierre. La V0.31 pedía M3 × 22, que no es un largo estándar. |
| 1 | Muelle de compresión 0,5 × 5 × 10 mm, inoxidable (hilo × diámetro exterior × largo libre) | Tienda (surtidos de muelles; corta uno más largo si hace falta) | Cierre. Unos 4–4,7 N cerrado y 6–7 N al tirar, estimados con el muelle medido más abajo. |
| 2 | Pasador de acero de Ø1,5 × 4 mm, ISO 8734 | Tienda | Pomo del cierre de cuarto de vuelta. |
| 1 | Tuerca M3, ISO 4032 | Tienda | Pomo del cierre, en su alojamiento hexagonal; fijada en la rosca con fijatornillos de fuerza media, o con el epoxi transparente (V0.32: sin contratuerca). |
| 1 | Cámara de bicicleta, butilo, pared de unos 0,8–1,2 mm; sirve una vieja | Tienda o una cámara usada | Dos tiras antivibración de 4 × 50 mm, pegadas en los alojamientos de la plataforma con el epoxi transparente. Opcionalmente las dos mitades del forro, de 25 × 43 mm (V0.33), en vez del TPU impreso. Mide la pared y ajusta `strip_t` (y `liner_radial`) antes de imprimir la parte delantera de la base. |
| 1 | Parte delantera de la base | Base, rígido; `print_base_front` | Una sola pieza para los dos diámetros de manillar (V0.28). 25 mm de ancho desde la V0.33. |
| 1 | Tapa de la base | Base, rígido; `print_base_cap` | |
| 2 | Mitad del forro del manillar | TPU 95A, `liner_main`, `liner_cap`, o cortada de la cámara | Para un manillar de 25,4 mm o para el casquillo. |
| 2 | Mitad del casquillo, solo para manillares de menos de 25,4 mm | Base, rígido; `print_sleeve`, con `bar_diameter` ajustado al manillar medido con un calibre | Entre el manillar y el forro. Los manillares pintados de 7/8 in pueden medir 0,3 mm más de 22,2 mm. |
| 1 | Pomo del cierre, Ø16 mm, cuarto de vuelta | Base, rígido; `print_lock_knob` | Cara de arriba sobre la cama. |

Coste estimado: 6,49 € por el muelle.

- Piezas impresas: presupuestadas con las del mando (mira [Piezas impresas](#printed-parts)); la base sola en PA12 por MJF costaba 91,97 € el 21-10-2026.
- Muelle: 5 × 0,5 × 5 × 10 mm, inoxidable 304, 6,49 € en [Amazon.es](https://www.amazon.es/dp/B0C77XC4WS) el 20-10-2026. Los surtidos de muelles revisados no tenían esta medida, y un diámetro exterior de 6 mm no cabe en el alojamiento de Ø6,0 mm.
  Medido el 22-10-2026: hilo de 0,5 mm, diámetro exterior de 5 mm, largo libre de 10 mm, 7 espiras con extremos cerrados sin rectificar (5–6 activas), 3,6 mm a tope. El cierre lo comprime a 4,0 mm (`lock_spring_solid`), así que nunca llega a tope. Pon el extremo con la punta cortada contra el fondo del alojamiento, para que la punta no roce la cabeza del tornillo al girar el pomo.
- Tornillos, tuerca y pasadores: en los paquetes de AliExpress del mando (mira [Tornillería y piezas](#hardware)).

<a id="consumables"></a>
## Consumibles

| Pieza | Uso |
|---|---|
| Barniz de protección, acrílico o de silicona | Las tres placas y la XIAO. Que no llegue a los conectores USB-C, a los conectores JST y los zócalos, a los actuadores de los interruptores, a la batería ni a la ventilación. |
| Epoxi transparente de dos componentes | Rellenar la ventana del LED de carga, rellenar la parte trasera del receptáculo USB-C de carga si falla la prueba de estanqueidad, fijar la tuerca del pomo del cierre en su tornillo si no hay fijatornillos, y pegar las tiras antivibración. Un solo epoxi transparente sirve para las cuatro cosas. |
| Fijatornillos de fuerza media (azul), opcional | Fijar la tuerca del pomo del cierre en su tornillo, de forma que el ajuste se pueda deshacer. Que no toque el pomo impreso: la hoja de datos del Loctite 243 de Henkel (edición de 2008) no lo recomienda sobre plásticos, porque puede agrietar los termoplásticos. |
| Flux sin limpieza (jeringa), estaño con flux de 0,5–0,8 mm, malla desoldadora de 2 mm, alcohol isopropílico | Solo para placas desnudas: soldar a mano y limpiar el flux antes del barniz. |

Coste estimado: unos 31 €, más 15–30 € del material de soldadura (sin comprobar) y 9,38 € del fijatornillos opcional. Todos duran muchos montajes.

- Barniz acrílico: Kontakt Chemie Plastik 70, aerosol de 400 ml, 22,27 € en [Amazon.es](https://www.amazon.es/dp/B00VATOHMC) el 20-10-2026; o 200 ml, 21,11 € con IVA en [RS Países Bajos](https://nl.rs-online.com/web/p/conformal-coatings/0714462).
- Epoxi transparente de dos componentes: fischer, 25 ml, 8,86 € en [Amazon.es](https://www.amazon.es/dp/B07TS8NX5K) el 20-10-2026.
- Fijatornillos: Loctite 243, 5 ml, 9,38 € con IVA en [RS Benelux](https://befr.rs-online.com/web/p/thread-lock/4423413), según un resultado de búsqueda del 28-10-2026; la página no se abrió. También lo venden tiendas de bicis y ferreterías.

<a id="ordering-notes"></a>
## Notas de pedido

- Las tres placas pueden ir en un mismo pedido de JLCPCB. La placa USB-C mide 1,2 mm de grosor y las otras dos 1,6 mm, así que son placas distintas dentro del pedido.
- Para el montaje: la placa de control y la del joystick llevan piezas por las dos caras, así que el montaje completo es a dos caras. Comprueba el giro de cada pieza en la vista previa de colocación de JLCPCB: los ficheros CPL usan los giros de KiCad.
- Los cables son rectos: el pin 1 de un extremo va al pin 1 del otro. Comprueba los cables comprados antes de montarlos.
- Los números y las existencias de LCSC se comprobaron en la biblioteca de JLCPCB el 14-10-2026; las existencias y los precios cambian.
