//******************* OTHER FILES NEEDED **************************************

use <../MCAD/hardware.scad>
use <../MCAD/boxes.scad>

//*****************************************************************************
//******************* VARIABLES TO ADJUST *************************************

baseWidth = 48; //leave
baseCornerRadius = 3.5; //leave
outsideHolesFromCentre = 20.5; //distance in x or y not vector
insideHolesFromCentre = 11; //distance in x or y not vector
outsideHolesRadius = 1.5;
oHR_Allow = 0.75; //adjustment for above for clearance. Printers put too much inside holes usually
baseHeight = 6; //6 is good
centreToInsideBase = 7;
baseLegWidth = 9;
fanSideBaseHeight = 6; //No less than 2 but preferably more. Need short to fit nut on fan below

//tubeRadius = 3.1;
//tR_Allow = 0.8; //adjustment for above for clearance. Printers put too much inside holes usually
//threadLength = 20;
//tubeBottom = 16;
//tighteningConeTopRadius = 4.7;
//tighteningConeHeight = 10;
//topOfTighteningConeHeight = 3;
//tighteningConeOpening = 1.7;
//tighteningConeInnerRatio = 0.9; //Ratio to Width of Bowden tube. 0.9 works good
//riserTubeRadius = 7.5;
//riserTubeSkirt = 1; // leave at 1
//capInsideDiameter = 16; // usually double riserTubeRadius + 1 (Use capTest(); first if not sure)
//capHeight = 24;
//capTopThickness = 4;
//capOuterDiameter = 24.5;

//holesTubeRadius = 5;

// Modif hugo
washerDiameter = 12;
washerHeight = 1;
supportLength = 18.5;
supportWidth = 10;


//*****************************************************************************
//******************* OTHER VARIABLES *****************************************

$fn = 36;
stlClearance = 0.02; //Used to make edges to overlap by a small amount to prevent errors in the STL output
PI=3.141592;
tubeCentre = [insideHolesFromCentre,-insideHolesFromCentre, -stlClearance];


//*****************************************************************************
//******************* VIEWING ****************************************************




//*****************************************************************************
//******************* PRINTING ****************************************************

con_thr_h = 9; //length of the air coupling threaded part
myrodsize = 10.5; //diameter of the threaded hole for air coupling INCLUDING THE THREAD THICKNESS
myrodpitch = 0.907; //not sure about that, so I suggest threading the coupling in while the clamps are still hot.

//*****************************************************************************
//************************** MODULES ******************************************


baseAndRiser();

/*
translate([0, 0, -2])
cube(size = [18, 25, 4], center = true);
bowdenSupport();
*/


module bowdenSupport() {
    difference() {
        cylinder(r = 7, h = con_thr_h);
        cylinder(r = 4.5, h = 100);
        translate([0, 0, con_thr_h / 2]) {
            rod( con_thr_h, true, renderrodthreads=true, rodsize=myrodsize, rodpitch=myrodpitch );
        }
    }
}


module baseAndRiser(){
    difference(){
        base();

        translate([tubeCentre[0], tubeCentre[1], 0]) {
            cylinder(r = 6, h = 50, center = true);
        }

        // Double support
        translate([tubeCentre[0], -tubeCentre[1], 0]) {
            cylinder(r = 6, h = 50, center = true);
        }

        // Washer
        translate ([outsideHolesFromCentre,outsideHolesFromCentre, baseHeight - washerHeight])
            cylinder(r = washerDiameter / 2, h = washerHeight);
        translate ([outsideHolesFromCentre,-outsideHolesFromCentre, baseHeight - washerHeight])
            cylinder(r = washerDiameter / 2, h = washerHeight + 1);
        translate ([-outsideHolesFromCentre,-outsideHolesFromCentre, 2])
            cylinder(r = washerDiameter / 2, h = baseHeight);

        translate ([-outsideHolesFromCentre,outsideHolesFromCentre,2])
            cylinder(r = washerDiameter / 2, h = baseHeight);

        translate([-10, 13, 10]) {
            rotate([0, 0, -45]) {
                electronicSupport();
            }
        }

        // Second electronic support
        translate([-4, -7, 10]) {
            rotate([0, 0, 180]) {
                electronicSupport();
            }
        }

        // New hole, v2 hot end
        translate([0, - baseWidth / 2 + 18, -stlClearance])
            cylinder(r = 4, h = baseHeight + washerHeight);

        translate([-15, - baseWidth / 2 + 18, (baseHeight + washerHeight) / 2 - 0.5])
            cube(size = [30, 2, baseHeight + washerHeight], center = true);
    }

