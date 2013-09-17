
use <Fan_60x25.scad>

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

module filter() {
    cube(size = [FILTER_WIDTH, FILTER_LENGTH, FILTER_THICKNESS], center = true);
}

module fan() {
    coeff_width = FAN_WIDTH / 60;
    coeff_height = FAN_THICKNESS / 25;
    scale([coeff_width, coeff_width, coeff_height]) {
        fan_60mm_x_25mm();
    }
}

PIVOT_HEIGHT = 5;
module pivot(male = true, diff = false) {
    female_diameter = 12;
    male_diameter = 20;

    if (diff) {
        //cylinder(r = 1.8, h = WIDTH * 2, center = true);
        m4_hole(WIDTH * 2);

        for (pos = [
            [0, 0, FILTER_WIDTH / 2],
            [0, 0, -FILTER_WIDTH / 2],
        ]) {
            translate(pos) {
                m4_nut(5);
                //cylinder(r = 4.0, h = 4, center = true, $fn = 6);
            }
        }
    } else {
        if (male) {
            cylinder(r = female_diameter / 2, h = PIVOT_HEIGHT, center = true);
        } else {
            difference() {
                cylinder(r = male_diameter / 2, h = PIVOT_HEIGHT * 2, center = true);
                translate([0, 0, -female_diameter / 2 + PIVOT_HEIGHT / 2 + 0.95]) {
                    cylinder(r = female_diameter / 2 + 1, h = PIVOT_HEIGHT, center = true);
                }
                m3_hole();
            }
        }
    }
}

module armUlti() {
    length = 53;
    difference() {
        translate([0, 0, - 37]) {
            cube(size = [10, 10, length], center = true);
        }

        %translate([0, 3, - 32]) {
            cube(size = [50, 4, 5.2], center = true);
        }

        translate([0, 3, - 64 / 2 + 0.8]) {
            cube(size = [50, 4, 6.8], center = true);
        }
    }

    %translate([-5, 9.5, -57]) {
        translate([0, -4.5, -5.5])
        cube(size = [10, 5, 28]);
    }

    translate([-5, 9.5, -55.5]) {
        rotate([0, -90, 180]) {
            linear_extrude(height = 10) {
                polygon([
                    [-7,14.5],[-9,14.5],[-11,7],[-11,-4],[-5,-4],[-5,-2],[-7,-2],[-7,2],[-7,2],[-7,2]
                ]);
            }
        }
    }
}

ARM_WIDTH = 10;
ARM_THICKNESS = 10;

module armsUlti() {

    for (pos = [
        [WIDTH / 2 + 5, 0, 0],
        [-WIDTH / 2 - 5, 0, 0],
    ]) {
        translate(pos) {
            armUlti();
        }
    }

    cube(size = [WIDTH + ARM_THICKNESS * 2 - ARM_THICKNESS * 2, 10, ARM_WIDTH], center = true);

    for (pos = [
        [WIDTH / 2 + ARM_THICKNESS / 2, 0, 0],
        [-WIDTH / 2 - ARM_THICKNESS / 2, 0, 0]
    ]) {
        translate(pos) {
            rotate([90, 0, 0]) {
                difference() {
                    cylinder(r = ARM_THICKNESS * 1.2, h = 10, center = true);

                    rotate([90, 0, 0]) {
                        scale([1.05, 1.05, 1.05]) {
                            cube(size = [ARM_THICKNESS, 50, ARM_WIDTH], center = true);
                        }
                    }
                }
            }
        }
    }
}

module arm() {
    length = 200;
    offset_y = 8;
    rotate([0, 90, 0]) {
        pivot(male = false);
    }

    translate([0, -length / 2 - offset_y, 0]) {
        cube(size = [ARM_THICKNESS, length, ARM_WIDTH], center = true);
    }
}

module arms() {
    length = 200;
    offset_y = 8;

/*
    for (pos = [
            [WIDTH / 2 + PIVOT_HEIGHT, 0, 0],
            [-WIDTH / 2 - PIVOT_HEIGHT, 0, 0]
        ]) {
        translate(pos) {
            arm();
        }
    }
*/
    arm();
    translate([0, -length - offset_y + 20, 0]) {

/*
        difference() {
            armHandler();

            for (pos = [
                [-WIDTH / 2 - ARM_THICKNESS / 2, length / 2, 0],
                [WIDTH / 2 + ARM_THICKNESS / 2, length / 2, 0],
            ]) {
                translate(pos) {
                    scale([1.05, 1.05, 1.05]) {
                        arm();
                    }
                }
            }
        }
*/
        //armsUlti();
    }
}

