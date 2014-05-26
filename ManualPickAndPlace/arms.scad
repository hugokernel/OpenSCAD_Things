
use <table.scad>

$fn = 40;

BEARING_INTERNAL_DIAMETER = 7.8;
BEARING_EXTERNAL_DIAMETER = 22.05;
BEARING_INTERNAL_ROTATE_DIAMETER = 12;
BEARING_HEIGHT = 7;

THICKNESS = 5;

ARM_THICKNESS = 3;

DEMO = false;

module bearing() {
    difference() {
        cylinder(r = BEARING_EXTERNAL_DIAMETER / 2, BEARING_HEIGHT, center = true);
        cylinder(r = BEARING_INTERNAL_DIAMETER / 2, BEARING_HEIGHT * 2, center = true);
    }
}

module arm_male(width = 15, length = 40, thickness = ARM_THICKNESS, holder_height = BEARING_HEIGHT / 2) {

    bearing_support_thickness = 0.5;
    bearing_support_diameter = 12;

    clear = -0.20;

    module bearing() {
        translate([0, 0, bearing_support_thickness / 2]) {
            cylinder(r = bearing_support_diameter / 2, h = bearing_support_thickness, center = true);

            translate([0, 0, BEARING_HEIGHT / 4]) {
                cylinder(r = BEARING_INTERNAL_DIAMETER / 2 - clear, h = holder_height, center = true);
            }
        }
    }

    difference() {
        translate([length / 2, 0, 0]) {
            for (data = [
                [ -length / 2, 0 ],
                [ length / 2, 1 ]
            ]) {
                translate([ data[0], 0, 0 ]) {
                    difference() {
                        union() {
                            cylinder(r = width / 2, h = thickness, center = true);

                            translate([0, 0, thickness / 2]) {
                                bearing();

                                if ($children) {
                                    children(data[1]);
                                }
                            }
                        }

                        // Small hole
                        translate([0, 0, -(thickness + holder_height + bearing_support_thickness) / 2]) {
                           cylinder(r = 1, h = holder_height * 10);
                        }
                    }
                }
            }

            cube(size = [length, 15, thickness], center = true);
        }
    }
}

closed_cap_thickness = 2.5;
module female_bearing(width = 30, thickness = THICKNESS, clear = 0, closed = false, fn = $fn) {
    difference() {
        cylinder(r = width / 2, h = thickness, center = true, $fn = fn);
        cylinder(r = BEARING_EXTERNAL_DIAMETER / 2 + clear, thickness + 1, center = true);
    }

    if (closed) {
        translate([0, 0, -thickness / 2 - closed_cap_thickness / 2]) {
            difference() {
                cylinder(r = width / 2, h = closed_cap_thickness, center = true);
                translate([0, 0, 1]) {
                    cylinder(r = BEARING_INTERNAL_ROTATE_DIAMETER / 2 + 2, h = 10, center = true);
                }
            }
        }
    }

    if ($children) {
        for (i = [0 : $children - 1]) {
            children(i);
        }
    }

    if (DEMO) {
        color("GREY") {
            bearing();
        }
    }
}

module arm_female(gap = 40, thickness = 5, closed = false) {

    width = 30;

    clear = 0.2;

    for (data = [
        [ -gap / 2, 0 ],
        [ gap / 2, 1 ]
    ]) {
        translate([ data[0], 0, 0 ]) {
            female_bearing(width = width, thickness = thickness, clear = clear, closed = closed) {
                if ($children) {
                    children(data[1]);
                }
            }
        }
    }

    if (closed) {
        translate([0, 0, -closed_cap_thickness / 2]) {
            cube(size = [gap - BEARING_EXTERNAL_DIAMETER - clear * 2, 15, thickness + closed_cap_thickness], center = true);
        }
    } else {
        cube(size = [gap - BEARING_EXTERNAL_DIAMETER - clear * 2, 15, thickness], center = true);
    }
}

module arm_female_special(thickness = 5, closed = false, width = 35, fn = $fn) {

    clear = 0.2;

    translate([0, 0, -16]) {
        rotate([180, 0, 0]) {
            arm_female(thickness = thickness, closed = closed) {
                if ($children) {
                    children(0);
                    children(1);
                }
            }
        }

        translate([0, 0, 18]) {
            rotate([0, 90, 0]) {
                female_bearing(width = width, thickness = thickness, clear = clear, fn = fn);
            }
        }
    }
}

HOLDER_DIAMETER = 26;

module holder_male(width, full = false) {
    height = 14;
    block_size = 3;
    skirt_thickness = 2;
    skirt_size = 2;

    module hole() {
        translate([-HOLDER_DIAMETER / 2, 0, 0]) {
            rotate([0, 90, 0]) {
                cylinder(r = 1, h = HOLDER_DIAMETER, center = true);
            }
        }
    }

