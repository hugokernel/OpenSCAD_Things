
PROFILE_WIDTH = 20;

FRAME_LENGTH = 600;
FRAME_WIDTH = 400;

ROD_DIAMETER = 12;

ROD_SUPPORT_LENGTH = 42;

//ROD_X_LENGTH = 760;
//ROD_Y_LENGTH = 500;

X_POSITION = 200;
Y_POSITION = 50;

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

module dolly(spacing) {
    position_x = X_POSITION;
    position_y = Y_POSITION;
    spacing_y = 130;
    for (pos = [
        [ position_x, 70 - position_y, ROD_DIAMETER * 2 ],
        [ position_x, 70 - position_y + spacing_y, ROD_DIAMETER * 2 ],
        [ position_x + spacing, 70 - position_y, ROD_DIAMETER * 2 ],
        [ position_x + spacing, 70 - position_y + spacing_y, ROD_DIAMETER * 2 ]
    ]) {
        translate(pos) {
            rotate([0, 90, 90]) {
                linearBall();
            }
        }
    }
}

/*
module train() {
    position_x = X_POSITION;
    spacing = 60;
    for (pos = [
        [ position_x, -ROD_Y_LENGTH / 2 + ROD_DIAMETER, 0 ],
        [ position_x, ROD_Y_LENGTH / 2 - ROD_DIAMETER, 0 ],
        [ position_x + spacing, -ROD_Y_LENGTH / 2 + ROD_DIAMETER, 0 ],
        [ position_x + spacing, ROD_Y_LENGTH / 2 - ROD_DIAMETER, 0 ]
    ]) {
        translate(pos) {
            rotate([0, 90, 0]) {
                linearBall();
            }
        }
    }

    // Y rail
    translate([position_x + spacing / 2, -ROD_Y_LENGTH / 2, ROD_DIAMETER * 2]) {
        rotate([0, 0, 90]) {
            rail(length = ROD_Y_LENGTH, spacing = spacing / 2);
        }
    }

    dolly(spacing);
}
*/

/*
module rail(length, spacing) {
    for (pos = [
        [ 0, -spacing, 0 ],
        [ 0, spacing, 0 ]
    ]) {
        translate(pos) {
            rotate([0, 90, 0]) {
                rod(length);
            }
        }
    }


    // Rail support
    // Todo
}
*/

module profile(width = 20, length = 50) {
    cube(size = [width, length, width], center = true);
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

module rodSupport() {

    // Base
    cube(size = [ROD_SUPPORT_LENGTH, 14, 6], center = true);

    // Main
    translate([0, 0, 3]) {
        difference() {
            translate([0, 0, 28.5 / 2]) {
                cube(size = [20, 14, 31.5], center = true);
            }

            translate([0, 10, 20]) {
                rotate([90, 0, 0]) {
                    cylinder(r = 6, h = 20);
                }
            }
        }
    }
}

module frame(width = 20) {

    // Ghost
    %cube(size = [FRAME_LENGTH, FRAME_WIDTH, 23], center = true);

    for (data = [
        // length, x, y, rotation
        [ FRAME_LENGTH - width * 2, -FRAME_WIDTH / 2 + width / 2, 0, 90, "RED" ],
        [ FRAME_LENGTH - width * 2, FRAME_WIDTH / 2 - width / 2, 0, 90, "RED" ],
        [ FRAME_WIDTH,  -FRAME_LENGTH / 2 + width / 2, 0, 0, "GREEN" ],
        [ FRAME_WIDTH,  FRAME_LENGTH / 2 - width / 2, 0, 0, "GREEN" ],
    ]) {
        rotate([ 0, 0, data[3] ]) {
            translate([ data[1], data[2], 0 ]) {
                color(data[4]) {
                    profile(length = data[0]);
                }
            }
        }
    }

    /*
    // Corner cube
    for (pos = [
        [ width / 2, ROD_Y_LENGTH / 2 - width / 2, 0 ],
        [ width / 2, -ROD_Y_LENGTH / 2 + width / 2, 0 ],
        [ ROD_X_LENGTH - width / 2, ROD_Y_LENGTH / 2 - width / 2, 0 ],
        [ ROD_X_LENGTH - width / 2, -ROD_Y_LENGTH / 2 + width / 2, 0 ]
    ]) {
        translate(pos) {
            color("RED") cornerCube(width = width);
        }
    }
    */
}

module rodAndSupport(width = 20) {
    // Rod support
    for (pos = [
        [ FRAME_LENGTH / 2 - width / 2, FRAME_WIDTH / 2 - ROD_SUPPORT_LENGTH / 2, 13 ],
        [ -FRAME_LENGTH / 2 + width / 2, FRAME_WIDTH / 2 - ROD_SUPPORT_LENGTH / 2, 13 ],
        [ FRAME_LENGTH / 2 - width / 2, -FRAME_WIDTH / 2 + ROD_SUPPORT_LENGTH / 2, 13 ],
        [ -FRAME_LENGTH / 2 + width / 2, -FRAME_WIDTH / 2 + ROD_SUPPORT_LENGTH / 2, 13 ]
    ]) {
        translate(pos) {
            rotate([0, 0, 90]) {
                rodSupport();
            }
        }
    }

