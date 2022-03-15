include <BOSL2/std.scad>

$fn = 40;

HOLE_GAP = 80;
HOLE_DIAMETER = 3.3;
HEIGHT = 120;
THICKNESS = 7;
WIDTH = 9;

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

module cub(length, width=WIDTH, thickness=THICKNESS) {
    xrot(-90) {
        cuboid(
            [length, thickness, width],
            chamfer=thickness / 3,
            edges=[FRONT],
            $fn=24
        );
    }
}

module main() {
    module pos() {
        for (pos = [-HOLE_GAP / 2, HOLE_GAP / 2]) {
            left(pos) {
                children();
            }
        }
    }

    module frame() {
        pos() {
            cylinder(d=HOLE_DIAMETER * 4.5, h=THICKNESS, center=true);
        }

        pos() {
            fwd(-HEIGHT / 4) {
                zrot(90) {
                    cub(HEIGHT / 2);
                }
            }
        }

        fwd(-HEIGHT / 2) {
            cub(HOLE_GAP + WIDTH);
        }
    }

    difference() {
        frame();

        pos() {
            down(THICKNESS) {
                oblong(HOLE_DIAMETER, HOLE_DIAMETER * 2, THICKNESS * 4);
            }
        }
    }

    back(HEIGHT / 2 + HEIGHT / 4) {
        zrot(90) {
            cub(HEIGHT / 2);
        }
    }

    back(6)
    down(THICKNESS / 2) {
        difference() {
            hook_height = 15;
            hook_width = 20;
            translate([0, HEIGHT, hook_height / 2]) {
                cube(size=[3, hook_width, hook_height], center=true);
            }

            for (pos = [0:1]) {
                translate([0, HEIGHT + hook_width / 2, 5 + hook_height / 2.5 * pos]) {
                    yrot(90) {
                        cylinder(d=4, h=10, center=true);
                    }
                }
            }
        }
    }
}

main();

%left(HOLE_GAP / 2)
    cylinder(r=1, h=50);
