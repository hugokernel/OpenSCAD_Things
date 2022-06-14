include <BOSL2/std.scad>

$fn = 50;

ARM_LENGTH = 16;
ARM_OUTER_DIAMETER = 6;
ARM_INNER_DIAMETER = 2.85;
CENTER_SIZE = 5;
MAIN_DIAMETER = 3.9;

module rod(l) {
    ycyl(d=ARM_INNER_DIAMETER, h=ARM_LENGTH * 2);
}

module arm(right) {

    module _arm() {
        difference() {
            ycyl(d=ARM_OUTER_DIAMETER, h=ARM_LENGTH);
            rod();
        }
    }

    zrot((right) ? -25 : 180 + 25)
        back(ARM_LENGTH / 2 + CENTER_SIZE)
            if ($children > 0) {
                children();
            } else {
                _arm();
            }
}

difference() {
    hull() {
        arm(true);
        arm(false);

        difference() {
            sphere(r=CENTER_SIZE * 1.2);
            down(ARM_OUTER_DIAMETER)
                cube(size=[CENTER_SIZE * 4, CENTER_SIZE * 4, ARM_OUTER_DIAMETER], center=true);
            zcyl(d=MAIN_DIAMETER, l=CENTER_SIZE * 4);
        }

        right(8)
            ycyl(d=ARM_OUTER_DIAMETER, l=34);
    }

    arm(true)
        rod();

    arm(false)
        rod();

    zcyl(d=MAIN_DIAMETER, l=CENTER_SIZE * 4);
}
