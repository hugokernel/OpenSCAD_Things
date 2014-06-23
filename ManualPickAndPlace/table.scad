
include <lib/aluminiumProfiles.scad>;

$fn = 60;

PROFILE_WIDTH = 20;

FRAME_LENGTH = 600;
FRAME_WIDTH = 400;

ROD_DIAMETER = 12;
ROD_DIAMETER_CLEARANCE = 0.1;

DOLLY_X_POSITION = 100;
DOLLY_Y_POSITION = 50;

DOLLY_X_GAP = 70;
DOLLY_Y_GAP = 70; // 70 !

ROD_SUPPORT_HOLE_HEIGHT = 10;
ROD_SUPPORT_THICKNESS = 20;

FIXATION_HOLE_DIAMETER = 6;
SCREW_HEAD_DIAMETER = 10;

THICKNESS = 5;

module rod(length, diameter = ROD_DIAMETER) {
    rotate([0, 90, 0]) {
        cylinder(r = diameter / 2, h = length, center = true);
    }
}

module linearBall() {
    rotate([0, 90, 0]) {
        difference() {
            cylinder(r = 11, h = 32, center = true);
            cylinder(r = 6, h = 34, center = true);
        }
    }
}

module profile(width = PROFILE_WIDTH, length = 50) {
    //cube(size = [width, length, width], center = true);
    translate([ 0, length / 2, 0 ]) {
        rotate([90, 0, 0]) {
            tslot_20x20_base(l=length, detailed=true);
        }
    }
}

module cornerCube(width = 20) {
    hole = width / 2.9;
    difference() {
        cube(size = [ width, width, width ], center = true);
        cylinder(r = hole, h = width * 2, center = true);
        rotate([ 0, 90, 0 ]) {
            cylinder(r = hole, h = width * 2, center = true);
        }
        rotate([ 90, 0, 0 ]) {
            cylinder(r = hole, h = width * 2, center = true);
        }
    }
}

lm12uu_length = 30;
module lm12uu(  external_diameter = 21,
                internal_diameter = 12,
                slot_thickness = 2,
                slot_deepness = 1,
                length = lm12uu_length
    ) {
    module slot() {
        difference() {
            cylinder(r = 11, h = slot_thickness, center = true);
            cylinder(r = 11 - slot_deepness, h = slot_thickness, center = true);
        }
    }

    //%cube(size = [21, 21, 21], center = true);

    difference() {
        cylinder(r = external_diameter / 2, h = length, center = true);

        translate([0, 0, -1]) {
            cylinder(r = internal_diameter / 2, h = 40, center = true);
        }

        for (pos = [
            [ 0, 0, 21 / 2 ],
            [ 0, 0, -21 / 2 ],
        ]) {
            translate(pos) {
                slot();
            }
        }
    }
}

sk12_support_length = 42;
module sk12(hole_height = 26, base_thickness = 6, thickness = 14, fixation_hole_diameter = 6, support_length = 42) {

    difference() {
        translate([0, 0, base_thickness / 2]) {
            union() {
                // Base
                cube(size = [support_length, thickness, base_thickness], center = true);

                // Main
                translate([0, 0, base_thickness / 2 + (hole_height + 5.5) / 2]) {
                    cube(size = [20, thickness, hole_height + 5.5], center = true);
                }
            }
        }

        // Rod hole
        translate([0, thickness, hole_height]) {
            rotate([90, 0, 0]) {
                cylinder(r = 6, h = thickness * 2);
            }
        }

        // Fixation hole
        for (pos = [
            [ -15, 0, 0 ],
            [ 15, 0, 0 ]
        ]) {
            translate(pos) {
                cylinder(r = fixation_hole_diameter / 2, h = thickness * 2);
            }
        }
    }
}

profile_slot_thickness = 2;
module profileSlot(length, slot_thickness = profile_slot_thickness) {
    cube(size = [5.8, length, slot_thickness], center = true);
}

