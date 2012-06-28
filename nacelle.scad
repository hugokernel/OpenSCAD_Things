
// Multiple of 4
BOND = 8;
THICKNESS = 3;
DIAMETER = 3;

// Divide by 4 before next op
HOLES_BY_FACE = BOND / 4;
SPACE = 90 / (HOLES_BY_FACE + 1);


module structure() {

	module arch() {
		 difference() {
			translate([- THICKNESS * 2, 0, 0]) rotate([0, 90, 0]) cylinder(THICKNESS * 4, BOND * 10, BOND * 10);
			translate([- THICKNESS * 2, 0, 0])   rotate([0, 90, 0]) cylinder(THICKNESS * 10, BOND * (10 - THICKNESS), BOND * (10 - THICKNESS));
			translate([0, 0, - BOND * 20 / 2])  cube(BOND * 20, BOND * 20, BOND * 20, center = true);
		}
	}

    module base() {
        difference() {

            union() {

                difference() {
                    cylinder(THICKNESS * 4, BOND * 10, BOND * 10);
                    cylinder(THICKNESS * 8, BOND * (10 - THICKNESS), BOND * (10 - THICKNESS));
                }

                for (s = [1:2]){
                    rotate([0, 0, s * 90]) arch();
                }

                translate([0, 0, BOND * (10 - THICKNESS)]) cylinder(THICKNESS * 8, (4 * THICKNESS), (4 * THICKNESS));
            }

            translate([0, 0, 0]) cylinder(THICKNESS * 100, DIAMETER, DIAMETER);
        }

        for (s = [1:HOLES_BY_FACE]) {
            for (x = [0:3]) {
                difference() {
                    translate([0, 0, THICKNESS * 4]) rotate([0, 0, SPACE * s + (x * 90)]) translate([((BOND * 10 - (BOND * (10 - THICKNESS))) / 2) + BOND * (10 - THICKNESS), 0, 0])
                        cylinder(THICKNESS * 1.2, (BOND * 10 - BOND * (10 - THICKNESS)) / 2, (BOND * 10 - BOND * (10 - THICKNESS)) / 2);

                    translate([0, 0, THICKNESS * 4]) rotate([0, 0, SPACE * s + (x * 90)]) translate([((BOND * 10 - (BOND * (10 - THICKNESS))) / 2) + BOND * (10 - THICKNESS), 0, 0])
                        cylinder(THICKNESS * 2, DIAMETER, DIAMETER * 4);
                }
            }
        }
    }

    difference() {
        base();

        // Holes
        for (s = [1:HOLES_BY_FACE]) {
            for (x = [0:3]) {
                rotate([0, 0, SPACE * s + (x * 90)]) translate([((BOND * 10 - (BOND * (10 - THICKNESS))) / 2) + BOND * (10 - THICKNESS), 0, 0]) cylinder(100, DIAMETER, DIAMETER);
            }
        }
    }
}

structure();

