
scale_coeff = 1.46;
x = 15.5;

module nut() {
    nut_diameter = 11.2;
    nut_clear = 0.2;
    nut_height = 4.6 + 1;
    cylinder(r = nut_diameter / 2 + nut_clear, h = nut_height, $fn = 6);
}

module main() {
    difference() {
        scale([scale_coeff, scale_coeff, scale_coeff]) {
            import("anchor.stl");
        }

        for (pos_x = [ -x, x ]) {
            translate([pos_x, 0, 16.5]) {
                nut();
            }
        }
    }
}

!main();

intersection() {
    main();
    translate([16, 0, 19]) {
        cube(size = [15, 15, 6], center = true);
    }
}

