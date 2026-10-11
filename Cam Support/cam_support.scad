include <BOSL2/std.scad>

$fn = 90;

CAM_LENGTH = 123.49 + 5;
CAM_WIDTH = 51.4 + 5;

THICKNESS = 3;

WOOD_THICKNESS = 52.5;

MARGIN = 5;

module cam_base(length=CAM_LENGTH + MARGIN, width=CAM_WIDTH + MARGIN, thickness=THICKNESS) {
    module positions() {
        for (i = [0 : $children - 1]) {
            left((length - width) / 2)
                children(i);
            right((length - width) / 2)
                children(i);
        }
    }

    hull() {
        positions() {
            zcyl(d=width, h=thickness);

            zcyl(d=width, h=thickness);
        }
    }
}

// Jupe
SKIRT_WALL = 2.5;
SKIRT_HEIGHT = 30;
SKIRT_FLARE   = 10;

// Larmier
DRIP_WIDTH  = 1.0;
DRIP_HEIGHT = 1.0;


module skirt() {
    back_thickness = 2;

    // Oblong 2D
    module oblong2d(length, width)
    {
        hull() {
            left((length-width)/2)
                circle(d=width);

            right((length-width)/2)
                circle(d=width);
        }
    }

    // Corps de la jupe
    module skirt_body()
    {
        inner_L = CAM_LENGTH - 0.1;
        inner_W = CAM_WIDTH - 0.1;

        difference() {
            hull() {
                up(SKIRT_HEIGHT)
                    linear_extrude(0.01)
                        offset(delta=SKIRT_WALL)
                            oblong2d(inner_L, inner_W);

                linear_extrude(0.01)
                    offset(delta=SKIRT_WALL + SKIRT_FLARE)
                        oblong2d(inner_L, inner_W);
            }

            hull() {
                up(SKIRT_HEIGHT - 0.1)
                    linear_extrude(0.2)
                        oblong2d(inner_L, inner_W);

                down(0.1)
                    linear_extrude(0.2)
                        offset(delta=SKIRT_FLARE)
                            oblong2d(inner_L, inner_W);
            }
        }
    }

    // Larmier périphérique
    module drip_edge()
    {
        inner_L = CAM_LENGTH - 0.1;
        inner_W = CAM_WIDTH - 0.1;

        // rayon extérieur atteint par la jupe au niveau inférieur
        base_offset = SKIRT_FLARE + SKIRT_WALL;

        difference() {

            // extérieur du larmier
            down(DRIP_HEIGHT)
                linear_extrude(DRIP_HEIGHT)
                    offset(delta=base_offset + DRIP_WIDTH)
                        oblong2d(inner_L, inner_W);

            // vide central
            down(DRIP_HEIGHT + 0.1)
                linear_extrude(DRIP_HEIGHT + 0.2)
                    offset(delta=base_offset)
                        oblong2d(inner_L - 2, inner_W - 2);
        }
    }

    up(30 - back_thickness / 2)
        difference() {
            cam_base(length=CAM_LENGTH, width=CAM_WIDTH, thickness=back_thickness);

            holes();
        }

    union() {
        skirt_body();
        drip_edge();
    }
}


module holes() {
    insert_hole_diameter = 4.55;

    hull() {
        fwd(6)
            zcyl(d=20, h=100);

        back(6)
            zcyl(d=20, h=100);
    }

    left(35) {
        zcyl(d=insert_hole_diameter, h=20);

        yrot(90)
            torus(or=20, ir=5);
    }

    right(35) {
        zcyl(d=insert_hole_diameter, h=20);

        yrot(90)
            torus(or=20, ir=5);
    }
}


module main() {
    difference() {
        hull() {
            cam_base();

            up(20)
                xcyl(d=40, h=75);
        }

        up(35)
            cube(size=[WOOD_THICKNESS, 100, 50], center=true);

        up(10)
            fwd(20)
                ycyl(d=10, h=50);
                // cube(size=[10, 50, 50], center=true);

        up(25) {
            xcyl(d=5, h=200);

            left(45)
                xcyl(d=10, h=20);

            right(45)
                xcyl(d=10, h=20);
        }

        holes();
    }

    //xrot(180) camera_skirt();
    //
}



module demo() {
    skirt();

    up(SKIRT_HEIGHT + 2)
        main();
}


cam_base();

main();

!skirt();

demo();
