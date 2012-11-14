
$fn = 40;

use <MCAD/boxes.scad>;

module plate() {
    DIAMETER = 30;
    HEIGHT = 7;

    difference() {
        //roundedBox([60, 45, HEIGHT], 5, true);
        //hull() {
        union() {
            translate([-7, 0, - HEIGHT / 2]) {
                cylinder(r = DIAMETER / 2 + 10, h = HEIGHT);
            }

            //roundedBox([60, 45, HEIGHT], 5, true);
            translate([10, 0, 0]) {
                roundedBox([DIAMETER * 1.2, DIAMETER * 1.5, HEIGHT], 5, true);
            }
        }

        // Main hole
        translate([-7, 0, - HEIGHT]) {
            cylinder(r = DIAMETER / 2, h = HEIGHT * 2);
        }

        // Led
        translate([10, 15, - HEIGHT]) {
            cylinder(r = 1.5, h = HEIGHT * 2);
        }
    }
}

module support() {

    difference() {
        translate([25, 0, -3]) {
            rotate([-90, 0, 90])
            linear_extrude(height = 10) {
                polygon([[-13,6],[13,6],[20,0],[-20,0]]);
            }
        }

        // Clamp
        translate([20, 0, 0]) {
            cube(size = [5, 20, 30], center = true);
        }
    }
}

module arm() {

    scale([5, 5, 5])
    linear_extrude(height = 1.5) {
        polygon([[0,0],[-7,0],[-10,3],[-10,10],[-5,10],[-5,5],[2,5],[2,4],[3,4],[3,1],[2,1],[2,0]]);
    }
}

module main() {
    plate();
    support();

    translate([23.75, -12.5, -18]) {
        rotate([0, -90, 0]) {
            arm();
        }
    }
}

main();

