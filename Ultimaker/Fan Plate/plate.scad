
$fn = 30;

/**
 *  Fan parameters
 */
FAN_WIDTH = 61;
FAN_THICKNESS = 10;
FAN_HOLE_WIDTH = 50;
FAN_DIAMETER = 58;
FAN_SCREW_DIAMETER = 2;
FAN_CORNER_DIAMETER = 2;

SUPPORT_WIDTH = 86;
SUPPORT_LENGTH = 180;
SUPPORT_THICKNESS = 5.5;

use <../../MCAD/boxes.scad>;

module fix() {
    cylinder(r = 3.5, h = SUPPORT_THICKNESS * 2);

    translate([0, 7, 0]) {
        cylinder(r = 1.5, h = SUPPORT_THICKNESS * 2);
    }

    translate([0, 2, 0]) {
        cube([3, 10, SUPPORT_THICKNESS * 4], center = true);
    }
}

module fixs(clearance = false) {
    translate([35, - SUPPORT_LENGTH / 2 + 16, - SUPPORT_THICKNESS]) {
        if (clearance) {
            fix_clearance();
        } else {
            fix();
        }
    }

    translate([-35, - SUPPORT_LENGTH / 2 + 16, - SUPPORT_THICKNESS]) {
        if (clearance) {
            fix_clearance();
        } else {
            fix();
        }
    }

    translate([35, - SUPPORT_LENGTH / 2 + 163, - SUPPORT_THICKNESS]) {
        if (clearance) {
            fix_clearance();
        } else {
            fix();
        }
    }

    translate([-35, - SUPPORT_LENGTH / 2 + 95, - SUPPORT_THICKNESS]) {
        if (clearance) {
            fix_clearance();
        } else {
            fix();
        }
    }
}

module fix_clearance() {
    cylinder(r = 3.5, h = SUPPORT_THICKNESS * 2);

    translate([0, 7, 0]) {
        cylinder(r = 3.5, h = SUPPORT_THICKNESS * 2);
    }

    translate([0, 3, 0]) {
        cube([7, 7, SUPPORT_THICKNESS * 4], center = true);
    }
}

module fan() {
    roundedBox([FAN_WIDTH, FAN_WIDTH, FAN_THICKNESS], FAN_CORNER_DIAMETER, true);

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
        roundedBox([SUPPORT_WIDTH, SUPPORT_LENGTH, SUPPORT_THICKNESS], 7, true);

        translate([0, - SUPPORT_LENGTH / 2 + 40, 0]) {
            roundedBox([60, 70, SUPPORT_THICKNESS * 2], 7, true);
        }

        translate([0, 50, 0]) {
            roundedBox([60, 70, SUPPORT_THICKNESS * 2], 7, true);
        }

        // Hole
        fixs();
    }

    translate([0, 0, SUPPORT_THICKNESS]) {
        legs(true);
    }
}

module leg(male = false) {

    width = 7;
    length = 5;
    thickness = SUPPORT_THICKNESS + 1;

    connector_radius = 2;
    clearance = 0.1;

    RADIUS = 2;

    if (male) {
        translate([0, length / 2, 0]) {
            cylinder(r = connector_radius - clearance, h = thickness + 2, center = true);
        }
    } else {
        difference() {
            union() {
                union() {
                    cube(size = [width, length, thickness], center = true);

                    translate([0, length / 2, 0]) {
                        cylinder(r = width / 2, h = thickness, center = true);
                    }
                }

                difference() {
                    translate([0, - length / 2 + RADIUS / 2, 0]) {
                        cube(size = [width + RADIUS * 2, RADIUS, thickness], center = true);
                    }

                    translate([(width + RADIUS * 2) / 2, (- length / 2 + RADIUS / 2) + RADIUS / 2, -5]) {
                        cylinder(r = RADIUS, h = 20);
                    }

                    translate([- (width + RADIUS * 2) / 2, (- length / 2 + RADIUS / 2) + RADIUS / 2, -5]) {
                        cylinder(r = RADIUS, h = 20);
                    }
                }
            }
            
            translate([0, length / 2, 0]) {
                cylinder(r = 2, h = thickness + 10, center = true);
            }
        }
    }
}

module legs(male = false) {
    translate([SUPPORT_WIDTH / 2 - 6.5, - SUPPORT_LENGTH / 2 + 35, 0]) {
        rotate([0, 0, -90]) {
            leg(male);
        }
    }

    translate([SUPPORT_WIDTH / 2 - 6.5, - SUPPORT_LENGTH / 2 + 85, 0]) {
        rotate([0, 0, -90]) {
            leg(male);
        }
    }

    translate([SUPPORT_WIDTH / 2 - 6.5, SUPPORT_LENGTH / 2 - 65, 0]) {
        rotate([0, 0, -90]) {
            leg(male);
        }
    }

    translate([SUPPORT_WIDTH / 2 - 6.5, SUPPORT_LENGTH / 2 - 30, 0]) {
        rotate([0, 0, -90]) {
            leg(male);
        }
    }


    translate([- SUPPORT_WIDTH / 2 + 6.5, - SUPPORT_LENGTH / 2 + 35, 0]) {
        rotate([0, 0, 90]) {
            leg(male);
        }
    }

    translate([- SUPPORT_WIDTH / 2 + 6.5, - SUPPORT_LENGTH / 2 + 85, 0]) {
        rotate([0, 0, 90]) {
            leg(male);
        }
    }

    translate([- SUPPORT_WIDTH / 2 + 6.5, SUPPORT_LENGTH / 2 - 65, 0]) {
        rotate([0, 0, 90]) {
            leg(male);
        }
    }

    translate([- SUPPORT_WIDTH / 2 + 6.5, SUPPORT_LENGTH / 2 - 20, 0]) {
        rotate([0, 0, 90]) {
            leg(male);
        }
    }
}

module fan_support() {

    difference() {
        roundedBox([SUPPORT_WIDTH - 18, SUPPORT_LENGTH - 8, SUPPORT_THICKNESS + 1], 7, true);

        translate([0, 50, 5]) {
            rotate([-6, 0, 0]) {
                fan();
            }
        }

        translate([0, -50, 5]) {
            rotate([-6, 0, 0]) {
                fan();
            }
        }

        fixs(true);
    }

    legs();
}


%support();

translate([0, 0, SUPPORT_THICKNESS+1]) {
    %fan_support();
}

translate([0, -50, 7.5]) {
    rotate([-6, 0, 0]) {
<<<<<<< HEAD
roundedBox([FAN_WIDTH, FAN_WIDTH, 2], FAN_CORNER_DIAMETER, true);
=======
        %roundedBox([FAN_WIDTH, FAN_WIDTH, 2], FAN_CORNER_DIAMETER, true);
>>>>>>> 45260e9129cb78fc8d4e880e83418701329745d9
    }
}

