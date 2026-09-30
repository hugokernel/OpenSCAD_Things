include <BOSL2/std.scad>

$fn = 80;

TUBE = 80.1;
HOLE = TUBE + 2 * 14.7;
THICKNESS = 5;

// %zcyl(d=HOLE, h=100);

tube(id=TUBE, od=HOLE, h=THICKNESS, chamfer1=2, chamfer2=0);
down(6)
    tube(id=TUBE, od=TUBE + 10, h=14, chamfer1=2, chamfer2=1);
