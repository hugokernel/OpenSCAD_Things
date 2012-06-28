
include <shapes.scad>;

SWITCH_GAP = 8;
THICKNESS = 4;
SPACE = 30;

$fn = 50;

module grip(offset) {
	// Holes
	translate([- SWITCH_GAP / 2, offset, -2]) cylinder(10, 1.5, 1.5);
	translate([SWITCH_GAP / 2, offset, -2]) cylinder(10, 1.5, 1.5);

	// Nut footprint
	translate([- SWITCH_GAP / 2, offset, 2]) hexagon(5.5, 2);
	translate([SWITCH_GAP / 2, offset, 2]) hexagon(5.5, 2);
}

module switch(offset) {
	// Holes
	translate([- SWITCH_GAP / 2, offset, -2]) cylinder(10, 1.5, 1.5);
	translate([SWITCH_GAP / 2, offset, -2]) cylinder(10, 1.5, 1.5);

	// Chamfer
	translate([-SWITCH_GAP / 2, offset, -3]) cylinder(2, 5, 2);
	translate([SWITCH_GAP / 2, offset, -3]) cylinder(2, 5, 2);
}

difference() {
	roundedBox(SWITCH_GAP + 10, SPACE + 15, THICKNESS, 5);
	grip(SPACE / 2);
	switch(-SPACE / 2);
}

