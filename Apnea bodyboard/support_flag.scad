
$fn = 30;

HEIGHT = 28;

THICKNESS = 9;
HOLE_DIAMETER = 6;

module nut() {
    nut_diameter = 11.2;
    nut_clear = 0.2;
    nut_height = 4.6 + 1.5;
    cylinder(r = nut_diameter / 2 + nut_clear, h = nut_height, $fn = 6);
}

module support() {
    flag_support_diameter = 8;

    module corners(all = true) {
        for (pos = [
            [0, 27, 0],
            [0, -27, 0]
            ]) {
            translate(pos) {
                children([0 : $children - 1]);
            }
        }

        if (all) {
            for (pos = [
                [24, 0, 0],
                [-24, 0, 0],
                ]) {
                translate(pos) {
                    children([0 : $children - 1]);
                }
            }
        }
    }

    difference() {
        union() {
            hull() {
                corners() {
                    cylinder(r = 8, h = THICKNESS);
                }
            }

            cylinder(r1 = flag_support_diameter / 2 + 16, r2 = flag_support_diameter / 2 + 12, h = HEIGHT);
        }

        translate([0, 0, -10]) {
            cylinder(r = flag_support_diameter / 2, h = 100);
        }

        corners(false) {
            translate([0, 0, 3]) {
                nut();
            }
            cylinder(r = HOLE_DIAMETER / 2, h = 15, center = true);
        }
    }
}

!support();

