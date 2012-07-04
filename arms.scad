
$fn = 20;

module arm(width, length, height, hole = [5, 5], gap_width = 0, gap_length = 0) {

    difference() {
        hull() {
            translate([0, - length / 2, 0])
                cylinder(h = height, r1 = width / 2, r2 = width / 2);

            translate([0, length / 2, 0])
                cylinder(h = height, r1 = width / 2, r2 = width / 2);
        }

        // Hole
        translate([0, - length / 2, -1])
            cylinder(h = height + 1, r1 = hole[0] / 2, r2 = hole[0] / 2);
        translate([0, length / 2, -1])
            cylinder(h = height + 1, r1 = hole[1] / 2, r2 = hole[1] / 2);

        if (gap_width) {
            difference() {
                translate([0, 0,  height / 2])
                    cube(size = [gap_width, length - width, height * 2], center = true);
                translate([0, - length / 2, 0])
                    cylinder(h = height * 2, r1 = width / 2 + gap_length, r2 = width / 2 + gap_length);
                translate([0, length / 2, 0])
                    cylinder(h = height * 2, r1 = width / 2 + gap_length, r2 = width / 2 + gap_length);
            }
        }
    }
}

// Long arm
module long_arm() {
    difference() {
        arm(15, 135, 4, [5, 1], 0, 0);
        
        translate([0, 12.5, -1])
            cylinder(h = 20, r1 = 2.5, r2 = 2.5);
    }
}

//long_arm();

// Basic arm
//arm(15, 80, 4, [5, 5], 0, 0);

module main_arm() {

    size = [ 20, 120, 4 ];
    radius = 5;

    difference() {
        union() {
            // From MCAD library
            cube(size - [2*radius,0,0], true);
            cube(size - [0,2*radius,0], true);
            for (x = [radius-size[0]/2, -radius+size[0]/2],
                   y = [radius-size[1]/2, -radius+size[1]/2]) {
                translate([x,y,0]) cylinder(r=radius, h=size[2], center=true);
            }
        }

        translate([ size[0] / 2 - 12, - size[1] / 2 + 7.5, -5]) {
            cylinder(h = 10, r1 = 2.5, r2 = 2.5);
        }

        translate([ size[0] / 2 - 12, - size[1] / 2 + 47.5, -5]) {
            cylinder(h = 10, r1 = 2.5, r2 = 2.5);
        }
    }
}

main_arm();

