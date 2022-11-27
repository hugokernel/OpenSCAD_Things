include <BOSL2/std.scad>

$fn = 100;

LENGTH = 140;
WIDTH = 70;
THICKNESS = 5;


module main() {
    difference() {
        union() {
            %cuboid(
                [LENGTH, WIDTH, THICKNESS],
                rounding=6,
                edges=[FWD + RIGHT, BACK + LEFT, FWD+LEFT, BACK + RIGHT],
                $fn=24
            );

            hull() {
                left(60)
                    zcyl(d=35, h=THICKNESS);

                zcyl(d=70, h=THICKNESS);

                right(60)
                    zcyl(d=35, h=THICKNESS);
            }

            up(THICKNESS / 2 + THICKNESS * 2 / 2)
                zcyl(d=65, h=THICKNESS * 2);
        }

        zcyl(d=43, h=THICKNESS * 2);

        // Holes
        xcopies(-120, 2) {
            zcyl(d=7, h=THICKNESS * 2);
        }

        zcyl(d=43, h=THICKNESS * 10);

        down(THICKNESS / 2 - 3 + 0.01)
            zcyl(d=52, h=6);
    }
}


main();
