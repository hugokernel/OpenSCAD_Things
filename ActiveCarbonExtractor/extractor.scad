
use <main.scad>

$fn = 60;

/*
 *  AUTOMATICALLY GENERATED VARIABLE
 *  DO NOT TOUCH THIS !
 */
ARM_THICKNESS = 7;

arm_thickness = ARM_THICKNESS;
arm_length = 95;
offset = 1;
offset_arm = 6;

HANDLER_HEIGHT = 3;

/*
module attach() {

    height = HANDLER_HEIGHT;

    // Arm
    difference() {
        union() {
            translate([0, 0, 0]) {
                arm(3, arm_thickness, false);
            }

            translate([0, -3, 0]) {
                arm(height, arm_thickness, true);
            }

/*
            translate([0, -height - 8, 0]) {
                cube(size = [10, 10, 10], center = true);
            }
        }

        translate([0, -height - 8 - 3.6, 0]) {
            rotate([90, 0, 0]) {
                m4_nut();
            }
        }
*-/

        }

        translate([0, 75, 0]) {
            rotate([90, 0, 0]) {
                cylinder(r = 2.05, h = 150);
            }
        }
    }

    thickness = 4;
    difference() {
        translate([0, -16, 0]) {
            cube(size = [thickness, 20, 10], center = true);
        }

        translate([0, -16, 0]) {
            rotate([0, 90, 0]) {
               cylinder(r = 1.5, h = 10, center = true);
            }
        }
    }
}
*/

module attach() {

    height = HANDLER_HEIGHT;

    // Arm
    difference() {
        union() {
            translate([0, -height, 0]) {
                cube(size = [7, 10, 10], center = true);
            }

            translate([0, -height - 3, 0]) {
                cube(size = [10, 5, 10], center = true);
            }
        }

        translate([0, -height - 4.6, 0]) {
            rotate([90, 90, 0]) {
                m4_nut();
            }
        }

        translate([0, 75, 0]) {
            rotate([90, 0, 0]) {
                cylinder(r = 2.05, h = 150);
            }
        }
    }

/*
    %translate([0, 0, 0]) {
        cube(size = [7, 100, 10], center = true);
    }
*/
    arm_spacing = 8;

    module arm() {
        diameter = 4;
        length = 12;
        difference() {
            union() {
                translate([-2, -length / 2, 0]) {
                    rotate([0, 90, 0]) {
                        cylinder(r = 5, h = 4);
                    }
                }

                cube(size = [4, length, 10], center = true);
            }

            translate([-2, -length / 2, 0]) {
                rotate([0, 90, 0]) {
                    cylinder(r = 2, h = 50, center = true);
                }
            }
        }
    }

    for (pos = [
        [arm_spacing / 2 + 2, -9.5, 0],
        [-arm_spacing / 2 - 2, -9.5, 0]
    ]) {
        translate(pos) {
            arm();
        }
    }
}

module demo() {
    rotate([-90, 0, 0]) {
        support();
        handle();

        translate([0, -arm_length - 9, 0]) {
            verticalBase();
            attach();
        }
    }
}

if (1) {
    attach();
    %verticalBase();
    //handle();
/*
    %difference() {
        pivot(true);
        pivot(true, true);
    }
    pivot(false);
*/
} else {
    demo();
}

