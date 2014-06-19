
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

module blocker( length = 6,
                diameter = TUBE_DIAMETER + TUBE_CLEARANCE_JAM,
                thickness = 2,
                hole_diameter = 0.7,
                extra_clear = 0) {
    difference() {
        cylinder(r = diameter / 2 + thickness, h = length);
        translate([0, 0, -1]) {
            cylinder(r = diameter / 2 + extra_clear, h = length + 2);
        }

        translate([0, 0, length / 2]) {
            rotate([0, 90, 0]) {
                cylinder(r = hole_diameter, h = diameter * 2, center = true);
            }
        }
    }
}

module blocker_big(chamfrein = true, extra_clear = 0) {
    diameter = BEARING_INTERNAL_DIAMETER + 0.3;
    thickness = 2;

    blocker(diameter = diameter, thickness = thickness, extra_clear = extra_clear);

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

            cylinder(r = diameter / 2 + extra_clear, h = 20);
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
    bearing_clear = 0.20;

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

            //translate([0, 0, 12.5]) {
            translate([0, 0, 26]) {
                cylinder(   r1 = BEARING_INTERNAL_DIAMETER / 2 + bearing_clear,
                            r2 = BEARING_INTERNAL_DIAMETER / 2 + bearing_clear + 1,
                            h = 1);
            }

            translate([0, 0, 27]) {
                cylinder(   r = BEARING_INTERNAL_DIAMETER / 2 + bearing_clear + 1,
                            h = 3);
            }

            translate([0, 0, 30]) {
                cylinder(   r1 = BEARING_INTERNAL_DIAMETER / 2 + bearing_clear + 1,
                            r2 = BEARING_INTERNAL_DIAMETER / 2 + bearing_clear,
                            h = 1);
            }
        }

        translate([0, 0, -0.5]) {
            cylinder(r = (TUBE_DIAMETER + TUBE_CLEARANCE) / 2, h = 100);
        }

        // Useless...
        %for (pos = [
            [0, 0, BEARING_HEIGHT / 2 + 13 - 0.5],
            [0, 0, BEARING_HEIGHT / 2 - 0.5]
        ]) {
            translate(pos) {
                rotate([0, 90, 0]) {
                    cylinder(r = 0.7, h = 50, center = true);
                }
            }
        }

        /*
        %for (data = [
            [0, 0, 13 + 0, 1],
            [0, 0, 0, 0]
        ]) {
            translate([data[0], data[1], data[2]]) {
                blocker_big(chamfrein = data[3]);
            }
        }
        */
    }
}

module washer(diameter = WASHER_DIAMETER, internal_diameter = WASHER_INTERNAL_DIAMETER, thickness = WASHER_THICKNESS) {
    color("GREY")
    difference() {
        cylinder(r = diameter / 2, h = thickness);
        cylinder(r = internal_diameter / 2, h = thickness * 4, center = true);
    }
}

cuff_internal_radius = 10;
cuff_external_radius = 16;

