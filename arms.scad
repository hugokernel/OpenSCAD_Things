
$fn = 20;

//BRACE_WIDTH = 5;
BRACE_LENGTH = 7;

ARMS_SPACING = 20;

ARM_THICKNESS = 4;
ARM_WIDTH = 20;

module arm(width, length, height, hole = [5, 5], gap_width = 0, gap_length = 0) {

    difference() {
        hull() {
            translate([0, - length / 2, 0])
                cylinder(h = height, r1 = width / 2, r2 = width / 2);

            translate([0, length / 2, 0])
                cylinder(h = height, r1 = width / 2, r2 = width / 2);
        }

        // Hole
        translate([0, - length / 2, -1])
            cylinder(h = height + 1, r1 = hole[0] / 2, r2 = hole[0] / 2);
        translate([0, length / 2, -1])
            cylinder(h = height + 1, r1 = hole[1] / 2, r2 = hole[1] / 2);

        if (gap_width) {
            difference() {
                translate([0, 0,  height / 2])
                    cube(size = [gap_width, length - width, height * 2], center = true);
                translate([0, - length / 2, 0])
                    cylinder(h = height * 2, r1 = width / 2 + gap_length, r2 = width / 2 + gap_length);
                translate([0, length / 2, 0])
                    cylinder(h = height * 2, r1 = width / 2 + gap_length, r2 = width / 2 + gap_length);
            }
        }
    }
}

// Long arm
module long_arm() {
    difference() {
        arm(15, 135, 4, [5, 1], 0, 0);
        
        translate([0, 12.5, -1])
            cylinder(h = 20, r1 = 2.5, r2 = 2.5);
    }
}

module main_arm() {

    size = [ ARM_WIDTH, 120, ARM_THICKNESS ];
    radius = 5;

    difference() {
        union() {
            // From MCAD library
            cube(size - [2*radius,0,0], true);
            cube(size - [0,2*radius,0], true);
            for (x = [radius-size[0]/2, -radius+size[0]/2],
                   y = [radius-size[1]/2, -radius+size[1]/2]) {
                translate([x,y,0]) cylinder(r=radius, h=size[2], center=true);
            }
        }

        // Hole
        union() {
            translate([ size[0] / 2 - 12, - size[1] / 2 + 7.5, -5]) {
                cylinder(h = 10, r1 = 2.5, r2 = 2.5);
            }

            translate([ size[0] / 2 - 12, - size[1] / 2 + 47.5, -5]) {
                cylinder(h = 10, r1 = 2.5, r2 = 2.5);
            }
        }

        // Brace hole
        union() {
            translate([0, size[1] / 2 - 15, 0]) {
                cube(size = [ BRACE_LENGTH, ARM_THICKNESS, 10 ], center = true);
            }

            translate([0, - size[1] / 2 + 27, 0]) {
                cube(size = [ BRACE_LENGTH, ARM_THICKNESS, 10 ], center = true);
            }
        }
    }
}

module brace() {

    size = [ ARMS_SPACING, ARM_WIDTH, ARM_THICKNESS ];

    difference() {
        union() {
            cube(size, center = true);
            cube(size = [ size[0] + size[2] * 2, BRACE_LENGTH, ARM_THICKNESS ], center = true);

            translate([ 0, 0, size[2] ]) {
                cube(size = [ size[0], BRACE_LENGTH, ARM_THICKNESS ], center = true);
            }

            translate([ 0, 0, size[2] / 2]) {
                cylinder(h = size[2], r1 = 5, r2 = 5);
            }
        }

        translate([ 0, 0, -10 ]) {
            cylinder(h = 100, r1 = 2.5, r2 = 2.5);
        }
    }
}

//main_arm();

//brace();

//long_arm();

// Basic arm
//arm(15, 80, 4, [5, 5], 0, 0);

module mounted_arm() {

    translate([ 0, 0, ARM_THICKNESS / 2 ]) {
        main_arm();

        translate([ 0, 0, ARMS_SPACING + ARM_THICKNESS]) {
            rotate([ 0, 0, 0 ]) {
                main_arm();
            }
        }

        translate([ 0, -33, ARMS_SPACING / 2 + ARM_THICKNESS / 2 ]) {
            rotate([ 0, 90, 90 ]) {
                brace();
            }
        }

        translate([ 0, 45, ARMS_SPACING / 2 + ARM_THICKNESS / 2 ]) {
            rotate([ 0, 90, -90 ]) {
                brace();
            }
        }
    }

    translate([ -69, -52, - ARM_THICKNESS]) {
        rotate([ 0, 0, 90]) {
            long_arm();
        }
    }

    translate([ -42, -52, ARMS_SPACING + ARM_THICKNESS * 2]) {
        rotate([ 0, 0, 90]) {
            arm(15, 80, 4, [5, 5, 0, 0]);
        }
    }

    translate([ -42, -12, ARMS_SPACING + ARM_THICKNESS * 2]) {
        rotate([ 0, 0, 90]) {
            arm(15, 80, 4, [5, 5, 0, 0]);
        }
    }

    translate([ -42, -12, - ARM_THICKNESS]) {
        rotate([ 0, 0, 90]) {
            arm(15, 80, 4, [5, 5, 0, 0]);
        }
    }
}

/*

include <servos.scad>
include <bleuette.scad>;
DEBUG = 1;

translate([-100, ARMS_SPACING + 8, 0]) {
    rotate([0, 0, -90]) {
        support();

        color("GREY") translate([-9, -20.1, 13]) rotate([90, 0, 90]) futabas3003();
    }
}
*/

rotate([ -90, 0, 0])
mounted_arm();

