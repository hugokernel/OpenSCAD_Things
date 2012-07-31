
$fn = 15;

LENGTH = 50.5;
HEIGHT = 31;
THICKNESS = 1.5;
RADIUS = 2.78;

module rbox(width, length, thickness, radius) {

    cube(size = [length - radius * 2, width, thickness], center = true);
    cube(size = [length, width - radius * 2, thickness], center = true);

    // Rounded corner
    translate([ length / 2 - radius, width / 2 - radius, - thickness / 2 ]) {
        cylinder(r = radius, h = thickness);
    }

    translate([ length / 2 - radius, - (width / 2 - radius), - thickness / 2 ]) {
        cylinder(r = radius, h = thickness);
    }

    translate([ - (length / 2 - radius), width / 2 - radius, - thickness / 2 ]) {
        cylinder(r = radius, h = thickness);
    }

    translate([ -(length / 2 - radius), - (width / 2 - radius), - thickness / 2 ]) {
        cylinder(r = radius, h = thickness);
    }
}

/*
difference() {
    rbox(LENGTH, HEIGHT, THICKNESS, RADIUS);

    translate([5, 0, THICKNESS / 1.2]) {
        rbox(LENGTH - 5, HEIGHT - 15, THICKNESS, RADIUS);
    }
}
*/

LENGTH_TOP = 50.5;
LENGTH_BOTTOM = 49.5;
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
