#!/usr/bin/env python3
"""V0.34 assembly guide video: every step of docs/mechanical-concept.md "Assembly" (remote,
base, fitting), action by action, with the hardware and the tools, in English and Spanish.

A draft for review: it is not regenerated with every design change. It drives
mechanical/cad/guide-video-v0.34.scad, which only draws; the animation is here: each action
has a duration, a caption, a camera and operations on the items it moves.

Run from the repository root:
  python3 mechanical/cad/tools/guide_video.py [--preview] [--only N ...] [en|es ...]
--preview renders the first and last frame of each action into a contact sheet instead.
Output: mechanical/cad/build/guide/guide-v0.34.<lang>.mp4. Needs ImageMagick and ffmpeg.
"""
import argparse
import json
import math
import os
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import assembly_video as av  # noqa: E402

SCAD = av.CAD / "guide-video-v0.34.scad"
WORK = av.BUILD / "guide"
FPS = 20
SIZE = (1280, 720)
FONT = av.FONT

# Model values used for staging and cameras (complete-remote-v0.34.scad).
ZC = 12.5                       # axial_width / 2
FOLD = math.radians(20)
FN = [math.cos(FOLD), math.sin(FOLD), 0.0]   # joystick axis, inward
H = [45, 0, 0]                  # housing staged above the stack (remote frame: +X up)
JA = [22 * c for c in FN]
JS = [JA[0], JA[1], JA[2] + 45]
CA = [22, 0, 0]
CS = [CA[0], CA[1], CA[2] - 45]
PO = [0, -60, 0]
BENCH = [0, 45, 0]              # the USB-C board on the bench, beside the housing (model frame)
HB = [14, 0, 0]                 # housing held beside the stack while the battery is plugged in
O = [0, 0, 0]
SLIDE = 9.0                     # dovetail slide from the entry position


def add(*vs):
    return [sum(c) for c in zip(*vs)]


def mul(k, v):
    return [k * c for c in v]


def vp(p, frame):
    return [-p[2], p[1], p[0]] if frame == "remote" else list(p)


def cam(c, az, el, d, frame="remote"):
    """Camera eye and centre, looking at model point c from azimuth az, elevation el (view frame)."""
    v = vp(c, frame)
    a, e = math.radians(az), math.radians(el)
    eye = [v[0] + d * math.cos(e) * math.cos(a), v[1] + d * math.cos(e) * math.sin(a), v[2] + d * math.sin(e)]
    return eye + v


# --- Actions ------------------------------------------------------------------------------
# Each action: dict(step=(en, es), cap=(en, es), dur=s, cam=[eye+centre], frame, cut, cut_items,
# ops=[...]). Ops, all over the action's time u in 0..1 (eased):
#   ("show", name, off, q)          visible from the start of the action
#   ("hide", name)                  hidden from the start
#   ("move", name, off0, off1)      offset from off0 to off1
#   ("q", name, i, v0, v1)          parameter i from v0 to v1
# An op may carry a window (u0, u1) as its last element.
REMOTE_PARTS = ["housing", "cover", "keypad", "joy_plate", "button_plate", "stick", "knob",
                "battery_cap", "cap_gasket", "foam_strip", "cover_screws", "cap_screws"]
HG = ["housing", "usbc_board", "usbc_nuts", "usbc_screws", "rear_foam", "epoxy_led", "plug_j2"]
JG = ["stick", "joy_plate", "joy_board", "joy_screws"]
CG = ["button_plate", "control_board", "xiao", "ctrl_screws"]

S = {
    "r1": ("Remote, step 1: screw pilots", "Mando, paso 1: pilotos de los tornillos"),
    "r2": ("Remote, step 2: USB-C board", "Mando, paso 2: placa USB-C"),
    "r3": ("Remote, step 3: joystick", "Mando, paso 3: joystick"),
    "r4": ("Remote, step 4: control board and XIAO", "Mando, paso 4: placa de control y XIAO"),
    "r5": ("Remote, step 5: cover, keypad and plates", "Mando, paso 5: tapa, teclado y placas"),
    "r6": ("Remote, step 6: XIAO pad", "Mando, paso 6: almohadilla de la XIAO"),
    "r7": ("Remote, step 7: battery foam", "Mando, paso 7: espuma de la batería"),
    "r8": ("Remote, step 8: battery", "Mando, paso 8: batería"),
    "r9": ("Remote, step 9: housing onto the stack", "Mando, paso 9: carcasa sobre el conjunto"),
    "r10": ("Remote, step 10: vent and battery cap", "Mando, paso 10: ventilación y tapa de la batería"),
    "r11": ("Remote, step 11: joystick knob", "Mando, paso 11: pomo del joystick"),
    "b1": ("Base, step 1: bolt pilots", "Base, paso 1: pilotos de los tornillos"),
    "b2": ("Base, step 2: lock", "Base, paso 2: cierre"),
    "b3": ("Base, step 3: anti-rattle strips", "Base, paso 3: tiras antivibración"),
    "b4": ("Base, step 4: on the bar", "Base, paso 4: en el manillar"),
    "fit": ("Fitting and removal", "Colocar y quitar el mando"),
}

