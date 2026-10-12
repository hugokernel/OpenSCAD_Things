include <BOSL2/std.scad>

$fn = 90;

CAM_LENGTH = 100;
CAM_WIDTH = 30;

THICKNESS = 3;

WOOD_THICKNESS = 52.5;

MARGIN = 5;

module cam_base(length=CAM_LENGTH + MARGIN, width=CAM_WIDTH + MARGIN, thickness=THICKNESS) {
    module positions() {
        for (i = [0 : $children - 1]) {
            left((length - width) / 2)
                children(i);
            right((length - width) / 2)
                children(i);
        }
    }

    hull() {
        positions() {
            zcyl(d=width, h=thickness);

            zcyl(d=width, h=thickness);
        }
    }
}

module holes() {
    insert_hole_diameter = 4.55;

    left(35) {
        zcyl(d=insert_hole_diameter, h=20);
    }

    right(35) {
        zcyl(d=insert_hole_diameter, h=20);
    }
}


module main() {
    difference() {
        hull() {
            down(20)
                xrot(55)
                    cam_base();

            up(30)
                xcyl(d=35, h=75);
        }

        up(35)
            cube(size=[WOOD_THICKNESS, 200, 50], center=true);

        up(25) {
            xcyl(d=5, h=200);

            left(45)
                xcyl(d=10, h=20);

            right(45)
                xcyl(d=10, h=20);
        }

        down(20) {
            xrot(45)
                holes();

            xrot(15)
                zcyl(d=18, h=30, rounding=7);
        }

        zcyl(d=18, h=26, rounding=7);

        up(10)
            fwd(10)
                ycyl(d=10, h=20);
    }
}



cam_base();

!main();

