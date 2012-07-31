/*
*************************************************************************
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
************************************************************************* 
*/

/*
Description:

A basic holder female end for the Ultimaker 3D Printer.

You will need to print and mount this first:
"Ultimaker Generic HeadMount" http://www.thingiverse.com/thing:20775

This part is a basic design for a holder part, it's a template so to say.

*/


//############################################################
//Fix up circles
$fs = 0.4; $fa = 5;
eps = 0.025;

clear = 0.1; // clearance 

// ########################


// PARAMETERS FOR THE COUPLING: 
// (do not change unless you change the male part too)
mountdepth = 12.25;

// width & length of vertical male coupling bar
wmountvert = 9; 
lmountvert = 50;
// width & length of horizontal male coupling bar
wmounthoriz = 9;
lmounthoriz = 18;

screwposz = 16; // vertical position of screws from center
//##########################################################
// PARAMETERS FOR THE HOLDER <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
tside = 2.75; // main coupling thickness
tmembrane = 0.55; // cut this mambrane away after printing
// ##############################################

femalecoupling();

// ##############################################

module femalecoupling()
{
	difference() {
		union() {
			translate([-mountdepth/2-tside/2,0,0]) cube([mountdepth+tside,wmountvert+tside*2, lmountvert+tside*2], center=true);
			translate([-mountdepth/2-tside/2,0,0]) cube([mountdepth+tside,lmounthoriz+tside*2,wmounthoriz+tside*2], center=true);
		}
		translate([-mountdepth/2-clear/2,0,0]) cube([mountdepth+clear*2,wmountvert+clear*2, lmountvert+clear*2], center=true);
		translate([-mountdepth/2-clear/2,0,0]) cube([mountdepth+clear*2,lmounthoriz+clear*2,wmounthoriz+clear*2], center=true);

		//holes for screws
		translate([-mountdepth+5,0,-screwposz]) rotate(90,[1,0,0])
			cylinder(r=3/2,h=wmountvert+tside*2+clear,center=true);
		translate([-mountdepth+5,0,+screwposz]) rotate(90,[1,0,0])
			cylinder(r=3/2,h=wmountvert+tside*2+clear,center=true);
	}

	// printing support membrane
	color([0.8,0.8,0.8])
	translate([-(mountdepth)/2+0.05, 0 , tmembrane/2+wmounthoriz/2+clear])
	cube([(mountdepth-0.1),wmounthoriz+clear*2+2,tmembrane],center=true);
	
	scale([1, 1, 1]) translate([-tside,wmountvert/2+tside,wmounthoriz/2+tside]) wedge(tside, (lmounthoriz - wmountvert) / 2);
	scale([1,-1, 1]) translate([-tside,wmountvert/2+tside,wmounthoriz/2+tside]) wedge(tside, (lmounthoriz - wmountvert) / 2);
	scale([1,-1,-1]) translate([-tside,wmountvert/2+tside,wmounthoriz/2+tside]) wedge(tside, (lmounthoriz - wmountvert) / 2);
	scale([1, 1,-1]) translate([-tside,wmountvert/2+tside,wmounthoriz/2+tside]) wedge(tside, (lmounthoriz - wmountvert) / 2);

	scale([1, 1, 1]) translate([-mountdepth-tside,wmountvert/2+tside,wmounthoriz/2+tside]) wedge(tside, (lmounthoriz - wmountvert) / 2);
	scale([1,-1, 1]) translate([-mountdepth-tside,wmountvert/2+tside,wmounthoriz/2+tside]) wedge(tside, (lmounthoriz - wmountvert) / 2);
	scale([1,-1,-1]) translate([-mountdepth-tside,wmountvert/2+tside,wmounthoriz/2+tside]) wedge(tside, (lmounthoriz - wmountvert) / 2);
	scale([1, 1,-1]) translate([-mountdepth-tside,wmountvert/2+tside,wmounthoriz/2+tside]) wedge(tside, (lmounthoriz - wmountvert) / 2);

	% translate([tside,0,0]) translate([0,0,-25]) rotate(-45,[0,0,1]) render() forbiddenregions();
}

module wedge(x, y)
{
	intersection() {
		translate([0,-eps,-eps]) cube([x, y+eps, y+eps]);
		rotate([0,90,0]) cylinder(r=y,h=x, $fn=4);
	}
}

//##############################
//##############################
// these are crude bounding boxes for the axes
module forbiddenregions()
{
  translate([16/2+15,0,50/2])  // 15
  cube([16,60,50],center=true);
  translate([0,16/2+15,50/2])  // 15
  cube([60,16,50],center=true);
}