CAM_HOUSE = cam(add(H, [-36, 2, ZC]), 200, -35, 230)
CAM_DRILL = cam(add(H, [-45, 10, ZC]), 200, -50, 170)
CAM_USBC = cam(add(H, [-27, 31, 19.5]), 268, 72, 48, "model")
CAM_USBC_BENCH = cam(add(H, BENCH, [-49, 31, 19.5]), 268, 72, 60, "model")
CAM_USBC_LOW = cam(add(H, [-29, -3, 19.5]), 268, 72, 210, "model")
CAM_USBC_OUT = cam(add(H, [-17, 30, ZC]), 200, 55, 90)
CAM_JOY = cam(add(JS, mul(8, FN), [-52.5, -26, ZC]), 215, 35, 120)
CAM_CTRL = cam(add(CS, [-48, 16, ZC]), 325, 40, 120)
CAM_STACK = cam([-30, 5, ZC], 300, 22, 270)
CAM_FOAM = cam(add(H, [-40, 2, ZC]), 200, -60, 210)
CAM_COVER = cam([-45, 2, ZC], 160, -70, 230)
CAM_BOTTOM = cam([-26, -50, ZC], 145, 20, 190)
CAM_POUCH = cam(add(HB, [-26, -40, ZC]), 145, 10, 230)
CAM_CTRL_STACK = cam([-40, 0, ZC], 330, 40, 150)
CAM_GAP = cam([-38, 2, ZC], 190, 12, 170)   # from the cut side, into the gap under the held housing
CAM_KNOB = cam([-52.5, -26, ZC], 250, -40, 140)
CAM_BASE = cam([-10, -5, ZC], 35, 30, 260, "model")
CAM_LOCK = cam([-5, -32, ZC], 30, 25, 140, "model")
CAM_LOCK_F = cam([-14, -32, ZC], 205, 22, 130, "model")   # platform side
CAM_BASE_F = cam([-17, -5, ZC], 205, 25, 200, "model")
CAM_FIT = cam([-25, -5, ZC], 300, 25, 300, "model")


def A(step, cap_en, cap_es, dur, camv, ops, frame="remote", cut="none", cut_items=(), cut_z=ZC):
    if cut == "usbc":   # through the +Z USB-C screw (the board is upside down, so screw 0)
        cut, cut_items, cut_z = "z", ["housing", "usbc_board", "usbc_nuts", "usbc_screws", "epoxy_back"], 19.5
        frame = "model"
    return dict(step=S[step], cap=(cap_en, cap_es), dur=dur, cam=camv, ops=ops, frame=frame,
                cut=cut, cut_items=list(cut_items), cut_z=cut_z)


def remote_on_base(d, extra=()):
    """Show the assembled remote at offset d (model frame)."""
    return [("show", n, d, q) for n, q in (("housing", []), ("cover", []), ("keypad", []),
            ("joy_plate", []), ("button_plate", []), ("stick", []), ("knob", []),
            ("battery_cap", []), ("cap_gasket", []))] + list(extra)


def lock_at(dx, rot, ops_from=None):
    return [("show", "lock_spring", O, [0]), ("show", "lock_screw", O, [dx]),
            ("show", "lock_knob", O, [dx, rot]), ("show", "lock_pins", O, [dx, rot, 1]),
            ("show", "lock_nut", O, [dx, rot, 1])]


def base_all(extra=()):
    return [("show", n, O, q) for n, q in (("bar", []), ("sleeve_a", []), ("sleeve_b", []),
            ("liner_main", []), ("liner_cap", []), ("base_front", []), ("base_cap", []),
            ("strips", []), ("m4_bolts", [2]))] + list(extra)


