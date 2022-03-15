/*
 *  Parametric Beam Support
 */
include <BOSL2/std.scad>

$fn = 60;

EXTERNAL_DIAMETER = 73.5;
EXTERNAL_HEIGHT = 37.5;

INTERNAL_DIAMETER = 61.3;
INTERNAL_THICKNESS = 2.37;
INTERNAL_OVERHANG_HEIGHT = 11.0;

OFFSET = 7.5;


module version() {
    fwd(-12) {
        linear_extrude(height=1) {
            text(text="Exercise bike foot", size=5, halign="center", valign="center");
        }
    }
    fwd(0) {
        linear_extrude(height=1) {
            text(text="1.0.0 - 2021-10", size=5, halign="center", valign="center");
        }
    }
}


module main() {
    module offset() {
        left(OFFSET / 2) {
            up(EXTERNAL_HEIGHT) {
                children(0);
            }
        }
    }

    difference() {
        union() {
            hull() {
                zrot(45) {
                    cylinder(d=EXTERNAL_DIAMETER, h=1, $fn=12);
                    down(3) {
                        cylinder(d=EXTERNAL_DIAMETER - 13, h=1);
                    }
                }
            }

            zrot(45) {
                cylinder(d=EXTERNAL_DIAMETER, h=EXTERNAL_HEIGHT, $fn=12);
            }
            offset() {
                zrot(45) {
                    cylinder(d=INTERNAL_DIAMETER + INTERNAL_THICKNESS, h=INTERNAL_OVERHANG_HEIGHT);
                }
            }
        }

        radius = INTERNAL_DIAMETER / 2;// - INTERNAL_THICKNESS * 2 + 2.25;
        echo(radius)

        down(EXTERNAL_HEIGHT - 1) {
            offset() {
                cylinder(
                    r=radius,
                    h=EXTERNAL_HEIGHT + INTERNAL_OVERHANG_HEIGHT
                );
            }
        }

        offset() {
            down(EXTERNAL_HEIGHT - .1) {
                version();
            }
        }
    }
}

!main();
