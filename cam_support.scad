
use <ultimalker_headmount_female.scad>;

$fn = 20;

//femalecoupling();

module cam_support() {
    width = 16;
    length = 23;
    height = 23;

    wall_thickness = 3;

    difference() {
        cube(size = [width + wall_thickness, length + wall_thickness, height + wall_thickness]);
        
        translate([-1, wall_thickness / 2, wall_thickness / 2]) {
            cube(size = [width, length, height]);
        }

        translate([width - wall_thickness, length - wall_thickness - 2, wall_thickness / 2]) {
            cube(size = [10, 7, 5]);
        }

        // Hole
        translate([14, 50, height / 2]) {
            rotate([90, 0, 0]) {
                cylinder(r = 1, h = 100);
            }
        }
    }
}

cam_support();