ACTIONS = [
    # ---- Remote ----
    A("r1", "The housing, cover side up. Ten bosses take the cover screws.",
      "La carcasa, con el lado de la tapa hacia arriba. Diez resaltes reciben los tornillos de la tapa.",
      4, CAM_HOUSE, [("show", "housing", H, [])], cut="wall", cut_items=["housing"]),
    A("r1", "Clear each Ø1.6 mm pilot with a 1.6 mm drill bit turned by hand: printed holes come out undersize.",
      "Repasa cada piloto de Ø1,6 mm con una broca de 1,6 mm girada a mano: los agujeros impresos salen pequeños.",
      9, CAM_DRILL, [("show", "drill", H, [0]), ("q", "drill", 0, 0, 9.99), ("hide", "drill", (0.999, 1))],
      cut="wall", cut_items=["housing"]),
    A("r2", "Slide a DIN 562 M2 square nut into each channel at the front of the USB-C rib.",
      "Mete una tuerca cuadrada M2 DIN 562 en cada canal, por delante del nervio USB-C.",
      5, CAM_USBC, [("show", "usbc_nuts", add(H, [-14, 0, 0]), [-1]), ("move", "usbc_nuts", add(H, [-14, 0, 0]), H)],
      cut="usbc"),
    A("r2", "Only if the leak test showed water through the receptacle: before fitting the board, pot the receptacle's back end with the clear epoxy on the bench, and let it cure.",
      "Solo si la prueba de estanqueidad mostró agua por el conector: antes de montar la placa, rellena con epoxi transparente la parte de atrás del conector, sobre la mesa, y deja que cure.",
      6, CAM_USBC_BENCH, [("show", "usbc_board", add(H, BENCH), [22]), ("show", "epoxy_back", add(H, BENCH, [-22, 0, 0]), [0]),
                          ("q", "epoxy_back", 0, 0, 1, (0.1, 0.8)), ("hide", "epoxy_back", (0.95, 1))], cut="usbc"),
    A("r2", "Plug the 3-pin cable into J2, under the board, until it clicks.",
      "Conecta el cable de 3 pines a J2, bajo la placa, hasta que haga clic.",
      4, CAM_USBC_BENCH, [("show", "plug_j2", add(H, BENCH, [-22, 0, 0]), [10]), ("q", "plug_j2", 0, 10, 0)], cut="usbc"),
    A("r2", "Fit the USBTJ-06 gasket over the receptacle's nose. Hold the board upside down, receptacle below, under the rib.",
      "Pon la junta USBTJ-06 en la boca del conector. Sujeta la placa boca abajo, con el conector debajo, bajo el nervio.",
      5, CAM_USBC, [("move", "usbc_board", add(H, BENCH), H), ("move", "plug_j2", add(H, BENCH, [-22, 0, 0]), add(H, [-22, 0, 0]))], cut="usbc"),
    A("r2", "Slide it along the rib's underside toward the wall until the nose enters the slot.",
      "Deslízala por la cara inferior del nervio hacia la pared hasta que la boca entre en la ranura.",
      5, CAM_USBC, [("q", "usbc_board", 0, 22, 1), ("move", "plug_j2", add(H, [-22, 0, 0]), add(H, [-1, 0, 0]))], cut="usbc"),
    A("r2", "Start the two M2 x 4 button-head screws by hand from below, through the board into the nuts. Leave them loose.",
      "Pon a mano, desde abajo, los dos tornillos M2 x 4 de cabeza redonda, a través de la placa hasta las tuercas. Déjalos flojos.",
      5, CAM_USBC, [("show", "usbc_screws", H, [1, 8, 0]), ("q", "usbc_screws", 1, 8, 0.3), ("q", "usbc_screws", 2, 0, 720)],
      cut="usbc"),
    A("r2", "Push the board toward the wall until the gasket resists, and hold it there.",
      "Empuja la placa hacia la pared hasta que la junta resista, y mantenla ahí.",
      4, CAM_USBC, [("q", "usbc_board", 0, 1, 0), ("q", "usbc_screws", 0, 1, 0), ("q", "usbc_nuts", 0, -1, 0),
                    ("move", "plug_j2", add(H, [-1, 0, 0]), H),
                    ("show", "arrow", H, [-44, 34, 9, 0, 90, 0]), ("hide", "arrow", (0.95, 1))],
      cut="usbc"),
    A("r2", "Tighten both screws with a 1.3 mm hex driver, about 75 mm long, passed up through the battery cap opening. Keep the cable out of its way.",
      "Aprieta los dos tornillos con un destornillador hexagonal de 1,3 mm, de unos 75 mm, metido por la abertura de la tapa de la batería. Aparta el cable.",
      8, CAM_USBC_LOW, [("show", "usbc_driver", H, [0, 40]), ("q", "usbc_driver", 1, 40, 0, (0, 0.2)),
                        ("q", "usbc_screws", 1, 0.3, 0, (0.2, 0.45)), ("q", "usbc_driver", 0, 0, 1, (0.5, 0.51)),
                        ("q", "usbc_screws", 2, 720, 1440, (0.2, 0.9)), ("q", "usbc_driver", 1, 0, 40, (0.9, 1)),
                        ("hide", "usbc_driver", (0.999, 1))],
      cut="usbc"),
    A("r2", "From outside, fill the charge LED window with the same clear epoxy.",
      "Desde fuera, rellena la ventana del LED de carga con el mismo epoxi transparente.",
      5, CAM_USBC_OUT, [("show", "epoxy_led", H, [0]), ("q", "epoxy_led", 0, 0, 1)]),
    A("r3", "Push the stick through the joystick plate from the back, so the ball sits in its seat.",
      "Pasa la palanca por la placa del joystick desde atrás, para que la bola asiente en su sitio.",
      5, CAM_JOY, [("show", "joy_plate", JS, []), ("show", "stick", add(JS, mul(15, FN)), []),
                   ("move", "stick", add(JS, mul(15, FN)), JS)]),
    A("r3", "Lay the joystick board rev C on the plate's standoffs; the disc rests on its four switches.",
      "Pon la placa del joystick rev C sobre los separadores de la placa; el disco apoya en sus cuatro pulsadores.",
      4, CAM_JOY, [("show", "joy_board", add(JS, mul(14, FN)), []), ("move", "joy_board", add(JS, mul(14, FN)), JS)]),
    A("r3", "Fix it with two M2 x 8 button-head screws.",
      "Fíjala con dos tornillos M2 x 8 de cabeza redonda.",
      6, CAM_JOY, [("show", "joy_screws", JS, [0, 1]), ("q", "joy_screws", 0, 0, 1.999), ("q", "joy_screws", 1, 1, 0, (0.98, 1))]),
    A("r3", "Plug the 5-pin cable into J1 on the back of the joystick board, until it clicks.",
      "Conecta el cable de 5 pines a J1, en la parte de atrás de la placa del joystick, hasta que haga clic.",
      4, CAM_JOY, [("show", "plug_j1", JS, [10]), ("q", "plug_j1", 0, 10, 0)]),
    A("r4", "Lay the control board on the button plate's standoffs, switches toward the plate.",
      "Pon la placa de control sobre los separadores de la placa de botones, con los pulsadores hacia la placa.",
      4, CAM_CTRL, [("show", "button_plate", CS, []), ("show", "control_board", add(CS, [12, 0, 0]), []),
                    ("move", "control_board", add(CS, [12, 0, 0]), CS)]),
    A("r4", "Fix it with two M2 x 4 button-head screws.",
      "Fíjala con dos tornillos M2 x 4 de cabeza redonda.",
      5, CAM_CTRL, [("show", "ctrl_screws", CS, [0, 1]), ("q", "ctrl_screws", 0, 0, 1.999), ("q", "ctrl_screws", 1, 1, 0, (0.98, 1))]),
    A("r4", "Plug the XIAO into its headers, components away from the board, USB-C toward the joystick end.",
      "Enchufa la XIAO en sus zócalos, con los componentes hacia fuera y el USB-C hacia el lado del joystick.",
      4, CAM_CTRL, [("show", "xiao", add(CS, [30, 0, 0]), []), ("move", "xiao", add(CS, [30, 0, 0]), CS)]),
    A("r5", "Lay the cover face down, and the keypad on it: keys through the cover holes, folded at the fold line.",
      "Pon la tapa boca abajo, y el teclado encima: las teclas por los agujeros de la tapa, doblado por la línea de pliegue.",
      5, CAM_STACK, [("show", "cover", O, []), ("show", "keypad", [15, 0, 0], []), ("move", "keypad", [15, 0, 0], O)]),
    A("r5", "Stick the foam strip, two layers of the sheet, on the sheet's back along its outer edge, round both facets, butt-jointed at the end corners. The edge is flush with the housing, so the strip lands on its rim.",
      "Pega la tira de espuma, dos capas de la lámina, en el dorso de la lámina a lo largo de su borde exterior, en las dos caras, con uniones a tope en las esquinas. El borde coincide con la carcasa, así que la tira cae sobre su borde.",
      7, CAM_STACK, [("show", "foam_strip", [10, 0, 0], []), ("move", "foam_strip", [10, 0, 0], O)]),
    A("r5", "Push the stick through the sheet hole and the cover hole, and lay the joystick plate on the sheet.",
      "Pasa la palanca por el agujero de la lámina y el de la tapa, y apoya la placa del joystick en la lámina.",
      5, CAM_STACK, [("move", n, JS, O) for n in JG + ["plug_j1"]]),
    A("r5", "With the control board in your hand, plug the free end of the joystick cable into J4.",
      "Con la placa de control en la mano, conecta el extremo libre del cable del joystick a J4.",
      5, CAM_CTRL, [("show", "plug_j4", CS, [10]), ("q", "plug_j4", 0, 10, 0)]),
    A("r5", "Lay the button plate, with the control board, on the upper-facet sheet.",
      "Apoya la placa de botones, con la placa de control, en la lámina de la cara superior.",
      5, CAM_STACK, [("move", n, CS, O, (0, 0.85)) for n in CG + ["plug_j4"]]
      + [("show", "cable_joy", O, [], (0.9, 1)), ("hide", "plug_j1", (0.9, 1)), ("hide", "plug_j4", (0.9, 1))]),
    A("r6", "Stick a pad of six layers of the seal foam on the XIAO's components.",
      "Pega una almohadilla de seis capas de la espuma del sellado sobre los componentes de la XIAO.",
      4, CAM_STACK, [("show", "xiao_foam", [12, 0, 0], []), ("move", "xiao_foam", [12, 0, 0], O)]),
    A("r7", "Stick one layer of the same foam on the rear wall, where the pouch lies.",
      "Pega una capa de la misma espuma en la pared trasera, donde apoya la batería.",
      4, CAM_FOAM, [("show", "rear_foam", add(H, [-10, 0, 0]), []), ("move", "rear_foam", add(H, [-10, 0, 0]), H)],
      cut="wall", cut_items=["housing"]),
    A("r8", "Hold the housing beside the stack, open side toward it, and plug the free end of the USB-C board's 3-pin cable (blue) into J3 on the control board.",
      "Sujeta la carcasa junto al conjunto, con el lado abierto hacia él, y conecta el extremo libre del cable de 3 pines de la placa USB-C (azul) a J3, en la placa de control.",
      6, CAM_GAP, [("move", n, H, HB, (0, 0.4)) for n in HG] + [("show", "plug_j3", O, [10], (0.4, 1)), ("q", "plug_j3", 0, 10, 0, (0.4, 1))], cut="wall", cut_items=HG + ["pouch"]),
    A("r8", "Slide the pouch up through the housing's bottom opening, protection board and lead first.",
      "Mete la batería desde abajo por la abertura inferior de la carcasa, con la placa de protección y el cable por delante.",
      5, CAM_POUCH, [("show", "pouch", add(HB, PO), []), ("move", "pouch", add(HB, PO), HB)]),
    A("r8", "Check the polarity, then plug the pouch's lead (red) into J5 on the control board. Its 43.5 mm lead should reach with the housing about 14 mm off its seat (estimate).",
      "Comprueba la polaridad y conecta el cable de la batería (rojo) a J5, en la placa de control. Su cable de 43,5 mm debería llegar con la carcasa a unos 14 mm de su sitio (estimado).",
      6, CAM_GAP, [("show", "plug_j5", O, [10]), ("q", "plug_j5", 0, 10, 0)], cut="wall", cut_items=HG + ["pouch"]),
    A("r9", "Lower the housing onto the stack, guiding the cables; its walls locate the plates.",
      "Baja la carcasa sobre el conjunto, guiando los cables; sus paredes centran las placas.",
      6, CAM_STACK, [("move", n, HB, O, (0, 0.85)) for n in HG + ["pouch"]]
      + [("show", "cable_usb", O, [], (0.9, 1)), ("show", "cable_bat", O, [], (0.9, 1)),
         ("hide", "plug_j2", (0.9, 1)), ("hide", "plug_j3", (0.9, 1)), ("hide", "plug_j5", (0.9, 1))]),
    A("r9", "Turn it over. Fit the ten M2 x 10 countersunk screws in a cross pattern; they cut their own thread, so drive them slowly.",
      "Dale la vuelta. Pon los diez tornillos avellanados M2 x 10 en cruz; se hacen su propia rosca, así que atorníllalos despacio.",
      12, CAM_COVER, [("show", "cover_screws", O, [0, 1]), ("q", "cover_screws", 0, 0, 9.999), ("q", "cover_screws", 1, 1, 0, (0.99, 1))]),
    A("r10", "Stick the vent label inside the battery cap, over its vent hole, and two pads of four foam layers, about 8 x 6 mm, one on each side of it.",
      "Pega la etiqueta de ventilación dentro de la tapa de la batería, sobre su agujero, y dos almohadillas de cuatro capas de espuma, de unos 8 x 6 mm, una a cada lado.",
      5, CAM_BOTTOM, [("show", "battery_cap", [0, -25, 0], []), ("show", "vent_label", [0, -18, 0], []),
                      ("move", "vent_label", [0, -18, 0], [0, -25, 0], (0, 0.5)),
                      ("show", "cap_pad", [0, -18, 0], [], (0.5, 1)), ("move", "cap_pad", [0, -18, 0], [0, -25, 0], (0.5, 1))]),
    A("r10", "Stick the foam cap gasket, two layers, inside the cap's lip.",
      "Pega la junta de espuma de la tapa, de dos capas, por dentro del labio.",
      4, CAM_BOTTOM, [("show", "cap_gasket", [0, -15, 0], []), ("move", "cap_gasket", [0, -15, 0], O)]),
    A("r10", "Fit the cap with three M2 x 8 countersunk screws; the lip meets the housing when they are tight.",
      "Pon la tapa con tres tornillos avellanados M2 x 8; el labio toca la carcasa cuando están apretados.",
      8, CAM_BOTTOM, [("move", n, [0, -25, 0], O, (0, 0.3)) for n in ("battery_cap", "vent_label", "cap_pad")]
      + [("show", "cap_screws", O, [0, 1], (0.3, 1)), ("q", "cap_screws", 0, 0, 2.999, (0.3, 1)), ("q", "cap_screws", 1, 1, 0, (0.99, 1))]),
    A("r11", "Drop the M2 square nut into the slot under the knob, and start the M2 x 4 grub screw in it from the rim.",
      "Mete la tuerca cuadrada M2 en la ranura de debajo del pomo, y empieza el prisionero M2 x 4 en ella desde el borde.",
      5, CAM_KNOB, [("show", "knob", mul(-20, FN), []), ("show", "knob_nut", mul(-20, FN), [0]), ("q", "knob_nut", 0, 0, 1, (0, 0.5)),
                    ("show", "grub", mul(-20, FN), [0], (0.5, 1)), ("q", "grub", 0, 0, 0.4, (0.5, 1))]),
    A("r11", "Slide the knob onto the pin with a 0.9 mm shim (a bank card and a sheet of paper) between the hub and the cover.",
      "Mete el pomo en el pasador con una galga de 0,9 mm (una tarjeta bancaria y una hoja de papel) entre el cubo y la tapa.",
      5, CAM_KNOB, [("show", "shim", O, []), ("move", "knob", mul(-20, FN), O), ("move", "knob_nut", mul(-20, FN), O),
                    ("move", "grub", mul(-20, FN), O)]),
    A("r11", "Tighten the grub screw with a 0.9 mm hex key, then pull the shim out.",
      "Aprieta el prisionero con una llave hexagonal de 0,9 mm y saca la galga.",
      5, CAM_KNOB, [("show", "grub_key", O, [0], (0, 0.8)), ("q", "grub_key", 0, 0, 1, (0, 0.8)), ("q", "grub", 0, 0.4, 1, (0, 0.8)),
                    ("hide", "grub_key", (0.8, 1)), ("move", "shim", O, [0, 0, 30], (0.8, 1))]),
    # ---- Base ----
    A("b1", "Clear the two Ø3.4 mm pilots in the base front's split face with a 3.4 mm drill bit turned by hand.",
      "Repasa los dos pilotos de Ø3,4 mm de la cara de unión de la parte delantera de la base con una broca de 3,4 mm a mano.",
      5, CAM_BASE, [("show", "base_front", O, []), ("show", "bar_drill", O, [0]), ("q", "bar_drill", 0, 0, 1.999),
                    ("hide", "bar_drill", (0.99, 1))], frame="model"),
    A("b2", "Press the two Ø1.5 x 4 mm dowel pins into the lock knob, and an M3 nut into the hex pocket on its outer face.",
      "Mete a presión los dos pasadores de Ø1,5 x 4 mm en el pomo del cierre, y una tuerca M3 en el alojamiento hexagonal de su cara exterior.",
      6, CAM_LOCK, [("show", "lock_knob", O, [25, 90]), ("show", "lock_pins", O, [25, 90, 0]), ("show", "lock_nut", O, [25, 90, 0]),
                    ("q", "lock_pins", 2, 0, 1, (0, 0.5)), ("q", "lock_nut", 2, 0, 1, (0.5, 1))], frame="model"),
    A("b2", "Drop the spring into the pocket in the platform, and push the M3 x 20 screw through it from the platform side.",
      "Mete el muelle en el alojamiento de la plataforma, y pasa el tornillo M3 x 20 a través de él desde el lado de la plataforma.",
      6, CAM_LOCK_F, [("show", "lock_spring", [-20, 0, 0], [0]), ("move", "lock_spring", [-20, 0, 0], O, (0, 0.45)),
                    ("show", "lock_screw", O, [-25]), ("q", "lock_screw", 0, -25, 0, (0.5, 1))], frame="model"),
    A("b2", "Fit the knob over the boss, pins in the axial slots, and thread it on until the head stands 2 mm proud. Turn it to the locked position.",
      "Pon el pomo sobre el resalte, con los pasadores en las ranuras axiales, y enróscalo hasta que la cabeza sobresalga 2 mm. Gíralo a la posición de cierre.",
      7, CAM_LOCK, [("q", n, 0, 25, 0, (0, 0.6)) for n in ("lock_knob", "lock_pins", "lock_nut")]
      + [("q", n, 1, 90 + 1440, 90, (0, 0.6)) for n in ("lock_knob", "lock_pins", "lock_nut")]
      + [("q", n, 1, 90, 0, (0.7, 1)) for n in ("lock_knob", "lock_pins", "lock_nut")], frame="model"),
    A("b2", "Check the pull and the release. Undo the thread two turns, put a drop of medium-strength threadlocker on it, screw it back the same two turns and let it cure. No threadlocker: a drop of the clear epoxy at the nut.",
      "Comprueba el tirón y la liberación. Desenrosca la rosca dos vueltas, pon una gota de fijatornillos de fuerza media, vuelve a enroscar las mismas dos vueltas y deja que cure. Sin fijatornillos: una gota de epoxi transparente junto a la tuerca.",
      9, CAM_LOCK, [("show", "threadlock", O, [0]), ("q", "threadlock", 0, 0, 1, (0.3, 0.8))], frame="model"),
    A("b3", "Cut the two strips from a bike inner tube and glue them into their pockets on the platform.",
      "Corta las dos tiras de una cámara de bicicleta y pégalas en sus alojamientos de la plataforma.",
      5, CAM_BASE_F, [("show", "strips", [-15, 0, 0], []), ("move", "strips", [-15, 0, 0], O)], frame="model"),
    A("b4", "On a 22.2 mm bar, fit the two sleeve halves round the bar first. Then fit the liner halves.",
      "En un manillar de 22,2 mm, pon primero las dos mitades del casquillo alrededor del manillar. Después, las mitades del forro.",
      6, CAM_BASE, [("show", "bar", O, []), ("show", "sleeve_a", [-15, 0, 0], []), ("show", "sleeve_b", [15, 0, 0], []),
                    ("move", "sleeve_a", [-15, 0, 0], O, (0, 0.45)), ("move", "sleeve_b", [15, 0, 0], O, (0, 0.45)),
                    ("show", "liner_main", [-25, 0, 0], [], (0.5, 1)), ("show", "liner_cap", [25, 0, 0], [], (0.5, 1)),
                    ("move", "liner_main", [-25, 0, 0], O, (0.5, 1)), ("move", "liner_cap", [25, 0, 0], O, (0.5, 1))], frame="model"),
    A("b4", "Place the base on the bar with the platform where the remote should sit, and fit the cap from behind.",
      "Pon la base en el manillar con la plataforma donde debe ir el mando, y pon la tapa desde detrás.",
      5, CAM_BASE, [("move", n, [-30, 0, 0], O, (0, 0.5)) for n in ("base_front", "strips", "lock_spring", "lock_screw", "lock_knob", "lock_pins", "lock_nut", "threadlock")]
      + [("show", "base_cap", [30, 0, 0], [], (0.5, 1)), ("move", "base_cap", [30, 0, 0], O, (0.5, 1))], frame="model"),
    A("b4", "Set the angle, and tighten the two M4 x 16 bolts evenly with a 3 mm hex key.",
      "Ajusta el ángulo y aprieta por igual los dos tornillos M4 x 16 con una llave hexagonal de 3 mm.",
      7, CAM_BASE, [("show", "m4_bolts", O, [0]), ("q", "m4_bolts", 0, 0, 1.999), ("show", "m4_key", O, [0]),
                    ("q", "m4_key", 0, 0, 1.999), ("hide", "m4_key", (0.99, 1))], frame="model"),
    # ---- Fitting ----
    A("fit", "Turn the lock knob a quarter turn and pull it: the lock head drops flush with the platform.",
      "Gira el pomo del cierre un cuarto de vuelta y tira de él: la cabeza del cierre queda a ras de la plataforma.",
      5, CAM_FIT, [("q", n, 1, 0, 90, (0, 0.4)) for n in ("lock_knob", "lock_pins", "lock_nut")]
      + [("q", n, 0, 0, 2, (0.5, 1)) for n in ("lock_knob", "lock_pins", "lock_nut", "lock_screw")], frame="model"),
    A("fit", "Press the remote onto the platform 9 mm below its working position.",
      "Apoya el mando en la plataforma 9 mm por debajo de su posición de trabajo.",
      5, CAM_FIT, [("show", n, [-12, -SLIDE, 0], []) for n in ("housing", "cover", "keypad", "joy_plate", "button_plate", "stick", "knob", "battery_cap", "cap_gasket")]
      + [("move", n, [-12, -SLIDE, 0], [0, -SLIDE, 0], (0.1, 1)) for n in ("housing", "cover", "keypad", "joy_plate", "button_plate", "stick", "knob", "battery_cap", "cap_gasket")],
      frame="model"),
    A("fit", "Slide it up until it stops, and release the knob: the lock clicks into the hole in the remote's rear face.",
      "Deslízalo hacia arriba hasta el tope y suelta el pomo: el cierre entra en el agujero de la cara trasera del mando.",
      5, CAM_FIT, [("move", n, [0, -SLIDE, 0], O, (0, 0.6)) for n in ("housing", "cover", "keypad", "joy_plate", "button_plate", "stick", "knob", "battery_cap", "cap_gasket")]
      + [("q", n, 0, 2, 0, (0.65, 0.85)) for n in ("lock_knob", "lock_pins", "lock_nut", "lock_screw")]
      + [("q", n, 1, 90, 0, (0.85, 1)) for n in ("lock_knob", "lock_pins", "lock_nut")], frame="model"),
    A("fit", "To remove it: turn and pull the knob, slide the remote down 9 mm, and lift it off.",
      "Para quitarlo: gira y tira del pomo, desliza el mando 9 mm hacia abajo y sepáralo.",
      6, CAM_FIT, [("q", n, 1, 0, 90, (0, 0.2)) for n in ("lock_knob", "lock_pins", "lock_nut")]
      + [("q", n, 0, 0, 2, (0.2, 0.35)) for n in ("lock_knob", "lock_pins", "lock_nut", "lock_screw")]
      + [("move", n, O, [0, -SLIDE, 0], (0.4, 0.7)) for n in ("housing", "cover", "keypad", "joy_plate", "button_plate", "stick", "knob", "battery_cap", "cap_gasket")]
      + [("move", n, [0, -SLIDE, 0], [-12, -SLIDE, 0], (0.7, 1)) for n in ("housing", "cover", "keypad", "joy_plate", "button_plate", "stick", "knob", "battery_cap", "cap_gasket")],
      frame="model"),
]