cap_thread_length = 8;
module cap_thread(male = true) {
    diameter = cuff_internal_radius + cuff_external_radius - 1.5;
    if (male) {
        trapezoidThread(
            length=cap_thread_length, 				// axial length of the threaded rod
            pitch=1.5,				 // axial distance from crest to crest
            pitchRadius=diameter / 2 - .25, 			// radial distance from center to mid-profile
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
            length=cap_thread_length,				// axial length of the threaded rod
            radius=diameter / 2 + 3,				// outer radius of the nut
            pitch=1.5,				// axial distance from crest to crest
            pitchRadius=diameter / 2,			// radial distance from center to mid-profile
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

module cuff() {
    height = 35;
    base_height = 10;

    difference() {
        union() {
            hull() {
                cylinder(r = BEARING_INTERNAL_DIAMETER / 2 + 2, h = 5);

                translate([0, 0, base_height]) {
                    cylinder(r = cuff_external_radius, h = 0.01, $fn = 12);
                }
            }

            translate([0, 0, base_height]) {
                cylinder(r = cuff_external_radius, h = height, $fn = 12);
            }

            translate([0, 0, base_height + height - .1]) {
                cap_thread();//male = false);
            }
        }

        translate([0, 0, base_height - WASHER_THICKNESS + .1]) {
            scale([1.07, 1.07, 1.07]) {
                washer(thickness = WASHER_THICKNESS * 2);
            }
        }

        translate([0, 0, -1]) {
            cylinder(r = BEARING_INTERNAL_DIAMETER / 2 + 0.5, h = height * 2);
        }

        translate([0, 0, 10]) {
            cylinder(r = cuff_internal_radius, h = height * 2, $fn = 80);
        }

        /*
        translate([0, 0, height + 1.99]) {
            cylinder(r = cuff_internal_radius + 2, h = thread_length);
        }
        */
    }

    /*
    translate([0, 0, base_height]) {
        washer();
    }
    */

    thread(male = false);

    module rail() {
        difference() {
            cube(size = [size, size, 20], center = true);
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
                translate([cuff_internal_radius / 2 + size / 2, 0, 0]) {
                    rail();
                }
            }
        }
    }
}

module cuff_cap() {
    difference() {
        union() {
            //cylinder(r = cuff_external_radius, h = cap_thread_length, $fn = 12);

            hull() {
                cylinder(r = cuff_external_radius, $fn = 12);

                for (data = [
                    [ cap_thread_length, cuff_external_radius ],
                    [ cap_thread_length + 5, cuff_external_radius - 3 ],
                    [ cap_thread_length + 9, cuff_external_radius - 9 ],
                ]) {
                    translate([0, 0, data[0]]) {
                        cylinder(r = data[1], $fn = 12);
                    }
                }
            }

            /*
            translate([0, 0, cap_thread_length - 0.1]) {
                difference() {
                    sphere(r = cuff_external_radius, $fn = 12);
                    translate([0, 0, - cuff_external_radius / 2]) {
                        cube(size = [50, 50, cuff_external_radius], center = true);
                    }
                }
            }
            */
        }

        translate([0, 0, -1]) {
            cylinder(r = cuff_internal_radius + 3, h = 10);
            cylinder(r = (TUBE_DIAMETER + TUBE_CLEARANCE) / 2 + 2, h = 50);
        }
    }

    cap_thread(male = false);
}

module cuff_internal() {
    size = 6;
    size_clear = .7;
    cuff_internal_radius = cuff_internal_radius - .5;
    height = 19;
    hole_diameter = 0.7;

    module hole() {
        translate([0, cuff_internal_radius, 0]) {
            rotate([90, 0, 0]) {
                cylinder(r = 2.3, h = 5);
                cylinder(r = hole_diameter, h = 8);
            }
        }
    }

    difference() {
        union() {
            hull() {
                cylinder(r = cuff_internal_radius - 2, h = 2, $fn = 80);
                translate([0, 0, 2]) {
                    cylinder(r = cuff_internal_radius, h = height - 2 * 2, $fn = 80);
                }
                translate([0, 0, height - 2]) {
                    cylinder(r = cuff_internal_radius - 2, h = 2, $fn = 80);
                }
            }

            /*
            translate([0, 0, height - .2]) {
                thread();
            }
            */
        }

        for (pos = [
            [cuff_internal_radius / 2 + size / 2, 0, height / 2],
            [-cuff_internal_radius / 2 - size / 2, 0, height / 2]
        ]) {
            translate(pos) {
                cube(size = [size + size_clear, size + size_clear, height * 2], center = true);
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
                cylinder(r = 0.8, h = height * 2);
            }
        }

        for (pos = [
            [ -4.5, -3.2, -1 ],
            [ -4.5, 3.2, -1 ],
            [ 4.5, -3.2, -1 ],
            [ 4.5, 3.2, -1 ]
        ]) {
             translate(pos) {
                cylinder(r = 0.5, h = height * 2, center = true);
            }
        }

        // Blocker
        translate([0, 0, height / 2]) {
            for (rot = [ 0, 180 ]) {
                rotate([0, 0, rot]) {
                    hole();
                }
            }
        }

        translate([0, 0, height]) {
            cylinder(r = 6, h = 5, center = true);
        }
    }

    %difference() {
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
    }

    translate([0, 0, 30 + LINK_HEIGHT + exploded]) {
        cuff();

        translate([0, 0, 11 + exploded + offset]) {
            cuff_internal();
        }

        translate([0, 0, 45 + exploded]) {
            cuff_cap();
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

link();

cuff();
cuff_internal();
!cuff_cap();

cap_thread(male = false);
intersection() {
    cuff();
    translate([0, 0, 46])
    cube(size = [25, 25, 20], center = true);
}

union() {
    //%cuff();
    //translate([0, 0, 10])
    cuff_internal();
}

blocker(extra_clear = 0.1);

extra_clear = 0.15;
blocker_big(extra_clear = extra_clear);
blocker_big(chamfrein = false, extra_clear = extra_clear);

