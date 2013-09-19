
use <main.scad>

$fn = 60;

FILTER_WIDTH = 134;
FILTER_LENGTH = 134;
FILTER_THICKNESS = 10;

FAN_WIDTH=120;
//FAN_WIDTH=80;
FAN_THICKNESS=25;
FAN_DIAMETER=120;
//FAN_DIAMETER=70;

HEIGHT=22;

HOLE_DISTANCE = 105 / 2;
HOLE_DIAMETER = "M3";

MARGIN = 10;
MARGIN_HEIGHT = 7;

PYRAMID_HEIGHT = 20;

/*
 *  AUTOMATICALLY GENERATED VARIABLE
 *  DO NOT TOUCH THIS !
 */
WIDTH = FILTER_WIDTH + MARGIN;

ARM_THICKNESS = 7;
PIVOT_MALE_DIAMETER = 16;

arm_thickness = ARM_THICKNESS;
arm_length = 95;
offset = 1;
offset_arm = 6;

module handleVerticalBase() {
    coeff = 1.06;
    difference() {
        cyl();

        scale([coeff, coeff, coeff]) {
            arm(10, arm_thickness, false);
        }

        translate([0, 10, 0]) {
            rotate([90, 0, 0]) {
                cylinder(r = 2.05, h = 20);
            }
        }
    }
}

module handleVertical() {

    height = 40;

    // Arm
    difference() {
        union() {
            translate([0, 0, 0]) {
                arm(3, arm_thickness, false);
            }

            translate([0, -3, 0]) {
                arm(height, arm_thickness, true);
            }
        }

        rotate([90, 0, 0]) {
            cylinder(r = 2.05, h = 150);
        }
    }

    module armUlti() {
        length = 53;
        thickness = 5;
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

    translate([0, -height - 8, 0]) {
        cube(size = [45, 10, 10], center = true);
    }

    distance = height + 8;
    rotate([0, 0, 0]) {
        for (pos = [
            [20, -distance, 10],
            [-20, -distance, 10],
        ]) {
            translate(pos) {
                armUlti();
            }
        }
    }
}

module demo() {
    rotate([-90, 0, 0]) {
        body();
        handle();

        translate([0, -arm_length - 9, 0]) {
            handleVerticalBase();
            handleVertical();
        }
    }
}

demo();