TOOLS = {
    "en": ["Tools", "",
           "1.6 mm and 3.4 mm drill bits, turned by hand",
           "1.3 mm hex driver, about 75 mm long (USB-C board screws)",
           "Small hex or cross driver for the M2 x 4 and M2 x 8 screws",
           "Driver for the M2 x 10 and M2 x 8 countersunk screws",
           "0.9 mm hex key (knob grub screw), 3 mm hex key (M4 bolts)",
           "0.9 mm shim (bank card + paper sheet), sharp knife, clear two-part epoxy",
           "Medium-strength threadlocker (optional; the epoxy also works)",
           "",
           "The drives of the bought screws are not checked yet."],
    "es": ["Herramientas", "",
           "Brocas de 1,6 mm y 3,4 mm, giradas a mano",
           "Destornillador hexagonal de 1,3 mm, de unos 75 mm (tornillos de la placa USB-C)",
           "Destornillador pequeño para los tornillos M2 x 4 y M2 x 8",
           "Destornillador para los tornillos avellanados M2 x 10 y M2 x 8",
           "Llave hexagonal de 0,9 mm (prisionero del pomo) y de 3 mm (tornillos M4)",
           "Galga de 0,9 mm (tarjeta bancaria + hoja de papel), cúter y epoxi transparente",
           "de dos componentes",
           "Fijatornillos de fuerza media (opcional; también vale el epoxi)",
           "",
           "La cabeza de los tornillos comprados aún no está comprobada."],
}
CARD_S = 7