rod_support_offset = 10;
module rod_support(hole_height = 26, base_thickness = 6, thickness = 20, fixation_hole_diameter = FIXATION_HOLE_DIAMETER, screw_head_diameter = SCREW_HEAD_DIAMETER, stopper = false, stopper_thickness = 1.5) {

    hole_height = 10;

    module profile(thickness) {
        hull() {
            // Base
            translate([5, 0, 0]) {
                cube(size = [30, thickness, base_thickness], center = true);
            }

            translate([0, 0, hole_height - base_thickness / 2]) {
                rotate([90, 0, 0]) {
                    cylinder(r = 10, h = thickness, center = true);
                }
            }
        }
    }

    translate([0, 0, base_thickness / 2]) {
        difference() {
            profile(thickness);

            // Rod hole
            translate([0, thickness, hole_height - base_thickness / 2]) {
                rotate([90, 0, 0]) {
                    cylinder(r = ROD_DIAMETER / 2 + ROD_DIAMETER_CLEARANCE * 2, h = thickness * 2);
                }
            }

            // Fixation hole
            translate([ 15, 0, -3.9 ]) {
                screw();
            }

            translate([ 15, 0, 3 ]) {
                cylinder(r = screw_head_diameter / 2, h = thickness * 2);
            }
        }
    }

    translate([-2.5, 0, -profile_slot_thickness / 2]) {
        rotate([0, 0, 90]) {
            profileSlot(15);
        }
    }

    if (stopper) {
        translate([0, thickness / 2 + stopper_thickness / 2, base_thickness / 2]) { 
            profile(stopper_thickness);
        }
    }
}

module blocker( hole_height = 26,
                base_thickness = 6,
                thickness = 20,
                fixation_hole_diameter = FIXATION_HOLE_DIAMETER,
                screw_head_diameter = SCREW_HEAD_DIAMETER) {

    hole_height = 10;
    rod_clear = .2;
    profile_clear = 0.2;

    module profile(thickness) {
        hull() {
            // Base
            translate([2.5 + profile_clear / 2, 0, 0]) {
                cube(size = [25 + profile_clear, thickness, base_thickness], center = true);
            }

            translate([0, 0, hole_height - base_thickness / 2]) {
                rotate([90, 0, 0]) {
                    cylinder(r = 10, h = thickness, center = true);
                }
            }
        }
    }

    translate([0, 0, base_thickness / 2]) {
        difference() {
            profile(thickness);

            // Rod hole
            translate([0, thickness, hole_height - base_thickness / 2]) {
                rotate([90, 0, 0]) {
                    cylinder(r = ROD_DIAMETER / 2 + ROD_DIAMETER_CLEARANCE * 2 + rod_clear, h = thickness * 2);
                }
            }
        }
    }

    wall_thickness = 5;
    difference() {
        union() {
            translate([PROFILE_WIDTH / 2 + wall_thickness / 2 + profile_clear, 0, -PROFILE_WIDTH / 4]) {//PROFILE_WIDTH]) {
                cube(size = [wall_thickness, 20, PROFILE_WIDTH / 2], center = true);
            }

            translate([PROFILE_WIDTH / 2 + profile_clear, 0, -PROFILE_WIDTH / 2]) {
                rotate([0, 90, 0]) {
                    cylinder(r = 10, h = 5);
                }
            }
        }

        // Fixation hole
        rotate([0, 90, 0]) {
            translate([ PROFILE_WIDTH / 2, 0, 8.25 ]) {
                screw();
            }
        }
    }

    translate([0, 0, -profile_slot_thickness / 2]) {
        rotate([0, 0, 0]) {
            profileSlot(20);
        }
    }
}

module screw() {
    cylinder(r = FIXATION_HOLE_DIAMETER / 2, h = 10, center = true);
    translate([0, 0, 5 + 0.999]) {
        cylinder(r1 = FIXATION_HOLE_DIAMETER / 2, r2 = SCREW_HEAD_DIAMETER / 2, h = 2, center = true);
    }
}

