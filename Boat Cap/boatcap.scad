include <BOSL2/std.scad>

$fn = 80;

EXTERNAL_DIAMETER = 71.5;
INTERNAL_DIAMETER = 66.0;
TOTAL_HEIGHT = 9.2;

HOLE_DIAMETER = 47;

SCREW_HOLE_MIN_DIAMETER = 3.5;
SCREW_HOLE_MAX_DIAMETER = 6.4;
SCREW_HOLE_SPACING = 58.44;

NEGATIVE_HEIGHT = 3;

module base() {
    difference() {
        cyl(l=TOTAL_HEIGHT, d=EXTERNAL_DIAMETER, rounding1=0.01, rounding2=2);
        up(4) {
            cyl(l=TOTAL_HEIGHT + 10, d=HOLE_DIAMETER);
        }

        down(TOTAL_HEIGHT / 2 - 1.5 + 0.01) {
            cyl(l=NEGATIVE_HEIGHT, d=INTERNAL_DIAMETER);
        }

        zrot(45) {
            for (position = [
                [SCREW_HOLE_SPACING / 2, 0],
                [0, SCREW_HOLE_SPACING / 2],
                [-SCREW_HOLE_SPACING / 2, 0],
                [0, -SCREW_HOLE_SPACING / 2],
            ]) {
                translate([position[0], position[1], .01]) {
                    up(0.01) {
                        cyl(l=TOTAL_HEIGHT + 1, d=SCREW_HOLE_MIN_DIAMETER);
                    }

                    up(TOTAL_HEIGHT - 2.3) {
                        cyl(l=TOTAL_HEIGHT + 1, d=SCREW_HOLE_MAX_DIAMETER);
                    }
                }
            }
        }
    }
}

module tab() {
    s = 0.49;
    intersection() {
        translate([0, 0.61, -1.6]) {
            linear_extrude(height=TOTAL_HEIGHT - NEGATIVE_HEIGHT) {
                scale([s, s, 1]) {
                    polygon([[-20,42],[-16,36/*1:0,0,0,0*/] ,[-15.75,35.03] ,[-15.58,34.04] ,[-15.5,32.96] ,[-15.54,31.9] ,[-15.74,30.82] ,[-16.15,29.79] ,[-16.73,28.96] ,[-17.55,28.26],[-18,28/*1:4,2,-4,-3*/] ,[-18.84,27.44] ,[-19.79,26.96] ,[-20.82,26.61] ,[-21.82,26.41] ,[-22.84,26.35] ,[-23.85,26.41] ,[-24.84,26.6] ,[-25.81,26.91],[-26,27],[-32,34],[-36,30],[-53,49/*1:0,0,0,0*/] ,[-52.29,49.75] ,[-51.5,50.54] ,[-50.77,51.25] ,[-49.92,52.06] ,[-49.14,52.78] ,[-48.3,53.54] ,[-47.38,54.35] ,[-46.39,55.19] ,[-45.61,55.84] ,[-44.79,56.51] ,[-43.95,57.18] ,[-43.06,57.86] ,[-42.15,58.54] ,[-41.21,59.22] ,[-40.25,59.9] ,[-39.25,60.57] ,[-38.23,61.23] ,[-37.19,61.89] ,[-36.13,62.52] ,[-35.05,63.14] ,[-33.95,63.74] ,[-32.83,64.31] ,[-31.7,64.85] ,[-30.55,65.37] ,[-29.39,65.85],[-29,66/*1:-13,-5,12,6*/] ,[-27.91,66.52] ,[-26.79,67.02] ,[-25.65,67.48] ,[-24.5,67.91] ,[-23.34,68.32] ,[-22.16,68.69] ,[-20.98,69.04] ,[-19.8,69.37] ,[-18.62,69.67] ,[-17.44,69.94] ,[-16.28,70.2] ,[-15.12,70.43] ,[-13.98,70.64] ,[-12.86,70.83] ,[-11.77,71] ,[-10.7,71.16] ,[-9.66,71.29] ,[-8.65,71.42] ,[-7.37,71.56] ,[-6.16,71.67] ,[-5.03,71.76] ,[-4,71.84] ,[-2.84,71.91] ,[-1.69,71.96] ,[-0.59,71.99],[0,72],[0,47/*1:0,0,0,0*/] ,[-1.02,46.99] ,[-2.03,46.97] ,[-3.14,46.93] ,[-4.23,46.88] ,[-5.24,46.82] ,[-6.27,46.75] ,[-7.3,46.66] ,[-8.29,46.54] ,[-9.36,46.39] ,[-10.41,46.17],[-11,46/*1:3,1,-5,-1*/] ,[-12.03,45.76] ,[-13.03,45.48] ,[-13.99,45.15] ,[-15.02,44.75] ,[-15.99,44.32] ,[-16.97,43.84] ,[-17.93,43.32] ,[-18.8,42.8] ,[-19.67,42.24]]);
                }
            }
        }

        cylinder(d=HOLE_DIAMETER, h=TOTAL_HEIGHT * 2, center=true);
    }
}

module main() {
    base();

    tab();
    mirror() {
        tab();
    }
}

main();

