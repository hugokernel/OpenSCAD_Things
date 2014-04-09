/*   	Makerbottable Filament Spool v2.0
		by Randy Young <dadick83@hotmail.com>
		2010, 2011.   License, GPL v2 or later
**************************************************/

include <Libs.scad> //  Libs.scad is @ http://www.thingiverse.com/thing:6021

displayMode = rezPrinter();  // (rezPrinter | rezScreen)

// *** Arm Assembly Plate ***
//translate([-5,-19,0])
//	ExtensionArm();
translate([0,-37,0])
	ArmEnd();
translate([30,-9,0]) rotate(loosen())
	ForkClip();


// *** Hub Assembly Plate ***
//Hub(holeRadius = 9.1);
//translate([-45,45,0]) rotate(tighten())
//	Spindle();
//translate([45,35,0]) rotate(tighten(180))
//	FilamentGuide();
//translate([35,15,0]) rotate(tighten())
//	FilamentGuide(drop=6, outrigger=0);


//-------------------------------------------------

module Hub(holeRadius = 	5.5, ringThickness =	4){
	union(){
		tube(holeRadius+ringThickness,ringThickness,10);
		tube(28,ringThickness,10);		
		for (i= [0:2])
			rotate (tighten(i*120+0))
			difference(){
				translate(push (20+holeRadius/2)+lift(5))
					cube([16,40-holeRadius,10], center=true);
				translate(push((30+holeRadius)/2)+lift(10))
					roundRect (size=[7.5,30-holeRadius-2*ringThickness,10], round=2, center=true);
				translate(push(40)+lift(5)) rotate(tighten())
					dovetail(height=10.1);
}	}	}

//-------------------------------------------------

module ExtensionArm (length=70){
	translate(lift(5))
	difference(){
		union(){
			cube([length,16,10], center=true);
			translate(slide(length/2)) dovetail();
		}
		translate(slide(2)) rotate(tighten())	slot([8,length-16,10.05], centerXYZ=[1,1,1]);
		translate(slide(-length/2-0.01)) dovetail(height=10.1,male=false);
}	}

//-------------------------------------------------

module ArmEnd(length=60){
	translate(lift(5))
		difference(){
		union(){
			rotate(tighten()) slot([16,length,10], endRound=false, centerXYZ=[1,1,1]);
			translate(slide(length/2)) dovetail();
		}
		 rotate(tighten())	slot([8,length-10,10.05], centerXYZ=[1,1,1]);
}	}

//-------------------------------------------------

// Note: the ForkClip press fits into the slots on the ArmEnds.  Default settings match
// 		the sizes of old MBI and Ultimaker (spoolless) 1lb rolls



module ForkClip(
			forkSize = [40,50,5], 	// width, length, thickness
			armLength = 60,	 		// This should be same as the ArmEnd length you chose
			filamentSize = 3,		// for filament holding tabs
			slotSize = [8,10],		// width, depth.  length derived from armLength
			forkOffset = 6.5)		// moves the fork up on the clip to fine tune filament diameter 

	difference() {
		union(){
			translate(slide(slotSize[1]+1)+push(slotSize[0]+4.5+forkOffset)){
				slot(forkSize, endRound=false,centerXYZ=0);
				cube([forkSize[0]/2,forkSize[1],forkSize[2]]);
			}
			translate(lift(slotSize[0]/2-0.5)+push(slotSize[0]/2)){
				rotate(righty()) 
					cylinder(r1=slotSize[0]/2-0.5, r2=slotSize[0]/2+0.5, h=slotSize[1]-0.5, 
						$fn=resolution(slotSize[0]/2));
				translate(push(armLength-10-slotSize[0]))
					rotate(righty()) 
					cylinder(r1=slotSize[0]/2-0.5, r2=slotSize[0]/2+0.5, h=slotSize[1]-0.5, 
						$fn=resolution(slotSize[0]/2));
			}
			translate(push(slotSize[0]/2))
				cube([slotSize[1]-0.5,armLength-10-slotSize[0],1.51]); // spring
			translate(push(slotSize[0]+2.5)) 
				cube([slotSize[1]+forkSize[2],armLength-15-2*slotSize[0],forkSize[2]]);
		}
		translate(slide(slotSize[1]+1+forkSize[2])+push(slotSize[0]+4.5+forkOffset+forkSize[2]))
				slot([forkSize[0]-2*forkSize[2],forkSize[1],forkSize[2]*2.1], endRound=false,centerXYZ=[0,0,1]);
		translate([-ep,0,-5]) 
			cube([slotSize[1]+2*ep,armLength-10,5+ep]);
		translate([slotSize[1]+forkSize[2]-1.1,slotSize[0]+3.5+filamentSize*0.33,-ep]) 
			cube([1.2,filamentSize*0.77,forkSize[2]+1]);
		translate([slotSize[1],slotSize[0]+3.5,-0.01]) rotate(tighten())
			slot([filamentSize*1.1,forkSize[2]-1,forkSize[2]+0.1], endRound=false, centerXYZ=[2,0,0]);
	}

