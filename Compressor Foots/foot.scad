include <BOSL2/std.scad>

$fn = 50;

BASE_DIAMETER = 35;
BASE_HEIGHT = 10;

CONTACT_DIAMETER = 23;
CONTACT_HEIGHT = 7;


module main() {
    tube(h=CONTACT_HEIGHT, od=CONTACT_DIAMETER, id=7);

    up(BASE_HEIGHT / 2 + CONTACT_HEIGHT / 2)
        tube(h=BASE_HEIGHT, od=BASE_DIAMETER, id=12);
}

main();
