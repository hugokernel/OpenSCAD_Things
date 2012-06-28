use <Thread_Library.scad>

$fn = 50;
CAM_MOUNT_HEIGHT = 10;
AXIS_ADAPTER_HEIGHT = 10;// - 1.45;

module camera_mount(height) {

    difference() {
        cylinder(
            h = height,
            r1 = 15, 
            r2 = 15, 
            $fn = 8
        );

        translate([0, 0, -.5])
            trapezoidThread( 
                length=height, 				// axial length of the threaded rod
                pitch=1.2,				 // axial distance from crest to crest
                //pitchRadius=2.47, 			// radial distance from center to mid-profile
                pitchRadius=2.95, 			// radial distance from center to mid-profile
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
};

module support() {

    OFFSET = 1.45;

    union() {
        camera_mount(CAM_MOUNT_HEIGHT);

        translate([0, 0, CAM_MOUNT_HEIGHT - OFFSET])
            trapezoidThread( 
                length=AXIS_ADAPTER_HEIGHT, 				// axial length of the threaded rod
                pitch=1.5,				 // axial distance from crest to crest
                pitchRadius=8.7, 			// radial distance from center to mid-profile
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

        translate([0, 0, CAM_MOUNT_HEIGHT - OFFSET + AXIS_ADAPTER_HEIGHT]) {
            difference() {
                cylinder(
                    h = 10,
                    r1 = 3.5,
                    r2 = 3.5
                );
        
                translate([0, 0, 6 + 4.875])
                    sphere(4.875);
            }
        }
    }
}

support();

//camera_mount(5);

