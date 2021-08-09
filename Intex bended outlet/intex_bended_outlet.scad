use <Thread_Library.scad>

$fn=60;

Base_external_diameter = 92;
Base_internal_diameter = 80;
Base_height = 15;
Base_face = 12;

Link_height = 15;
Pipe_diameter = 31.5;
Pipe_angle = 60;
Pipe_base_diameter = Pipe_diameter + 6;
Pipe_base_height = 2;
Pipe_clearance = 0.2; // Clearance between pipe and main piece


module tube(external, internal, height) {
    difference() {
        cylinder(r=external / 2, h=height);
        translate([0, 0, -height / 2]) {
            cylinder(r=internal / 2, h=height * 2);
        }
    }
}

module pipe() {
    offset = 30;
    base = 10;
    thickness = 1;
    translate([-offset, 0, base]) {
        rotate([90, 0, 0]) {
            rotate_extrude(angle=Pipe_angle, $fn=60, convexity=10) {
                translate([offset, 0, 0]) {
                    difference() {
                        circle(Pipe_diameter / 2);
                        circle(Pipe_diameter / 2 - thickness);
                    }
                }
            }
        }
    }

    tube(Pipe_diameter, Pipe_diameter - thickness * 2, base);
    tube(Pipe_base_diameter, Pipe_diameter - thickness * 2, Pipe_base_height);
}

module base() {
    difference() {
        tube(Base_external_diameter, Base_internal_diameter, Base_height, $fn=Base_face);

        trapezoidThreadNegativeSpace( 
            length=11, 				// axial length of the threaded rod
            pitch=3.2,				 // axial distance from crest to crest
            pitchRadius=41, 			// radial distance from center to mid-profile
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
    }
}

module link() {
    diff = 2;
    module cone() {
        hull() {
            tube(Base_external_diameter, Base_internal_diameter, 1, $fn=Base_face);
            translate([0, 0, Link_height]) {
                tube(Pipe_diameter, 18, 1);
            }
        }
    }

    difference() {
        cone();
        translate([0, 0, -diff]) {
            cone();
        }

        // Pipe hole
        translate([0, 0, -Link_height / 2]) {
            cylinder(r=Pipe_diameter / 2 + Pipe_clearance, h=Link_height * 2);
        }

        translate([0, 0, Link_height]) {
            cylinder(r=Pipe_base_diameter, h=2);
        }
    }
}

module main() {
    base();
    translate([0, 0, Base_height]) {
        link();
    }
}

module demo() {
    difference() {
        main();
        translate([0, -100, -50]) {
            cube(size=[50, 200, 100]);
        }
    }

    translate([0, 0, Base_height + Link_height - 5]) {
        rotate([0, 0, 0]) {
            pipe();
        }
    }
}

!demo();

main();
pipe();
