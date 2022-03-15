/*
 *  Parametric Profile End Cap
 */
include <BOSL2/std.scad>

$fn = 40;

OVAL_LENGTH = 36.3;
OVAL_WIDTH = 21.3;
OVAL_LINK_HEIGHT = 50;
OVAL_CLEARANCE = 0.5;

CYLINDER_DIAMETER = 19.7;
CYLINDER_LINK_HEIGHT = 50;
CYLINDER_CLEARANCE = 0.5;

WALL_THICKNESS = 5;

HOLE_DIAMETER = 8;


module oval(length, width) {
    resize([length, width])
        circle(d=20);
}


module main() {

    module body() {
        difference() {
            linear_extrude(OVAL_LINK_HEIGHT) {
                oval(
                    OVAL_LENGTH + 2 * WALL_THICKNESS,
                    OVAL_WIDTH + 2 * WALL_THICKNESS
                );
            }

            down(.01) {
                linear_extrude(OVAL_LINK_HEIGHT) {
                    oval(OVAL_LENGTH + OVAL_CLEARANCE, OVAL_WIDTH + OVAL_CLEARANCE);
                }
            }
        }

        up(OVAL_LINK_HEIGHT) {
            hull() {
                linear_extrude(1) {
                    oval(
                        OVAL_LENGTH + 2 * WALL_THICKNESS,
                        OVAL_WIDTH + 2 * WALL_THICKNESS
                    );
                };

                up(5) {
                    cylinder(d=CYLINDER_DIAMETER + 2 * WALL_THICKNESS, h=10);
                }
            }

            up(10) {
                difference() {
                    cylinder(
                        d=CYLINDER_DIAMETER + 2 * WALL_THICKNESS,
                        h=CYLINDER_LINK_HEIGHT
                    );

                    up(0.01) {
                        cylinder(
                            d=CYLINDER_DIAMETER + CYLINDER_CLEARANCE,
                            h=CYLINDER_LINK_HEIGHT
                        );
                    }
                }
            }
        }
    }

    difference() {
        body();
        //cylinder(r=10, h=10);
        cylinder(d=HOLE_DIAMETER, h=1000);

        up(OVAL_LINK_HEIGHT - 7)
            xrot(45)
                cylinder(d=HOLE_DIAMETER, h=1000);
    }
}

//oval(r=25);
//main();

main();
//cylinder(d=10, h=100);
