
use <table.scad>
use <lib/makerbeam.scad>

$fn = 40;

BEARING_INTERNAL_DIAMETER = 5;
BEARING_EXTERNAL_DIAMETER = 10;
BEARING_HEIGHT = 4;
BEARING_FLANGE_DIAMETER = 11.2;
BEARING_FLANGE_THICKNESS = .8;

BEARING_INTERNAL_ROTATE_DIAMETER = 12;

THICKNESS = 5;

ARM_THICKNESS = 3;

DEMO = true;

module tube(external, internal, height) {
    difference() {
        cylinder(r = external / 2, height, center = true);
        cylinder(r = internal / 2, height * 2, center = true);
    }
}

module bearing( external_diameter = BEARING_EXTERNAL_DIAMETER,
                internal_diameter = BEARING_INTERNAL_DIAMETER,
                height = BEARING_HEIGHT,
                flange_diameter = BEARING_FLANGE_DIAMETER,
                flange_thickness = BEARING_FLANGE_THICKNESS,
                ) {

    tube(external_diameter, internal_diameter, height);

    if (flange_thickness) {
        translate([0, 0, height / 2 - flange_thickness / 2]) {
            tube(flange_diameter, external_diameter - 1, flange_thickness);
        }
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

module bearing_negative() {
    clear_coeff = 1.10;
    scale([clear_coeff, clear_coeff, clear_coeff]) {
        union() {
            bearing();
            cylinder(r = BEARING_INTERNAL_DIAMETER / 2 + 1, h = bearing_support_thickness * 2, center = true);
        }
    }
}

bearing_support_width = 15;
bearing_support_thickness = BEARING_HEIGHT;
module bearing_support( width = bearing_support_width,
                        clear = 0.15,
                        fn = $fn) {

    difference() {
        tube(width, BEARING_EXTERNAL_DIAMETER, bearing_support_thickness);

        bearing_negative();
    }

    if (DEMO) {
        %bearing();
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

        /*
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
        */

        translate([-2.5, 29.5, 0]) {
            rotate([-90, 180, -90]) {
                linear_extrude(height = 5) {
                    polygon([[-10, 10],[-10,-15],[20.5,5],[20.5,10]]);
                }
            }
        }
    }

    translate([-11.5, 35, 8]) {
        rotate([0, 0, 90]) {
            male_join();
        }
    }
}

module demo() {

    final_horizontal_angle = 0;
    vertical_angle = 0;

    module arm_with_joins() {

        translate([-5, 70, -5]) {
            rotate([90, 0, 0]) {
                tslot(h = 60, w = slot_width, model = "tslot2");
            }
        }

        for (data = [
            [ 0, 0 ],
            [ 80, 180 ]
        ]) {
            translate([0, data[0], 0]) {
                rotate([0, 0, data[1]]) {
                    arm_join();
                }
            }
        }
    }

    module dbl_arm_male(width = 15, length = 40, thickness = 3) {
        arm_male(width, length, thickness);
        translate([0, 0, 11]) {
            rotate([ 180, 0, 0]) {
                arm_male(width, length, thickness);
            }
        }
    }

    mount_point();

    translate([-11.5, 35, 8]) {
        rotate([0, 0, 90]) {
            arm_with_joins();
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


male_thickness = 6.0;

module arm_join() {

    slot_width = 10;
    slot_clear = .6;

    hole_diameter = 3;

    module pos() {
        for (data = [
            [ 0, 0, bearing_support_thickness / 2 + male_thickness / 2, 0 ],
            [ 0, 0, -(bearing_support_thickness / 2 + male_thickness / 2), 180 ],
        ]) {
            translate([ data[0], data[1], data[2] ]) {
                rotate([0, data[3], 0]) {
                    if ($children) {
                        for (i = [0 : $children - 1]) {
                            children(i);
                        }
                    }
                }
            }
        }
    }

    /*
    %pos() {
        bearing_support();
    }
    */

    difference() {
        hull() {
            pos() {
                cylinder(r = bearing_support_width / 2, h = bearing_support_thickness, center = true);
            }

            //translate([0, 7, 0]) {
            translate([0, 13.5, 0]) {
                //cube(size = [12, 1, 12], center = true);
                cube(size = [12, 14, 12], center = true);
            }
        }

        translate([0, 0, 0]) {
            cube(size = [30, 17, male_thickness], center = true);
        }

        /*
        pos() {
            bearing_negative();
        }
        */

        cylinder(r = 2.55, h = 100, center = true);

        translate([0, 18, 0]) {
            cube(size = [slot_width + slot_clear, 15, slot_width + slot_clear], center = true);
        }

        rotate([90, 0, 0]) {
            cylinder(r = hole_diameter / 2 + .15, h = 100, center = true);
        }

        translate([0, 9.45, 0]) {
            rotate([90, 0, 0]) {
                cylinder(r1 = 1, r2 = 5.3 / 2, h = 2, center = true);
            }
        }
    }

    /*
    %pos() {
        bearing();
    }
    */

    %for (roty = [ 0, -90 ]) {
        rotate([0, roty, 0]) {
            for (rotx = [ 90, -90 ]) {
                translate([0, 15.5, 0]) {
                    rotate([rotx, 0, 0]) {
                        tnut(h=12,w=10);
                    }
                }
            }
        }
    }

    /*
    %translate([0, 42, 0]) {
        rotate([90, 0, 0]) {
            tslot(h=60, w=slot_width, model="tslot2");
            //tslot(model="tslot2",h=10,w=10);
        }
    }
    */
}

module male_join() {
    thickness = male_thickness - 2;
    difference() {
        hull() {
            cylinder(r = 5.5, h = thickness, center = true);
            translate([0, -9, 0]) {
                cube(size = [30, 0.1, thickness], center = true);
            }
        }

        cylinder(r = BEARING_INTERNAL_DIAMETER / 2, h = 100, center = true);
    }
}

!demo();

bearing();

bearing_support();

male_join();
tube(BEARING_INTERNAL_DIAMETER - 0.3, 0, 14.5);
union() {
    arm_join();
    male_join();
}

union() {
    mount_point();

    translate([-40, 40, 10]) {
        rotate([0, 90, 0]) {
            tslot(h=50, w=10);
            //tslot(model="tslot2",h=10,w=10);
        }
    }
}

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