module stem_support() { 
                       
    fixation_hole_diameter = FIXATION_HOLE_DIAMETER;
    thickness = 5;

    module pos() {
        for (pos = [
            [ -15, 0, 0 ],
            [ 15, 0, 0 ]
        ]) {
            translate(pos) {
                if ($children) {
                    for (i = [0 : $children - 1]) {
                        children(i);
                    }
                }
            }
        }
    }

    difference() {
        union() {
            hull() {
                pos() {
                    cylinder(r = 10, h = thickness, center = true);
                }
            }

            /*
            translate([0, 0, thickness / 2 + profile_slot_thickness / 2]) {
                rotate([0, 0, 90]) {
                    profileSlot(20);
                }
            }
            */

            difference() {
                rotate([45, 0, 0]) {
                    cube(size = [15, 17, 17], center = true);
                }

                translate([0, 0, -7.5]) {
                    cube(size = [50, 50, 20], center = true);
                }

                translate([0, 0, 21]) {
                    cube(size = [50, 50, 20], center = true);
                }
            }
        }

        // Fixation hole
        pos() {
            translate([0, 0, -4.4]) {
                screw();
            }
        }

        rotate([45, 0, 0]) {
            translate([0, 4, 0]) {
                cylinder(r = 0.55, h = 100, center = true);
            }
        }
    }
}

module desk(box_length = 54, box_width = 20) { 
                       
    fixation_hole_diameter = FIXATION_HOLE_DIAMETER;
    thickness = 5;

    module pos(width) {
        for (pos = [
            [ -width / 2, 0, 0 ],
            [ width / 2, 0, 0 ]
        ]) {
            translate(pos) {
                if ($children) {
                    for (i = [0 : $children - 1]) {
                        children(i);
                    }
                }
            }
        }
    }

    /*
    translate([0, 0, 10]) {
        rotate([-45, 0, 0]) {
            difference() {
                cube(size = [box_length, 22, 18], center = true);
                translate([0, 0, -4]) {
                    cube(size = [50, 18, 18], center = true);
                }
            }
        }
    }
    */

    module elec() {
        difference() {
            cube(size = [48, 16.5, 1.5], center = true);
            for (pos = [
                [ -19, 0, 0 ],
                [ 19, 0, 0 ],
            ]) {
                translate(pos) {
                    cylinder(r = 2, h = 20, center = true);
                }
            }
        }

        for (pos = [
            [ -9.5, 0, 7 / 2 ],
            [ 9.5, 0, 7 / 2 ],
        ]) {
            translate(pos) {
                cylinder(r = 6, h = 7, center = true);
                translate([0, 0, 7]) {
                    cylinder(r = 4.5, h = 7, center = true);
                }
            }
        }
    }

    difference() {
        union() {
            difference() {
                hull() {
                    pos(width = box_length + 30) {
                        cylinder(r = 10, h = thickness, center = true);
                    }
                }

                // Fixation hole
                pos(width = box_length + 30) {
                    translate([0, 0, -4.4]) {
                        screw();
                    }
                }
            }

        //%cube(size = [box_length, 10, 30], center = true);

            difference() {
                hull() {
                    translate([0, 7, thickness / 2]) {
                        pos(width = box_length) {
                            cylinder(r = 10, h = 0.1, center = true);
                        }
                    }

                    translate([0, 7, thickness / 2 + 25]) {
                        pos(width = box_length) {
                            cylinder(r = 10, h = 0.1, center = true);
                        }
                    }

                    translate([0, 4, 6]) {
                        rotate([-30, 0, 0]) {
                            cube(size = [box_length + 6, 20, 35], center = true);
                        }
                    }
                }

                // Top plan
                translate([0, 0, 34]) {
                    rotate([-30, 0, 0]) {
                        cube(size = [box_length * 2, 60, 20], center = true);
                    }
                }

                // Bottom plan
                translate([0, 0, -20 / 2 - thickness / 2]) {
                    cube(size = [100, 100, 20], center = true);
                }
            }
        }

        // Empty box
        translate([0, 3, 5]) {
            rotate([-30, 0, 0]) {
                cube(size = [box_length, box_width, 26], center = true);
            }
        }

        translate([0, 4, 9]) {
            rotate([-30, 0, 0]) {
                scale([1.1, 1.1, 1.1]) {
                    elec();
                }
            }
        }
    }
}