    // X rod
    offset_z = width + 16;
    for (data = [
        // x, y, rot z, length
        [ FRAME_WIDTH / 2 - ROD_SUPPORT_LENGTH / 2, FRAME_LENGTH ],
        [ -FRAME_WIDTH / 2 + ROD_SUPPORT_LENGTH / 2, FRAME_LENGTH ]
    ]) {
        translate([ 0, data[0], offset_z ]) {
            rod(length = data[1]);
        }
    }
}

module manchon(length, diameter = 15) {
    rotate([0, 90, 0]) {
        difference() {
            cylinder(r = diameter, h = length, center = true);
            cylinder(r = diameter - 2, h = length * 2, center = true);
        }
    }
}

spacing = 30;
module xdolly() {

    manchon(spacing * 3.3);

    for (pos = [
        [- spacing, 15, 0],
        [spacing, 15, 0],
    ]) {
        translate(pos) {
            rotate([0, 0, 90]) {
                manchon(length = 20, diameter = 9);
            }
        }
    }

    // X rail
    translate([ -spacing, 0, 0 ]) {
        linearBall();
    }
    translate([ spacing, 0, 0 ]) {
        linearBall();
    }

    translate([spacing, FRAME_WIDTH / 2 - 20, 0]) {
        rotate([0, 0, 90]) {
            rod(length = FRAME_WIDTH - 70);
        }
    }
}

module ydolly() {

    module part() {
        translate([ -spacing, 0, 0 ]) {
            linearBall();
        }
        translate([ spacing, 0, 0 ]) {
            linearBall();
        }

        manchon(spacing * 3.3);
    }

    for (pos = [
        [0, - spacing, 0],
        [0, spacing, 0]
    ]){
        translate(pos) {
            part();
        }
    }
}

module dolly() {
    //dolly();
    translate([0, FRAME_WIDTH / 2 - ROD_SUPPORT_LENGTH / 2, PROFILE_WIDTH + 16]) {
        rotate([0, 0, 180]) {
            xdolly();
        }
    }

    translate([0, - FRAME_WIDTH / 2 + ROD_SUPPORT_LENGTH / 2, PROFILE_WIDTH + 16]) {
        xdolly();
    }
}

module lm12uu(  external_diameter = 21,
                internal_diameter = 12,
                slot_thickness = 1.3,
                slot_deepness = 1
    ) {
    length = 30;
    module slot() {
        difference() {
            cylinder(r = 11, h = slot_thickness, center = true);
            cylinder(r = 11 - slot_deepness, h = slot_thickness, center = true);
        }
    }

    difference() {
        cylinder(r = external_diameter / 2, h = length, center = true);

        translate([0, 0, -1]) {
            cylinder(r = internal_diameter / 2, h = 40, center = true);
        }

        for (pos = [
            [ 0, 0, 23 / 2 ],
            [ 0, 0, -23 / 2 ],
        ]) {
            translate(pos) {
                slot();
            }
        }
    }
}

module shf12() {
    
}

module lm12uu_support() {

    difference() {
        rotate([0, 90, 0]) {
            difference() {
                cylinder(r = 14, h = 28, center = true);
                lm12uu(internal_diameter = 0, external_diameter = 22);
            }
        }

        translate([0, 0, -15]) {
            cube(size = [50, 50, 20], center = true);
        }
    }

    rotate([0, 90, 0]) {
        //lm12uu();
    }

}


if (0) {
    frame();

    rodAndSupport();

    translate([-100, 0, 0]) {
        dolly();

        translate([0, 0, PROFILE_WIDTH + 16]) {
            rotate([0, 0, 90]) {
                ydolly();
            }
        }
    }

    translate([0, 0, 30]) {
        %cube(size = [600, 400, 10], center = true);
    }

} else {

    lm12uu_support();

    //cornerCube();
    //rodSupport();

    /*
    hull() {
        rotate([0, 90, 0]) {
            cylinder(r = 10, h = 60, center = true);
        }

        translate([0, 0, 20]) {
            rotate([0, 90, 90]) {
                cylinder(r = 10, h = 60, center = true);
            }
        }
    }
    */

}



//linearBall();

