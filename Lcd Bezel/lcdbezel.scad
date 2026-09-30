include <BOSL2/std.scad>

$fn = 100;

LENGTH = 70;
THICKNESS = 1.5;

difference() {
    cuboid([LENGTH, 44, THICKNESS], chamfer=THICKNESS, edges=[TOP]);

    for (pos = [
        [57 / 2, 33.5 / 2, 0],
        [57 / 2, -33.5 / 2, 0],
        [-57 / 2, 33.5 / 2, 0],
        [-57 / 2, -33.5 / 2, 0]
    ]) {
        translate(pos) {
            zcyl(d=2.5, h=10);
            
            zcyl(d1=2, d2=4.65, h=THICKNESS + .1);
        }
    }

    left(LENGTH / 2 + 2.5)
        back(.95) // 1.75 > 0.75
            zcyl(d1=13, d2=15, h=THICKNESS + .1);

    right(LENGTH / 2 + 10)
        zcyl(d1=28, d2=30, h=THICKNESS + .1);

    // Opening
    pos = LENGTH / 2 - (70 - 57) / 2 - 7;

    right(pos - 37 / 2)
        // 37, 31
        cuboid([37.5, 31.5, THICKNESS + .1], chamfer=THICKNESS, edges=[BOTTOM]);
    /*
    cuboid([45, 37, 2], chamfer=1, edges=[TOP]);

    // Opening
    cuboid([37, 31, 20]);
    */
}