def ease(x):
    u = min(1.0, max(0.0, x))
    return u * u * (3 - 2 * u)


def window(op):
    last = op[-1]
    return (op[:-1], last) if isinstance(last, tuple) and len(last) == 2 and all(isinstance(v, (int, float)) for v in last) else (op, (0.0, 1.0))


def lerp(a, b, k):
    if isinstance(a, list):
        return [x + (y - x) * k for x, y in zip(a, b)]
    return a + (b - a) * k


def apply(state, act, u):
    """State after action act at time u (0..1), from the state at its start."""
    st = {k: [v[0], list(v[1]), list(v[2])] for k, v in state.items()}
    for op in act["ops"]:
        op, (u0, u1) = window(op)
        k = ease((u - u0) / (u1 - u0)) if u1 > u0 else 1.0
        started = u >= u0
        kind, name = op[0], op[1]
        if kind == "show" and started:
            if name not in st or not st[name][0]:
                st[name] = [True, list(op[2]), list(op[3])]
        elif kind == "hide" and started:
            if name in st:
                st[name][0] = False
        elif kind == "move" and name in st:
            if started or u0 == 0:
                st[name][1] = lerp(list(op[2]), list(op[3]), k)
        elif kind == "q" and name in st:
            i, v0, v1 = op[2], op[3], op[4]
            while len(st[name][2]) <= i:
                st[name][2].append(0)
            if started or u0 == 0:
                st[name][2][i] = lerp(v0, v1, k)
    return st


