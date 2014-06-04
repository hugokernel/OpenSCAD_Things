
$fn = 40;

use <lib/Thread_Library.scad>
//use <tip_OLD.scad>

BEARING_INTERNAL_DIAMETER = 7.8;
BEARING_HEIGHT = 7;

TUBE_DIAMETER = 4;
TUBE_CLEARANCE = 0.9;
TUBE_CLEARANCE_JAM = 0.32;

LINK_HEIGHT = 42;

WASHER_THICKNESS = 1.1;
WASHER_DIAMETER = 12;
WASHER_INTERNAL_DIAMETER = 5;

module tube(diameter = 4, thickness = 0.4, length = 115) {
    difference() {
        cylinder(r = diameter / 2, h = length);
        translate([0, 0, -0.5]) {
            cylinder(r = diameter / 2 - thickness / 2, h = length + 1);
        }
    }
}

module blocker(length = 6, diameter = TUBE_DIAMETER + TUBE_CLEARANCE_JAM, thickness = 2, hole_diameter = 0.7) {
    difference() {
        cylinder(r = diameter / 2 + thickness, h = length);
        translate([0, 0, -1]) {
            cylinder(r = diameter / 2, h = length + 2);
        }

        translate([0, 0, length / 2]) {
            rotate([0, 90, 0]) {
                cylinder(r = hole_diameter, h = diameter * 2, center = true);
            }
        }
    }
}

module blocker_big(chamfrein = true) {
    diameter = BEARING_INTERNAL_DIAMETER + 0.3;
    thickness = 2;

    blocker(diameter = diameter, thickness = thickness);

    if (chamfrein) {
        difference() {
            hull() {
                translate([0, 0, 6]) {
                    blocker(diameter = diameter, thickness = thickness, length = .1);
                }

                translate([0, 0, 11]) {
                    blocker(diameter = diameter, thickness = 0.5, length = .1);
                }
            }

            cylinder(r = diameter / 2, h = 20);
        }
    }
}

module spring() {

}

thread_length = 8;
module thread(male = true) {
    if (male) {
        trapezoidThread(
            length=thread_length, 				// axial length of the threaded rod
            pitch=1.5,				 // axial distance from crest to crest
            pitchRadius=BEARING_INTERNAL_DIAMETER / 2 - .25, 			// radial distance from center to mid-profile
            threadHeightToPitch=0.5, 	// ratio between the height of the profile and the pitch
                                // std value for Acme or metric lead screw is 0.5
            profileRatio=0.5,			 // ratio between the lengths of the raised part of the profile and the pitch
                                // std value for Acme or metric lead screw is 0.5
            threadAngle=30, 			// angle between the two faces of the thread
                                // std value for Acme is 29 or for metric lead screw is 30
            RH=true, 				// true/false the thread winds clockwise looking along shaft, i.e.follows the Right Hand Rule
            clearance=0.1, 			// radial clearance, normalized to thread height
            backlash=0.1, 			// axial clearance, normalized to pitch
            stepsPerTurn=24 			// number of slices to create per turn
        );
    } else {
        trapezoidNut(
            length=thread_length,				// axial length of the threaded rod
            radius=BEARING_INTERNAL_DIAMETER / 2 + 2,				// outer radius of the nut
            pitch=1.5,				// axial distance from crest to crest
            pitchRadius=BEARING_INTERNAL_DIAMETER / 2,			// radial distance from center to mid-profile
            threadHeightToPitch=0.5,	// ratio between the height of the profile and the pitch
                                // std value for Acme or metric lead screw is 0.5
            profileRatio=0.5,			// ratio between the lengths of the raised part of the profile and the pitch
                                // std value for Acme or metric lead screw is 0.5
            threadAngle=30,			// angle between the two faces of the thread
                                // std value for Acme is 29 or for metric lead screw is 30
            RH=true,				// true/false the thread winds clockwise looking along shaft, i.e.follows the Right Hand Rule
            countersunk=0,			// depth of 45 degree chamfered entries, normalized to pitch
            clearance=0.1,			// radial clearance, normalized to thread height
            backlash=0.1,			// axial clearance, normalized to pitch
            stepsPerTurn=24			// number of slices to create per turn
        );
    }
}