    difference() {
        union() {
            cylinder(r = HOLDER_DIAMETER / 2, h = height, center = true);

            if (!full) {
                translate([0, 0, -height / 2 + skirt_thickness / 2]) {
                    cylinder(r = HOLDER_DIAMETER / 2 + skirt_size / 2, h = skirt_thickness, center = true);
                }
            }
        }
        if (!full) {
            cylinder(r = (HOLDER_DIAMETER - 2) / 2, h = height + 1, center = true);
            hole();
        }
    }

    translate([HOLDER_DIAMETER / 2 + block_size / 2 - 1, 0, 0]) {
        cube(size = [block_size, block_size, height], center = true);
    }

    if (full) {
        hole();
    }
}

module holder() {

    width = 32;
    thickness = 10;

    clear = 1.02;

    rotate([0, 180, 0]) {
        arm_female(closed = true, thickness = BEARING_HEIGHT);
    }

    translate([0, 0, 24]) {
        difference() {
            hull() {
                rotate([0, 90, 0]) {
                    cylinder(r = HOLDER_DIAMETER / 2 + 6, h = thickness, center = true);//, $fn = 10);
                }

                translate([0, 0, -16]) {
                    cube(size = [thickness, 15, 6], center = true);
                }
            }

            rotate([0, 90, 0]) {
                scale([clear, clear, clear]) {
                    holder_male(full = true);
                }
            }
        }
    }
}

module mountPoint() {
    thickness = BEARING_HEIGHT;
    union() {
        socket(female = false, height = 35, oblong = true, hole_diameter = 4.5);

        translate([0, 10, 3]) {
            rotate([0, 0, 90]) {
                linear_extrude(height = thickness) {
                    polygon([[0,0],[18,0],[18,5],[14,10],[12.5,23]]);
                }
            }
        }

        translate([-2.5, 18, -7]) {
            rotate([-90,-180, 0]) {
                linear_extrude(height = thickness - 1) {
                    polygon([[0,0],[0,12],[12, 12]]);
                }
            }
        }

        translate([-2.5, 30, 0]) {
            rotate([-90, 180, -90]) {
                linear_extrude(height = 5) {
                    polygon([[-10, 10],[-10,-10],[10,5],[10,10]]);
                }
            }
        }
    }

    translate([-15, 35, 1.5]) {
        translate([0, 0, 5]) {
            female_bearing(thickness = thickness);
        }
    }
}

module demo() {

    final_horizontal_angle = 0;
    vertical_angle = 0;

    module dbl_arm_male(width = 15, length = 40, thickness = 3) {
        arm_male(width, length, thickness);
        translate([0, 0, 11]) {
            rotate([ 180, 0, 0]) {
                arm_male(width, length, thickness);
            }
        }
    }

    mountPoint();

    translate([-15, 35, 2.5]) {
        rotate([0, 0, 180 - 0]) {
            dbl_arm_male(length = 60);
        }
    }

    translate([-80, 35, 0]) {
        rotate([0, 0, 45]) {
            translate([0, 0, 3]) {
                rotate([0, 90, -45 + final_horizontal_angle]) {
                    arm_female_special() {
                        translate([40, 0, -6]) {
                            rotate([0, 0, -60 + vertical_angle]) {
                                dbl_arm_male();
                            }
                        }
                        translate([0, 0, -6]) {
                            rotate([0, 0, -60 + vertical_angle]) {
                                dbl_arm_male();
                            }
                        }
                    }
                }
            }
        }
    }
}

module armWithBlocker() {
    gap = 40;

    arm_male(length = gap, holder_height = BEARING_HEIGHT);

    %translate([gap, 0, THICKNESS]) {
        female_bearing();
    }

    translate([gap, 0, 0]) {
        translate([0, 13, 0]) {
            cube(size = [7, 19, ARM_THICKNESS], center = true);
        }

        translate([0, 20, 5]) {
            cube(size = [3, 5, 7], center = true);
        }
    }
}

module tripod(blocker = false) {
    gap = 40;
    thickness = BEARING_HEIGHT;

    %rotate([0, 0, -90]) {
        translate([-gap, gap / 2, -21.5]) {
            armWithBlocker();
        }
    }

    arm_female_special(thickness = thickness, closed = true, width = 38);//, fn = 10);

    if (blocker) {
        translate([gap / 2, 0, -14.75]) {
            difference() {
                cylinder(r = 17, h = thickness + closed_cap_thickness, center = true);
                cylinder(r = 13, h = thickness + 3, center = true);
                for (rot = [ -90 : 15 : 90 ]) {
                    rotate([rot, 90, 0]) {
                        cylinder(r = 0.75, h = 20, $fn = 40);
                    }
                }
            }
        }
    }
}



demo();

!mountPoint();

arm_male(length=40, holder_height=BEARING_HEIGHT);
arm_male(length=40);

tripod(blocker = true);

armWithBlocker();

module demo_hold() {
    holder();
    translate([0, 0, 24]) {
        rotate([0, 90, 0]) {
            holder_male();
        }
    }
}

holder();
demo_hold();
holder_male();

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


