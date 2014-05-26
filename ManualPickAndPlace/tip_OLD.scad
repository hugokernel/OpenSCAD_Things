
BEARING_INTERNAL_DIAMETER = 7.8;

module tip() {

    $fn = 40;
    clear = 0.05;

    difference() {
        union() {
            hull() {
                cylinder(r = 4.0 / 2, h = 1);
                translate([0, 0, 12]) {
                    cylinder(r = 4.2 / 2, h = 1);
                }
            }

            hull() {
                translate([0, 0, 12]) {
                    cylinder(r = 4.2 / 2, h = 1);
                }

                translate([0, 0, 17]) {
                    cylinder(r = BEARING_INTERNAL_DIAMETER / 2 + clear, h = 20);
                }
            }

            hull() {
                translate([0, 0, 37]) {
                    cylinder(r = 12 / 2, h = 4);
                }

                translate([0, 0, 41]) {
                    cylinder(r = BEARING_INTERNAL_DIAMETER / 2, h = 5);
                }
            }

            difference() {
                union() {
                    translate([0, 0, 46]) {
                        cylinder(r = BEARING_INTERNAL_DIAMETER / 2, h = 25);
                    }

                    translate([0, 0, 71]) {
                        cylinder(r = 20 / 2, h = 20, $fn = 12);
                    }
                }

                translate([0, 0, 81]) {
                    cylinder(r = 5, h = 11, $fn = 14);
                }               
            }

            translate([0, 0, 81]) {
                hull() {
                    cylinder(r = 4.1 / 2, h = 1);
                    translate([0, 0, 9]) {
                        cylinder(r = 4.5 / 2, h = 1);
                    }
                }
            }
        }

        cylinder(r = 1.2, h = 1000);
    }
}

intersection() {
    !tip();
    cube(size = [10, 10, 60], center = true);
}

