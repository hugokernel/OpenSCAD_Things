
use <ultimalker_headmount_female.scad>;

DEBUG = false;

$fn = 20;

module cam_support() {
    width = 16;
    length = 23;
    height = 23;

    wall_thickness = 3;

    difference() {
        cube(size = [width + wall_thickness, length + wall_thickness, height + wall_thickness]);
        
        translate([-4, wall_thickness / 2, wall_thickness / 2]) {
            cube(size = [width + 5, length, height]);
        }

        translate([width - wall_thickness, length - wall_thickness - 2, wall_thickness / 2]) {
            cube(size = [10, 6.5, 5]);
        }

        // Hole
        translate([14, 50, height / 2]) {
            rotate([90, 0, 0]) {
                cylinder(r = 1, h = 100);
            }
        }
    }
}

module arm(width, length, thickness, half = true) {
    translate([length / 2, 0, 0]) {
        difference() {
            union() {
                cube(size = [length, width, thickness], center = true);

                translate([length / 2, 0, - thickness / 2]) {
                    cylinder(r = width / 2, h = thickness);
                }

                if (!half) {
                    translate([- length / 2, 0, - thickness / 2]) {
                        cylinder(r = width / 2, h = thickness);
                    }
                }
            }

            translate([length / 2, 0, - thickness]) {
                cylinder(r = 1.5, h = 50);
            }

            if (!half) {
                translate([- length / 2, 0, - thickness]) {
                    cylinder(r = 1.5, h = 50);
                }
            }
        }
    }
}

module support_armed() {
    rotate([0, -90, 0]) {
        cam_support();
    }

    // From scratch values !!
    translate([- (23 / 2 + 1), 23 / 2 + 1.5, 19]) {
        rotate([90, -90, 0]) {
            arm(10, 15, 6);
        }
    }
}

module headmount_armed() {
    union() {
        translate([0, 0, 28]) {
            femalecoupling();
        }

        rotate([0, 0, 180]) {
            translate([15, 0, 20]) {
                rotate([90, 0, 0])
                arm(10, 15, 6);
            }
        }
    }
}

if (DEBUG) {
    translate([-5, -13, -7]) {
        rotate([0, -60, 0])
            support_armed();
    }

    headmount_armed();

    translate([-40, 0, 0])
    rotate([90, -60, 0]) {
        arm(10, 25, 3, false);
    }
} else {
    //support_armed();

    rotate([0, 90, 0]) {
        headmount_armed();
    }

    //arm(10, 15, 6);
}

