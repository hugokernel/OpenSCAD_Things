
include <servos.scad>
//include <MCAD/units.scad>

$fn = 25;

DEBUG = 1;
BODY_HEIGHT = 65.0;
BODY_WIDTH = 27.5;

SERVO_HOLE_DIAMETER = 0.5;
SERVO_WIDTH = 20;

CHANFREIN = 7;

LEG_HOLE_DIAMETER = 2.5;

module support() {

    difference() {
        difference() {
            union() {
                difference() {
                    cube(size = [BODY_WIDTH, BODY_WIDTH, BODY_HEIGHT]);

                    // Main hole
                    translate([13.75, 10, 0]) cylinder(h = 65, r = 3);
                }

                // Servo holder
                translate([CHANFREIN, -SERVO_WIDTH, 53.5])
                    cube(size = [17.5 - CHANFREIN, SERVO_WIDTH, 11.5]);

                translate([CHANFREIN, -SERVO_WIDTH, 0])
                    cube(size = [17.5 - CHANFREIN, SERVO_WIDTH, 12.5]);


translate([BODY_WIDTH, 7, 0]) {
    difference() {
        cube(size = [LEG_THICKNESS * 1.3, 17, BODY_HEIGHT]);

        translate([0, LEG_THICKNESS, -1])
            cube(size = [LEG_THICKNESS, 100, BODY_HEIGHT + 3]);
    }
}

            }

            // Hole for leg
            translate([-1, BODY_WIDTH - 10, 10]) rotate([0, 90, 0]) cylinder(h = 100, r = LEG_HOLE_DIAMETER);
            translate([-1, BODY_WIDTH - 10, 50]) rotate([0, 90, 0]) cylinder(h = 100, r = LEG_HOLE_DIAMETER);

            // Servo hole
            translate([-1, - 5, 9]) rotate([0, 90, 0]) cylinder(h = 30, r = 0.5);
            translate([-1, - 15, 9]) rotate([0, 90, 0]) cylinder(h = 30, r = 0.5);

            translate([-1, - 5, 53.5 + 4]) rotate([0, 90, 0]) cylinder(h = 30, r = SERVO_HOLE_DIAMETER);
            translate([-1, - 15, 53.5 + 4]) rotate([0, 90, 0]) cylinder(h = 30, r = SERVO_HOLE_DIAMETER);
        }

        // Reduce size
        linear_extrude(height = BODY_HEIGHT) {
            // Body chanfrein
            polygon([[0, BODY_WIDTH - CHANFREIN], [0, BODY_WIDTH], [CHANFREIN, BODY_WIDTH]]);
            polygon([[BODY_WIDTH, BODY_WIDTH - CHANFREIN], [BODY_WIDTH, BODY_WIDTH], [BODY_WIDTH - CHANFREIN, BODY_WIDTH]]);
            polygon([[BODY_WIDTH, 0], [BODY_WIDTH, CHANFREIN], [BODY_WIDTH - CHANFREIN, 0]]);
            polygon([[0, 0], [0, CHANFREIN], [CHANFREIN, 0]]);
        }

        translate([BODY_WIDTH / 2, BODY_HEIGHT / 2, -1])
            cylinder(r = 10, h = BODY_HEIGHT + 1);

        // Servo holder chanfrein
        translate([20, 0, -0.1])
            rotate([0, -90, 0])
                linear_extrude(height = 30)
                    polygon([[0, 0], [0, -SERVO_WIDTH - 0.1], [4, -SERVO_WIDTH]]);

        translate([20, 0, 65])
            rotate([0, -90, 0])
                linear_extrude(height = 30)
                    polygon([[0, 0], [0, -SERVO_WIDTH - 0.1], [-4, -SERVO_WIDTH]]);
    }

    // Rudder
    RUDDER_HEIGHT = 4;
    RUDDER_CYLINDER_HEIGHT = RUDDER_HEIGHT + 2;
    rotate([0, 0, 45]) {
        translate([16.5, -21, 0]) {


            translate([2.5, 1, 0])
                cube(size = [1, 9, RUDDER_CYLINDER_HEIGHT]);


            difference() {
                union() {
                    cube(size = [6, 10, RUDDER_HEIGHT]);
                    translate([3, 0, 0]) {
                        cylinder(r = 3, h = RUDDER_CYLINDER_HEIGHT);
                    }
                }

                translate([3, 0, -1]) cylinder(r = 1, h = 100);
            }

        }
    }
//        polygon([[0, 0], [0, 10], [5, 10], [5, 5]]);
}

LEG_THICKNESS = 5;

translate([-14, -10, 0]) {
    support();


    if (DEBUG) {
        color("GREY") translate([-9, -20.1, 13]) rotate([90, 0, 90]) futabas3003();
    }
}


//cube(275, 275, 650, center = true);


