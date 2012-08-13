
$fn = 30;

SERVO_HEAD_DIAMETER = 5.92;
SERVO_HEAD_HEIGHT = 4;

HOLDER_THICKNESS = 1;

SCREW_DIAMETER = 1;

module teeth() {
    height = 3;
    length = 2;
    width = 0.8;

    linear_extrude(height = SERVO_HEAD_HEIGHT) {
        polygon([[-length / 2,0],[-width / 2,height],[width / 2,height],[length / 2,0]]);
    }
}

module servo_hold() {
    difference() {
        cylinder(r = SERVO_HEAD_DIAMETER / 2 + HOLDER_THICKNESS, h = SERVO_HEAD_HEIGHT + 1);
        translate([0, 0, -0.1]) {
            cylinder(r = SERVO_HEAD_DIAMETER / 2, h = SERVO_HEAD_HEIGHT);
        }

        cylinder(r = SCREW_DIAMETER, h = 10);
    }
}

//servo_hold();

teeth();

