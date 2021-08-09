$fn = 40;

LENGTH = 56;
WIDTH = 30;
HEIGHT = 30;
THICKNESS = 10;

X = 15.85;
Y = 3.2;

TUBE_INNER_DIAMETER = 6.13;
TUBE_OUTER_DIAMETER = 12;
TUBE_HEIGHT = 40;

module cap() {
    difference() {
        union() {
            hull() {
                cylinder(r=WIDTH / 2, h=0.1);
                cylinder(r=TUBE_OUTER_DIAMETER / 2, h=TUBE_HEIGHT / 2);
            }
            cylinder(r=TUBE_OUTER_DIAMETER / 2, h=TUBE_HEIGHT);
        }
        translate([0, 0, -1]) {
            cylinder(r=TUBE_INNER_DIAMETER / 2, h=TUBE_HEIGHT * 2);
        }
    }
}

module base() {
    difference() {
        cube(size=[LENGTH, WIDTH, HEIGHT]);

        translate([-1, WIDTH / 2 - X / 2, -1]) {
            cube(size=[LENGTH * 2, X, HEIGHT - THICKNESS]);
        }

        translate([LENGTH / 2 - Y / 2, -1, -1]) {
            cube(size=[Y, WIDTH * 2, HEIGHT - THICKNESS]);
        }

        for (x = [10, LENGTH - 10]) {
            translate([x, WIDTH / 2, 0]) {
                rotate([0, 90, 0]) {
                    difference() {
                        cylinder(r=35, h=5, center=true);
                        cylinder(r=28, h=5, center=true);
                    }
                }
            }
        }
    }
}

module main() {
    base();

    translate([LENGTH / 2, WIDTH / 2, HEIGHT]) {
        cap();
    }
}



cap();
intersection() { translate([0, 0, 11]) cube(size=[100, 100, 10]); base();}
!main();

