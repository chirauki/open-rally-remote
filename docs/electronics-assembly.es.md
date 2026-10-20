# Montaje de la electrónica — V0.32

> Traducción al castellano de [electronics-assembly.md](electronics-assembly.md). La versión en inglés es la de referencia; si las dos difieren, vale la inglesa. Los textos de las imágenes están en inglés.

Esta guía lleva las tres placas desnudas del pedido de JLCPCB y los componentes de [`electronics/lcsc-parts.csv`](../electronics/lcsc-parts.csv) hasta tener tres placas soldadas, probadas y barnizadas. Después, el [montaje mecánico](mechanical-concept.es.md#assembly) las coloca en el mando.

Si las placas llegaron montadas, sáltate la soldadura y empieza en [Cables](#cables). Con el montaje Economic de JLCPCB aún hay que soldar los interruptores y los zócalos de la XIAO (pasos J1, C5 y C7) y el receptáculo USB-C (paso U3).

**Estado.** Esta guía sale de los ficheros de diseño, no de un montaje real. Nadie ha montado todavía estas placas. Lo que aún no se ha comprobado con piezas reales está en [Puntos abiertos](#puntos-abiertos). Apunta lo que salga distinto en el primer montaje y corrige la guía.

## Índice

1. [Antes de empezar](#antes-de-empezar)
2. [Placa del joystick](#placa-joystick) (placa de práctica)
3. [Placa de control](#placa-control)
4. [Placa USB-C](#placa-usbc)
5. [Cables](#cables)
6. [Pruebas de alimentación, sin la XIAO](#pruebas-alimentacion)
7. [XIAO, firmware y prueba de funcionamiento](#xiao)
8. [Barniz de protección](#barniz)
9. [Puntos abiertos](#puntos-abiertos)

<a id="antes-de-empezar"></a>
## Antes de empezar

### Componentes para un mando

| Placa | Componentes | Cantidad |
|---|---|---:|
| Joystick rev C | Interruptor KSC221JLFS (SW1–SW4); conector de 5 pines, paso 1,0 mm, entrada lateral (J1) | 5 |
| Control | Interruptor KSC221JLFS (SW1–SW3); MCP73831 (U1); TPS70933 (U2); AO3401A (Q1); resistencias 0603 de 10k (R1), 100k (R2, R4), 150k (R3, R5), 1M (R6, R7); condensadores 0603 de 4,7 µF (C1–C4) y 100 nF (C5); fusible PTC 1812 (F1); SMBJ5.0A (D1); conectores de 3 y 5 pines, paso 1,0 mm, entrada lateral (J3, J4); conector JST PH de 2 pines, entrada por arriba (J5); dos zócalos hembra 1 × 7, paso 2,54 mm, 5,7 mm de alto (J1, J2) | 28 |
| USB-C rev B | 5,1k 0603 (R1, R2); 1k 0603 (R3); LED rojo de vista lateral LTST-S270KRKT (D1); conector de 3 pines, paso 1,0 mm, entrada lateral (J2); receptáculo GCT USB4736-GF-A (J1; su junta se pone después) | 6 |
| Fuera de las placas | XIAO nRF52840 con pines; batería LiPo con cable JST PH; cables JST SH de 3 y 5 pines | |

Los números de LCSC están en el CSV y en el `fab/*-bom.csv` de cada placa. Los componentes pequeños vienen en tiras de cinta. Deja cada pieza en su tira hasta colocarla. Los condensadores 0603 no llevan ninguna marca, y las resistencias 0603 puede que tampoco. Una pieza suelta de valor desconocido no se puede identificar: tírala.

### Herramientas

| Herramienta | Notas |
|---|---|
| Soldador con control de temperatura | Punta cónica fina o de cincel de 1–1,5 mm. Unos 330 °C con estaño con plomo y 360 °C sin plomo. Los planos de masa y las patas de la carcasa del USB-C necesitan una punta más caliente o más grande. |
| Flux sin limpieza (jeringa), estaño de 0,5 mm con alma de flux, malla desoldadora de 2 mm | El estaño de 0,8 mm es demasiado grueso para los 0603 y los conectores de paso 1 mm. |
| Pinzas finas, no magnéticas | **Imprescindibles.** Sin ellas no se pueden colocar los 0603. |
| Lupa o cámara del móvil en modo macro | Para revisar cada soldadura. |
| Alcohol isopropílico y un cepillo de dientes viejo | Para quitar el flux. |
| Multímetro | Continuidad, resistencia y voltios en continua. |
| Un cable Dupont macho (del kit del banco) | Metido en un zócalo, da a la punta del multímetro algo que tocar. |
| Una aguja de coser | Para tocar los contactos de los cables JST SH a través de la carcasa. |
| Cinta de pintor, Blu-Tack o un soporte de PCB | Para sujetar la placa mientras sueldas. |

### Seguridad

- Suelda en un sitio ventilado: los humos del flux irritan.
- Ponte gafas cuando cortes patas o retires estaño con la malla.
- Lávate las manos después de soldar, sobre todo si usas estaño con plomo.
- Batería LiPo: no cortocircuites sus cables, no la perfores y no la dobles. Conéctala solo cuando un paso lo diga.
- Aplica el barniz al aire libre o con extracción, lejos de llamas.

### Cómo leer las imágenes

![Cara trasera de la placa de control, todas las piezas](images/control-pcb-v0.32-asm-back-map.png)

- **Naranja:** las piezas del paso actual, con su referencia y su valor.
- **Gris:** las piezas ya soldadas.
- **Punto rojo:** el pin 1 de una pieza con polaridad o de un conector.
- **Cara trasera en espejo.** Las imágenes de la cara trasera están dibujadas como la ves al darle la vuelta a la placa. El texto del dibujo no sale en espejo.
- **Serigrafía.** La placa real lleva contornos, marcas de pin 1 y el `+ −` junto a J5, pero **no lleva las referencias** (R1, C2…). Estas imágenes son el único mapa de qué va dónde: imprímelas o tenlas abiertas al lado.

Las placas desnudas son así; el texto impreso permite distinguir las caras.

| Control, trasera | Control, delantera ("ORR CONTROL V0.26") | Joystick, trasera ("ORR JOY REV C") | Joystick, delantera | USB-C, cara superior |
|---|---|---|---|---|
| ![](images/control-pcb-v0.32-bare-back.png) | ![](images/control-pcb-v0.32-bare-front.png) | ![](images/joystick-pcb-rev-c-v0.32-bare-back.png) | ![](images/joystick-pcb-rev-c-v0.32-bare-front.png) | ![](images/usbc-pcb-rev-b-v0.32-bare-top.png) |

### Cómo soldar

- **Piezas de dos pads (0603, 1812, SMB).**
  1. Pon flux en los dos pads.
  2. Pon una gota pequeña de estaño en un pad.
  3. Sujeta la pieza plana con las pinzas, calienta la gota y desliza la pieza dentro.
  4. Suelta cuando el estaño solidifique.
  5. Comprueba que la pieza queda recta y plana.
  6. Suelda el otro pad.
  7. Repasa el primero con un poco de flux.
- **SOT-23 y SOT-23-5.** Estaña un pad de una esquina, fija la pieza en ese pad, comprueba que todas sus patas caen sobre sus pads y suelda el resto.
- **Conectores de paso 1,0 mm.**
  1. Fija primero una de las dos pestañas grandes de sujeción.
  2. Comprueba que los pines coinciden con sus pads.
  3. Suelda la otra pestaña y luego los pines, con mucho flux.
  4. Los puentes entre pines se quitan con la malla.
- **Zócalos de agujero pasante.** Calienta a la vez el pin y el pad durante 2–3 s y aporta el estaño a la unión, no a la punta. Una buena soldadura es un cono brillante.
- **Después de cada placa.**
  1. Frota el flux con alcohol isopropílico.
  2. Deja secar la placa.
  3. Revisa cada soldadura con aumento: puentes, bolitas de estaño, soldaduras mates o agrietadas y patas levantadas.

### Orden

1. **Primero la placa del joystick.** Sus piezas son las más grandes, y su conector sirve de práctica para el paso de 1 mm.
2. **Después la placa de control.** En cada cara van primero las piezas bajas, para que la placa quede plana al soldar las siguientes.
3. **La placa USB-C la última.** Su receptáculo y su LED son las piezas más difíciles.
4. **Pruebas.** Luego los cables y las pruebas.
5. **El barniz al final.** Barniza solo cuando todo funcione: retocar a través del barniz es más difícil.

<a id="placa-joystick"></a>
## 1. Placa del joystick

![Cara delantera de la placa del joystick, todas las piezas](images/joystick-pcb-rev-c-v0.32-asm-front-map.png)

<a id="paso-j1"></a>
### Paso J1: interruptores (cara delantera)

![Paso J1](images/joystick-pcb-rev-c-v0.32-asm-j1-switches.png)

- **Coloca SW1–SW4, los interruptores KSC221JLFS**, en la cara delantera, con el cuerpo alineado con el contorno de la serigrafía. Cada interruptor tiene cuatro patas en J. La placa usa dos pads en diagonal; los otros dos solo lo sujetan. Por eso funciona en cualquiera de sus cuatro giros.
- **Patas en J.** Quedan casi debajo del cuerpo; de cada pad asoma alrededor de 1 mm.
- **Cómo soldarlos:**
  1. Pon flux en los cuatro pads.
  2. Estaña un pad un poco.
  3. Aprieta el interruptor contra la placa y calienta el extremo libre de ese pad hasta que la pata se asiente.
  4. Suelda los otros tres igual. Calienta el pad, no el cuerpo del interruptor: es de plástico sellado.

### Paso J2: conector (cara trasera)

![Paso J2](images/joystick-pcb-rev-c-v0.32-asm-j2-socket.png)

1. Dale la vuelta a la placa: se apoya estable sobre sus cuatro interruptores.
2. Coloca J1, el conector de 5 pines. Solo entra de una forma: sus cinco pines sobre la fila de cinco pads pequeños, y sus dos pestañas sobre los pads grandes.
3. Fija una pestaña, comprueba los pines y suelda la segunda pestaña y los cinco pines.

### Comprobaciones del joystick

Mide en J1 por el lado de los pines, sobre los pads. El pin 1 es el punto rojo; el pin 5 es GND.

- Sin pulsar nada: ningún pin tiene continuidad con el pin 5.
- Pulsando cada interruptor pita con el pin 5: el pin 1 (SW1, UP), el pin 2 (SW2, DOWN), el pin 3 (SW3, LEFT) y el pin 4 (SW4, RIGHT).
- Ningún par de pines pita entre sí.

<a id="placa-control"></a>
## 2. Placa de control

![Cara trasera de la placa de control, todas las piezas](images/control-pcb-v0.32-asm-back-map.png) ![Cara delantera de la placa de control, todas las piezas](images/control-pcb-v0.32-asm-front-map.png)

### Paso C1: U1, U2, Q1 (cara trasera)

![Paso C1](images/control-pcb-v0.32-asm-c1-ics.png)

- **U1 y U2.** U1 es el MCP73831 (lleva una marca, a menudo un código corto) y U2 es el TPS70933. Los dos son SOT-23-5 y se parecen: no los saques de su tira hasta colocarlos.
- **Q1** es el AO3401A, en SOT-23.
- **Polaridad.** Estos encapsulados solo entran de una forma: el lado con tres patas va sobre la fila de tres pads. El pin 1 (punto rojo) coincide con el punto o triángulo de la serigrafía.
- **Comprueba** que las patas quedan centradas en sus pads y que ninguna hace puente con la siguiente.

### Paso C2: resistencias (cara trasera)

![Paso C2](images/control-pcb-v0.32-asm-c2-resistors.png)

- Suelda un valor cada vez, directamente desde su tira:
  - 10k: R1.
  - 100k: R2 y R4.
  - 150k: R3 y R5.
  - 1M: R6 y R7.
- Las resistencias no tienen polaridad.
- Intercambiar R2 con R3, o R4 con R5, invierte un divisor y mete demasiada tensión en un pin de la XIAO. Comprueba el valor antes de colocar cada una.

### Paso C3: condensadores (cara trasera)

![Paso C3](images/control-pcb-v0.32-asm-c3-capacitors.png)

- 4,7 µF: C1–C4.
- 100 nF: C5.
- No tienen polaridad. Los dos valores parecen iguales: haz un valor cada vez.

### Paso C4: F1 y D1 (cara trasera)

![Paso C4](images/control-pcb-v0.32-asm-c4-fuse-tvs.png)

- **F1, el fusible PTC:** sin polaridad. Es grande: da tiempo a que el estaño moje cada pad.
- **D1, el SMBJ5.0A: tiene polaridad.**
  - Su cuerpo lleva una banda en un extremo. La banda (cátodo) va en el extremo marcado en rojo: el izquierdo, mirando la cara trasera como en la imagen.
  - Al revés, D1 cortocircuita la entrada de 5 V y F1 salta en cuanto conectas un cargador.

### Paso C5: interruptores (cara delantera)

![Paso C5](images/control-pcb-v0.32-asm-c5-switches.png)

1. Dale la vuelta a la placa. Las piezas de atrás miden como mucho unos 2,4 mm (D1), así que nivela la placa con Blu-Tack o un soporte.
2. Suelda SW1–SW3 como en el [paso J1](#paso-j1).
3. SW1 es la tecla A, SW2 la B y SW3 la C.

### Paso C6: conectores (cara trasera)

![Paso C6](images/control-pcb-v0.32-asm-c6-sockets.png)

1. Vuelve a girar la placa: ahora se apoya sobre sus tres interruptores.
2. Suelda los conectores. Cada uno entra de una sola forma, con los pines sobre la fila de pads pequeños.
   - J3: 3 pines, placa USB-C.
   - J4: 5 pines, joystick.
   - J5: JST PH de 2 pines, entrada por arriba, batería.
3. J5 es más grande, de paso 2 mm. Su pin 1 es el `+` de la batería, como indica el `+ −` de la serigrafía.

### Paso C7: zócalos de la XIAO (se meten por detrás y se sueldan por delante)

![Paso C7](images/control-pcb-v0.32-asm-c7-headers.png)

Los dos zócalos hembra 1 × 7, J1 y J2, se meten por la cara trasera. Sus pines salen por la delantera, donde se sueldan. Los pads cuadrados marcan el pin 1, en el extremo de J4.

**Elige primero el zócalo.** El diseño usa el de 5,7 mm de alto (C55218877).
- **Pruébalo antes:** mete los pines de la XIAO en un zócalo de 5,7 mm suelto. Deben entrar del todo y sujetar la XIAO con firmeza.
- **Zócalo de 8,5 mm (C54876729):** úsalo solo si el de 5,7 mm no pasa esa prueba.
  - En el CAD (V0.32, `header_h` = 8,5) la XIAO queda 2,4 mm más alta, hacia la batería.
  - No choca con la batería, la carcasa ni la tapa. Entre la parte de atrás de la XIAO y la batería quedan 4,5 mm en vez de 6,9 mm.
  - La espuma sobre la XIAO pasa entonces de 6 capas a 4.
  - Con este zócalo no se ha vuelto a comprobar el recorrido de montaje.

**Para que los zócalos queden rectos, suéldalos con la XIAO puesta.**
1. Mete los pines de la XIAO en los dos zócalos, para que los mantenga paralelos y a la distancia justa.
2. Mete los zócalos en la placa por la cara trasera, con la XIAO bien orientada (mira [la imagen de la XIAO](#xiao)): componentes hacia ti y USB-C en el extremo de J4.
3. Da la vuelta al conjunto y apóyalo sobre la XIAO.
4. Suelda un pin en cada extremo de cada zócalo.
5. Comprueba que los zócalos quedan planos contra la placa. Si alguno no, recalienta un pin y aprieta el zócalo.
6. Suelda el resto de pines.
7. Quita la XIAO. Los pines del zócalo son cortos, así que a sus componentes les llega poco calor.

### Comprobaciones de la placa de control

Usa los [puntos de medida de los zócalos](#puntos-de-medida). Mete el cable Dupont macho en un zócalo y toca con la punta del multímetro. Mide en el rango de resistencia, sin la XIAO y sin la batería.

| Entre | Esperado | Si no |
|---|---|---|
| J2 pin 3 (3V3) y J2 pin 2 (GND) | Lejos de 0 Ω; puede subir mientras se carga C4 | Puente junto a U2 o C4 |
| J3 pin 1 (entrada de 5 V) y J3 pin 2 (GND), sobre los pads de J3, en modo diodo con la punta roja en el pin 1 | Sin lectura (OL) | Unos 0,6–0,8 V: D1 está al revés. Cerca de 0: puente junto a F1, D1, C1 o U1 |
| Pads `+` y `−` de J5 | Lejos de 0 Ω | Puente junto a Q1, C2 o C3 |
| J2 pin 5 (detección de VBUS) a GND | Unos 150 kΩ | R4 y R5 intercambiadas o falta alguna |
| J2 pin 6 (detección de carga) a GND | Unos 150 kΩ | R2 y R3 intercambiadas o falta alguna |
| J1 pines 2, 3 y 4 (botones) a GND | Abierto; 0 Ω mientras pulsas SW1, SW2 o SW3 | Soldadura del interruptor |
| Cada pin de los zócalos con sus vecinos | No pita | Puente en la cara delantera |

Los 150 kΩ son una estimación: el multímetro también ve las demás piezas de cada nudo.

<a id="puntos-de-medida"></a>
![Puntos de medida de los zócalos de la placa de control](images/control-pcb-v0.32-asm-test-points.png)

<a id="placa-usbc"></a>
## 3. Placa USB-C

Todas sus piezas van en la cara superior. La placa tiene 1,2 mm de grosor.

![Placa USB-C, todas las piezas](images/usbc-pcb-rev-b-v0.32-asm-top-map.png)

### Paso U1: resistencias

![Paso U1](images/usbc-pcb-rev-b-v0.32-asm-u1-resistors.png)

- 5,1k: R1 y R2, las resistencias a masa de las líneas CC del USB-C.
- 1k: R3, la resistencia del LED.

### Paso U2: conector

![Paso U2](images/usbc-pcb-rev-b-v0.32-asm-u2-socket.png)

J2 es el conector de 3 pines; se suelda como en el paso C6.

### Paso U3: receptáculo USB-C

![Paso U3](images/usbc-pcb-rev-b-v0.32-asm-u3-receptacle.png)

- **Colocación.** J1 es el GCT USB4736-GF-A, sin su junta. Sus dos tetones de posicionado entran en los dos agujeros pequeños, y su boca sobresale 1,7 mm del borde de la placa.
- **Primero los pads de señal.** Suelda los seis pads de señal de la parte de atrás del receptáculo mientras los tetones lo sujetan.
  - Usa mucho flux y una punta fina.
  - Entre pads solo hay unos 0,3 mm. Busca puentes con aumento y quítalos con la malla.
- **Después las cuatro patas de la carcasa**, en sus ranuras metalizadas, desde cualquier cara. Están sobre el plano de masa y necesitan calor: usa la punta más caliente o más grande y dale unos segundos a cada una.
- **No pongas la junta todavía.** La junta USBTJ-06, el relleno de epoxi y la ventana del LED van en el [montaje mecánico](mechanical-concept.es.md#assembly), paso 2.

### Paso U4: LED de carga

![Paso U4](images/usbc-pcb-rev-b-v0.32-asm-u4-led.png)

D1 es el LTST-S270KRKT, un LED de vista lateral de 1,65 × 1,15 mm. Su lente alumbra de lado, hacia fuera del borde de la placa y hacia la pared trasera, como indica la flecha.

**Comprueba la polaridad antes de soldarlo.**
1. Pon el multímetro en modo diodo.
2. Toca los dos extremos del LED. Con la punta roja en el ánodo, se enciende débilmente y marca unos 1,6–2 V.
3. El otro extremo, el cátodo, va en el pad 1 (punto rojo, junto a la raya de la serigrafía).

No he comprobado la marca de cátodo de la propia pieza con el plano de Lite-On. La prueba con el multímetro es la que vale.

Suéldalo como un 0603, con poco estaño: los pads son pequeños, y el estaño que sube a la lente le quita luz.

### Comprobaciones de la placa USB-C

| Entre | Esperado |
|---|---|
| J2 pin 1 (VBUS) y J2 pin 2 (GND) | Abierto |
| Sobre R1, y luego sobre R2 | Unos 5,1 kΩ |
| Un pad CC (de R1 o R2, del lado del receptáculo) y J2 pin 1 | Abierto (un puente aquí pondría 5 V en CC) |
| J2 pin 1 a J2 pin 3, en modo diodo, punta roja en el pin 1 | El LED se enciende débilmente, o el multímetro marca su tensión directa más la caída en R3. Puede marcar "OL" si la tensión de prueba del multímetro no da para el LED y 1 kΩ juntos. |

<a id="cables"></a>
## 4. Cables

Los dos cables tienen que ser rectos: el pin 1 de un extremo va al pin 1 del otro.

1. **Busca el pin 1.** Pon las dos clavijas una al lado de la otra, con las pestañas hacia arriba, y mira por las ventanas de la carcasa.
2. **Mide cada hilo** con la aguja, en el rango de continuidad: pin 1 con pin 1, y así con todos.
3. **Sin vecinos.** Ningún contacto pita con el de al lado.

Un cable vendido como `reverse direction` une el pin 1 con el último. No lo uses.

Los cables se vuelven a comprobar ya conectados, en las dos secciones siguientes.

<a id="pruebas-alimentacion"></a>
## 5. Pruebas de alimentación, sin la XIAO

La primera prueba se hace sin la XIAO y sin la batería.

1. **Une las placas.** Conecta el cable de 3 pines entre el J2 de la placa USB-C y el J3 de la placa de control, con las pestañas bien encajadas. Comprueba con el multímetro que el cable es recto:
   - El pin 1 de J2 en la placa USB-C pita con el pin 1 de J3 en la de control, y el 3 con el 3. Mide en los pines de los conectores, sobre sus pads; el pin 1 es el punto rojo de las imágenes.
   - El pin 1 de J2 no pita con el pin 3 de J3.
2. **Da alimentación USB.** Conecta un cargador USB-C de 5 V al receptáculo. Lo más seguro es un cable USB-C a USB-C desde un cargador USB-C. Un cable USB-A a USB-C también sirve, porque la placa lleva sus propias resistencias CC.
3. **Mide tensiones respecto a J2 pin 2 (GND), en voltios de continua:**

| Punto | Esperado | Notas |
|---|---|---|
| Pad `+` de J5 | Unos 4,2 V | La salida del cargador sin batería. Puede oscilar; sin batería es normal. |
| J2 pin 3 (3V3) | 3,3 V | |
| J2 pin 5 (detección de VBUS) | Unos 3,0 V | |
| LED de carga | Apagado o parpadeando | Sin batería, la salida STAT queda en alta impedancia |

Si F1 se calienta o la lectura es 0 V, desconecta enseguida y busca un cortocircuito en D1, C1 o U1.

4. **Comprueba la clavija de la batería.** Desconecta el cargador. Con el multímetro en la clavija de la batería, localiza el hilo `+`. El `+` de la clavija tiene que coincidir con el `+` de J5.
   - Q1 protege la placa de una batería al revés. Pero con el USB conectado, una batería al revés se va descargando poco a poco (mira el [README de la placa de control](../electronics/control-pcb/README.md#checks)).
5. **Conecta la batería** en J5 y vuelve a medir:
   - J2 pin 3: 3,3 V. Si la batería está por debajo de unos 3,6 V, saldrá algo menos: el regulador ya no tiene margen.
   - J1 pin 1 (VBAT/2): más o menos la mitad de la tensión de la batería. Un multímetro de 10 MΩ marca alrededor de un 5 % menos en este divisor de 1 MΩ.
6. **Vuelve a conectar el cargador.** El LED de carga se enciende mientras la batería carga y se apaga cuando está llena.

Opcional: mide la corriente de la batería con un alargador JST PH, con el multímetro en serie en el rango de mA y el cargador desconectado. Sin la XIAO debe marcar 0,00 mA (son unos pocos µA, por debajo de lo que mide el multímetro). Más de 1 mA indica una avería.

<a id="xiao"></a>
## 6. XIAO, firmware y prueba de funcionamiento

![Orientación de la XIAO](images/control-pcb-v0.32-asm-xiao.png)

1. **Carga el firmware** con la XIAO fuera de la placa.
   - Pon `BOARD_V026 = true` en [`open-rally-remote.ino`](../firmware/xiao-nrf52840/open-rally-remote.ino).
   - Compila y carga como indica el [README del firmware](../firmware/xiao-nrf52840/README.md).
   - El firmware del banco (`false`) usa otro mapa de pines y activa D8 como salida, que en esta placa es la entrada de estado del cargador.
2. **Pincha la XIAO.** Desconecta antes la batería. Pincha la XIAO en los zócalos:
   - con los componentes hacia fuera de la placa;
   - con el USB-C en el extremo de J4;
   - con D0 en el pin 1 de J1 y 5V en el pin 1 de J2.
   Girada, sus pines de 3V3 y GND caen en señales que no son.
3. **Conecta la batería.**
4. **Conecta un ordenador.** Conecta el USB-C de la propia XIAO a un ordenador y abre el Monitor Serie a 115200 baudios. Su regulador y el de la placa alimentan los dos la línea de 3V3; el TPS70933 de la placa bloquea la corriente de vuelta.
5. **Botones.** Pulsa SW1, SW2 y SW3: el Monitor Serie muestra cada control y su gesto.
6. **Joystick.**
   - Une la placa del joystick a J4 con el cable de 5 pines.
   - Pulsa cada interruptor del joystick: aparecen UP, DOWN, LEFT y RIGHT.
   - Aquí se nota un cable al revés: solo funciona UP, porque la masa de la placa del joystick acaba en la línea de UP.
7. **Batería y cargador.** La línea `Battery:` muestra más o menos la tensión de la batería, `USB` y `CHG`. Conecta el cargador a la placa USB-C: `USB` y `CHG` cambian y el LED se enciende.
8. **Teléfono.** Empareja el teléfono y haz la [primera prueba](../firmware/xiao-nrf52840/README.md#first-test).

Sin ordenador, los pasos 5 a 7 también se pueden comprobar desde el teléfono con un comprobador de teclado.

<a id="barniz"></a>
## 7. Barniz de protección

Barniza las tres placas y la XIAO cuando todas las pruebas estén bien.

1. **Desconéctalo todo.** Quita la batería, los cables y la XIAO.
2. **Limpia.** Vuelve a limpiar con alcohol isopropílico y deja secar.
3. **Tapa con cinta:**
   - Todos los conectores JST: J3, J4, J5 y los dos J2, más J1 en la placa del joystick.
   - Las bocas de los zócalos de la XIAO.
   - El receptáculo USB-C: la boca y el morro.
   - La parte de arriba (el pulsador) de los siete interruptores.
   - En la XIAO: sus pines, su USB-C, su botón de reset y su LED RGB.
4. **Pulveriza.** Da capas finas de barniz acrílico por las dos caras de cada placa, a la distancia que indique el bote. Dos capas finas chorrean menos que una gruesa.
5. **Deja curar.** Deja secar cada capa el tiempo que diga el bote. Quita la cinta antes de que la última capa endurezca del todo.
6. **Revisa.** Busca zonas sin barniz mirando de lado bajo una lámpara. Si el bote dice que el barniz lleva trazador UV, una linterna UV las muestra mejor.

El barniz no va en la batería ni en la membrana de ventilación, que no están en las placas. El montaje mecánico empieza luego con la placa USB-C en la carcasa ([paso 2](mechanical-concept.es.md#assembly)).

<a id="puntos-abiertos"></a>
## Puntos abiertos

Cada uno se comprueba en el primer montaje. Apunta aquí el resultado.

- **KSC2 a mano.** Si las patas en J del KSC221JLFS se sueldan bien con soldador. De cada pad asoma alrededor de 1 mm. Si no, hace falta una estación de aire caliente o una placa calefactora.
- **USB4736 a mano.** La separación de 0,3 mm entre sus pads de señal, y el calor que necesitan las patas de la carcasa.
- **Marca de polaridad del LED.** La marca de cátodo del LTST-S270KRKT frente a la huella: usa la prueba con el multímetro de arriba.
- **Elección del zócalo.** Si los pines de 6,1 mm de la XIAO entran y sujetan en el zócalo de 5,7 mm. El de 8,5 mm cabe en el CAD (comprobado el 20-10-2026), pero no se ha vuelto a comprobar el recorrido de montaje con él.
- **Cables.** Que los cables `same direction` de AliExpress sean rectos y encajen en los conectores "1.0 WT".
- **Lecturas.** Las tensiones y resistencias esperadas de arriba salen del circuito y de las hojas de datos, no de una placa real.
- **Sin batería.** Cómo se comporta el cargador con el USB conectado y sin batería (el LED y D8 parpadean); mira el [README de la placa de control](../electronics/control-pcb/README.md#checks).

## Regenerar las imágenes

Las imágenes de los pasos, los mapas y las vistas de las placas desnudas salen de las placas de KiCad:

```sh
/Applications/KiCad/KiCad.app/Contents/Frameworks/Python.framework/Versions/Current/bin/python3 \
    electronics/tools/assembly_images.py
```

El script necesita el `kicad-cli` de KiCad, además de `rsvg-convert` y `magick` (`librsvg` e `imagemagick` de Homebrew). Los pasos y sus piezas están en la lista `STEPS`, al principio del script. Escribe `docs/images/<board>-v0.32-asm-*.png` y `*-bare-*.png`.
