include <BOSL2/std.scad>

$fn = 100;

// This thing is used to fillup a wall hole used for electrical wire

Display = 0; // [0:Base, 1:Male, 2:Female]

// The wall hole diameter
Wall_Hole_Diameter = 21;

// The wall thickess
Wall_Thickness = 15;

// The extra larger (related to wall hole diameter) you want for the external cylinder
External_Cylinder_Diameter_Extra = 10;

// Thickness of the external cylinder
External_Cylinder_Thickness = 3;

// The electrical wire diameter
Electrical_Wire_Diameter = 5.5;

module base() {
    difference() {
        union() {
            cyl(d=Wall_Hole_Diameter + External_Cylinder_Diameter_Extra, l=External_Cylinder_Thickness, chamfer2=0.5);
            down(External_Cylinder_Thickness / 2 + Wall_Thickness / 2) {
                cyl(d=Wall_Hole_Diameter, l=Wall_Thickness);
            }
        }

        cyl(d=Electrical_Wire_Diameter, l=100);
    }
}

module main(piece1=true) {

    // Substracter
    module piece2() {
        right(Wall_Hole_Diameter / 2) {
            cube(size=[Wall_Hole_Diameter, Electrical_Wire_Diameter, Wall_Thickness * 3], center=true);
        }
    }

    module blocker(radius=2) {
        back(1.1) {
            difference() {
                sphere(r=radius);
                fwd(1) {
                    back(radius) {
                        cube(size=[radius * 2, radius * 2, radius * 4], center=true);
                    }
                }
            }
        }
    }

    module blockers(radius=2) {
        module pos() {
            down(Wall_Thickness / 2) {
                fwd(Electrical_Wire_Diameter / 2) {
                    right(Electrical_Wire_Diameter / 8) {
                        blocker(radius);
                    }
                }
            }

            right(4) {
                down(Wall_Thickness / 2) {
                    fwd(Electrical_Wire_Diameter / 2) {
                        right(Electrical_Wire_Diameter / 8) {
                            blocker(radius);
                        }
                    }
                }
            }
        }

        pos();
        yflip() {
            pos();
        }
    }

    if (piece1) {
        difference() {
            base();
            piece2();

            blockers(2);
        }
    } else {
        intersection() {
            base();
            piece2();
        }

        blockers(1.85);
    }
}

if (Display == 0) {
    base();
} else if (Display == 1) {
    main();
} else if (Display == 2) {
    main(false);
}
