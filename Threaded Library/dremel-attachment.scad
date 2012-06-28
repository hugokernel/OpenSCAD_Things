// A replacement holder to fit a dremel to
// The little bolt hobbit by elk
// http://www.thingiverse.com/thing:23717
//derived from Router attachment for rotary tool (thing:17105)


// You need the sylwych's thread library. Get it from:
// http://www.thingiverse.com/thing:8793
// or
// https://github.com/syvwlch/Thingiverse-Projects/tree/master/Threaded%20Library
include<Thread_Library.scad>


threadRad=9.0;   // Tweak this so the thread fits snugly on your dremel
nut=5.5;       // 
nutHeight=2.3;
nutHole=3.2;
thickness=10;    // Depth of the top nut
width=40;
baseRad=35;      // Radius at the base
baseDepth=35;    // Distance from bottom of the nut to the base
baseLift=5;      // How much of the base rises vertically before the cone starts / windows are cut out
wallThickness=4; // Thickness of the walls, increase for more strength
holeRad=15;      // Radius of the window corners

offset=2.6;

// Set resolution parameters
$fn=20;
$fa=0.6;
$fs=4;



    // Top nut that attaches to the rotary tool
	difference() 
	{
	union(){
		cylinder(
			h=thickness,
			r=threadRad+wallThickness+1, 
			center=true
			);
	}
	
		
		
	translate([0,0,-5])
		trapezoidThreadNegativeSpace(length=thickness, 
		pitch=2.0, pitchRadius=threadRad, threadHeightToPitch=0.7, stepsPerTurn=20, countersunk=0.2);
	}

	