/*
module desk() { 
                       
    fixation_hole_diameter = FIXATION_HOLE_DIAMETER;
    thickness = 5;

    module elec() {
        difference() {
            cube(size = [48, 16.5, 1.5], center = true);
            for (pos = [
                [ -19, 0, 0 ],
                [ 19, 0, 0 ],
            ]) {
                translate(pos) {
                    cylinder(r = 2, h = 20, center = true);
                }
            }
        }

        for (pos = [
            [ -9.5, 0, 7 / 2 ],
            [ 9.5, 0, 7 / 2 ],
        ]) {
            translate(pos) {
                cylinder(r = 6, h = 7, center = true);
                translate([0, 0, 7]) {
                    cylinder(r = 4.5, h = 7, center = true);
                }
            }
        }
    }

    module pos() {
        for (pos = [
            [ -35, 0, 0 ],
            [ 35, 0, 0 ]
        ]) {
            translate(pos) {
                if ($children) {
                    for (i = [0 : $children - 1]) {
                        children(i);
                    }
                }
            }
        }
    }

    translate([0, 0, 10]) {
        rotate([-45, 0, 0]) {
            elec();
        }
    }

    translate([0, 0, 10]) {
        rotate([-45, 0, 0]) {
            difference() {
                cube(size = [54, 22, 18], center = true);
                translate([0, 0, -4]) {
                    cube(size = [50, 18, 18], center = true);
                }
            }
        }
    }

    difference() {
        union() {
            hull() {
                pos() {
                    cylinder(r = 10, h = thickness, center = true);
                }
            }

            /*
            translate([0, 0, thickness / 2 + profile_slot_thickness / 2]) {
                rotate([0, 0, 90]) {
                    profileSlot(20);
                }
            }
            *-/
        }

        // Fixation hole
        pos() {
            translate([0, 0, -4.4]) {
                screw();
            }
        }
    }
}
*/

/*
module cable_passes() { 
                       
    fixation_hole_diameter = FIXATION_HOLE_DIAMETER;
    thickness = 5;

    difference() {
        hull() {
            for (pos = [
                [ -5, 0, 0 ],
                [ 5, 0, 0 ]
            ]) {
                translate(pos) {
                    cylinder(r = 10, h = thickness, center = true);
                }
            }
        }

        // Fixation hole
        translate([5, 0, -4.4]) {
            screw();
        }
    }
}
*/

foot_width = PROFILE_WIDTH;
foot_length = 15;
foot_thickness = 5;
module foot(width = foot_width, length = foot_length, thickness = foot_thickness, fixation_hole_diameter = FIXATION_HOLE_DIAMETER, screw_head_diameter = SCREW_HEAD_DIAMETER) {
    difference() {
        union() {
            cube(size = [width, length * 2, thickness], center = true);
            translate([0, 10, thickness / 2 + profile_slot_thickness / 2]) {
                profileSlot(width / 2);
            }
        }

        translate([ 0, -7, -5 ]) {
            cylinder(r = fixation_hole_diameter / 2, h = thickness * 2);
        }

        translate([ 0, -7, -thickness + 2.4 ]) {
            cylinder(r = screw_head_diameter / 2, h = 3);
        }
    }
}