def frames_of(act):
    return max(1, int(round(act["dur"] * FPS)))


def timeline():
    """[(action index, u, state, camera)] for every frame, cameras blended between actions."""
    out, state, prev_cam = [], {}, None
    for ai, act in enumerate(ACTIONS):
        n = frames_of(act)
        # The base sequence starts a new scene.
        if act["step"] == S["b1"] and ACTIONS[ai - 1]["step"] != S["b1"]:
            state = {}
        for f in range(n):
            u = f / (n - 1) if n > 1 else 1.0
            st = apply(state, act, u)
            c = act["cam"]
            if prev_cam is not None and act["frame"] == ACTIONS[ai - 1]["frame"]:
                c = lerp(prev_cam, c, ease(u / 0.3))
            out.append((ai, u, st, c))
        state = apply(state, act, 1.0)
        prev_cam = act["cam"]
    return out


def render(job):
    i, ai, st, c = job
    act = ACTIONS[ai]
    items = [[n, v[1], v[2]] for n, v in st.items() if v[0]]
    out = WORK / "raw" / ("f%05d.png" % i)
    av.run_scad({"items": items, "frame": act["frame"], "cut": act["cut"], "cut_items": act["cut_items"],
                 "cut_z": act["cut_z"]}, out,
                args=["--imgsize=%d,%d" % SIZE, "--colorscheme=Tomorrow",
                      "--camera=" + ",".join("%.3f" % v for v in c)], scad=SCAD)
    return i


