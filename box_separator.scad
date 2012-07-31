
$fn = 15;

RADIUS = 1.5;

LENGTH_TOP = 50.85;
LENGTH_BOTTOM = 49.9;
HEIGHT = 31;
THICKNESS = 0.2;
BORDER_WIDTH = 2;
BORDER_THICKNESS = 1.5;

module separator() {

    difference() {
        union() {
            // Create exterior
            linear_extrude(height = BORDER_THICKNESS) {
                polygon([
                    [- LENGTH_TOP / 2, HEIGHT], [LENGTH_TOP / 2, HEIGHT],
                    [LENGTH_BOTTOM / 2, RADIUS], [LENGTH_BOTTOM  / 2 - RADIUS, 0],
                    [- LENGTH_BOTTOM / 2 + RADIUS, 0], [- LENGTH_BOTTOM / 2, RADIUS]
                ]);
            }

            // Rounded corner
            translate([- LENGTH_BOTTOM / 2 + RADIUS, RADIUS, 0]) {
                cylinder(r = RADIUS, h = BORDER_THICKNESS);
            }

            translate([LENGTH_BOTTOM / 2 - RADIUS, RADIUS, 0]) {
                cylinder(r = RADIUS, h = BORDER_THICKNESS);
            }
        }

        // Create border
        translate([0, 0, THICKNESS]) {
            linear_extrude(height = BORDER_THICKNESS) {
                polygon([
                    [- LENGTH_TOP / 2 + BORDER_WIDTH, HEIGHT - BORDER_WIDTH],
                    [LENGTH_TOP / 2 - BORDER_WIDTH, HEIGHT - BORDER_WIDTH],
                    [LENGTH_BOTTOM / 2 - BORDER_WIDTH, BORDER_WIDTH],
                    [- LENGTH_BOTTOM / 2 + BORDER_WIDTH, BORDER_WIDTH]
                ]);
            }
        }
    }
}

separator();
