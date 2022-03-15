include <BOSL2/std.scad>

$fn = 60;

LENGTH = 180;
WIDTH = 150;
THICKNESS = 5;

OBLONG_DIAMETER = 5.5;
OBLONG_LENGTH = 15;

TUBE_DIAMETER = 26.9;

BOLT_DIAMETER = 4.5;
BOLT_HEAD_DIAMETER = 9;
NUT_DIAMETER = 8.25;
NUT_HEIGHT = 3.5;


module oblong(diameter, length, thickness) {
    translate([-length / 2, 0, 0]) {
        hull() {
            cylinder(d=diameter, h=thickness);
            translate([length, 0, 0]) {
                cylinder(d=diameter, h=thickness);
            }
        }
    }
}

module nut(diameter, height) {
    cylinder(d=diameter, h=height, $fn=6);
    //%cylinder(d=7.8, h=height, $fn=40);
}

module tube(diameter, length) {
    // Tube have a simple cylinder section
    //cylinder(d=diameter, h=length * 2);

    // Tube section is oval
    OVAL_LENGTH = 36.3;
    OVAL_WIDTH = 21.3;
    linear_extrude(length * 2) {
        resize([36.3, 21.3])
            circle(d=20);
    }
}

module tube_holder_position() {
    for (x=[item_position, -item_position]) {
        translate([x, 0, 0]) {
            rotate([0, 0, 90]) {
                children();
            }
        }
    }
}

CONNECTOR_THICKNESS = 2;
module connector(length, width=30, thickness=CONNECTOR_THICKNESS, male=true) {
    scale_coeff = male ? 1 : 1.01;
    scale([scale_coeff, scale_coeff, 1]) {
        down(thickness / 2) {
            difference() {
                union() {
                    up(1) {
                        cube(size=[length, width, 2], center=true);
                    }

                    down(thickness - 0.01) {
                        prismoid(
                            size1=[length - 5, width - 5],
                            size2=[length, width],
                            h=thickness
                        );
                    }
                }

                down(2.5) {
                    prismoid(
                        size1=[BOLT_HEAD_DIAMETER * 2, BOLT_HEAD_DIAMETER * 2],
                        size2=[BOLT_HEAD_DIAMETER * 2 - 5, BOLT_HEAD_DIAMETER * 2 - 5],
                        h=3
                    );
                }

                if (male) {
                    cylinder(d=BOLT_DIAMETER, h=length, center=true);
                }
            }
        }
    }
}

module tube_holder() {
    diameter = TUBE_DIAMETER;
    length = 30;

    down(CONNECTOR_THICKNESS / 2) {
        connector(length=diameter * 3);
    }

    difference() {
        hull() {
            cube(size=[diameter * 3, length, 1], center=true);
            translate([0, length / 2, diameter]) {
                rotate([90, 0, 0]) {
                    cylinder(d=diameter * 2, h=length);
                }
            }
        }

        translate([0, length, diameter]) {
            rotate([90, 0, 0]) {
                tube(diameter, length);
            }
        }

        translate([0, 0, diameter * 2 - 3]) {
            cylinder(d=BOLT_HEAD_DIAMETER, h=diameter);
        }
        cylinder(d=BOLT_DIAMETER, h=diameter * 5, center=true);

        translate([0, 0, diameter / 2 - 2]) {
            cylinder(d=BOLT_HEAD_DIAMETER, h=diameter);
        }
    }
}