module foots() {
    // Foot
    for (pos = [
        [ FRAME_LENGTH / 2 - foot_width / 2, FRAME_WIDTH / 2 - foot_length, -foot_thickness / 2 ],
        [ - FRAME_LENGTH / 2 + foot_width / 2, FRAME_WIDTH / 2 - foot_length, -foot_thickness / 2 ],
        [ FRAME_LENGTH / 2 - foot_width / 2, - FRAME_WIDTH / 2 + foot_length, -foot_thickness / 2, 180 ],
        [ - FRAME_LENGTH / 2 + foot_width / 2, - FRAME_WIDTH / 2 + foot_length, -foot_thickness / 2, 180 ]
    ]) {
        translate([ pos[0], pos[1], pos[2] ]) {
            rotate([0, 0, pos[3]]) {
                foot();
            }
        }
    }
}

module frame(width = 20) {

    translate([0, 0, PROFILE_WIDTH / 2]) {
        // Ghost
        //%cube(size = [FRAME_LENGTH, FRAME_WIDTH, 23], center = true);

        for (data = [
            // length, x, y, rotation
            [ FRAME_LENGTH - width * 2, -FRAME_WIDTH / 2 + width / 2, 0, 90, "RED" ],
            [ FRAME_LENGTH - width * 2, FRAME_WIDTH / 2 - width / 2, 0, 90, "RED" ],
            [ FRAME_WIDTH,  -FRAME_LENGTH / 2 + width / 2, 0, 0, "GREEN" ],
            [ FRAME_WIDTH,  FRAME_LENGTH / 2 - width / 2, 0, 0, "GREEN" ],
        ]) {
            rotate([ 0, 0, data[3] ]) {
                translate([ data[1], data[2], 0 ]) {
                    //color(data[4]) {
                        profile(length = data[0]);
                    //}
                }
            }
        }
    }
}

module rod_and_support(width = PROFILE_WIDTH) {

    // Rod support
    for (data = [
        [ FRAME_LENGTH / 2 - width / 2, FRAME_WIDTH / 2 - rod_support_offset, PROFILE_WIDTH, -90 ],
        [ -FRAME_LENGTH / 2 + width / 2, FRAME_WIDTH / 2 - rod_support_offset, PROFILE_WIDTH, -90 ],
        [ FRAME_LENGTH / 2 - width / 2, -FRAME_WIDTH / 2 + rod_support_offset, PROFILE_WIDTH, 90 ],
        [ -FRAME_LENGTH / 2 + width / 2, -FRAME_WIDTH / 2 + rod_support_offset, PROFILE_WIDTH, 90 ]
    ]) {
        translate([ data[0], data[1], data[2]]) {
            rotate([0, 0, data[3]]) {
                rod_support(hole_height = ROD_SUPPORT_HOLE_HEIGHT, thickness = ROD_SUPPORT_THICKNESS);
            }
        }
    }

    // X rod
    offset_z = width + ROD_SUPPORT_HOLE_HEIGHT;
    for (data = [
        // x, y, rot z, length
        [ FRAME_WIDTH / 2 - 10, FRAME_LENGTH ],
        [ -FRAME_WIDTH / 2 + 10, FRAME_LENGTH ]
    ]) {
        translate([ 0, data[0], offset_z ]) {
            rod(length = data[1]);
        }
    }
}

module lm12uu_holder(length = lm12uu_length, thickness = 3, slot_thickness = 1, closed = false) {

    difference() {
        rotate([0, 90, 0]) {
            difference() {
                hull() {
                    cylinder(r = 11 + thickness, h = length, center = true);
                    if ($children) {
                        for (i = [0 : $children - 1]) {
                            children(i);
                        }
                    }
                }

                lm12uu(internal_diameter = 0, external_diameter = 21.3, slot_thickness = slot_thickness, slot_deepness = 0.3);
            }
        }

        if (!closed) {
            translate([0, 0, -16]) {
                cube(size = [50, 50, 20], center = true);
            }
        }
    }

    /*
    %rotate([0, 90, 0]) {
        lm12uu();
    }
    */
}

