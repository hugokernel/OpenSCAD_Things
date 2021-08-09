// Fixation murale pour barrière de poele à bois
use <dovetail.scad>;

Length = 467;
Width = 30;
Thickness = 6.0;
Border_thickness = 3;

Part = 0; // [0: All, 1: Male, 2: Female, 3: Demo]

module plate(length, width, thickness) {
    translate([width / 2, 0, 0]) {
        cylinder(r=width / 2, h=thickness, center=true);
    }

    translate([length / 2, 0, 0]) {
        cube(size=[length - width, width, thickness], center=true);
    }

    translate([length - width / 2, 0, 0]) {
        cylinder(r=width / 2, h=thickness, center=true);
    }
}

module main() {
    module hole() {
        width = 18.5;
        translate([0, 0, 3]) {
            plate(width, 9.7, 6);
        }
        translate([width / 8, 0, -2]) {
            plate(13.5, 4.6, 6);
        }
    }

    module bighole() {
        translate([6.25, 0, -5]) {
            cylinder(r=6.25, h=10);
        }
        plate(25.5, 5.0, 10);
        plate(25.5, 12.5, 3.5);
    }

    difference() {
        plate(Length, Width, Thickness);

        for (posx = [0 : 21 : 150]) {
            translate([58.5 + posx, 0, 0]) {
                hole();
            }
        }

        for (posx = [0 : 21 : 150]) {
            translate([256.5 + posx, 0, 0]) {
                hole();
            }
        }

        for (posx = [0 : 200 : 400]) {
            translate([28.5 + posx, 0, -1.5]) {
                bighole();
            }
        }

        square_width = 9.6;
        translate([square_width / 2 + 10, 0, 0]) {
            cube(size=[square_width, square_width, 10], center=true);
        }
    }

    square_width = 8.6;
    square_thickness = 1.1;
    translate([square_width / 2 + 10, 0, square_thickness + 1.4]) {
        cube(size=[square_width, square_width, square_thickness], center=true);
    }
}

module cutted(male=true, debug=false) {
    /**
     * [x, y, z]
     * - x : Teeth count
     * - y : Teeth height
     * - z : Teeth Clearance
     */
    teeth = [3.5, 5, 0.1];

    intersection() {
        children();
        translate([Length / 2 - 10, 0, 0]) {
            rotate([0, 0, 90]) {
                cutter([0, -10, 0], [Width, Length, Thickness], teeth, male, debug);
            }
        }
    }
}

if (Part == 0) {
    main();
} else if (Part == 1) {
    cutted(false) { main(); }
} else if (Part == 2) {
    cutted(true) { main(); }
} else if (Part == 3) {
    cutted(true) { main(); }
    cutted(false) { main(); }
}
