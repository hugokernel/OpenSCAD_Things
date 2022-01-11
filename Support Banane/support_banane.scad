
FACE_WIDTH = 50;
FACE_HEIGHT = 25;
FACE_THICKNESS = 3;

PLUG_DIAMETER = 12;

HOLDER_WIDTH = FACE_WIDTH;
HOLDER_HEIGHT = 40;
HOLDER_THICKNESS = FACE_THICKNESS;

module face(hole = false) { 
    if (hole) {
        for (pos = [
            [-12.5, 0, 0],
            [12.5, 0, 0]
        ]) {
            translate(pos) {
                cylinder(r = PLUG_DIAMETER / 2, h = 100, center = true);
            }
        }
    } else {
        cube(size = [FACE_WIDTH, FACE_HEIGHT, FACE_THICKNESS], center = true);
    }
}

module holder(hole = false) {
    translate([0, FACE_HEIGHT / 2 - FACE_THICKNESS / 2, HOLDER_HEIGHT / 2 - FACE_THICKNESS / 2]) {
        rotate([90, 0, 0]) {
            if (hole) {
                for (pos = [
                    [-10, 0, 0],
                    [10, 0, 0],
                ]) {
                    translate(pos) {
                        cylinder(r = 3, h = 10, center = true);
                    }
                }
            } else {
                cube(size = [HOLDER_WIDTH, HOLDER_HEIGHT, HOLDER_THICKNESS], center = true);
            }
        }
    }
}

module main() { 

    difference() {
        hull() {
            face();
            holder();
        }

        face(hole = true);
        holder(hole = true);
        translate([0, 0, FACE_HEIGHT]) {
            cube(size = [FACE_WIDTH - 2 * FACE_THICKNESS, FACE_HEIGHT - 2 * FACE_THICKNESS, HOLDER_HEIGHT], center = true);
        }
    }
}

main();