item_position = LENGTH / 2 - 35;
module base1() {
    difference() {
        union() {
            difference() {
                down(THICKNESS / 2) {
                    resize([LENGTH, WIDTH]) {
                        prismoid(
                            LENGTH,
                            LENGTH - 8,
                            rounding=[10, 10, 10, 10],
                            h=THICKNESS
                        );
                    }
                }

                for (position = [
                    [item_position, WIDTH / 2 - 20, 0],
                    [-item_position, WIDTH / 2 - 20, 0],
                    [item_position, -(WIDTH / 2 - 20), 0],
                    [-item_position, -(WIDTH / 2 - 20), 0],
                ]) {
                    translate(position) {
                        translate([0, 0, -THICKNESS]) {
                            oblong(OBLONG_DIAMETER, OBLONG_LENGTH, THICKNESS * 2);
                        }
                    }
                }

                cuboid(
                    [LENGTH / 3.5, WIDTH / 1.8, THICKNESS * 4],
                    rounding=5
                );

                up(2.5) {
                    tube_holder_position() {
                        scale([1.01, 1.01, 1]) {
                            tube_holder();
                        }
                    }
                }
            }
        }

        for (x=[item_position, -item_position]) {
            translate([x, 0, -THICKNESS / 2 - .1]) {
                nut(NUT_DIAMETER, NUT_HEIGHT);
                cylinder(d=BOLT_DIAMETER + 0.1, h=100, center=true);
            }
        }

        rot([0, 0, 90]) {
            yflip() {
                down(THICKNESS / 2 + 0.1) {
                    back(item_position + 11) {
                        fwd(-12)
                            linear_extrude(height=1)
                                text(text="Wall Pipe Support", size=10, halign="center", valign="center");
                        fwd(0)
                            linear_extrude(height=1)
                                text(text="2.0.0 - 2021-10", size=7, halign="center", valign="center");
                    }
                }
            }
        }
    }
}

module base2(length, width) {
    difference() {
        down(THICKNESS / 2) {
            resize([length, width]) {
                prismoid(
                    length,
                    length - 8,
                    rounding=[10, 10, 10, 10],
                    h=THICKNESS
                );
            }
        }

        for (position = [
            [WIDTH / 2 - 45, WIDTH / 2 + 5, 0],
            [-(WIDTH / 2) + 45, WIDTH / 2 + 5, 0],
            [WIDTH / 2 - 45, -(WIDTH / 2 + 5), 0],
            [-(WIDTH / 2) + 45, -(WIDTH / 2 + 5), 0],
        ]) {
            zrot(90)
            translate(position) {
                translate([0, 0, -THICKNESS]) {
                    oblong(OBLONG_DIAMETER, OBLONG_LENGTH, THICKNESS * 2);
                }
            }
        }

        cuboid(
            [length / 3.5, width / 1.5, THICKNESS * 4],
            rounding=5
        );

        up(2.5) {
            tube_holder_position() {
                scale([1.01, 1.01, 1]) {
                    tube_holder();
                }
            }
        }

        for (x=[item_position, -item_position]) {
            translate([x, 0, -THICKNESS / 2 - .1]) {
                nut(NUT_DIAMETER, NUT_HEIGHT);
                cylinder(d=BOLT_DIAMETER + 0.1, h=100, center=true);
            }
        }
    }
}

module arm() {
    length = TUBE_DIAMETER * 3;
    width = 30;
    height = 100;

    connector(length=length, width=width);

    difference() {
        difference() {
            up(height / 2) {
                cuboid(
                    [length + 5, width + 5, height],
                    edges=[FRONT, BACK, TOP, BOTTOM],
                    chamfer=3, trimcorners=false,
                    $fn=24
                );
            }

            up(height / 2) {
                cuboid(
                    [length - 10, width + 6, height - 10],
                    edges=[FRONT, BACK, TOP, BOTTOM],
                    chamfer=12, trimcorners=false,
                    $fn=24
                );
                cube(size=[length - 20, width * 2, height - 20], center=true);
            }
        }

        up(height - CONNECTOR_THICKNESS / 2 + 0.1) {
            connector(length=length, width=width, male=false);
        }

        cylinder(d=BOLT_DIAMETER, h=height * 3, center=true);

        up(10) {
            cylinder(d=BOLT_DIAMETER * 5, h=10, center=true);
        }

        up(height - 10) {
            cylinder(d=BOLT_DIAMETER * 5, h=10, center=true);
        }
    }
}

module demo1() {
    base1();

    tube_holder_position() {
        tube_holder();
    }
}

module demo2() {
    base2(190, 100);

    tube_holder_position() {
        up(3) {
            arm();
        }
        up(105) {
            tube_holder();
        }
    }
}

// Test
oblong(OBLONG_DIAMETER, OBLONG_LENGTH, THICKNESS);
difference() { cylinder(d=15, h=10); translate([0, 0, -.1]) nut(NUT_DIAMETER, NUT_HEIGHT); cylinder(d=BOLT_DIAMETER, h=100); }

tube_holder();

intersection() {
    base1();
    right(55)
        cube(size=[40, 100, 10], center=true);
}

demo1();

demo2();

base1();
!base2(190, 100);

arm();
