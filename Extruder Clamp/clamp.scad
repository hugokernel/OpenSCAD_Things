
$fn = 40;
INTERNAL_DIAMETER = 6.1;
BASE_HEIGHT = 5;
WELL_HEIGHT = 30;

module main() {
    difference() {
        union() {
            cube(size = [15, 50, BASE_HEIGHT]);//, center = true);

            translate([7.5, 50, 0]) {
                cylinder(r = 7.5, h = BASE_HEIGHT);
            }

            translate([7.5, 0, 0]) {
                cylinder(r = 7.5, h = BASE_HEIGHT);
            }
        }

        // Hole
        translate([7.5, 5, -1]) {
            cylinder(r = 1.5, h = 20);
        }

        translate([7.5, 25.5, -1]) {
            cylinder(r = 1.5, h = 20);
        }

        translate([7.5, 5, BASE_HEIGHT - 2.7 + 0.1]) {
            cylinder(r1 = 1.5, r2 = 3.5, h = 2.7);
        }

        translate([7.5, 25.5, BASE_HEIGHT - 2.7 + 0.1]) {
            cylinder(r1 = 1.5, r2 = 3.5, h = 2.7);
        }
    }
}

difference() {

    union() {
        main();
        translate([7.5, 45, 0]) {
            cylinder(r = 7.5, h = WELL_HEIGHT);
        }
    }

    translate([7.5, 45, -1]) {
        cylinder(r = INTERNAL_DIAMETER / 2, h = 100);
    }

    translate([7.5, 45, WELL_HEIGHT - 5]) {
       cylinder(r1 = INTERNAL_DIAMETER / 2, r2 = 5, h = 6);
    }
}