module body() {

    module pyramid() {
        width = WIDTH / 2 * sqrt(2);
        width_fan = (FAN_WIDTH) / 2 * sqrt(2) + 4;
        rotate([0, 0, 45]) {
            translate([0, 0, FILTER_THICKNESS / 2 + MARGIN_HEIGHT / 2]) {
                difference() {
                    cylinder(r1 = width, r2 = width_fan, h = PYRAMID_HEIGHT, $fn = 4);

                    translate([0, 0, -4]) {
                        cylinder(r1 = width, r2 = width_fan, h = PYRAMID_HEIGHT, $fn = 4);
                    }
                }
            }
        }
    }

    difference() {

        union() {
            cube(size = [WIDTH, FILTER_LENGTH + MARGIN, FILTER_THICKNESS + MARGIN_HEIGHT], center = true);
            pyramid();

            for (pos = [
                    [WIDTH / 2 + PIVOT_HEIGHT / 2, 0, 0],
                    [-WIDTH / 2 - PIVOT_HEIGHT / 2, 0, 0]
                ]) {
                translate(pos) {
                    rotate([0, 90, 0]) {
                        pivot();
                    }
                }
            }
        }

        cylinder(r = FAN_DIAMETER / 2, h = 100, center = true);

        scale([0.95, 0.95, 2]) {
            filter();
        }

        translate([0, -FILTER_LENGTH / 2, 0]) {
            scale([1, 1.1, 1]) {
                filter();
            }
        }

        filter();

        for (pos = [
            [ HOLE_DISTANCE, HOLE_DISTANCE, 0 ],
            [ HOLE_DISTANCE, -HOLE_DISTANCE, 0 ],
            [ -HOLE_DISTANCE, HOLE_DISTANCE , 0],
            [ -HOLE_DISTANCE, -HOLE_DISTANCE , 0],
        ]) {
            translate(pos) {
                if (HOLE_DIAMETER == "M3") {
                    m3_hole();
                    translate([0, 0, HEIGHT]) {
                        m3_nut(10);
                    }
                } else {
                    cylinder(r = HOLE_DIAMETER / 2, h = 100, center = true);

                    translate([0, 0, HEIGHT]) {
                        cylinder(r = 3, h = 10, $fn = 6);
                    }
                }
            }
        }

        rotate([0, 90, 0]) {
            pivot(diff = true);
        }

        //cube(size = [200, 200, 40], center = true);
    }
}

module m4_nut(height = 2) {
    cylinder(r = 4.3, h = height, center = true, $fn = 6);
}

module m4_hole() {
    cylinder(r = 2.2, h = WIDTH * 2, center = true);
}

module m3_nut(height = 2) {
    cylinder(r = 3.4, h = height, center = true, $fn = 6);
}

module m3_hole() {
    cylinder(r = 1.9, h = WIDTH * 2, center = true);
}

module m2_nut(height = 2) {
    cylinder(r = 2.6, h = height, center = true, $fn = 6);
}

module m2_hole() {
    cylinder(r = 1.2, h = WIDTH * 2, center = true);
}


if (0) {
    difference() {
        cube(size = [35, 12, 4], center = true);

        // M4
        translate([-10, 0, 1.5]) {
            m4_hole();
            m4_nut();
        }

        // M2
        translate([10, 0, 1.5]) {
            m2_hole();
            m2_nut();
        }

        // M3
        translate([0, 0, 1.5]) {
            m3_hole();
            m3_nut();
        }
    }
} else {
    //body();
    intersection() {
    cube(size = [50, 50, 50], center = true);
    arms();
    }
    //armUlti();
}

//translate([0, 0, HEIGHT / 2]) {
//    cube(size = [10, 10, HEIGHT], center = true);
//}

translate([0, 0, HEIGHT + PYRAMID_HEIGHT]) {
    //%fan();
}

//translate([0, -10, 0])
//    %filter();

