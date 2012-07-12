


module cutter() {

    scale([1.5, 1, 1]) child(0);

}

//cutter() cube(size = [100, 300, 10], center = true);

// Reduce size
//linear_extrude(height = 10) {
//}

/**
 *  Cutter
 *  - dimension (length, width, thickness)
 *  - part_count
 *  - part_number
 *  - teeth (teeth count, height, offset)
 */
module paf(dimension, part_count, part_number, teeth = [20, 15, 5]) {

    length = dimension[0];
    width = dimension[1];
    height = dimension[2];

    teeth_width = width / teeth[0];
    teeth_height = teeth[1];
    teeth_offset = teeth[2] / 2;

    dent = length / teeth_width;
    echo(dent);

    difference() { 
        child(0);

        union() {
            translate([-500, -250, -25]) cube(size = [500, 500, 50]);
            
            translate([0, 0, - thickness / 2])
            linear_extrude(height = thickness) {
                for ( i = [- length / 2 : dent] ) {
                    echo(i);
                    echo((teeth_width - teeth_offset));
                    translate([0, (teeth_width - teeth_offset) * i, 0]) {
                        if (i % 2) {
                            translate([teeth_height, 0, 0]) {
                                rotate([0, 180, 0]) {
                                    polygon([[0, 0], [0, teeth_width], [teeth_height, teeth_width - teeth_offset], [teeth_height, teeth_offset]]);
                                }
                            }
                        } else {
                            translate([0, 0, 0]) {
                                % polygon([[0, 0], [0, teeth_width], [teeth_height, teeth_width - teeth_offset], [teeth_height, teeth_offset]]);
                            }
                        }
                    }
                }
            }
        }
    }
}

thickness = 15;

/*
translate([-50, 0, 0]) {
    % color("blue") cube(size = [50, 100, thickness]);
}

translate([15, 0, 0]) {
    cube(size = [50, 100, thickness]);
}
*/

translate([0, -25, 0]) cylinder(r = 10, h = 10);

//cube(size = [50, 100, 5], center = true);
paf([50, 100, 5], 3, 1, [5, 8, 4]) {
    cube(size = [50, 100, 5], center = true);
}


