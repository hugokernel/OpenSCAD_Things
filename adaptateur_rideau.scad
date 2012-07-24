

CUBE_WIDTH = 16;
CUBE_LENGTH = 15;
CUBE_HEIGHT = 12;
CUBE_THICKNESS = 2;

ARM_HEIGHT = 50;
ARM_THICKNESS = 2;

module adapter() {
    // Make female connector
    difference() {
        cube(size = [CUBE_WIDTH + CUBE_THICKNESS * 2, CUBE_LENGTH + CUBE_THICKNESS * 2 + 2, CUBE_HEIGHT + CUBE_THICKNESS], center = true);

        translate([0, 0, - CUBE_THICKNESS + 1]) {
            cube(size = [CUBE_WIDTH * 2, CUBE_LENGTH + 2, CUBE_HEIGHT + 0.1], center = true);
        }
    }

    // Make arm
    translate([0, CUBE_WIDTH / 2 + CUBE_THICKNESS / 2 + 0.5, 5]) {
        color("RED")
            cube(size = [CUBE_WIDTH + CUBE_THICKNESS * 2, ARM_THICKNESS * 2, 100], center = true);
    }

    translate([- 4 / 2, 4.5, ARM_HEIGHT / 2 + CUBE_HEIGHT / 2 - CUBE_THICKNESS / 2]) {
        color("GREEN")  cube(size = [CUBE_WIDTH, 10, ARM_HEIGHT], center = true);
    }

    // Make male
    translate([- CUBE_THICKNESS, ARM_THICKNESS, ARM_HEIGHT - CUBE_THICKNESS / 2]) {
        cube(size = [CUBE_WIDTH, CUBE_LENGTH, CUBE_HEIGHT], center = true);
    }

    translate([- CUBE_LENGTH / 2, 0, 2.5])
        color("BLUE") cube(size = [5, CUBE_LENGTH + 2, 5], center = true);
}

rotate([0, -90, 0])
adapter();