def card(lang):
    out = WORK / ("card-%s.png" % lang)
    txt = WORK / ("card-%s.txt" % lang)
    txt.write_text("\n".join(TOOLS[lang]))
    subprocess.run(["magick", "-size", "%dx%d" % (SIZE[0], SIZE[1] + 110), "xc:white", "-font", FONT,
                    "-pointsize", "30", "-fill", "black", "-gravity", "northwest",
                    "-annotate", "+90+90", "@" + str(txt), str(out)], check=True)
    return out


def compose(job):
    lang, i, ai = job
    li = 0 if lang == "en" else 1
    act = ACTIONS[ai]
    cap = WORK / ("cap-%s-%03d.txt" % (lang, ai))
    subprocess.run(["magick", str(WORK / "raw" / ("f%05d.png" % i)), "-gravity", "north", "-background", "white",
                    "-splice", "0x110",
                    "(", "-size", "1240x34", "-background", "white", "-fill", "#1565c0", "-font", FONT,
                    "-pointsize", "26", "caption:" + act["step"][li], ")", "-gravity", "northwest",
                    "-geometry", "+20+8", "-composite",
                    "(", "-size", "1240x62", "-background", "white", "-fill", "black", "-font", FONT,
                    "-pointsize", "22", "caption:@" + str(cap), ")", "-gravity", "northwest",
                    "-geometry", "+20+44", "-composite",
                    str(WORK / lang / ("f%05d.png" % (i + CARD_S * FPS)))], check=True)
    return i


