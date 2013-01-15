
use <roundCornersCube.scad>;
$fn = 30;

module plate() {

    width = 241;
    length = width;
    thickness = 6;
    groove_depth = 2;

    module fix() {
        cylinder(r = 3, h = thickness  * 2);

        translate([7.5, 0, 0]) {
            cylinder(r = 1.5, h = thickness * 2);
        }

        translate([2, 0, 0]) {
            cube([10, 3, thickness * 4], center = true);
        }
    }

    module holes_heater() {
        width_space = 209;
        length_space = width_space;
        depth = 6;
        radius = 1.4;

        translate([ width_space / 2, length_space / 2, -thickness / 2 - 0.1 ]) {
            cylinder(r = radius, h = depth);
        }

        translate([ - width_space / 2, length_space / 2, -thickness / 2 - 0.1 ]) {
            cylinder(r = radius, h = depth);
        }

        translate([ width_space / 2, - length_space / 2, -thickness / 2 - 0.1 ]) {
            cylinder(r = radius, h = depth);
        }

        translate([ - width_space / 2, - length_space / 2, -thickness / 2 - 0.1 ]) {
            cylinder(r = radius, h = depth);
        }
    }

    difference() {
        roundCornersCube(width, length, thickness, 10);

        // Groove
        translate([ -2, -5, -thickness + groove_depth - 0.01 ]) {
            cube(size = [ 4, length / 2 - 5, 3 ]);
        }

        translate([106 / 2, 230.6 / 2, -thickness]) {
            fix();
        }

        translate([- 106 / 2, 230.6 / 2, -thickness]) {
            fix();
        }

        translate([106 / 2, - 230.6 / 2, -thickness]) {
            fix();
        }

        translate([- 106 / 2, - 230.6 / 2, -thickness]) {
            fix();
        }

        holes_heater();
    }
}

plate();