//-------------------------------------------------

module Spindle(
	postDiameter =	10.5,				// matched to size of hole in hub
	hubThickness =	11,				// length of post before flange
	drop = 			30,				// distance hook hangs down from edge it's clipped to
	overhang = 		6,				// length hook overlaps edge
	plywood = 		5,				// thickness of wall hook is attached to
	outrigger = 		8,				// standoff distance from hook
	girth = 			5,				// beefiness, thickness of hook (width governed by postDiameter)
	springTab =		0,				// use 0 for none.  tensioner that presses against hub to provide friction
	springSize =		[1.5,18,5])		// if springTab is used.  Only needed if you're using a hub with bearing

	difference(){
		translate(lift(-0.75)) difference(){
			union(){
				cube([2*girth+plywood+outrigger, drop+girth, postDiameter]);
				translate([2*girth+plywood+outrigger-ep,postDiameter/2+1,postDiameter/2])
				rotate(righty()){ 
					cylinder(r=postDiameter/2, h=hubThickness*2);
					translate(lift(hubThickness))
						cylinder(r1=postDiameter/2+1.3, r2=postDiameter/2, h=hubThickness);
				}
				if (springTab>0){
					translate([2*girth+plywood+outrigger-springTab-1,ep-springSize[1],0.75]) {
						cube(springSize);
						cube([springTab+1,springTab*2,springSize[2]]);
						translate([springTab+1,springTab,springSize[2]/2]) sphere(springTab);
				}	}
			}
			translate([-ep,-ep,-ep]){
				cube([girth+plywood,drop-overhang,postDiameter+1]);
				translate([2*girth+plywood+ep,postDiameter+2,0])
					cube([outrigger+ep,drop,postDiameter+1]);
				translate([girth,0,0])
					cube([plywood,drop,postDiameter+1]);
				translate([2*girth+plywood+outrigger+ep,postDiameter/2+1,0])	linear_extrude(2)
					polygon(points=[	[-outrigger/2,0],
									[hubThickness*2,postDiameter/4],
									[hubThickness*2,-postDiameter/4]]);
			}
		}
		translate([-ep,-ep,-5]) cube([100,100,5]);
		translate([-ep,-ep,postDiameter-1.5]) cube([100,100,5]);
}


//-------------------------------------------------

module FilamentGuide(
	tubeDiameter =	0.25*in,			// size of filament hole
	tubeThickness =	1.5,				// thickness of gude tube
	drop = 			10,				// distance hook hangs down from edge it's clipped to
	overhang = 		6,				// length hook overlaps edge
	plywood = 		5,				// thickness of wall hook is attached to
	outrigger = 		15,				// standoff distance from hook
	girth = 			4)				// beefiness, thickness/width of hook

	difference(){
		union(){
			cube([2*girth+plywood, drop+girth, girth]);
			cube([2*girth+plywood+outrigger, girth, girth]);
			translate([girth*2+plywood+outrigger+tubeDiameter/2,girth/2,0])
				tube(tubeDiameter/2+tubeThickness,tubeThickness,girth);

		}
		translate([-ep,-ep,-ep]){
			cube([girth+plywood,drop-overhang,girth+2*ep]);
		translate([girth,0,0])
			cube([plywood,drop+ep,girth+2*ep]);
		translate([girth*2+plywood+outrigger+tubeDiameter/1.5,girth/2-tubeDiameter/4,0])
			cube([plywood,tubeDiameter/2,girth+2*ep]);
		}
}



