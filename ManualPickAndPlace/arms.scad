
use <table.scad>

BEARING_INTERNAL_DIAMETER = 7.8;
BEARING_EXTERNAL_DIAMETER = 22.05;
BEARING_HEIGHT = 7;

DEMO = true;

thickness = 5;

module bearing() {
    difference() {
        cylinder(r = BEARING_EXTERNAL_DIAMETER / 2, BEARING_HEIGHT, center = true);
        cylinder(r = BEARING_INTERNAL_DIAMETER / 2, BEARING_HEIGHT * 2, center = true);
    }
}

module arm_male() {

    width = 15;
    length = 40;
    thickness = 3;
    bearing_support_thickness = 0.5;
    bearing_support_diameter = 12;

    clear = -0.20;

    module bearing() {
        translate([0, 0, bearing_support_thickness / 2]) {
            cylinder(r = bearing_support_diameter / 2, h = bearing_support_thickness, center = true);

            translate([0, 0, BEARING_HEIGHT / 4]) {
                cylinder(r = BEARING_INTERNAL_DIAMETER / 2 - clear, h = BEARING_HEIGHT / 2, center = true);
            }
        }
    }

    translate([length / 2, 0, 0]) {
        /*
        for (data = [
            [ -length / 2, 0 ],
            [ length / 2, 1 ]
        ]) {
            translate([ data[0], 0, 0 ]) {
                cylinder(r = width / 2, h = thickness, center = true);

                translate([0, 0, thickness / 2]) { 
                    bearing();

                    if ($children) {
                        children(data[1]);
                    }
                }
            }
        }
        */

        translate([ -length / 2, 0, 0 ]) {
            color("ORANGE")
            cylinder(r = width / 2, h = thickness, center = true);

            translate([0, 0, thickness / 2]) { 
                bearing();

                if ($children) {
                    echo("FIRST!");
                    children(0);
                }
            }
        }

        translate([ length / 2, 0, 0 ]) {
            color("RED")
            cylinder(r = width / 2, h = thickness, center = true);

            translate([0, 0, thickness / 2]) { 
                bearing();

                if ($children) {
                    echo("SECOND!");
                    children(1);
                }
            }
        }

        cube(size = [length, 15, thickness], center = true);
    }
}

module female_bearing(width = 30, thickness = 5, clear = 0) {
    difference() {
        cylinder(r = width / 2, h = thickness, center = true);
        cylinder(r = BEARING_EXTERNAL_DIAMETER / 2 + clear, thickness + 1, center = true);
    }

    if ($children) {
        translate([0, 0, -thickness]) {
            for (i = [0 : $children - 1]) {
                children(i);
            }
        }
    }

    if (DEMO) {
        color("GREY") {
            bearing();
        }
    }
}

module arm_female(gap = 40) {

    width = 30;

    clear = 0.2;

    translate([gap / 2, 0, 0]) {
        for (data = [
            [ -gap / 2, 0 ],
            [ gap / 2, 1 ]
        ]) {
            translate([ data[0], 0, 0 ]) {
                female_bearing(width = width, thickness = thickness, clear = clear) {
                    if ($children) {
                        translate([0, 0, -thickness]) {
                            children(data[1]);
                        }
                    }
                }
            }
        }

        cube(size = [gap - BEARING_EXTERNAL_DIAMETER - clear * 2, 15, thickness], center = true);
    }
}

module arm_female_special() {

    width = 30;
    thickness = 5;

    clear = 0.2;

    translate([0, 0, -16]) {
        arm_female() {
            if ($children) {
                children(0);
                children(1);
            }
        }

        translate([0, 0, 16]) {
            rotate([0, 90, 0]) {
                female_bearing(width = width, thickness = thickness, clear = clear);
            }
        }
    }
}

module dbl_arm_male() {
    arm_male();
    translate([0, 0, 11]) {
        rotate([ 180, 0, 0]) {
            arm_male() {
                if ($children) {
                    translate([0, 0, thickness / 2]) {
                        for (i = [0 : $children - 1]) {
                            children(i);
                        }
                    }
                }
            }
        }
    }
}

module demo() {

    final_horizontal_angle = 0;
    vertical_angle = 0;

    module dummy() {
        cylinder(r = 10, h = 50);
        echo("DUMMY");
    }

    socket(female = false, height = 35, oblong = true);

    first_horizontal_angle = 0;

    translate([-20, 40, 0]) {
        rotate([0, 0, 180 + first_horizontal_angle]) {
            female_bearing() {
                dbl_arm_male() {
                    dummy();
                    rotate([0, 0, 90])arm_female();
                }
            }
        }
    }
}

//!arm_male() {
!dbl_arm_male() {
    cylinder(r = 3, h = 50);
    cylinder(r = 4, h = 50);
}

demo();

intersection() {
    translate([20, 0, 0])
    cube(size = [40, 30, 30], center = true);
    arm_female();
    arm_female_special();
}

intersection() {
    translate([20, 0, 0])
    cube(size = [20, 30, 30], center = true);
    arm_male();
}

