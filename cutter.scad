


module cutter() {

    scale([1.5, 1, 1]) child(0);

}

//cutter() cube(size = [100, 300, 10], center = true);

// Reduce size
//linear_extrude(height = 10) {
//}

module paf(thickness) {
    width = 20;
    height = 15;
    offset = 5;

    linear_extrude(height = thickness) {
    for ( i = [0 : 5] ) {
        translate([0, (width - offset) * i, 0]) {
            if (i % 2) {
                translate([height, 0, 1])
                    rotate([0, 180, 0])
                        % color("blue") polygon([[0, 0], [0, width], [height, width - offset], [height, offset]]);
            } else {
                translate([0, 0, 0]) {
                    polygon([[0, 0], [0, width], [height, width - offset], [height, offset]]);
                }
            }
        }
    }}
}

translate([-50, 0, 0]) {
    % color("blue") cube(size = [50, 100, 5]);
}

translate([15, 0, 0]) {
    cube(size = [50, 100, 5]);
}

paf(5);

