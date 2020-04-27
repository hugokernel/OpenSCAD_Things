
$fn = 60;

Internal_diameter_top = 49.5;
Internal_diameter_bottom = 51;
External_diameter = 53;
Grid_width = 1.5;
Grid_height = 3;
Grid_interval = 7;
Hole_diameter = 0;
Height = 20;

module main() {
    module holes() {
        for (angle = [0 : 45 : 360]) {
            translate([0, 0, Height / 2]) {
                rotate([0, 90, angle]) {
                    cylinder(r=Hole_diameter / 2, h=External_diameter * 2, center=true);
                }
            }
        }
    }

    difference() {
        cylinder(r=External_diameter / 2, h=Height);
        translate([0, 0, -Height / 2]) {
            cylinder(r1=Internal_diameter_bottom / 2, r2=Internal_diameter_top / 2, h=Height * 2);
        }

        if (Hole_diameter) {
            holes();
        }
    }

    module grid() {
        width = 1.5;
        intersection() {
            cylinder(r=External_diameter / 2, h=Height);

            union() {
                for (x = [-External_diameter / 2 : Grid_interval : External_diameter / 2]) {
                    translate([x, 0, Height - width / 2]) {
                        cube(size=[width, External_diameter, Grid_height], center=true);
                    }
                }

                for (y = [-External_diameter / 2 : Grid_interval : External_diameter / 2]) {
                    translate([0, y, Height - width / 2]) {
                        cube(size=[External_diameter, width, Grid_height], center=true);
                    }
                }
            }
        }
    }

    grid();
}

main();

