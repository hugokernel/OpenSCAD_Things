use <teardrops.scad>
use <roundCornersCube.scad>
use <../../MCAD/boxes.scad>

$fn = 40;

BOX_WIDTH = 76;
BOX_LENGTH = 112;
BOX_HEIGHT = 32;
BOX_WALL_THICKNESS = 1.8;

module polyhole(h, d) 
{
	/* Nophead's polyhole code */
    n = max(round(2 * d),3);
    rotate([0,0,180])
        cylinder(h = h, r = (d / 2) / cos (180 / n), $fn = n);
}

module standoff(outer_diam, inner_diam, height, hole_depth) {
	/* Generates a standoff for mounting something e.g. a PCB */
	difference() {
		cylinder(r=outer_diam/2, h=height, $fn=50);
		translate([0,0, height - hole_depth]) polyhole(hole_depth + 1, inner_diam); 
	}
}

module rounded_cube_case(generate_box = true, generate_lid = false) 
{
	//Case details (these are *outer* diameters of the case 
	sx = BOX_LENGTH; 			//X dimension
	sy = BOX_WIDTH;			//Y dimension
	sz = BOX_HEIGHT;				//Z dimension
	r = 2.5;				//The radius of the curves of the box walls.
	wall_thickness = BOX_WALL_THICKNESS;//Thickness of the walls of the box (and lid)

	//Screw hole details
	screw_hole_dia = 2;  	//Diameter of the screws you want to use
	screw_hole_depth = 20;	//Depth of the screw hole

	screw_head_dia = 5;		//Diameter of the screw head (for the recess)
	screw_head_depth = 1.0;	//Depth of the recess to hold the screw head

	screw_hole_centres = [ [wall_thickness*2, wall_thickness*2,0 ], 
					[sx - ( wall_thickness*2), wall_thickness*2, 0],
					[sx - ( wall_thickness*2), sy - ( wall_thickness*2), 0], 
					[1 + wall_thickness*2, sy - (wall_thickness*2), 0] ];

	if (generate_lid == true) 
	{
			translate([0, sy+10, 0])
			difference() 
			{
				translate([sx/2, sy/2, wall_thickness/2]) roundCornersCube(sx,sy,wall_thickness,r); //Create the cube
	
				for (i = screw_hole_centres) 
				{
					/*	Drill two holes in the lid - the screw-hole, and the countersink 
						The screw-hole is made 25% larger here, as the idea is for the screw
						to pass through the lid without biting into it */
		
	 				translate([0,0,-0.5]) translate(i) polyhole(wall_thickness + 1, screw_hole_dia * 1.25);  //The screw hole.
					translate([0, 0, wall_thickness - screw_head_depth]) translate(i) polyhole(screw_head_depth + 1, screw_head_dia); //The countersink
				}
			}
	}

	if (generate_box == true)  
	{
		//The 'box' part of the case.
		union() 
		{
			difference() 
			{
				translate([sx/2, sy/2,sz/2 ]) roundCornersCube(sx,sy,sz, r);
				//cut off the 'lid' of the box
				translate([-0.1,-0.1, sz - wall_thickness]) cube([sx+1,sy+1,wall_thickness + 1]);
				//hollow it out
				translate([sx/2, sy/2, sz/2 + wall_thickness]) roundCornersCube(sx - (wall_thickness*2) , sy - (wall_thickness*2) , sz, r);
			}
			
			//Put in the pillars for the screws to go into.
			for (i = screw_hole_centres)  
			{
				translate([0,0,wall_thickness]) translate(i) 
					standoff(screw_hole_dia * 3, screw_hole_dia, sz - (wall_thickness * 2) - 2, 
						screw_hole_depth);
			}
		}
	}

}

module support_screw(boolean = false) {
    radius = 3.5;
    height = 2;

    if (boolean) {
        translate([0, 0, -10]) {
            cylinder(r = 1.5, h = 20);
        }
    } else {
        difference() {
            cylinder(r = radius, h = height);
            cylinder(r = 1.5, h = 20);
        }
    }
}

module support(boolean = false) {
    for (position = [
        [0,     0,      BOX_WALL_THICKNESS],
        [90.2,  0,      BOX_WALL_THICKNESS],
        [0,     52.07,  BOX_WALL_THICKNESS],
        [90.2,  52.07,  BOX_WALL_THICKNESS]
    ]) {
        translate(position) {
            support_screw(boolean);
        }
    }
}

module holes() {
    translate([0, BOX_WIDTH / 2, BOX_HEIGHT * 2 - 15]) {
        roundedBox([25, BOX_WIDTH - 20, 50], 5);
    }

    translate([BOX_LENGTH / 2, BOX_WIDTH, BOX_HEIGHT * 2 - 15]) {
        roundedBox([BOX_WIDTH - 20, 20, 50], 5);
    }
}

module mouse_ears() {

    for (position = [
        [BOX_LENGTH, BOX_WIDTH, 0],
        [0, BOX_WIDTH, 0],
        [BOX_LENGTH, 0, 0],
        [0, 0, 0]
    ]) {
        translate(position) {
            cylinder(r = 10, h = 0.6);
        }
    }
}

module case() {
    difference() {
        rounded_cube_case(false, true);
        //holes();
   
        translate([10, 12, 0]) {
            //support(true);
        }
    }

    translate([10, 12, 0]) {
        support();
    }

    //mouse_ears();
}

translate([5, 6, 5]) {
    //color("red") cube([100.3, 62.3, 25]);
}

case();

