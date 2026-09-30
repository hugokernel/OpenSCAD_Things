include <BOSL2/std.scad>
include <BOSL2/screws.scad>

$fn = 100;

// Display Touch distance between hole width
DT_HOLES_LENGTH = 140;
DT_HOLES_WIDTH = 70.71;
DT_HOLES_THICKNESS = 3;
DT_HOLES_DIAMETER = 2.5;
DT_WIDTH = 99.71;
DT_LENGTH = 168.55;
DT_BUMP_WIDTH = 32.7;
DT_BUMP_THICKNESS = 2;

ARM_WIDTH = 13;
THICKNESS = DT_HOLES_THICKNESS * 2;

SUPPORT_LENGTH = 60;
SUPPORT_THICKNESS = 7.5;
SUPPORT_HOLE_DIAMETER = 3;

module touch_display() {
    cuboid(
        [DT_WIDTH, DT_LENGTH, THICKNESS]
    );
}

module touch_display_holes_positions() {
    for (pos = [
        [DT_HOLES_WIDTH / 2, DT_HOLES_LENGTH / 2, 0],
        [-DT_HOLES_WIDTH / 2, DT_HOLES_LENGTH / 2, 0],
        [DT_HOLES_WIDTH / 2, -DT_HOLES_LENGTH / 2, 0],
        [-DT_HOLES_WIDTH / 2, -DT_HOLES_LENGTH / 2, 0]
    ]) {
        //fwd(10 - 8.42)
        fwd(DT_LENGTH / 2 - DT_HOLES_LENGTH / 2 - 18.25)
        translate(pos) {
            for (i = [0 : $children - 1])
                children(i);
        }
    }
}

module main_arms() {

    %touch_display_holes_positions() {
        zcyl(d=3, l=10);
    };

    for (pos = [DT_HOLES_LENGTH / 2, -DT_HOLES_LENGTH / 2]) {
        fwd(pos) {
            cuboid(
                [DT_WIDTH, ARM_WIDTH, THICKNESS],
                edges=[TOP],
                chamfer=2
            );
        }
    }

    for (pos = [DT_HOLES_WIDTH / 2, -DT_HOLES_WIDTH / 2]) {
        left(pos) {
            cuboid(
                [ARM_WIDTH, DT_LENGTH, THICKNESS],
                edges=[TOP],
                chamfer=2
            );
        }
    }
}

module main() {

    /*
    %touch_display_holes_positions() {
        zcyl(d=3, l=10);
    };

    //%touch_display();
    */

    difference() {
        cuboid(
            [DT_WIDTH, DT_LENGTH, THICKNESS],
            chamfer=2,
            edges=[TOP],
            trimcorners=false
        );

        cuboid(
            [DT_WIDTH - 35, DT_LENGTH - 50, THICKNESS * 2],
            chamfer=2,
            edges=[TOP],
            trimcorners=false
        );

        bump_thickness = DT_BUMP_THICKNESS * 1.5;
        fwd(50)
            down(bump_thickness / 2 + .01)
                cuboid(
                    [DT_BUMP_WIDTH + 2, DT_LENGTH, bump_thickness]
                );

        touch_display_holes_positions() {
            zcyl(d=3, l=10);
            up(7.5) {
                zcyl(d=6, l=10);
            }

            down(1.5 + .01)
                cuboid([15, 7, 3.2]);
        };

        support_position() {
            scale([1.02, 1.02, 1])
                support();

            support_holes_positions() {
                zcyl(l=100, d=SUPPORT_HOLE_DIAMETER + .5);
                down(3)
                    zcyl(l=3, d1=SUPPORT_HOLE_DIAMETER + 6, d2=SUPPORT_HOLE_DIAMETER + .5);
            }
        }
    }

}

/*
%cuboid(
    [58, 58, 100],
    chamfer=2,
    edges=[TOP],
    trimcorners=false
);
*/

    /*
    difference() {
        zrot_copies(n=3)
            leg();

        zcyl(r=6, h=THICKNESS_CENTER * 2);
    }

    down(4)
        nut("3/8", shape="square");
    */ 


module support_position() {
    for (pos = [
        [0, DT_WIDTH / 2 - 9, 0, 90],
        [0, -DT_WIDTH / 2 + 9, 0, 90],
        [0, DT_LENGTH / 2 - 10.5, 0, 0]
    ]) {
        zrot(pos[3]) {
            translate([pos[0], pos[1], pos[2]])
                for (i = [0 : $children - 1])
                    children(i);
        }
}
}

module support_holes_positions() {
    for (pos = [-1, 1]) {
        left(pos * 11) {
            for (i = [0 : $children - 1])
                children(i);
        }
    }
}

module support() {
    length = SUPPORT_LENGTH;
    thickness = SUPPORT_THICKNESS;

    difference() {
        union() {
            difference() {
                prismoid(size1=[50, thickness], size2=[30, thickness], h=length);

                up(10) {
                    support_holes_positions() {
                        cuboid([10, 10, 7]);

                        zcyl(d=SUPPORT_HOLE_DIAMETER, h=length);
                    }
                }
            }

            up(length) {
                ycyl(d=30, l=thickness);
            }
        }

        up(length) {
            ycyl(r=6, h=thickness * 2);
        }
    }

    back(thickness / 2)
        up(length)
            xrot(90)
                nut("3/8", shape="square", thickness=thickness);
}

module demo() {
    main();

        support_position() {
            support();
        }
}

!main();

support();

demo();