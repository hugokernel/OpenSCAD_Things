
$fn = 40;

difference() {
    union() {
        cube(size = [20, 20, 7], center = true);

        translate([0, 0, 7 + 3.5]) {
            cylinder(r = 11.5 / 2, 15, center = true);
        }
    }

    //cylinder(r = 3.4, h = 100);
    cylinder(r = 3.9, h = 100);
}

translate([3, 0, 9]) {
    cube(size = [0.95, 7, 18], center = true);
}

