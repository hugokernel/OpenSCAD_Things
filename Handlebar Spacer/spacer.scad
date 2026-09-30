include <BOSL2/std.scad>

$fn = 100;

SPACER_HEIGHT = 10;
OUTER_DIAMETER = 28;
INNER_DIAMETER = 27;
SUPPORT_HEIGHT = 10;

tube(h=SPACER_HEIGHT, or=OUTER_DIAMETER / 2, ir=INNER_DIAMETER / 2);

up(SUPPORT_HEIGHT / 2 + SPACER_HEIGHT / 2) {
    difference() {
        tube(h=SUPPORT_HEIGHT, or=OUTER_DIAMETER / 2, ir=INNER_DIAMETER / 2);
        up(.1)
            pie_slice(h=SUPPORT_HEIGHT, ang=260, d=OUTER_DIAMETER * 2, center=true);
    }
}
