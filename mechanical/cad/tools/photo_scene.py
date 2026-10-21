"""Blender scene for photo-like renders of the Open Rally Remote: the front and the side view.
photo_render.py exports the part STLs and runs this file:
  blender -b -P photo_scene.py -- <stl_dir> <out_dir> [samples]
The materials are a guess at the look; the print material is not chosen (docs/materials-study.md).
"""
import bpy, sys, math
from mathutils import Vector, Matrix

argv = sys.argv[sys.argv.index("--") + 1:]
SRC, OUT = argv[0], argv[1]
SAMPLES = int(argv[2]) if len(argv) > 2 else 192

bpy.ops.wm.read_factory_settings(use_empty=True)
scene = bpy.context.scene
scene.unit_settings.scale_length = 0.001

# --- render settings -------------------------------------------------------------------
scene.render.engine = "CYCLES"
prefs = bpy.context.preferences.addons["cycles"].preferences
try:
    prefs.compute_device_type = "METAL"
    prefs.get_devices()
    for d in prefs.devices:
        d.use = True
    scene.cycles.device = "GPU"
except Exception:
    scene.cycles.device = "CPU"
scene.cycles.samples = SAMPLES
scene.cycles.use_denoising = True
scene.render.resolution_x, scene.render.resolution_y = 1600, 1200
scene.view_settings.view_transform = "AgX"
scene.view_settings.look = "AgX - Medium High Contrast"
scene.view_settings.exposure = 0.6

# --- materials -------------------------------------------------------------------------
def principled(name, color, rough, metal=0.0, coat=0.0, bump=0.0, bump_scale=900.0, sheen=0.0):
    m = bpy.data.materials.new(name)
    m.use_nodes = True
    nt = m.node_tree
    b = nt.nodes["Principled BSDF"]
    b.inputs["Base Color"].default_value = (*color, 1)
    b.inputs["Roughness"].default_value = rough
    b.inputs["Metallic"].default_value = metal
    b.inputs["Coat Weight"].default_value = coat
    b.inputs["Sheen Weight"].default_value = sheen
    if bump > 0:
        # Fine noise: the sintered grain of an MJF surface.
        tc = nt.nodes.new("ShaderNodeTexCoord")
        n = nt.nodes.new("ShaderNodeTexNoise")
        n.inputs["Scale"].default_value = bump_scale
        n.inputs["Detail"].default_value = 4.0
        bp = nt.nodes.new("ShaderNodeBump")
        bp.inputs["Strength"].default_value = bump
        bp.inputs["Distance"].default_value = 0.02
        nt.links.new(tc.outputs["Object"], n.inputs["Vector"])
        nt.links.new(n.outputs["Fac"], bp.inputs["Height"])
        nt.links.new(bp.outputs["Normal"], b.inputs["Normal"])
    return m

MAT = {
    "pa11": principled("PA11 MJF dyed black", (0.028, 0.028, 0.030), 0.78, bump=0.35),
    "pa12": principled("PA12 MJF grey", (0.20, 0.21, 0.22), 0.82, bump=0.35),
    "tpu": principled("TPU 85A black", (0.018, 0.018, 0.020), 0.55, sheen=0.3),
    "rubber": principled("Inner tube", (0.015, 0.015, 0.015), 0.6),
    "steel": principled("Steel", (0.62, 0.62, 0.63), 0.28, metal=1.0),
    "black_steel": principled("Black-coated steel", (0.05, 0.05, 0.055), 0.35, metal=1.0),
    "stainless": principled("Stainless", (0.70, 0.70, 0.72), 0.25, metal=1.0),
    "alu": principled("Aluminium bar", (0.80, 0.80, 0.82), 0.32, metal=1.0),
    "grip": principled("Grip rubber", (0.02, 0.02, 0.02), 0.85, bump=0.6, bump_scale=60.0),
}

PARTS = {
    "housing": "pa11", "cover": "pa11", "battery_cap": "pa11", "knob": "pa11",
    "keypad": "tpu", "stick": "steel", "screws": "stainless",
    "base_front": "pa12", "base_cap": "pa12", "lock": "pa11",
    "bolts": "black_steel", "strips": "rubber", "liners": "rubber", "sleeves": "pa12",
}

