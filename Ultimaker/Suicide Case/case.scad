use <teardrops.scad>
use <roundCornersCube.scad>

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

module rounded_cube_case (generate_box = true, generate_lid = false) 
{
	//Case details (these are *outer* diameters of the case 
	sx = 110; 			//X dimension
	sy = 75;			//Y dimension
	sz = 20;				//Z dimension
	r = 2.5;				//The radius of the curves of the box walls.
	wall_thickness = 1.5;//Thickness of the walls of the box (and lid)

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
					standoff(screw_hole_dia * 3, screw_hole_dia, sz - (wall_thickness * 2), 
						screw_hole_depth);
			}
		}
	}

}

//rounded_cube_case(false, true);
rounded_cube_case(true, false);

module support() {

    radius = 2.5;

    translate([0, 0, 0]) {
        cylinder(r = radius, h = 10);
    }

    translate([90.2, 0, 0]) {
        cylinder(r = radius, h = 10);
    }

    translate([0, 52.07, 0]) {
        cylinder(r = radius, h = 10);
    }

    translate([90.2, 52.07, 0]) {
        cylinder(r = radius, h = 10);
    }

}

translate([10, 12, 0]) {
    support();
}

translate([5, 6, 5]) {
    color("red")
    cube([100.3, 62.3, 1]);
}
