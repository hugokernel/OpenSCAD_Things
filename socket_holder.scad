
$fn = 20;

FOOTPRINT_WIDTH = 13.5;
FOOTPRINT_DEEP = 14;

SOCKET_MAX_SIZE = 26;
SOCKET_COUNT = 4;

BASE_THICKNESS = 3;
BASE_WIDTH = SOCKET_MAX_SIZE / 1.5;

HOLE_DIAMETER = 4;

module positioner() {
    for (x = [ 0 : SOCKET_COUNT - 1 ]) {
        translate([ - x * SOCKET_MAX_SIZE + ((SOCKET_COUNT - 1 ) * SOCKET_MAX_SIZE / 2), 0, BASE_THICKNESS / 2 ]) {
            for (i = [0 : $children - 1]) {
                children(i);
            }
        }
    }
}

module main() {

    difference () {
        union() {
            cube(size = [ SOCKET_MAX_SIZE * SOCKET_COUNT, BASE_WIDTH, BASE_THICKNESS ], center = true);

            positioner() {
                difference() {
                    cylinder(r = FOOTPRINT_WIDTH / 2, h = FOOTPRINT_DEEP);
                    translate([0, 0, 1]) {
                        cylinder(r = FOOTPRINT_WIDTH / 2 - 2, h = FOOTPRINT_DEEP);
                    }
                }

                %cylinder(r = SOCKET_MAX_SIZE / 2, h = FOOTPRINT_DEEP);
            }
        }

        // Hole
        translate([0, 0, -25]) {
            positioner() {
                cylinder(r = HOLE_DIAMETER / 2, h = 50);
            }
        }
    }
}

if (1) {
    main();
} else {
    intersection() {
        main();
        translate([SOCKET_MAX_SIZE / 2, 0, 0]) {
            cube(size = [SOCKET_MAX_SIZE, BASE_WIDTH, 100], center = true);
        }
    }
}