module lm12uu_rodshaft(stopper_thickness = 2.3, slot_thickness = 0) {
    difference() {
        lm12uu_holder(slot_thickness = slot_thickness) {
            translate([-17, stopper_thickness / 2, 0]) {
                rotate([90, 0, 0]) {
                    difference() {
                        cylinder(r = 10, h = 25 + stopper_thickness, center = true);
                    }
                }
            }
        }

        rotate([90, 0, 0]) {
            translate([0, 17.1, 0]) {
                cylinder(r = ROD_DIAMETER / 2 + ROD_DIAMETER_CLEARANCE, h = 28, center = true);
            }
        }
    }
}

module dolly_x() {
    for (pos = [
        [-DOLLY_X_GAP / 2, 0, 0],
        [DOLLY_X_GAP / 2, 0, 0],
    ]) {
        translate(pos) {
            lm12uu_rodshaft();
        }
    }

    rotate([0, 90, 0]) {
        difference() {
            cylinder(r = 14, h = DOLLY_X_GAP - lm12uu_length, center = true);
            //%translate([10, 0, 0]) {
            translate([16, 0, 0]) {
                cube(size = [20, 100, 100], center = true);
            }
            cylinder(r = 8, h = 100, center = true);
        }
    }
}

module dolly_xs() {

    for (data = [
        [ FRAME_WIDTH / 2 - rod_support_offset, 0 ],
        [ - FRAME_WIDTH / 2 + rod_support_offset, 180 ]
    ]) {
        translate([0, data[0], PROFILE_WIDTH + ROD_SUPPORT_HOLE_HEIGHT]) {
            rotate([0, 0, data[1]]) {
                dolly_x();
            }
        }
    }

    for (pos = [
        [-DOLLY_X_GAP / 2, 0, PROFILE_WIDTH + ROD_SUPPORT_HOLE_HEIGHT + 17],
        [DOLLY_X_GAP / 2, 0, PROFILE_WIDTH + ROD_SUPPORT_HOLE_HEIGHT + 17],
    ]) {
        translate(pos) {
            rotate([0, 0, 90]) {
                rod(length = FRAME_WIDTH);
            }
        }
    }
}

module dolly_y() {
    difference() {
        lm12uu_holder(closed = true, thickness = 4) {
            translate([-15, 0, 0]) {
                rotate([90, 0, 0]) {
                    difference() {
                        cube(size = [2, 25, 25], center = true);
                    }
                }
            }
        }
    }
}

// Value for M4, m4_ nut
module holeAndNut(length = 10, nut = true, hole_diameter = 4.4, hole_nut_diameter = 8.6) {
    cylinder(r = hole_diameter / 2, h = length);
    if (nut) {
        cylinder(r = hole_nut_diameter / 2, h = 5, center = true, $fn = 6);
    }
}

/*
module m4_nut(height = 3) {
    cylinder(r = 4.3, h = height, center = true, $fn = 6);
}

module m4_hole() {
    cylinder(r = 2.2, h = WIDTH * 2, center = true);
}
*/

module socket_holder(thickness = THICKNESS, height = 20, width = 40, base = 2, male = true) {
    module base() {
        cube(size = [base, width + .01, 6], center = true);
    }

    module holes_pos() {
        for (pos = [
            [-thickness / 2, - width / 2 + 5, 0],
            [-thickness / 2, width / 2 - 5, 0],
        ]) {
            translate(pos) {
                rotate([0, 90, 0]) {
                    cylinder(r = 1.7, h = thickness, center = true);
                    if ($children) {
                        for (i = [0 : $children - 1]) {
                            children(i);
                        }
                    }
                }
            }
        }
    }

    if (male) {
        //base();

        holes_pos() {
            translate([0, 0, -3]) {
                cylinder(r = 3.2, h = thickness, center = true);
            }
        }
    } else {
        difference() {
            base();
            holes_pos();
        }
    }
}

module socket(female = true, thickness = THICKNESS, height = 20, oblong = false) {
    width = 40;
    grip_size = 1.2;

