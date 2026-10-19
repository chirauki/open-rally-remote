// Paper template for the V0.31 battery cap foam gasket. Export to SVG or PDF
// and print at 100 % scale; the bar below the outline is 40 mm long and checks
// the printer's scale. Cut the foam round the outline and the screw holes.
//   openscad -o cap-gasket-template.svg mechanical/cad/tools/cap-gasket-template.scad
include <../complete-remote-v0.31.scad>
part_to_render = "none";

projection() rotate([90, 0, 0]) cap_gasket();
translate([-40, -axial_width - 4]) square([40, 1]);
