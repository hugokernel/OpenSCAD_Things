/*
 *  Parametric Pipe Support
 */
include <BOSL2/std.scad>
include <BOSL2/screws.scad>

$fn = 40;

OVAL_LENGTH = 36.3;
OVAL_WIDTH = 21.3;
OVAL_LINK_HEIGHT = 50;
OVAL_CLEARANCE = 0.75;

WALL_THICKNESS = 4;

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

            down(1) {
                linear_extrude(OVAL_LINK_HEIGHT * 2) {
                    oval(OVAL_LENGTH + OVAL_CLEARANCE, OVAL_WIDTH + OVAL_CLEARANCE);
                }
            }
        }
    }

    module plate() {
        difference() {
            linear_extrude(WALL_THICKNESS / 1.5) {
                rect([100, 100], rounding=5, center=true);
            }

            for (position = [
                [74 / 2, 74 / 2, 0],
                [-74 / 2, 74 / 2, 0],
                [74 / 2, -74 / 2, 0],
                [-74 / 2, -74 / 2, 0],
            ]) {
                translate(position) {
                    down(1) {
                        cylinder(r=2.2, h=WALL_THICKNESS * 2);
                        up(2) {
                            nut("M4", 7, 3);
                        }
                    }
                }
            }
        }
    }

    plate();
    fwd(OVAL_LINK_HEIGHT / 2) {
        up(15) {
            xrot(-90) {
                body();
            }
        }
    }
}

//oval(r=25);
//main();

main();
//cylinder(d=10, h=100);