    translate([tubeCentre[0], tubeCentre[1], 0]) {
        bowdenSupport();
    }

    // Double support
    translate([tubeCentre[0], -tubeCentre[1], 0]) {
        bowdenSupport();
    }

/*
    color([0.4, 0.4, 0.4]) {
        translate([-10, 13, 10]) {
            rotate([0, 0, -45]) {
                electronicSupport();
            }
        }

        // Second electronic support
        translate([-4, -7, 10]) {
            rotate([0, 0, 180]) {
                electronicSupport();
            }
        }
    };
*/
}

module electronicSupport() {

    translate([0, 0, baseHeight])
        cube(size = [supportWidth, supportLength, 10], center = true);

    translate([- supportWidth / 2, - supportLength / 2, -baseHeight * 2]) {
        m3_hole();

        translate([supportWidth, supportLength, 0]) {
            m3_hole();
        }
    }

    translate([- supportWidth / 2, - supportLength / 2, -9]) {
        m3_nut(height = 4);

        translate([supportWidth, supportLength, 0]) {
            m3_nut(height = 4);
        }
    }
}

module base(){
    difference(){
        union(){
            difference(){
                translate([0, 0, baseHeight / 2])roundedBox([baseWidth,baseWidth,baseHeight],baseCornerRadius,true);
                    //rotate ([0,0,45])
                        //translate ([-baseWidth,-centreToInsideBase, -baseHeight / 2])
                          //  cube([2 * baseWidth, baseWidth, 2 * baseHeight]);
            }
            translate ([0,-baseWidth / 2 + baseLegWidth / 2, fanSideBaseHeight / 2])
                roundedBox([baseWidth, baseLegWidth, fanSideBaseHeight],baseCornerRadius,true);
            translate ([baseCornerRadius,-baseWidth / 2 + baseLegWidth / 2, baseHeight / 2])
                roundedBox([baseWidth - baseCornerRadius * 2, baseLegWidth, baseHeight],baseCornerRadius,true);
            translate ([baseWidth / 2 - baseLegWidth / 2, 0, baseHeight / 2])
                roundedBox([baseLegWidth, baseWidth, baseHeight],baseCornerRadius,true);

            // Washer
            translate ([outsideHolesFromCentre,outsideHolesFromCentre, 0])
                cylinder(r = washerDiameter / 2, h = baseHeight);
            translate ([outsideHolesFromCentre,-outsideHolesFromCentre,0])
                cylinder(r = washerDiameter / 2, h = baseHeight);
            translate ([-outsideHolesFromCentre,-outsideHolesFromCentre,0])
                cylinder(r = washerDiameter / 2, h = baseHeight);
            translate ([-outsideHolesFromCentre,outsideHolesFromCentre,0])
                cylinder(r = washerDiameter / 2, h = baseHeight);
        }

        // Holes on each corner
        translate ([outsideHolesFromCentre,outsideHolesFromCentre,-1])
            cylinder(r = outsideHolesRadius + oHR_Allow, h = baseHeight * 2);
        translate ([outsideHolesFromCentre,-outsideHolesFromCentre,-1])
            cylinder(r = outsideHolesRadius + oHR_Allow, h = baseHeight * 2);
        translate ([-outsideHolesFromCentre,-outsideHolesFromCentre,-1])
            cylinder(r = outsideHolesRadius + oHR_Allow, h = baseHeight * 2);
        translate ([-outsideHolesFromCentre,outsideHolesFromCentre,-1])
            cylinder(r = outsideHolesRadius + oHR_Allow, h = baseHeight * 2);
    }
}

module m3_nut(height = 2) {
    cylinder(r = 3.4, h = height, center = true, $fn = 6);
}

module m3_hole(length = 50) {
    cylinder(r = 1.9, h = length, center = true);
}


//********************** END MODULES ******************************************

