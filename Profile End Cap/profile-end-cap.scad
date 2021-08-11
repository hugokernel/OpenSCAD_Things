/*
 *  Parametric Profile End Cap
 */
include <BOSL2/std.scad>


$fn = 20;

TOP_LENGTH = 114.2;
TOP_WIDTH = 56.6;
TOP_THICKNESS = 3;
TOP_ROUNDING = 5;
TOP_OFFSET = 4;

FOOT_LENGTH = 20;
FOOT_HEIGHT = 10;
FOOT_THICKNESS = 4;


module top() {
    difference() {
        prismoid([TOP_LENGTH, TOP_WIDTH], [TOP_LENGTH - TOP_OFFSET, TOP_WIDTH - TOP_OFFSET], h=TOP_THICKNESS, rounding=TOP_ROUNDING);
        down(TOP_THICKNESS / 2 + .1) {
            cuboid(size=[TOP_LENGTH + 5, TOP_WIDTH + 5, TOP_THICKNESS]);
        }
    }
}

module foot() {
    cuboid([FOOT_LENGTH, FOOT_THICKNESS, FOOT_HEIGHT]);
}

X_OFFSET = .5;

module main() {
    difference() {
        union() {
            top();
            down(FOOT_HEIGHT / 2) {
                for (pos = [1, -1]) {
                    fwd(pos * (TOP_WIDTH / 2 - FOOT_THICKNESS / 2 - 2.6)) {
                        foot();
                    }
                }

                for (pos = [
                        -(TOP_LENGTH / 2 - FOOT_THICKNESS / 2 - (1.6 - X_OFFSET)),
                        (TOP_LENGTH / 2 - FOOT_THICKNESS / 2 - (1.6 + X_OFFSET)),
                    ]) {
                    zrot(90) {
                        fwd(pos) {
                            foot();
                        }
                    }
                }
            }
        }

        yflip() {
            down(1) {
                fwd(-12)
                    linear_extrude(height=1.5)
                        text(text="Profile End Cap", size=10, halign="center", valign="center");
                fwd(0)
                    linear_extrude(height=1.5)
                        text(text="0.0.7 - 2021-08", size=7, halign="center", valign="center");
                information = str_format("l: {}, r: {}", [TOP_LENGTH, TOP_ROUNDING]);
                fwd(12)
                    linear_extrude(height=1.5)
                        text(text=information, size=7, halign="center", valign="center");
            }
        }
    }
}

main();

left(X_OFFSET)
%cuboid([111, 50, 20]);
