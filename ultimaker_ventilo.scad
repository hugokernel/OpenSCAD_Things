
/**
 *  Fan parameters
 */
FAN_WIDTH = 40;
FAN_HOLE_WIDTH = 31.75;
FAN_DIAMETER = 31.75;
FAN_SCREW_DIAMETER = 2;

/**
 *  Motor parameters
 */
MOTOR_WIDTH = 42;
MOTOR_HOLE_WIDTH = 31.5;
MOTOR_SCREW_DIAMETER = 2.5;

AERATION = FAN_DIAMETER - 10;

HEIGHT = 5;
ADJUST = 1.4;

$fn = 30;

module ultimaker_fan_support() {

    // Fan
    % translate([0, 0, -5]) cube(size = [FAN_WIDTH, FAN_WIDTH, 10], center = true);

    // Motor
    % translate([0, 0, HEIGHT + 40 / 2]) cube(size = [MOTOR_WIDTH, MOTOR_WIDTH, 40], center = true);

    difference() {
        rotate([0, 0, 45]) {
            cylinder(r1 = FAN_WIDTH / 2 * ADJUST, r2 = MOTOR_WIDTH / 2 * ADJUST, h = HEIGHT, $fn = 4);
        }

        cylinder(r = FAN_DIAMETER / 2, HEIGHT * 4, center = true);
       
        // Aeration X
        translate([0, 0, HEIGHT]) {
            cube(size = [AERATION, MOTOR_WIDTH * 2, 4], center = true);
        }

        // Aeration Y
        translate([0, 0, HEIGHT]) {
            cube(size = [MOTOR_WIDTH * 2, AERATION, 4], center = true);
        }

        // Hole
        translate([- FAN_HOLE_WIDTH / 2, - FAN_HOLE_WIDTH / 2, -10]) {
            cylinder(r = FAN_SCREW_DIAMETER / 2, h = 100);
        }

        translate([- FAN_HOLE_WIDTH / 2, FAN_HOLE_WIDTH / 2, -10]) {
            cylinder(r = FAN_SCREW_DIAMETER / 2, h = 100);
        }

        translate([FAN_HOLE_WIDTH / 2, - FAN_HOLE_WIDTH / 2, -10]) {
            cylinder(r = FAN_SCREW_DIAMETER / 2, h = 100);
        }

        translate([FAN_HOLE_WIDTH / 2, FAN_HOLE_WIDTH / 2, -10]) {
            cylinder(r = FAN_SCREW_DIAMETER / 2, h = 100);
        }
    }

    translate([0, 0, HEIGHT]) {
        // Hole
        translate([- MOTOR_HOLE_WIDTH / 2, - MOTOR_HOLE_WIDTH / 2, -1]) {
            cylinder(r = MOTOR_SCREW_DIAMETER / 2, h = 5);
        }

        translate([- MOTOR_HOLE_WIDTH / 2, MOTOR_HOLE_WIDTH / 2, -1]) {
            cylinder(r = MOTOR_SCREW_DIAMETER / 2, h = 5);
        }

        translate([MOTOR_HOLE_WIDTH / 2, - MOTOR_HOLE_WIDTH / 2, -1]) {
            cylinder(r = MOTOR_SCREW_DIAMETER / 2, h = 5);
        }

        translate([MOTOR_HOLE_WIDTH / 2, MOTOR_HOLE_WIDTH / 2, -1]) {
            cylinder(r = MOTOR_SCREW_DIAMETER / 2, h = 5);
        }
    }
}

ultimaker_fan_support();

