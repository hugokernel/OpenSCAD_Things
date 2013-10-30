
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

HANDLER_HEIGHT = 4;

module ultiHandle() {

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

            translate([0, -height - 8, 0]) {
                cube(size = [45, 10, 10], center = true);
            }
        }

        translate([0, -height - 8 - 3.6, 0]) {
            rotate([90, 0, 0]) {
                m4_nut();
            }
        }

        translate([0, 75, 0]) {
            rotate([90, 0, 0]) {
                cylinder(r = 2.05, h = 150);
            }
        }
    }

    module ultiArm() {
        length = 53;
        thickness = 15;
        difference() {
            translate([0, 0, - 37]) {
                cube(size = [thickness, 10, length], center = true);
            }

            translate([0, 3, - 64 / 2 + 0.8]) {
                cube(size = [50, 4, 6.8], center = true);
            }
        }

        translate([-thickness / 2, 9.5, -55.5]) {
            rotate([0, -90, 180]) {
                linear_extrude(height = thickness) {
                    polygon([
                        [-7,14.5],[-9,14.5],[-11,7],[-11,-4],[-5,-4],[-5,-2],[-7,-2],[-7,2],[-7,2],[-7,2]
                    ]);
                }
            }
        }
    }

    distance = height + 8;
    rotate([0, 0, 0]) {
        for (pos = [
            [15, -distance, 10],
            [-15, -distance, 10],
        ]) {
            translate(pos) {
                ultiArm();
            }
        }
    }
}

module ultimaker() {
    echo();
    translate([0, -(arm_length + HANDLER_HEIGHT) + 2, -21]) {
        cube(size = [100, 35, 5], center = true);
    
            translate([0, -11.5, -16]) {
            cube(size = [100, 5, 30], center = true);
        }
    }
}

module demo() {
    rotate([-90, 0, 0]) {
        support();
        handle();

        translate([0, -arm_length - 9, 0]) {
            verticalBase();
            ultiHandle();
        }

        ultimaker();
    }
}

if (0) {
    ultiHandle();
    //verticalBase();
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