LINK_HEIGHT = 47;
module link() {
    bearing_clear = 0.055;

    difference() {
        union() {
            cylinder(r = BEARING_INTERNAL_DIAMETER / 2 + bearing_clear, h = LINK_HEIGHT);

            /*
            translate([0, 0, 14]) {
                hull() {
                    cylinder(r = 12 / 2, h = 4);
                    translate([0, 0, 4]) {
                        cylinder(r = BEARING_INTERNAL_DIAMETER / 2, h = 5);
                    }
                }
                //cylinder(r = 12 / 2, h = LINK_HEIGHT - thread_length);
            }
            */

            translate([0, 0, LINK_HEIGHT - thread_length]) {
                hull() {
                    cylinder(r = BEARING_INTERNAL_DIAMETER / 2, h = 5);
                    translate([0, 0, 4]) {
                        cylinder(r = 12 / 2, h = 4);
                    }
                }
            }

            translate([0, 0, LINK_HEIGHT - 0.3]) {
                thread();
            }
        }

        translate([0, 0, -0.5]) {
            cylinder(r = (TUBE_DIAMETER + TUBE_CLEARANCE) / 2, h = 100);
        }

        for (pos = [
            [0, 0, BEARING_HEIGHT / 2 + 13 - 0.5],
            [0, 0, BEARING_HEIGHT / 2 - 0.5]
        ]) {
            translate(pos) {
                rotate([0, 90, 0]) {
                    cylinder(r = 0.7, h = 50, center = true);
                }
            }
        }
    }
}

module washer(diameter = WASHER_DIAMETER, internal_diameter = WASHER_INTERNAL_DIAMETER, thickness = WASHER_THICKNESS) {
    color("GREY")
    difference() {
        cylinder(r = diameter / 2, h = thickness);
        cylinder(r = internal_diameter / 2, h = thickness * 4, center = true);
    }
}

module cuff() {
    internal_diameter = 10;
    height = 20;
    base_height = 10;

    difference() {
        union() {
            hull() {
                cylinder(r = BEARING_INTERNAL_DIAMETER / 2 + 2, h = 5);

                translate([0, 0, base_height]) {
                    cylinder(r = 12, h = 0.01, $fn = 12);
                }
            }

            translate([0, 0, base_height]) {
                cylinder(r = 12, h = height, $fn = 12);
            }
        }

        translate([0, 0, base_height - WASHER_THICKNESS + .1]) {
            scale([1.07, 1.07, 1.07]) {
                washer(thickness = WASHER_THICKNESS * 2);
            }
        }

        translate([0, 0, -1]) {
            cylinder(r = BEARING_INTERNAL_DIAMETER / 2 + 0.5, h = 22);
        }

        translate([0, 0, 10]) {
            cylinder(r = internal_diameter, h = 22, $fn = 80);
        }
    }

    /*
    translate([0, 0, base_height]) {
        washer();
    }
    */

    thread(male = false);

    module rail() {
        difference() {
            cube(size = [size, size, height], center = true);
            translate([0, 0, -10]) {
                rotate([0, -45, 0]) {
                    cube(size = [size, size * 2, 20], center = true);
                }
            }

            translate([-size / 2, 0, 0]) {
                cube(size = [4, 2, 50], center = true);
            }
        }
    }

    size = 6;
    translate([0, 0, 20]) {
        for (rot = [
            [0, 0, 0],
            [0, 0, 180]
        ]) {
            rotate(rot) {
                translate([internal_diameter / 2 + size / 2, 0, 0]) {
                    rail();
                }
            }
        }
    }
}

module cuff_internal() {
    size = 6;
    size_clear = .7;
    internal_diameter = 10 - .5;
    height = 19;

