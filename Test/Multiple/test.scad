
use <oshw.scad>


/*
%for (i = [0 : 5 : 75]) {
    translate([0, i - 75 / 2, 1]) {
        cube([80, 3, 0.5], center = true);
    }
}
*/

%cube(size = [ 80, 80, 1 ], center = true);

translate([0, 0, 0])
linear_extrude(height=1)
	oshw_logo_2d(75);


