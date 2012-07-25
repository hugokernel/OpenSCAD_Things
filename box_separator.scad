
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

difference() {
    rbox(LENGTH, HEIGHT, THICKNESS, RADIUS);
   
    translate([5, 0, THICKNESS / 1.2]) {
        rbox(LENGTH - 5, HEIGHT - 15, THICKNESS, RADIUS);
    }
}

