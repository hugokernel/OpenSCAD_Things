
$fn = 20;
HOLE_DIAMETER = 2;

module arm(width, length, height, gap_width = 0, gap_length = 0) {

    difference() {
        union() {
            translate([0, - length / 2 + width / 2, 0]) cylinder(h = height, r1 = width / 2, r2 = width / 2);

            translate([0, length / 2  - width / 2, 0]) cylinder(h = height, r1 = width / 2, r2 = width / 2);

            translate([- width / 2, - length / 2 + width / 2, 0]) cube(size = [width, length - width, height]);
        }

        // Hole
        translate([0, - length / 2 + width / 2, -1]) cylinder(h = 5, r1 = HOLE_DIAMETER, r2 = HOLE_DIAMETER);
        translate([0, length / 2 - width / 2, -1]) cylinder(h = 5, r1 = HOLE_DIAMETER, r2 = HOLE_DIAMETER);

        if (gap_width) {
           
            
            echo("paf");
            //translate([0, 0, - height / 2]) {
            //base(width / gap_width, length / gap_width, height * 2, false);

            //translate([- width / 2, - length / 2 + width / 2, 0])
            difference() {
                translate([0, 0,  height / 2]) cube(size = [gap_width, length - width, height * 2], center = true);
                translate([0, - length / 2 + width / 2, 0]) cylinder(h = height * 2, r1 = width / 2 + gap_length, r2 = width / 2 + gap_length);
                translate([0, length / 2  - width / 2, 0]) cylinder(h = height * 2, r1 = width / 2 + gap_length, r2 = width / 2 + gap_length);
            }
        }
    }
}

arm(10, 100, 2, 3, 0);

