
$fn = 30;

WIDTH = 125;
LENGTH = 30;
THICKNESS = 5;

use <MCAD/boxes.scad>;

module support() {
    difference() {
        roundedBox([WIDTH, LENGTH, THICKNESS], 7, true);

        translate([- WIDTH / 2 + 25, 0, - THICKNESS]) {
            cylinder(r = 15.8 / 2, h = 20);
        }

        translate([- WIDTH / 2 + 50, 0, - THICKNESS]) {
            cylinder(r = 6 / 2, h = 20);
        }

        translate([- WIDTH / 2 + 70, 0, - THICKNESS]) {
            cylinder(r = 4.8 / 2, h = 20);
        }

        translate([- WIDTH / 2 + 85, 0, - THICKNESS]) {
            cylinder(r = 4.8 / 2, h = 20);
        }

        translate([- WIDTH / 2 + 100, 0, - THICKNESS]) {
            cylinder(r = 4.8 / 2, h = 20);
        }

        translate([- WIDTH / 2 + 9, 0, - THICKNESS / 2 + 0.9]) {
            roundedBox([5, 20, 2.5], 1, true);
        }

        translate([WIDTH / 2 - 9, 0, - THICKNESS / 2 + 0.9]) {
            roundedBox([5, 20, 2.5], 1, true);
        }
    }
}

translate([0, 0, THICKNESS / 2]) {
    support();
}

