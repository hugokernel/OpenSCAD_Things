


module cutter() {

    scale([1.5, 1, 1]) child(0);

}

//cutter() cube(size = [100, 300, 10], center = true);

// Reduce size
//linear_extrude(height = 10) {
//}

module teeth(width, length, thickness, offset = 1) {
    translate([- length / 2, - width / 2, 0])
    linear_extrude(height = thickness) {
        polygon([[0, 0], [0, width], [length, width - offset], [length, offset]]);
    }
}


module zip(length, teeths) {

    count = teeths[0];
    echo("count:", count);
    offset = 3;
    space = 0;


    teeth_width = length / count;

    //for (i = [- length : teeth_width + offset : length - 1] ) {
    x = - length / 2;
    for (i = [0 : count] ) {
echo(i);
        if (i % 2) {
            echo("HERE",i);
            assign(x = x + (teeth_width - offset + space) * i) {
                translate([0, x, 0]) {
                    color("RED") teeth(teeth_width, teeths[1], teeths[1] * 2, offset);
                }
            }
        } else {
            echo("LA",i);
            assign(x = x + (teeth_width - offset + space) * i + 0.1) {
                translate([0, x, 0]) {
                    rotate([0, 0, 180])
                    
                    color("BLUE") teeth(teeth_width, teeths[1], teeths[1] * 2, offset);
                    //% teeth(teeth_width, teeths[1], teeths[1] * 2, - offset);
                }
            }
        }
    }

}

/**
 *  Cutter
 *  - dimension (length, width, thickness)
 *  - part_count
 *  - part_number
 *  - teeth (teeth count, height, offset)
 */
module paf(dimension, part_count, part_number, teeth = [20, 15, 5]) {

    width = dimension[0];
    length = dimension[1];
    height = dimension[2];

    teeth_width = width / teeth[0];
    teeth_height = teeth[1];
    teeth_offset = teeth[2] / 2;

    dent = length / teeth_width;
    echo("Dent: ", dent, ", width: ", width);

    thickness = height;

    difference() {
    child(0);
    union() {
            translate([-499.9, -250, -25]) cube(size = [500, 500, 50]);
    translate([0, 0, -thickness / 2 - 1])
    for (i = [- width : teeth_width : width - 1] ) {
        echo(i);
        translate([0, i, 0]) {
            if (i / 10 % 2) {
                teeth(teeth_width, teeth_height, thickness * 2, 3);
            }
        }
    }
    }
    }

/*
    //difference() { 
      //  child(0);

        union() {
            translate([-500, -250, -25]) cube(size = [500, 500, 50]);
            
            translate([0, 0, - thickness / 2])
            linear_extrude(height = thickness) {
                //for ( i = [- length / 2 : dent] ) {
                for ( i = [- width : teeth_width : width] ) {
                    echo(i);
                    //translate([0, (teeth_width - teeth_offset) * i, 0]) {
                    translate([0, i, 0]) {
                        if (i % 2) {
                            translate([0, 0, 0]) {
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
    //}
*/
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

//translate([0, -50, 0]) cylinder(r = 4, h = 100);

//cube(size = [50, 100, 5], center = true);

//teeth(8, 5, 3);

/*
paf([50, 100, 5], 3, 1, [5, 8, 4]) {
    cube(size = [50, 100, 5], center = true);
}
*/

//color("RED") teeth(5, 8, 4);
zip(50, [5, 8, 4]);


