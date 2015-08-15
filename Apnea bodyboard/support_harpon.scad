
$fn = 30;

WIDTH = 60;
HEIGHT = 30;
LENGTH = 80;

HOLE_DIAMETER = 6.1;
HOLE_COUNT = 2;

BASE_HEIGHT = 5;

module nut() {
    nut_diameter = 11.2;
    nut_clear = 0.2;
    nut_height = 4.6 + 1.5;
    cylinder(r = nut_diameter / 2 + nut_clear, h = nut_height, $fn = 6);
}

module oblong(width = 40, height = HEIGHT, length = LENGTH * 2) {
    hull() {
        translate([-width / 2 + height / 2, 0, 0]) {
            cylinder(r = height / 2, h = length, center = true);
        }
        translate([width / 2 - height / 2, 0, 0]) {
            cylinder(r = height / 2, h = length, center = true);
        }
    }
}

module support() {
    width = WIDTH;
    height = HEIGHT / 2;
    base_height = BASE_HEIGHT;
    length = LENGTH;

    holder_diameter = 15;

    flag_support_diameter = 8;

    difference() {
        union() {
            translate([0, 0, -height / 2 - base_height / 2]) {
                cube(size = [width, length, base_height], center = true);
            }
            difference() {
                translate([0, 0, 0]) {
                    cube(size = [width, length, height], center = true);
                }
                translate([-5, 0, 10]) {
                    rotate([90, 0, 0]) {
                        oblong();
                    }
                }

                // Flag support
                translate([22, 0, height / 2]) {
                    translate([0, 0, - 4]) {
                        rotate([90, 0, 0]) {
                            cylinder(r = flag_support_diameter / 2, h = 100, center = true);
                        }
                    }
                    cube(size = [ flag_support_diameter, 100, flag_support_diameter ], center = true);
                }
            }
        }
        translate([-WIDTH, 0, -height / 2 - base_height / 2 - holder_diameter / 2 - 11]) {
            rotate([0, 90, 0]) {
                rotate([0, 0, 30]) {
                    cylinder(r = holder_diameter / 2 + 16, h = WIDTH * 2, $fn = 6);
                }
            }
        }

        translate([-WIDTH, 0, 23]) {
            rotate([0, 90, 0]) {
                rotate([0, 0, 30]) {
                    cylinder(r = holder_diameter / 2 + 16, h = WIDTH * 2, $fn = 6);
                }
            }
        }
    }
}

module main() {
    difference() {
        intersection() {
            support();
            rotate([0, 0, 90]){ 
                oblong(width=LENGTH, height=60, length=HEIGHT + BASE_HEIGHT);
            }
        }
        for (pos = [-LENGTH / 2 : LENGTH / HOLE_COUNT : LENGTH / 2]) {
            translate([-5, pos + (LENGTH / HOLE_COUNT) / 2, -10.7]) {
                nut();
                cylinder(r = HOLE_DIAMETER / 2, h = 15, center = true);
            }
            /*
            translate([0, pos + (LENGTH / HOLE_COUNT) / 2, -14]) {
                cylinder(r = HOLE_DIAMETER / 2, h = 15, center = true);
                translate([0, 0, 7.5]) {
                    cylinder(r = 10, h = 5, center = true);
                }
            }
            */
        }
    }
}

intersection() {
    translate([20, 10, 6]) {
        cube(size = [ 20, 20, 20], center = true);
    }
    main();
}

!main();

/*
!union() {
    main();
    %translate([0, 0, 5])
        cube(size = [100, 25, 1], center = true);
}
*/

//!support();

