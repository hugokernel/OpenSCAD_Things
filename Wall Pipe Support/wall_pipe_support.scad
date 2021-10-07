include <BOSL2/std.scad>

$fn = 60;

LENGTH = 180;
WIDTH = 150;
THICKNESS = 5;

OBLONG_DIAMETER = 5.5;
OBLONG_LENGTH = 15;

TUBE_DIAMETER = 26.9;

BOLT_DIAMETER = 4.5;
BOLT_HEAD_DIAMETER = 9;
NUT_DIAMETER = 8.25;
NUT_HEIGHT = 6;


module oblong(diameter, length, thickness) {
    translate([-length / 2, 0, 0]) {
        hull() {
            cylinder(d=diameter, h=thickness);
            translate([length, 0, 0]) {
                cylinder(d=diameter, h=thickness);
            }
        }
    }
}

module nut(diameter, height) {
    cylinder(d=diameter, h=height, $fn=6);
    //%cylinder(d=7.8, h=height, $fn=40);
}

module tube_holder(diameter, length) {
    difference() {
        hull() {
            cube(size=[diameter * 3, length, 1], center=true);
            translate([0, length / 2, diameter]) {
                rotate([90, 0, 0]) {
                    cylinder(d=diameter * 2, h=length);
                }
            }
        }

        translate([0, length, diameter]) {
            rotate([90, 0, 0]) {
                cylinder(d=diameter, h=length * 2);
            }
        }

        translate([0, 0, diameter * 2 - 3]) {
            cylinder(d=BOLT_HEAD_DIAMETER, h=diameter);
        }
        cylinder(d=BOLT_DIAMETER, h=diameter * 2);
    }
}

module main() {
    item_position = LENGTH / 2 - 35;

    difference() {
        union() {
            difference() {
                down(THICKNESS / 2) {
                    resize([LENGTH, WIDTH]) {
                        prismoid(
                            LENGTH,
                            LENGTH - 8,
                            rounding=[10, 10, 10, 10],
                            h=THICKNESS
                        );
                    }
                }

                for (position = [
                    [item_position, WIDTH / 2 - 20, 0],
                    [-item_position, WIDTH / 2 - 20, 0],
                    [item_position, -(WIDTH / 2 - 20), 0],
                    [-item_position, -(WIDTH / 2 - 20), 0],
                ]) {
                    translate(position) {
                        translate([0, 0, -THICKNESS]) {
                            oblong(OBLONG_DIAMETER, OBLONG_LENGTH, THICKNESS * 2);
                        }
                    }
                }

                cuboid(
                    [LENGTH / 3.5, WIDTH / 1.8, THICKNESS * 4],
                    rounding=5
                );
            }

            for (x=[item_position, -item_position]) {
                translate([x, 0, 0]) {
                    rotate([0, 0, 90]) {
                        tube_holder(TUBE_DIAMETER, 30);
                    }
                }
            }
        }

        for (x=[item_position, -item_position]) {
            translate([x, 0, -THICKNESS / 2 - .1]) {
                nut(NUT_DIAMETER, NUT_HEIGHT);
            }
        }
    }
}

// Test
intersection() { translate([0, 0, 27]) cube(size=[43, 50, 35], center=true); tube_holder(TUBE_DIAMETER, 30); }
tube_holder(TUBE_DIAMETER, 30);
oblong(OBLONG_DIAMETER, OBLONG_LENGTH, THICKNESS);
difference() { cylinder(d=15, h=10); translate([0, 0, -.1]) nut(NUT_DIAMETER, NUT_HEIGHT); cylinder(d=BOLT_DIAMETER, h=100); }

!main();