    %difference() {
        union() {
            hull() {
                cylinder(r = internal_diameter - 2, h = 2, $fn = 80);
                translate([0, 0, 2]) {
                    cylinder(r = internal_diameter, h = height - 2 * 2, $fn = 80);
                }
                translate([0, 0, height - 2]) {
                    cylinder(r = internal_diameter - 2, h = 2, $fn = 80);
                }
            }

            /*
            translate([0, 0, height - .2]) {
                thread();
            }
            */
        }

        for (pos = [
            [internal_diameter / 2 + size / 2, 0, 0],
            [-internal_diameter / 2 - size / 2, 0, 0]
        ]) {
            translate(pos) {
                cube(size = [size + size_clear, size + size_clear, 80], center = true);
            }
        }

        translate([0, 0, -1]) {
            cylinder(r = (TUBE_DIAMETER + TUBE_CLEARANCE_JAM) / 2, h = 100);
        }

        // Contact holes
        for (pos = [
            [ -3, -2, -1 ],
            [ -3, 2, -1 ],
            [ 3, -2, -1 ],
            [ 3, 2, -1 ]
        ]) {
             translate(pos) {
                cylinder(r = 0.7, h = height * 2);
            }
        }

        translate([0, 0, height]) {
            cylinder(r = 6, h = 5, center = true);
        }
    }

    difference() {
        // Cap
        translate([0, 0, height - 1]) {
            cylinder(r = 5.8, h = 3, center = true);
        }

        translate([0, 0, height - 2]) {
            cylinder(r = 4.7, h = 3, center = true);
        }

        translate([0, 0, -1]) {
            cylinder(r = (TUBE_DIAMETER + TUBE_CLEARANCE) / 2, h = 100);
        }

        for (pos = [
            [-4.1, 0, 0],
            [4.1, 0, 0]
        ]) {
            translate(pos) {
                cylinder(r = 0.6, h = 100);
            }
        }

        translate([0, 0, height - 2]) {
            cube(size = [20, size, 2], center = true);
        }
    }
}

/*
intersection() {
    !tip();
    cube(size = [10, 10, 60], center = true);
}
*/

module demo(exploded = 0) {

    offset = $t;

    translate([0, 0, offset]) {
        color([0.9, 0.9, 0.9]) {
            tube(diameter = TUBE_DIAMETER);
        }
    }

    translate([0, 0, 10 + offset]) {
        blocker();
    }

    translate([0, 0, 30]) {
        link();
   
        for (data = [
            [0, 0, 13 + offset, 1],
            [0, 0, offset, 0]
        ]) {
            translate([data[0], data[1], data[2]]) {
                blocker_big(chamfrein = data[3]);
            }
        }
    }

/*
module blocker(length = 6, diameter = TUBE_DIAMETER + TUBE_CLEARANCE_JAM, thickness = 2) {
            translate([0, 0, 14]) {
                hull() {
                    cylinder(r = 12 / 2, h = 4);
                    translate([0, 0, 4]) {
                        cylinder(r = BEARING_INTERNAL_DIAMETER / 2, h = 5);
                    }
                }
                //cylinder(r = 12 / 2, h = LINK_HEIGHT - thread_length);
            }
*/
    translate([0, 0, 30 + LINK_HEIGHT + exploded]) {
        cuff();

        translate([0, 0, 11 + exploded + offset]) {
            cuff_internal();
        }
    }
}

module test() {
    /*
    intersection() {
        cuff();
        cube(size = [15, 15, 20], center = true);
    }
    */

    intersection() {
        link();
        translate([0, 0, 50]) {
            cube(size = [15, 15, 30], center = true);
        }
    }
}

demo();
demo(exploded = 25);
test();

!link();

cuff();

intersection() {
    cuff();
    translate([0, 0, 10])
    cube(size = [22, 22, 5], center = true);
}

union() {
    //%cuff();
    //translate([0, 0, 10])
    cuff_internal();
}

blocker();
blocker_big();
blocker_big(chamfrein = false);

