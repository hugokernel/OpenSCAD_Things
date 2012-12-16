
$fn = 30;

/**
 *  Fan parameters
 */
FAN_WIDTH = 61;
FAN_THICKNESS = 10;
FAN_HOLE_WIDTH = 50;
FAN_DIAMETER = 58;
FAN_SCREW_DIAMETER = 2;

SUPPORT_WIDTH = 90;
SUPPORT_LENGTH = 180;
SUPPORT_THICKNESS = 5.5;

use <MCAD/boxes.scad>;

module fix() {

    cylinder(r = 3.5, h = SUPPORT_THICKNESS * 2);
    
    translate([0, 7, 0]) {
        cylinder(r = 1.5, h = SUPPORT_THICKNESS * 2);
    }

    translate([0, 2, 0]) {
        cube([3, 10, SUPPORT_THICKNESS * 4], center = true);
    }
}

module fan() {
    roundedBox([FAN_WIDTH, FAN_WIDTH, FAN_THICKNESS], 7, true);

    translate([0, 0, -20]) {
        cylinder(r = FAN_DIAMETER / 2, h = 20);
    }

    // Hole
    translate([- FAN_HOLE_WIDTH / 2, - FAN_HOLE_WIDTH / 2, -30]) {
        cylinder(r = FAN_SCREW_DIAMETER / 2, h = 100);
    }

    translate([- FAN_HOLE_WIDTH / 2, FAN_HOLE_WIDTH / 2, -30]) {
        cylinder(r = FAN_SCREW_DIAMETER / 2, h = 100);
    }

    translate([FAN_HOLE_WIDTH / 2, - FAN_HOLE_WIDTH / 2, -30]) {
        cylinder(r = FAN_SCREW_DIAMETER / 2, h = 100);
    }

    translate([FAN_HOLE_WIDTH / 2, FAN_HOLE_WIDTH / 2, -30]) {
        cylinder(r = FAN_SCREW_DIAMETER / 2, h = 100);
    }
}

module support() {
    difference() {
        union() {
            // Main
            roundedBox([SUPPORT_WIDTH, SUPPORT_LENGTH, SUPPORT_THICKNESS], 7, true);
        
            translate([0, 42, SUPPORT_THICKNESS / 2]) {
                roundedBox([FAN_WIDTH + 8, FAN_WIDTH + 8, 6], 7, true);
            }
        }


        translate([0, 42, 6]) {
            rotate([-6, 0, 0]) {
            //rotate([0, 0, 0]) {
                fan();
            }
        }

        // Hole
        translate([SUPPORT_WIDTH / 2 - 6.5, - SUPPORT_LENGTH / 2 + 16, - SUPPORT_THICKNESS]) {
            fix();
        }

        translate([-SUPPORT_WIDTH / 2 + 6.5, - SUPPORT_LENGTH / 2 + 16, - SUPPORT_THICKNESS]) {
            fix();
        }

        translate([SUPPORT_WIDTH / 2 - 6.5, - SUPPORT_LENGTH / 2 + 165, - SUPPORT_THICKNESS]) {
            fix();
        }

        translate([-SUPPORT_WIDTH / 2 + 6.5, - SUPPORT_LENGTH / 2 + 95, - SUPPORT_THICKNESS]) {
            fix();
        }
    }
}

support();

//fan();

