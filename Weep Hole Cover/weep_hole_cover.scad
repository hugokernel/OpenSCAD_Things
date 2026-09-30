include <BOSL2/std.scad>
include <BOSL2/screws.scad>

$fn = 40;

LENGTH = 77;
HEIGHT = 17;
THICKNESS = 8;

HOLE_DIAMETER = 4;

module base(length, height, thickness) {
    cuboid([length, height, thickness], rounding=3.5, edges=[TOP+FRONT, TOP+RIGHT, TOP+LEFT, FRONT+RIGHT, FRONT+LEFT]);
}

module screw(diameter, height=THICKNESS, head_height=2) {
    cylinder(d=diameter, h=height - head_height + 0.5);
    up(height - head_height)
        cylinder(h=head_height, r1=diameter / 2, r2=diameter / 2 + 2.25);
}

module main() {
    difference() {
        base(LENGTH, HEIGHT, THICKNESS);

        down(THICKNESS / 2 + .5)
        for (position = [LENGTH / 2 - 6.5, -LENGTH / 2 + 6.5]) {
            left(position) {
                screw(HOLE_DIAMETER, THICKNESS + 1);
            }
        }

        down(1)
            back(1.1)
                base(LENGTH - 20, HEIGHT - 1, THICKNESS - 1);
    }
}

main();

// base(45, 10, 10);
//screw(5);
