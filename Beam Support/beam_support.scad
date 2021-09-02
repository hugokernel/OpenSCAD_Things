/*
 *  Parametric Beam Support
 */
include <BOSL2/std.scad>
include <BOSL2/screws.scad>

$fn = 60;

SUPPORT_LENGTH = 130;
SUPPORT_WIDTH = 120;
SUPPORT_THICKNESS = 2;
SUPPORT_ROUNDING = [45, 10, 10, 45];

ARM_HEIGHT = 45;
ARM_THICKNESS = 10;

BEAM_THICKNESS = 63;

module support(height=SUPPORT_THICKNESS) {
    module obj() {
        linear_extrude(height) {
            polygon([
                [-47,-8],
                [-47,32],[-47,35],[-46,39],[-44,42],[-42,45],[-40,47],[-37,49],[-34,50],[-28,51],[1,51],[1,-53],[-20,-53],[-24,-52],[-27,-51],[-30,-49],[-33,-46],[-37,-40],[-40,-35],[-43,-29],[-45,-23],[-46,-19],[-47,-14]]
            );
        }
    }

    left(1)
        scale(1.25)
            zrot(90) {
                obj();
                xflip()
                    obj();
            }
}

module arm() {
    rounding = 20;

    offset = ARM_HEIGHT / 2 - rounding;

    down(ARM_THICKNESS / 2)
        hull() {
            fwd(-offset)
                cylinder(r=rounding, h=ARM_THICKNESS);

            fwd(offset) {
                left(40)
                    cylinder(r=1, h=ARM_THICKNESS);
                right(40)
                    cylinder(r=1, h=ARM_THICKNESS);
            }
        }
}

module arms() {
    difference() {
        hull() {
            support(1);

            up(-SUPPORT_THICKNESS + ARM_HEIGHT / 2) {
                fwd(BEAM_THICKNESS / 2 + ARM_THICKNESS / 2)
                    xrot(90)
                        arm();

                back(BEAM_THICKNESS / 2 + ARM_THICKNESS / 2)
                    xrot(90)
                        arm();
            }
        }

        up(ARM_THICKNESS / 2 + ARM_HEIGHT / 2)
            cube(size=[SUPPORT_LENGTH * 2, BEAM_THICKNESS, ARM_HEIGHT], center=true);
    }
}

module information() {
    back(35)
        linear_extrude(height=1.5)
            text(text="Beam Support", size=10, halign="center", valign="center");
    fwd(35)
        linear_extrude(height=1.5)
            text(text="@hugokernel - 2021-08", size=7, halign="center", valign="center");
}

module main() {
    difference() {
        union() {
            support();

            up(SUPPORT_THICKNESS)
                arms();
        }

        // Holes
        for (position = [-45.5, 44.5]) {
            right(position)
                down(.1)
                    cylinder(r=4, h=SUPPORT_THICKNESS * 4);
        }

        down(.1)
            cylinder(r=20, h=SUPPORT_THICKNESS * 4);

        for (position = [
                [-90, BEAM_THICKNESS / 2 + 10],
                [90, -BEAM_THICKNESS / 2 - 10]
            ]) {
            up(ARM_HEIGHT / 1.5)
                back(position[1])
                    xrot(position[0]) {
                        cylinder(r=6, h=100);
        
                        down(19.9)
                            screw("M5", head="flat small", length=20, thread=0);
                    }
        }

        xflip() {
            information();
        }
    }
}

!main();
