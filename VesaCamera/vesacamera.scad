include <BOSL2/std.scad>
include <BOSL2/screws.scad>

$fn = 100;

THICKNESS_CENTER = 8;
THICKNESS_LEG_ENDS = 4;

VESA_SUPPORT_SPACING = 75; // 75, 50, etc...

module leg() {
    difference() {
        hull() {
            zcyl(h=THICKNESS_CENTER, d=30);
            fwd(VESA_SUPPORT_SPACING / 2)
                right(VESA_SUPPORT_SPACING / 2)
                    down(THICKNESS_LEG_ENDS / 2)
                        zcyl(h=THICKNESS_LEG_ENDS, d=15);
        }

        fwd(VESA_SUPPORT_SPACING / 2)
            right(VESA_SUPPORT_SPACING / 2) {
                up(1)
                    zcyl(r=5, h=3);

                down(1)
                    zcyl(r=2.1, h=THICKNESS_LEG_ENDS * 2);
            }
    }
}

module main() {
    difference() {
        zrot_copies(n=4)
            leg();

        zcyl(r=6, h=THICKNESS_CENTER * 2);
    }

    down(4)
        nut("3/8", shape="square");
}

main();
