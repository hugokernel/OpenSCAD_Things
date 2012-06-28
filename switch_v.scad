

$fn = 50;


module base(x, y, z, t) {
//minkowski() {
    difference() {
        cube([x, y, z]);
        translate([t / 2, t / 2, 0]) cube(x - t, y - t, z - t);
    }
//    cylinder(2, 50);
//    }
}

base(50, 50, 50, 10);


