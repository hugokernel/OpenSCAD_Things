include <BOSL2/std.scad>

$fn = 100;

THICKNESS = 2;
ANTENNA_DIAMETER = 2.65;

INTERNAL_DIAMETER = 4;
EXTERNAL_DIAMETER = 15;

torus(d_maj=EXTERNAL_DIAMETER, d_min=THICKNESS);

difference() {
    union() {
        torus(d_maj=INTERNAL_DIAMETER, d_min=THICKNESS);

        zcyl(d=4, h=THICKNESS);
    }

    zcyl(d=ANTENNA_DIAMETER, h=10);
}

h = (EXTERNAL_DIAMETER - INTERNAL_DIAMETER) / 2;
arc_copies(d=INTERNAL_DIAMETER + h, n=4) {
    xcyl(d=THICKNESS, h=h);
}

