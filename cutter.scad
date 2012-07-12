


module cutter() {

    scale([1.5, 1, 1]) child(0);

}

//cutter() cube(size = [100, 300, 10], center = true);

// Reduce size
//linear_extrude(height = 10) {
//}

module paf(length, count, thickness) {

    width = 20;
    height = 15;
    offset = 5;
    
    dent = length / width;
    section = length / count;
    echo(dent);

    difference() { 
        child(0);

        union() {
            translate([-500, -250, -25]) cube(size = [500, 500, 50]);
            
            translate([0, 0, -thickness/2])
            linear_extrude(height = thickness) {
                for ( i = [-length / 2 : dent] ) {
                    translate([0, (width - offset) * i, 0]) {
                        if (i % 2) {
                            translate([height, 0, 0]) {
                                rotate([0, 180, 0]) {
                                    polygon([[0, 0], [0, width], [height, width - offset], [height, offset]]);
                                }
                            }
                        } else {
                            translate([0, 0, 0]) {
                                %polygon([[0, 0], [0, width], [height, width - offset], [height, offset]]);
                            }
                        }
                    }
                }
            }
        }
    }
}

thickness = 15;

translate([-50, 0, 0]) {
    % color("blue") cube(size = [50, 100, thickness]);
}

translate([15, 0, 0]) {
//    cube(size = [50, 100, thickness]);
}

paf(100, 3, thickness) cube(size = [200, 200, 5], center = true);