    module grip() {
        for (data = [ grip_size : grip_size : height - 0.5]) {
            translate([0, 0, 10 - data]) {
                rotate([0, 45, 0]) {
                    cube(size = [grip_size, width, grip_size], center = true);
                }
            }
        }
    }

    module base(nut = true, oblong = false) {
        difference() {
            union() {
                translate([-thickness / 2, - 20, 10 - height]) {
                    cube(size = [thickness, width, height]); //, center = true);
                }

                // Draw grip
                translate([-thickness / 2, 0, 0]) {
                    grip();
                }

                /*
                if (!female) {
                    translate([thickness / 2, 0, 0]) {
                        grip();
                    }
                }
                */

                if (female) {
                    for (data = [
                        [ -17, 3 ],
                        [ 8, 16 ],
                        [ 20, 3 ]
                    ]) {
                        translate([2.5, data[0], -10]) {
                            rotate([-90, -180, 180]) {
                                linear_extrude(height = data[1]) {
                                    polygon([[0,0],[0,16],[7, 16]]);
                                }
                            }
                        }
                    }
                }
            }

            for (pos = [
                [3 + grip_size, -12.3, -2],
                [3 + grip_size, 12.3, -2]
            ]) {
                if (oblong) {
                    hull() {
                        for (offset = [ 7, -height + 20 ]) {
                            translate([ pos[0], pos[1], pos[2] + offset ]) {
                                rotate([0, -90, 0]) {
                                    holeAndNut(nut = nut);
                                }
                            }
                        }
                    }
                } else {
                    translate(pos) {
                        rotate([0, -90, 0]) {
                            holeAndNut(nut = nut);
                        }
                    }
                }
            }

            /*
            translate([thickness / 2 - 1, 0, height / 2 - 6 / 2]) {
                socket_holder(thickness = thickness, height = height, width = width);
            }
            */
        }
    }

    if (female) {
        base();
    } else {
        base(nut = false, oblong = oblong);
    }
}

module socketRing() {
    height = 35;
    socket(female = false, height = height, oblong = true);
    translate([-58, 0, 7 + THICKNESS - height]) {
        difference() {
            cylinder(r = 121 / 2, h = THICKNESS, center = true);
            cylinder(r = 104 / 2, h = THICKNESS + 1, center = true);
        }
    }
}

module dolly_ys(thickness = THICKNESS) {

    for (pos = [
        [ DOLLY_X_GAP / 2, DOLLY_Y_GAP / 2, 0 ],
        [ -DOLLY_X_GAP / 2, DOLLY_Y_GAP / 2, 0 ],
        [ DOLLY_X_GAP / 2, -DOLLY_Y_GAP / 2, 0 ],
        [ -DOLLY_X_GAP / 2, -DOLLY_Y_GAP / 2, 0 ]
    ]) {
        translate(pos) {
            rotate([0, 0, 90]) {
                dolly_y();
            }
        }
    }