# OpenSCAD: bar along Z, Y up. Blender: Z up. Rotate +90 deg about X: (x, y, z) -> (x, -z, y).
ROT = Matrix.Rotation(math.radians(90), 4, "X")

objs = []
for name, mat in PARTS.items():
    bpy.ops.wm.stl_import(filepath="%s/%s.stl" % (SRC, name))
    o = bpy.context.selected_objects[0]
    o.name = name
    o.matrix_world = ROT
    o.data.materials.clear()
    o.data.materials.append(MAT[mat])
    bpy.context.view_layer.objects.active = o
    bpy.ops.object.shade_smooth_by_angle(angle=math.radians(35))
    objs.append(o)

# --- handlebar: aluminium bar through the clamp ------------------------------------------
def bar_cylinder(name, d, z0, z1, mat):
    bpy.ops.mesh.primitive_cylinder_add(vertices=128, radius=d / 2, depth=z1 - z0,
                                        location=(0, 0, (z0 + z1) / 2))
    o = bpy.context.active_object
    o.name = name
    o.matrix_world = ROT @ o.matrix_world
    o.data.materials.append(MAT[mat])
    bpy.ops.object.shade_smooth_by_angle(angle=math.radians(30))
    return o
bar_cylinder("bar", 22.2, -170, 70, "alu")

# --- world and studio lights -----------------------------------------------------------
world = bpy.data.worlds.new("studio")
scene.world = world
world.use_nodes = True
bg = world.node_tree.nodes["Background"]
bg.inputs["Color"].default_value = (0.62, 0.64, 0.67, 1)
bg.inputs["Strength"].default_value = 0.35

def area(name, loc, target, size, power, color=(1, 1, 1)):
    bpy.ops.object.light_add(type="AREA", location=loc)
    l = bpy.context.active_object
    l.name = name
    l.data.size = size
    l.data.energy = power
    l.data.color = color
    d = Vector(target) - Vector(loc)
    l.rotation_euler = d.to_track_quat("-Z", "Y").to_euler()
    return l

# Floor: a soft shadow catcher far below, for a studio look.
bpy.ops.mesh.primitive_plane_add(size=2000, location=(0, 0, -75))
floor = bpy.context.active_object
floor.data.materials.append(principled("floor", (0.55, 0.56, 0.58), 0.9))

# --- framing ---------------------------------------------------------------------------
pts = [o.matrix_world @ Vector(c) for o in objs for c in o.bound_box]
lo = Vector([min(p[i] for p in pts) for i in range(3)])
hi = Vector([max(p[i] for p in pts) for i in range(3)])
centre = (lo + hi) / 2
radius = (hi - lo).length / 2

cam_data = bpy.data.cameras.new("cam")
cam_data.lens = 100
cam_data.dof.use_dof = True
cam_data.dof.aperture_fstop = 11
cam = bpy.data.objects.new("cam", cam_data)
scene.collection.objects.link(cam)
scene.camera = cam

VIEWS = {
    # Front: the control face, seen by the rider, a little from above and from the bar's end.
    "front": ((-1.0, 0.35, 0.30), 100),
    # Side: along the bar, the folded control face in profile.
    "side": ((-0.28, -1.0, 0.12), 135),
}

for view, (dvec, lens) in VIEWS.items():
    cam_data.lens = lens
    d = Vector(dvec).normalized()
    dist = radius / math.tan(cam_data.angle / 2) * 1.08
    cam.location = centre + d * dist
    cam.rotation_euler = (centre - cam.location).to_track_quat("-Z", "Y").to_euler()
    cam_data.dof.focus_distance = dist
    for l in [o for o in scene.objects if o.type == "LIGHT"]:
        bpy.data.objects.remove(l)
    right = d.cross(Vector((0, 0, 1))).normalized()
    area("key", centre + (d + right * 0.9 + Vector((0, 0, 1.1))) * 260, centre, 180, 9.0e5)
    area("fill", centre + (d - right * 1.2 + Vector((0, 0, 0.2))) * 260, centre, 260, 2.5e5)
    area("rim", centre + (-d + Vector((0, 0, 1.4))) * 260, centre, 120, 6.0e5, (0.92, 0.95, 1.0))
    scene.render.filepath = "%s/%s.png" % (OUT, view)
    bpy.ops.render.render(write_still=True)
