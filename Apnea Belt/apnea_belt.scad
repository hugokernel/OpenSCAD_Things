use <roundCornersCube.scad>

$fn = 40;

MAGNET_DIAMETER = 20;
MAGNET_THICKNESS = 1.95 * 2;
MAGNET_CLEARANCE = 0.17;

BODY_LENGTH = 32;
BODY_WIDTH = 40;
BODY_THICKNESS = 12;

MAGNET_SUPPORT_THICKNESS = 8;

CONNECTION_DEPTH = 7;

MAGNET_HOUSING_DIAMETER_CLEAR = 0.15;
MAGNET_HOUSING_DEPTH = MAGNET_THICKNESS + 0.5;

module magnet(diameter=MAGNET_DIAMETER, thickness=MAGNET_THICKNESS, clearance=MAGNET_CLEARANCE) {
    cylinder(r = diameter / 2 + clearance, h = thickness, center = true);
}

module body(length=BODY_LENGTH, width=BODY_WIDTH, thickness=BODY_THICKNESS, withrub=true) {

    diam = 2;

    module _body() {
        depth = 2.5;
        difference() {
            roundCornersCube(thickness + 5, width + 10, 5, diam);
            roundCornersCube(thickness - depth, width - depth, 5, diam);
        }
    }

    rotate([0, 90, 0]) {
        difference() {
            union() {
                roundCornersCube(thickness, width, length, 2);
                if (withrub) {
                    for (i = [-BODY_LENGTH / 2 + 5 : 4 : BODY_LENGTH / 2]) {
                        translate([0, 0, i]) {
                            roundCornersCube(thickness + 1, width + 1, 1, diam);
                        }
                    }
                }
            }
            _body();
        }
    }

    // Round corner
    translate([BODY_LENGTH / 2, 0, 0]) {
        for (pos = [
            [ 0, BODY_WIDTH / 2 - diam, BODY_THICKNESS / 2 - diam ],
            [ 0, -BODY_WIDTH / 2 + diam, BODY_THICKNESS / 2 - diam ],

            [ 0, BODY_WIDTH / 2 - diam, -BODY_THICKNESS / 2 + diam ],
            [ 0, -BODY_WIDTH / 2 + diam, -BODY_THICKNESS / 2 + diam ]
        ]) {
            translate(pos) {
                sphere(r=diam, h=10);
            }
        }

        for (pos = [
            [ 0, BODY_WIDTH / 2 - diam, -BODY_THICKNESS / 2 + diam, 0, BODY_THICKNESS - 2 * diam ],
            [ 0, -BODY_WIDTH / 2 + diam, -BODY_THICKNESS / 2 + diam, 0, BODY_THICKNESS - 2 * diam ],

            [ 0, BODY_WIDTH / 2 - diam, BODY_THICKNESS / 2 - diam, 90, BODY_WIDTH - 2 * diam ],
            [ 0, BODY_WIDTH / 2 - diam, -BODY_THICKNESS / 2 + diam, 90, BODY_WIDTH - 2 * diam ],
        ]) {
            translate([pos[0], pos[1], pos[2]]) {
                rotate([pos[3], 0, 0]) {
                    cylinder(r=diam, h=pos[4]);
                }
            }
        }

        translate([1, 0, 0]) {
            cube(size=[diam, BODY_WIDTH - 2 * diam, BODY_THICKNESS - 2 * diam], center=true);
        }
    }
}

CONN_HEIGHT = 8;
CONN_INTERNAL_DIAMETER = MAGNET_DIAMETER * 1.4;
CONN_WALL_THICKNESS = 3.2;

module connection_female(
        internal_diameter=CONN_INTERNAL_DIAMETER,
        height=CONN_HEIGHT,
        wall_thickness=CONN_WALL_THICKNESS,
        bottom_thickness=1,
        magnet_thickness=MAGNET_THICKNESS,
    ) {

    height = height + magnet_thickness + bottom_thickness;

    cone_height = 1.3;
    cone_diameter_offset = 1.3;

    difference() {
        // Body
        cylinder(r=internal_diameter / 2 + wall_thickness, h=height);

        translate([0, 0, bottom_thickness + magnet_thickness]) {
            cylinder(r=internal_diameter / 2, h=height);
        }

        // Magnet housing
        translate([0, 0, bottom_thickness + magnet_thickness / 2]) {
            magnet(thickness=magnet_thickness + 0.05);
        }

        // Cone
        translate([0, 0, height - cone_height + 0.1]) {
            cylinder(r1=internal_diameter / 2, r2=internal_diameter / 2 + wall_thickness - cone_diameter_offset, h=cone_height);
        }
    }
}

module connection_male(
        internal_diameter=CONN_INTERNAL_DIAMETER - MAGNET_HOUSING_DIAMETER_CLEAR,,
        height=CONN_HEIGHT,
        wall_thickness=CONN_WALL_THICKNESS,
        magnet_thickness=MAGNET_THICKNESS,
        clear=0.25
    ) {

    cone_height = 1.3;
    cone_diameter_offset = 1.3;

    cylinder(r=internal_diameter / 2 + wall_thickness, h=wall_thickness);

    translate([0, 0, wall_thickness]) {
        difference() {
            //cylinder(r=internal_diameter / 2, h=height);
            union() {
                cylinder(r=internal_diameter / 2, h=height - cone_height);
                translate([0, 0, height - cone_height]) {
                    cylinder(r1=internal_diameter / 2, r2=internal_diameter / 2 - cone_diameter_offset, h=cone_height);
                }
            }

            // Magnet housing
            translate([0, 0, magnet_thickness / 2 + height - magnet_thickness]) {
                magnet(thickness=magnet_thickness + 0.05);
            }
        }
    }
}

module link(withbody=true) {
    rotate([0, 90, 0]) {
        difference() {
            hull() {
                intersection() {
                    body();
                    translate([0, 0, 0]) {
                        cube(size = [ 7, 50, 50 ], center=true);
                    }
                }

                intersection() {
                    translate([0 - MAGNET_SUPPORT_THICKNESS / 2, 0, 0]) {
                        rotate([0, -90, 0]) {
                            cylinder(r = CONN_INTERNAL_DIAMETER / 2 + CONN_WALL_THICKNESS, h = MAGNET_SUPPORT_THICKNESS, center = true);
                        }
                    }

                    translate([ - MAGNET_SUPPORT_THICKNESS / 2, 0, 0]) {
                        cube(size = [ MAGNET_SUPPORT_THICKNESS, 50, 50 ], center=true);
                    }
                }
            }

            rotate([0, 90, 0]) {
                translate([0, 0, -10]) {
                    cylinder(r=CONN_INTERNAL_DIAMETER / 2, h=10);
                }
            }
        }

        if (withbody) {
            translate([BODY_LENGTH / 2 + 3, 0, 0]) {
                body();
            }
        }
    }
}

module female_connection_and_link() {
    link();
    connection_female();
}

module male_connection_and_link() {
    link();
    translate([0, 0, 6]) {
        connection_male();
    }
}

connection_female();
connection_male();

union() {
    translate([40, 0, 0]) {
        !female_connection_and_link();
    }
    male_connection_and_link();
}

body();

connection(true);

union() {
    female();

    translate([0, 0, 30]) {
        male();
    }
}

demo();

//magnet();

/*
translate([-BODY_LENGTH / 2 - MAGNET_SUPPORT_THICKNESS / 2, 0, 0]) {
    rotate([0, -90, 0]) {
        magnet_support();
    }
}
*/

//magnet_support(); 
