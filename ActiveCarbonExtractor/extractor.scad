
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
*/

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

if (0) {
    attach();
    verticalBase();
    handle();
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

