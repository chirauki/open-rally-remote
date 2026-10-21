# Materiales de impresión — Estudio

> Traducción al castellano de [materials-study.md](materials-study.md). La versión en inglés es la de referencia; si las dos difieren, vale la inglesa.

Este estudio compara los materiales de impresión antes de elegir un servicio de impresión. Hasta la V0.32 los documentos decían "PETG o ASA", algo que venía de lo que ofrecía un servicio, no de las condiciones en la moto. El estudio partió de la V0.32 y llevó a las paredes de 2 mm de la V0.33; mira [Con paredes de 2 mm](#with-2-mm-walls-v033).

**Estado:** estudio sobre el papel, 20-10-2026 y 21-10-2026. Los valores salen de fichas técnicas y ensayos publicados, citados abajo. Nada de esto se ha impreso ni medido. El material aún no está elegido: los [presupuestos](#quotes) ya están, y la elección sigue abierta.

<a id="conditions"></a>
## Condiciones

Acordadas el 20-10-2026:

- Sol de verano en España: aire hasta unos 40 °C; una pieza oscura al sol hasta unos 70 °C. Los 70 °C son una estimación: las piezas oscuras se ponen 20–30 °C por encima del aire ([QIDI](https://qidi3d.com/en-br/blogs/print-lab/best-filament-car-interiors-abs-asa)).
- Lluvia, barro y manguera sin presión (más o menos IPX5/6).
- Hasta unos −5 °C.
- Salpicaduras de combustible, aceite de cadena, limpiadores y crema solar.
- Vibración, golpes y manos con guantes.

Las piezas interiores van dentro de una caja oscura y cerrada. Al sol pueden calentarse casi tanto como las exteriores, así que este estudio no les da una temperatura más fácil.

<a id="what-each-part-needs"></a>
## Qué necesita cada pieza

| Grupo | Piezas | Necesita |
|---|---|---|
| Base | parte delantera de la base, tapa de la base, pomo del cierre, mitades del casquillo | Sin fluencia bajo la precarga de la abrazadera al sol; roscas autorroscantes M4 (pilotos de Ø3,4 mm); la holgura de 0,2 mm de la cola de milano (`dt_c`); golpes |
| Carcasa | carcasa | UV; paredes estancas (`case_wall`, 2 mm desde la V0.33, 1 mm antes); roscas autorroscantes M2 (pilotos de Ø1,6 mm); golpes |
| Tapas | tapa de controles, tapa de la batería | UV; apoyos planos para las juntas de espuma; roscas M2 |
| Pomos | pomo del joystick | UV; golpes |
| Placas interiores | placa del joystick, placa de botones | Rigidez; roscas M2; calor dentro de la caja |
| Bola del joystick | bola y disco | Desgaste; el ajuste a presión del pasador en el agujero de Ø2,95 mm |
| Teclado | teclado y junta | TPU blando, mejor 85–88A; lámina de 0,8 mm; flexión en frío; UV en las tres teclas |

<a id="rigid-candidates"></a>
## Candidatos rígidos

| Material, proceso | HDT 0,45 MPa | HDT 1,8 MPa | Notas | Fuente |
|---|---:|---:|---|---|
| PETG, FDM | 68–78 °C | — | Charpy con entalla 2,6–11,6 kJ/m² según la marca | Ficha de Prusament; [Polymaker](https://wiki.polymaker.com/polymaker-products/polymaker-filaments/technical-data-at-a-glance) |
| ASA, FDM | 92–103 °C | — | Charpy con entalla 10,3 kJ/m² (Polymaker ASA) | [Polymaker](https://wiki.polymaker.com/polymaker-products/polymaker-filaments/technical-data-at-a-glance), otras marcas |
| ABS, FDM | 100 °C | — | Charpy con entalla 18 kJ/m² | [Polymaker](https://wiki.polymaker.com/polymaker-products/polymaker-filaments/technical-data-at-a-glance) |
| PC, PC-ABS, FDM | 111–112 °C | — | Charpy con entalla 4,1 (PC), 25,8 (PC-ABS) kJ/m² | [Polymaker](https://wiki.polymaker.com/polymaker-products/polymaker-filaments/technical-data-at-a-glance) |
| PA12, MJF | 175 °C | 95 °C | Alargamiento 12 % en XY, 5–9 % en Z; agua 0,5 % al 50 % HR | [Protolabs](https://www.protolabs.com/media/1010893/2019-mjf-datasheet-pa-12-black.pdf), [JLC3DP](https://jlc3dp.com/help/article/pa12s-hp-nylon) |
| PA11, MJF | 183–185 °C | 50 °C | Alargamiento 50 %; Izod con entalla 5–6 kJ/m² | [HP 4AA7-0715EEP](https://3dprinting.com/wp-content/uploads/2019/02/4AA7-0715EEP.pdf), [JLC3DP](https://jlc3dp.com/help/article/pa11-hp-nylon) |
| PP, MJF | 100 °C | — | Alargamiento 20 %; Charpy con entalla 3,5 kJ/m² | [Forward AM](https://forward-am.com/material-portfolio/ultrasint-powders-for-powder-bed-fusion-pbf/pp-line/hp-3d-high-reusability-pp-enabled-by-forward-am/) |

Los valores de impacto vienen de ensayos distintos (Charpy, Izod) y de procesos distintos, así que no se comparan entre filas.

<a id="heat-and-creep"></a>
### Calor y fluencia

A 70 °C, el PETG está en su HDT a carga baja o por encima. La base aguanta la precarga de la abrazadera todo el día al sol, así que el PETG fluiría y la abrazadera se aflojaría. El ASA, el ABS y el PC guardan 20–40 °C de margen a 0,45 MPa. El PA12 guarda unos 100 °C a 0,45 MPa y todavía 25 °C a 1,8 MPa. El PA11 baja a 50 °C a 1,8 MPa, por debajo de la pieza a 70 °C, así que es el nylon más débil para la abrazadera.

<a id="sun"></a>
### Sol

- El ASA está hecho para exterior y resiste el envejecimiento por UV ([INEOS Styrolution, Luran S](https://www.ineos-styrolution.com/Product/Luran-S_ID40070019.html)).
- El PA12 pierde resistencia y alargamiento con el UV si no está teñido. Teñido de negro, conservó su resistencia a tracción tras 1.500 h de UV según ISO 4892-3, con un 15 % de fragilización ([Stratasys, SAF PA12](https://stratasys.co.jp/contentassets/155355c980974a9a9aa809b498f13001/wp_saf_pa12--pp-uv--weathering-exposure_0425a.pdf)). El mismo documento equipara 1.500 h a unos 1,5–3 años al aire libre. Ese ensayo usó SAF, no MJF. Las piezas MJF son grises por fuera y negras por dentro ([3DPRINTUK](https://www.3dprint-uk.co.uk/hp-mjf-pa12-nylon-material)); no se sabe si una pieza MJF sin teñir se comporta como la pieza SAF teñida.
- El PP conservó sus propiedades tras 1.500 h en el mismo ensayo.
- El PETG y el PC resisten el UV de forma moderada.

<a id="fuel-oil-cleaners-and-sunscreen"></a>
### Combustible, aceite, limpiadores y crema solar

- El ASA resiste la gasolina con pocos aromáticos y los aceites. Los hidrocarburos aromáticos, los ésteres, las cetonas y algunos alcoholes lo atacan ([Wikipedia, citando una ficha](https://en.wikipedia.org/wiki/Acrylonitrile_styrene_acrylate)). La gasolina puede llevar muchos aromáticos, así que el ASA solo la resiste con condiciones.
- El ABS se agrieta bajo tensión cuando le llega gasolina, líquido de frenos o aceite ([patente US 5093419](https://image-ppubs.uspto.gov/dirsearch-public/print/downloadPdf/5093419)). La crema solar también agrieta el ABS y el PC bajo tensión ([SAE 2011-01-0037](https://saemobilus.sae.org/content/2011-01-0037); [ASM IMAT 2025](https://asm.confex.com/asm/imat2025/webprogram/Paper63600.html)).
- El PC con deformación se rompe en segundos en gasolina ([SAE 760726](https://saemobilus.sae.org/papers/stress-cracking-plastics-gasoline-760726)).
- El PA12 resiste aceites, grasas, hidrocarburos alifáticos y álcalis ([UL Prospector, HP PA12](https://betaplastics.ulprospector.com/plastics/en/datasheet/398134/hp-3d-high-reusability-pa-12)); una tabla incluye el gasóleo y el fuel ([ARRK](https://media.arrk.com/pdf/eu/es/fichas-tecnicas/tabla-comparativa-materiales-sls-mjf.pdf)). Ninguna fuente nombra la gasolina.
- La plancha de PETG se califica como estable en gasolina, gasóleo, aceite de motor y etanol a 20 °C, e inestable en acetona (resistencia química del PETG de Brett Martin, 2024, vía [Sunclear](https://www.sunclear.fr/img/medias/bt/POLYESTER_PETG_INCOLORE_Chemical%20Resistance.pdf)). Son datos de plancha, no de pieza impresa.
- No se encontró ninguna fuente sobre crema solar y poliamida.

Donde estos productos hacen daño es en las roscas: un tornillo autorroscante deja el tetón bajo tensión constante.

<a id="watertight-walls"></a>
### Paredes estancas

Las capas FDM pueden filtrar a través de una pared de 1 mm con dos perímetros; es el punto abierto 8 de las [notas mecánicas](mechanical-concept.es.md#sealing). La V0.33 hace todas las paredes de la carcasa de 2 mm, cuatro perímetros con una boquilla de 0,4 mm; con un relleno del 100 % o cinco perímetros la pared es maciza. El PA12 MJF se vende como "estanco al agua y al aire sin tratamiento" ([Protolabs](https://www.protolabs.com/media/1010893/2019-mjf-datasheet-pa-12-black.pdf)). Es una afirmación del vendedor; no está comprobada para estas paredes.

<a id="tolerances"></a>
### Tolerancias

JLC3DP da ±0,3 mm hasta 100 mm para el PA12 MJF, y recomienda paredes de más de 1,0 mm ([JLC3DP](https://jlc3dp.com/help/article/pa12s-hp-nylon)). El diseño tiene detalles del mismo tamaño: la holgura de 0,2 mm de la cola de milano, el hueco de 0,3 mm de las teclas en reposo y los pilotos de Ø1,6 mm. Un ±0,3 mm en el peor caso no es compatible con esos valores, pero es un límite, no el error típico. Los servicios FDM no publican una cifra; depende de la impresora. En cualquier caso, esos detalles hay que comprobarlos en la primera impresión.

<a id="impact"></a>
### Impacto

Las caídas son frecuentes en pistas y caminos, así que el mando tiene que aguantar golpes. Hay dos casos que se diferencian en unos tres órdenes de magnitud.

- **Se cae el mando.** Las piezas impresas del mando suman 29,7 cm³ en el CAD de la V0.33 (carcasa, tapa de controles, tapa de la batería, pomo, placas, bola; 24,5 cm³ en la V0.32), unos 30 g en nylon, más 4 g de teclado. Con las placas, la XIAO, la batería y los tornillos, que no están pesados, el mando pesa quizá 50–70 g. Una caída de 1,5 m sobre roca es entonces de 1 J más o menos. Un material tenaz puede absorber eso.
- **La moto cae sobre el mando.** Una moto de 150–200 kg que cae de lado libera cientos de julios. Si el mando es lo primero que toca el suelo, ningún plástico lo aguanta. Ahí protege la geometría, no el material; mira [Diseño frente a caídas](#crash-design).

Valores comparables. El Charpy con entalla es ISO 179/1eA salvo que se diga otra cosa; el Izod con entalla (ASTM D256) no se compara con él.

| Material, proceso | Alargamiento a rotura XY / Z | Impacto con entalla, 23 °C | Impacto con entalla, −30 °C | Fuente |
|---|---|---|---|---|
| ASA, FDM (Polymaker) | 6,7 % / 1,65 % | Charpy 10,3 (XY), 6,7 (Z) kJ/m² | — | [Polymaker ASA](https://wiki.polymaker.com/polymaker-wiki-pt/produtos-polymaker/mais-sobre-nossos-produtos/documentos/fichas-tecnicas/abs-asa/polymaker-tm-asa) |
| PA12, MJF (HP) | 18 % / 10 % | Izod 4,5 (XY), 4,4 (Z) kJ/m² | — | Ficha de HP 3D HR PA 12, vía [MatterHackers](https://www.matterhackers.com/r/V5DB6y) |
| PA12, MJF (JLC3DP) | 12 % / 5 % | Izod 2–2,5 kJ/m² | — | [JLC3DP](https://jlc3dp.com/help/article/pa12s-hp-nylon) |
| PA12, SLS (EOS PA 2200) | 18 % / 4 % | Charpy 4,8 kJ/m²; sin entalla 53 kJ/m² | Charpy 4,8 kJ/m² (X) | [EOS PA 2200](https://www.eos.info/polymer-solutions/data-sheets/pds-pa-2200-balance) |
| PA11, MJF (HP) | 50 % / 50 % | Izod 6 (XY), 5 (Z) kJ/m² | — | [HP 4AA7-0715EEP](https://3dprinting.com/wp-content/uploads/2019/02/4AA7-0715EEP.pdf), [JLC3DP](https://jlc3dp.com/help/article/pa11-hp-nylon) |
| PA11, SLS (EOS PA 1101) | 30 % / 15 % | Charpy 6,9–7,3 (XY), 5,5 (Z); sin entalla no rompe (XY), 85 (Z) kJ/m² | Charpy 5,8–6,3 (XY), 5,1 (Z); sin entalla 70 (Z) kJ/m² | [EOS PA 1101](https://www.eos.info/fr/solutions-polymeres/materiaux-polymeres/fiches-techniques/mds-pa-1101) |

Lo que dice la tabla:

- **El ASA por FDM es tenaz a lo largo de las capas y frágil entre ellas.** Rompe al 1,65 % de deformación en Z. Un golpe en una esquina de la carcasa la abre por una línea de capa, y esas capas son las paredes que rodean la batería.
- **El PA12 es sensible a la entalla.** Sus valores con entalla son los más bajos de los nylons, y los tetones de los tornillos, las esquinas y la ranura de la cola de milano son entallas. El PA12 sinterizado además pierde resistencia al impacto en frío: unas probetas sinterizadas por láser ganaron un 20–47 % de −25 °C a 60 °C en Izod ([Korea Science](https://www.koreascience.or.kr/article/JAKO201835372298728.page)).
- **El PA11 es el tenaz.** Estira un 50 % antes de romper (HP), conserva casi toda su resistencia al impacto a −30 °C (EOS) y sin entalla no rompe en XY. HP lo describe como un material de "ductilidad y resistencia al impacto excepcionalmente altas". Su punto débil es la HDT de 50 °C a 1,8 MPa.

De ahí sale el reparto: el mando recibe los golpes y no lleva carga continua; la base lleva la precarga de la abrazadera todo el día al sol.

<a id="crash-design"></a>
### Diseño frente a caídas

El material solo cubre el mando que se cae y los golpes pequeños. Para una caída de la moto cuenta más esto; nada está comprobado todavía:

- **Quedarse dentro de la zona protegida.** El mando debería quedar detrás del paramanos o del extremo del manillar, para que el suelo los toque a ellos primero. Dónde queda depende de la moto y de los paramanos; es un punto abierto.
- **Dejar que la abrazadera patine.** La abrazadera aguanta unos 3,3 N·m (una estimación; mira [Base](mechanical-concept.es.md#v028-changes-from-v027-still-current)). En una caída, el mando gira entonces alrededor del manillar en vez de romperse, como una maneta con la abrazadera floja. No aprietes la abrazadera más de lo que necesitan los controles.
- **Proteger la batería.** La LiPo va detrás de paredes de 2 mm (1 mm hasta la V0.32). Una carcasa agrietada la puede aplastar o perforar. Una carcasa dúctil que se abolla es más segura que una que estalla.
- **El pomo es un recambio.** Sobresale 5,7 mm de la tapa sobre un pasador de acero de Ø3 mm. Un golpe de lado rompe el pomo o dobla el pasador; los dos son baratos de cambiar.
- **Las cabezas de los tornillos apoyan sobre el plástico.** Las cabezas M4 asientan sobre una cara de Ø7,0 mm alrededor del agujero de Ø4,3 mm, unos 24 mm². Con la precarga supuesta de 500 N son unos 21 MPa, sin arandela. Eso afecta a la fluencia de cualquier plástico, no solo al impacto; es un punto abierto de la base.

<a id="rejected"></a>
### Descartados

- **PETG:** está en su HDT al sol, y fluiría bajo la abrazadera. Solo sería posible si nada caliente y cargado se hace con él, y eso deja demasiado pocas piezas para que merezca un segundo material.
- **ABS:** UV malo, y se agrieta con gasolina y crema solar.
- **PC y mezclas de PC:** se agrietan con gasolina y crema solar.
- **PA11 para la base:** su HDT a 1,8 MPa es de 50 °C, por debajo de una pieza a 70 °C, y la base lleva la precarga de la abrazadera. El PA11 se queda para el mando; mira [Impacto](#impact).
- **PP:** la mejor resistencia al UV y a los productos químicos, pero el diseño pega cosas al plástico en tres sitios: la tira de espuma, la etiqueta de ventilación y el epoxi del tornillo del cierre. El PP se pega mal. Pocos servicios lo ofrecen.
- **Nylon con fibra de carbono (FDM):** siguen siendo capas FDM, y las fibras lo hacen más frágil. No resuelve nada que no resuelva el PA12 MJF.
- **Resinas (SLA):** no se han estudiado más. Las resinas de uso general envejecen con el UV y son frágiles.

<a id="with-2-mm-walls-v033"></a>
### Con paredes de 2 mm (V0.33)

La primera versión de este estudio partía de las paredes de 1 mm de la V0.32. Esas paredes las fijaban los 23 mm de manillar libre del manual del NAVCOMM, que es una referencia, no un requisito. La V0.33 las lleva a 2 mm, hacia fuera, así que el mando mide 25 mm de ancho y 2 mm más de alto, y la cavidad no cambia. Lo que cambia aquí:

- **Paredes estancas:** con cuatro perímetros, o una pared maciza, el FDM deja de ser un riesgo claro de filtración. La prueba de estanqueidad decide para cualquier material.
- **Golpes:** la resistencia a flexión de una pared crece con el cuadrado de su espesor, así que una pared de 2 mm aguanta unas cuatro veces la carga de una de 1 mm, en cualquier material. El ASA sigue rompiendo entre capas al 1,65 % de deformación, pero necesita mucha más carga para llegar ahí.
- **Sin cambios:** la gasolina, el calor bajo la abrazadera (PA12 para la base) y el sol (el ASA es el mejor).

La diferencia entre el PA11 por MJF y el ASA por FDM para el mando es menor que con paredes de 1 mm. Solo una prueba de caída dice si una pared de 2 mm de ASA basta para una caída real.

<a id="flexible-candidates-keypad"></a>
## Candidatos flexibles (teclado)

| Material, proceso | Dureza | Notas | Fuente |
|---|---|---|---|
| Ultrasint TPU 88A, SLS | 88–90A | Tg −48 °C; Charpy con entalla a −10 °C 58–60 kJ/m²; "buena resistencia al UV y a la hidrólisis"; alargamiento 270 % en XY, 130 % en Z | [BASF TDS 2.0](https://info.sculpteo.com/hubfs/Material%20documentation/TPU%2088A/TDS%20Ultrasint%20TPU%2088A_V2.0.pdf) |
| HP TPU, MJF | 88–90A | Parecido al polvo SLS | HP; sin comprobar en detalle |
| TPU FDM, por ejemplo Filaflex 82A | 82A | Alargamiento 650 % | Recreus |
| TPU FDM 90A / 95A | 90–95A | Alargamiento 550–590 % | [Polymaker](https://wiki.polymaker.com/polymaker-products/polymaker-filaments/technical-data-at-a-glance) |

Una mañana a −5 °C queda muy por encima de la transición vítrea de −48 °C del polvo de BASF, así que el frío no es un límite para el TPU. El teclado pide 85–88A por el tacto de las teclas. Los TPU en polvo son de 88–90A, justo por encima, y la lámina del teclado mide 0,8 mm, menos que la pared de 1,0 mm que los servicios de polvo recomiendan para el PA12; su límite para el TPU no está comprobado. Un TPU FDM cerca de 85A imprime una lámina de 0,8 mm sin ese límite.

<a id="recommendation"></a>
## Recomendación

Aún sin decidir. La recomendación tal como está:

- **Mando (carcasa, tapa de controles, tapa de la batería, pomo, placas, bola): PA11 por MJF, teñido de negro si el servicio lo ofrece.** Es el candidato rígido más tenaz, también en frío, y estas piezas no llevan carga continua.
- **Base (parte delantera, tapa, pomo del cierre, mitades del casquillo): PA12 por MJF.** Tiene el mayor margen de temperatura bajo la precarga de la abrazadera. La base es barata de reimprimir tras una caída.
- Los dos salen del mismo proceso y pueden ir en un solo pedido. PA11 para todo sería un material menos, pero su HDT de 50 °C a 1,8 MPa es un riesgo para la abrazadera; PA12 para todo haría el mando sensible a la entalla.
- **Alternativa para el mando: ASA por FDM.** Con paredes de 2 mm es una opción razonable: mejor al sol, más servicios y más barato por sí solo. Sigue siendo frágil entre capas, así que es la opción más débil para las caídas. Pide un relleno del 100 % o al menos cinco perímetros, y limpia la gasolina; no la dejes secarse sobre la pieza. La base sigue en PA12 por MJF.
- **Teclado: TPU FDM, 85A o lo más cerca que ofrezca el servicio.** TPU en polvo (88–90A) solo si el servicio imprime la lámina de 0,8 mm.
- **Forros y tiras antivibración:** cámara de bicicleta, como en la V0.32.

<a id="quotes"></a>
## Presupuestos

Presupuestos de Craftcloud del 21-10-2026 para los STL de la V0.33, con el casquillo para un manillar de 22,5 mm. Solo se listan talleres de la UE, porque los pedidos de fuera de la UE pagan aranceles. Los precios incluyen el envío a España; no está comprobado si incluyen el IVA. Son una foto del momento: los precios de Craftcloud cambian con la carga de cada taller.

| Pedido | Material | Taller (país) | Total |
|---|---|---|---:|
| 11 piezas rígidas | PA12 MJF, teñido de negro | WAITKUS 360° (Alemania) | 143,84 € |
| 11 piezas rígidas | PA11 MJF, teñido de negro | WAITKUS 360° (Alemania) | 161,49 € |
| 7 piezas del mando | PA11 MJF, teñido de negro | WAITKUS 360° (Alemania) | 136,60 € |
| 7 piezas del mando | PA12 MJF, teñido de negro | STURM Industries (Alemania) | 133,32 € |
| 7 piezas del mando | ASA FDM, negro, relleno del 20 % | Ľubomír Pavliš (Eslovaquia) | 56,99 € |
| 4 piezas de la base | PA12 MJF, gris | Smart Factory (Lituania) | 91,97 € |
| 11 piezas rígidas | ASA FDM, negro, relleno del 20 % | Ľubomír Pavliš (Eslovaquia) | 76,40 € |
| Teclado | TPU FDM, Shore 81–90A, negro | Amber Layer (Lituania) | 26,14 € |
| Teclado | TPU FDM, Shore 81–90A, negro | Imagination 3D (Rumanía) | 30,19 € |

Lo que dicen los presupuestos:

- **En MJF, la base es lo que más cuesta.** Pedida aparte, suma un segundo envío y un segundo pedido mínimo: el mando en PA11 más la base en PA12 de dos talleres sale por 228,57 €.
- **Un solo taller MJF para todo cuesta 144–161 €.** Lo mejor para la recomendación es el mando en PA11 y la base en PA12 en un único pedido a WAITKUS. Craftcloud deja elegir un material por pieza, pero esta mezcla no está cotizada; debería quedar entre los dos totales de arriba.
- **Mando en ASA más base en PA12 cuesta más o menos lo mismo, 149–166 €,** porque la base va en PA12 en los dos casos. El relleno del 100 % suma unos 17 € al mando en ASA.
- **Todo en ASA cuesta la mitad,** pero el ASA en la base es justo lo que descarta el [calor](#heat-and-creep).
- WAITKUS tenía una sola valoración en Craftcloud el 21-10-2026.
- El teclado suma 26–30 €. Craftcloud agrupa de 81 a 90A, así que hay que preguntar el filamento exacto; la lámina de 0,8 mm es más fina que la pared mínima de 1 mm que Craftcloud da para el TPU FDM.
- Sin cotizar: la mezcla de PA11 y PA12 en un solo pedido, el teclado en TPU MJF del taller del nylon e INNOVATIA3D en España (su calculadora necesita subir los ficheros a mano). Weerg y Sculpteo no se miraron. Las ofertas de Singapur, China e India empezaban en unos 115 € por todas las piezas, antes de aranceles.

<a id="open-points"></a>
## Puntos abiertos

- Si el servicio elegido tiñe de negro el nylon MJF, y cómo envejecen al sol el PA11 y el PA12 MJF sin teñir. No se encontraron datos de UV del PA11.
- La gasolina sobre el PA11 y el PA12: ninguna fuente la nombra.
- Tolerancias en la primera impresión: la holgura de la cola de milano, el hueco de las teclas en reposo, el ajuste a presión del pasador en el agujero de Ø2,95 mm y los pilotos de Ø1,6 mm y Ø3,4 mm.
- Si el adhesivo de la tira de espuma y la etiqueta de ventilación aguantan sobre la superficie rugosa del MJF.
- El impacto del PA11 y el PA12 MJF a −5 °C: solo se encontraron datos de SLS.
- Si una pared de 2 mm es estanca, en nylon MJF o en FDM.
- Dónde queda el mando respecto al paramanos y al extremo del manillar en cada moto.
- La presión de las cabezas de los tornillos sobre la tapa de la base, sin arandela.
- Una prueba de caída del primer mando: 1,5 m sobre hormigón, por cada cara, a temperatura ambiente y tras una noche en el congelador de casa (unos −18 °C), como prevé el [planteamiento del proyecto](project-brief.md). También dice si 2 mm de ASA bastan.
- Los presupuestos que faltan (mira [Presupuestos](#quotes)) y el filamento exacto del teclado.