def video(lang):
    out = WORK / ("guide-v0.34.%s.mp4" % lang)
    subprocess.run(["ffmpeg", "-loglevel", "error", "-y", "-framerate", str(FPS),
                    "-i", str(WORK / lang / "f%05d.png"), "-c:v", "libx264", "-crf", "24", "-preset", "slow",
                    "-pix_fmt", "yuv420p", "-movflags", "+faststart", str(out)], check=True)
    return out


def main(argv=None):
    ap = argparse.ArgumentParser()
    ap.add_argument("--preview", action="store_true")
    ap.add_argument("--only", type=int, action="append")
    ap.add_argument("langs", nargs="*")
    a = ap.parse_args(argv)
    langs = a.langs or ["en", "es"]
    (WORK / "raw").mkdir(parents=True, exist_ok=True)
    tl = timeline()
    jobs = [(i, ai, st, c) for i, (ai, u, st, c) in enumerate(tl)]
    if a.preview:
        pick = []
        for ai in range(len(ACTIONS)):
            if a.only and ai not in a.only:
                continue
            idx = [j for j in jobs if j[1] == ai]
            pick += [idx[0], idx[len(idx) // 2], idx[-1]]
        with ThreadPoolExecutor(os.cpu_count()) as ex:
            list(ex.map(render, pick))
        files = [str(WORK / "raw" / ("f%05d.png" % j[0])) for j in pick]
        sheet = WORK / "preview.png"
        subprocess.run(["magick", "montage"] + files + ["-tile", "3x", "-geometry", "420x+3+3", str(sheet)], check=True)
        print(sheet, len(tl) / FPS, "s")
        return
    with ThreadPoolExecutor(os.cpu_count()) as ex:
        list(ex.map(render, jobs))
        for lang in langs:
            (WORK / lang).mkdir(parents=True, exist_ok=True)
            li = 0 if lang == "en" else 1
            for ai, act in enumerate(ACTIONS):
                (WORK / ("cap-%s-%03d.txt" % (lang, ai))).write_text(act["cap"][li])
            c = card(lang)
            for k in range(CARD_S * FPS):
                dst = WORK / lang / ("f%05d.png" % k)
                if dst.exists():
                    dst.unlink()
                os.link(c, dst)
            list(ex.map(compose, [(lang, i, j[1]) for i, j in enumerate(jobs)]))
    for lang in langs:
        print(video(lang))


if __name__ == "__main__":
    main(sys.argv[1:])
