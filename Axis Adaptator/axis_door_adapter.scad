
use <Thread_Library.scad>
use <axis.scad>

$fn = 50;

module door_mount(thickness, top_clear, back_clear) {

    support_thickness = 5;
    width = 20;
    height = 60;
    back_height = height / 2;

    difference() {
        union() {
            // Front support
            translate([0, 0, height / 2]) {
                cube(size = [width, support_thickness, height], center = true);
            }

            // Cylinder
            translate([0, support_thickness / 2, 0]) {
                rotate([90, 0, 0]) {
                    cylinder(r = width / 2, h = support_thickness);

                    translate([0, 0, support_thickness]) {
                        %axis_connector();
                    }
                }
            }

            // Top
            translate([0, thickness / 2 + support_thickness / 2, height - top_clear / 2]) {
                cube(size = [width, thickness, top_clear], center = true);
            }

            // Back plate
            translate([0, thickness + support_thickness / 2 + back_clear / 2, height - back_height / 2]) {
                cube(size = [width, back_clear, back_height], center = true);
            }
        }

        // Cylinder
        translate([0, 15, 0]) {
            rotate([90, 0, 0]) {
                cylinder(r = 0.9, h = 30);
            }
        }
    }
};

door_thickness = 30.7;
door_top_clear = 2.3;
door_back_clear = 3;

door_mount(door_thickness, door_top_clear, door_back_clear);

%translate([0, door_thickness / 2 + 5 / 2, 100 / 2]) {
    cube(size = [door_thickness, door_thickness, 100], center = true);
}

%axis_connector();

