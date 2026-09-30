include <BOSL2/std.scad>

$fn = 100;

DIAMETER = 30;

difference() {
    sphere(d=DIAMETER);
    down(5)
        fwd(5)
            left(5) {
                cube(size=[50, 50, 50]);

                translate([10, 10, 0]) {
                    zcyl(h=DIAMETER, d=3);
                    down(7)
                        zcyl(h=5, d=7);
                }
            }

    /*
    up(DIAMETER / 2 - 5)
        fwd(25)
            left(25)
    cube(size=[50, 50, 50]);
    */
    h = 10;
    down(DIAMETER / 2 + h / 2 - 3)
        cube(size=[50, 50, h], center=true);
}