    translate([0, 0, 11 + thickness / 2]) {
        difference() {
            cube(size = [DOLLY_X_GAP + 25, DOLLY_Y_GAP + 30, thickness], center = true);

            for (pos = [
                //[ 0, 0, -thickness + 2 ],
                [ DOLLY_X_GAP / 2, 0, -thickness + 2 ],
                [ -DOLLY_X_GAP / 2, 0, -thickness + 2 ],
                [ 0, DOLLY_Y_GAP / 2, -thickness + 2 ],
                [ 0, -DOLLY_Y_GAP / 2, -thickness + 2 ],
            ]) {
                translate(pos) {
                    holeAndNut();
                }
            }

            cylinder(r = 25, h = 50, center = true, $fn = 6);

            for (pos = [
                [ DOLLY_X_GAP / 2 - 15, DOLLY_Y_GAP / 2, 0 ],
                [ -DOLLY_X_GAP / 2 + 15, DOLLY_Y_GAP / 2, 0 ],
                [ DOLLY_X_GAP / 2 - 15, -DOLLY_Y_GAP / 2, 0 ],
                [ -DOLLY_X_GAP / 2 + 15, -DOLLY_Y_GAP / 2, 0 ]
            ]) {
                translate(pos) {
                    rotate([0, 0, 90]) {
                        //cylinder(r = 5, h = 100, center = true);
                        cube(size = [12, 5, 100], center = true);
                    }
                }
            }
        }

        translate([-DOLLY_X_GAP / 2 - 18, 0, -7.5]) {
            translate([4, 0, 7.5]) {
                //socket_holder(base = 5, male = false);
                cube(size = [5, 40, thickness], center = true);
            }

            translate([0, 0, 0]) {
                socket(female = true, thickness = thickness);
            }
        }
        /*
        translate([-DOLLY_X_GAP / 2 - 18, 0, -7.5]) {
            translate([4, 0, 8]) {
                cube(size = [3, 40, 4], center = true);
            }

            translate([-1, 0, 0]) {
                socket(female = true, thickness = thickness);
            }

            // Socket tool
            translate([-THICKNESS, 0, 0]) {
                if ($children) {
                    for (i = [0 : $children - 1]) {
                        children(i);
                    }
                }
            }
        }
        */
    }
}

module demo() {
    frame();

    foots();

    rod_and_support();

    // Rod support
    for (data = [
        [ -FRAME_LENGTH / 2 + PROFILE_WIDTH / 2 + 100, FRAME_WIDTH / 2 - rod_support_offset, PROFILE_WIDTH, -90 ],
        [ -FRAME_LENGTH / 2 + PROFILE_WIDTH / 2 + 100, -FRAME_WIDTH / 2 + rod_support_offset, PROFILE_WIDTH, 90 ]
    ]) {
        translate([ data[0], data[1], data[2]]) {
            rotate([0, 0, data[3]]) {
                blocker();
            }
        }
    }

    translate([ 0, FRAME_WIDTH / 2 + 2.5, 10 ]) {
        rotate([90, 0, 0]) {
            stem_support();
        }
    }

    translate([ -FRAME_LENGTH / 2 + 70, -FRAME_WIDTH / 2 - 2.5, 10 ]) {
        rotate([90, 0, 0]) {
            desk();
        }
    }

    echo($t);

    translate([-100, 0, 0]) {
        translate([DOLLY_X_POSITION - 125 + ($t * 100), 0, 0]) {
            dolly_xs();
            translate([0, DOLLY_Y_POSITION - 120 + ($t * 50), 0]) {
                translate([0, 0, PROFILE_WIDTH + ROD_SUPPORT_HOLE_HEIGHT + 17]) {
                    dolly_ys() {
                        socketRing();
                    }
                }
            }
        }
    }
}

!demo();

lm12uu_holder();

intersection() {
    lm12uu_rodshaft();
    cube(size = [40, 40, 28], center = true);
    //translate([15, 0, 0])cube(size = [20, 40, 28], center = true);
}

rod_support(stopper = true);     // x2

mirror([0, 1, 0]) {
    rod_support(stopper = true); // x2
}

/*
union() {
    translate([ -FRAME_LENGTH / 2 + PROFILE_WIDTH / 2, -FRAME_WIDTH / 2 + rod_support_offset + 50, -PROFILE_WIDTH ]) {
        frame();
    }

    rotate([0, 0, 0]) {
        blocker();
    }
}
*/

blocker();

stem_support();

desk();

//cable_passes();

dolly_x();          // x2

foot();             // x4

dolly_ys();         // x1

union() {
    translate([THICKNESS + 2, 0, 0]) {
        socket();
    }

    socketRing();
}

socket(female = false, height = 35, oblong = true);
socket(female = true, oblong = true);

intersection() {
    translate([-5, 10, 0])
        cube(size = [10, 10, 10]);
    socket(female = true, oblong = true);
}

