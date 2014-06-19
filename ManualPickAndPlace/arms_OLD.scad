
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

module m3_nut(height = 2) {
    cylinder(r = 3.4, h = height, center = true, $fn = 6);
}

module m3_hole(length = 50) {
    cylinder(r = 1.9, h = length, center = true);
}

module m3_cone(height = 2) {
    cylinder(r1 = 3.9, r2 = 1.9, h = height, center = true);
}

module arm_male(width = 15,
                length = 40,
                thickness = ARM_THICKNESS,
                holder_height = BEARING_HEIGHT / 2, 
                nut = true,
                cone = false) {

    bearing_support_thickness = 0.5;
    bearing_support_diameter = 12;

    clear = -0.15;

    module bearing() {
        translate([0, 0, bearing_support_thickness / 2]) {
            cylinder(r = bearing_support_diameter / 2, h = bearing_support_thickness, center = true);

            translate([0, 0, BEARING_HEIGHT / 4]) {
                cylinder(r = BEARING_INTERNAL_DIAMETER / 2 - clear, h = holder_height, center = true);
            }
        }
    }

    module position() {
        for (pos = [
            [ -length / 2, 0, 0 ],
            [ length / 2, 0, 0 ]
        ]) {
            translate(pos) {
                for (i = [0 : $children - 1]) {
                    children(i);
                }
            }
        }
    }

    translate([length / 2, 0, 0]) {
        difference() {
            union() {
                position() {
                    cylinder(r = width / 2, h = thickness, center = true);
                    translate([0, 0, thickness / 2]) {
                        bearing();
                    }
                }

                cube(size = [length, 15, thickness], center = true);
            }

            translate([0, 0, -thickness / 5.5]) {
                position() {
                    if (nut) {
                        m3_nut();
                    } else if (cone) {
                        m3_cone();
                    }

                    m3_hole();
                }
            }
        }
    }
}

closed_cap_thickness = 2.5;
module female_bearing(  width = 30,
                        thickness = THICKNESS,
                        clear = 0.15,
                        closed = false,
                        closed_cap_thickness = closed_cap_thickness,
                        fn = $fn) {
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

HOLDER_DIAMETER = 28;
module holder_male(height = 14, block_size = 3, skirt_thickness = 2, skirt_size = 2, full = false) {

    module hole() {
        translate([-HOLDER_DIAMETER / 2, 0, 0]) {
            rotate([0, 90, 0]) {
                cylinder(r = 1, h = HOLDER_DIAMETER, center = true);
            }
        }
    }

    module holes() {
        for (rot = [0 : 90 : 360]) {
            rotate(rot) {
                hole();
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
            holes();
        }
    }

    translate([HOLDER_DIAMETER / 2 + block_size / 2 - 1, 0, 0]) {
        cube(size = [block_size, block_size, height], center = true);
    }

    if (full) {
        holes();
    }
}

module holder(thickness = 18) {

    width = 32;

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
                    holder_male(height = thickness, full = true);
                }
            }
        }
    }
}

module mount_point() {
    thickness = BEARING_HEIGHT;
    union() {
        socket(female = false, height = 35, oblong = true, hole_diameter = 4.5);

        translate([0, 17, 2.5]) {
            rotate([0, 0, 90]) {
                linear_extrude(height = thickness + .5) {
                    polygon([[3,2],[18,2],[18,5],[14,10],[12.5,23]]);
                }
            }
        }

        translate([-2.5, 26, -4]) {
            rotate([-90,-180, 0]) {
                linear_extrude(height = thickness) {
                    polygon([[0,0],[0,7],[9, 7]]);
                }
            }
        }

        translate([-2.5, 29.5, 0]) {
            rotate([-90, 180, -90]) {
                linear_extrude(height = 5) {
                    polygon([[-10, 10],[-10,-15],[16,5],[16,10]]);
                }
            }
        }
    }

    translate([-15, 42, 6.5]) {
        female_bearing(thickness = thickness, closed = true, closed_cap_thickness = 0.5);
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

    mount_point();

    translate([-15, 35, 2.5]) {
        rotate([0, 0, 180 - 0]) {
            dbl_arm_male(length = 60);
        }
    }

    translate([-80, 35, 0]) {
        rotate([0, 0, 45]) {
            translate([0, 0, 3]) {
                rotate([0, 90, -45 + final_horizontal_angle]) {
                    //arm_blocker();
                    tripod(blocker = true);
                    /*
                    %arm_female_special() {
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
                    */
                }
            }
        }
    }
}

module arm_blocker() {
    gap = 40;

    arm_male(length = gap, holder_height = BEARING_HEIGHT / 2);

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
            arm_blocker();
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

module holder_male_bearing() {
    rotate([0, 180, 0]) {
        holder_male(height = 20);
    }

    for (data = [
        [[0, 0, 5], 0],
        [[0, 0, 5], 1]
    ]) {
        mirror([0, 0, data[1]]) {
            translate(data[0]) {
                female_bearing(width = HOLDER_DIAMETER - 1, thickness = 10, closed = true, closed_cap_thickness = 2);
            }
        }
    }

    %for (pos = [
        [0, 0, 6],
        [0, 0, -6]
    ]) {
        translate(pos) {
            bearing();
        }
    }
}

module holder_male_syringe() {
    rotate([0, 180, 0]) {
        holder_male(height = 20);
    }

    %cylinder(r = 25 / 2, h = 115, center = true);
}

demo();

!mount_point();

//arm_male(length=40, holder_height=BEARING_HEIGHT);

arm_male(length=40, nut=true);
arm_male(length=40, nut=false, cone=true);

arm_male(length=0, nut=false, cone=true);
arm_male(length=0, nut=true, cone=false);

tripod(blocker = true);

arm_blocker();

module demo_hold() {
    holder();
    translate([0.5, 0, 24]) {
        rotate([0, 90, 0]) {
            //holder_male();
            holder_male_bearing();
        }
    }
}

holder();
demo_hold();
holder_male();

holder_male_bearing();
holder_male_syringe();

