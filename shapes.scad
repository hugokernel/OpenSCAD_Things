/*
 *  OpenSCAD Shapes Library (www.openscad.at)
 *  Copyright (C) 2009  Catarina Mota <clifford@clifford.at>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
*/

module box(w,h,d) {
	scale ([w,h,d]) cube(1, true);
}

module roundedBox(w,h,d,f){
	difference(){
		box(w,h,d);
		translate([-w/2,h/2,0]) cube(w/(f/2),true);
		translate([w/2,h/2,0]) cube(w/(f/2),true);
		translate([-w/2,-h/2,0]) cube(w/(f/2),true);
		translate([w/2,-h/2,0]) cube(w/(f/2),true);
	}
	translate([-w/2+w/f,h/2-w/f,-d/2]) cylinder(d,w/f, w/f);
	translate([w/2-w/f,h/2-w/f,-d/2]) cylinder(d,w/f, w/f);
	translate([-w/2+w/f,-h/2+w/f,-d/2]) cylinder(d,w/f, w/f);
	translate([w/2-w/f,-h/2+w/f,-d/2]) cylinder(d,w/f, w/f);
}

module cone(height, radius) {
		cylinder(height, radius, 0);
}

module oval(w,h,d) {
	scale ([w/100, h/100, 1]) cylinder(d, 50, 50);
}

module tube(height, radius, wall) {
	difference(){
		cylinder(height, radius, radius);
		cylinder(height, radius-wall, radius-wall);
	}
}

module ovalTube(w,h,d,wall) {
	difference(){
		scale ([w/100, h/100, 1]) cylinder(d, 50, 50);
		scale ([w/100, h/100, 1]) cylinder(d, 50-wall, 50-wall);
	}
}

module hexagon(height, depth) {
	boxWidth=height/1.75;
		union(){
			box(boxWidth, height, depth);
			rotate([0,0,60]) box(boxWidth, height, depth);
			rotate([0,0,-60]) box(boxWidth, height, depth);
		}
}

module octagon(height, depth) {
	intersection(){
		box(height, height, depth);
		rotate([0,0,45]) box(height, height, depth);
	}
}

module dodecagon(height, depth) {
	intersection(){
		hexagon(height, depth);
		rotate([0,0,90]) hexagon(height, depth);
	}
}

module hexagram(height, depth) {
	boxWidth=height/1.75;
	intersection(){
		box(height, boxWidth, depth);
		rotate([0,0,60]) box(height, boxWidth, depth);
	}
	intersection(){
		box(height, boxWidth, depth);
		rotate([0,0,-60]) box(height, boxWidth, depth);
	}
	intersection(){
		rotate([0,0,60]) box(height, boxWidth, depth);
		rotate([0,0,-60]) box(height, boxWidth, depth);
	}
}

module rightTriangle(adjacent, opposite, depth) {
	difference(){
		translate([-adjacent/2,opposite/2,0]) box(adjacent, opposite, depth);
		translate([-adjacent,0,0]){
			rotate([0,0,atan(opposite/adjacent)]) dislocateBox(adjacent*2, opposite, depth);
		}
	}
}

module equiTriangle(side, depth) {
	difference(){
		translate([-side/2,side/2,0]) box(side, side, depth);
		rotate([0,0,30]) dislocateBox(side*2, side, depth);
		translate([-side,0,0]){
			rotate([0,0,60]) dislocateBox(side*2, side, depth);
		}
	}
}

module 12ptStar(height, depth) {
	starNum=3;
	starAngle=360/starNum;
	for (s=[1:starNum]){
		rotate([0, 0, s*starAngle]) box(height, height, depth);
	}
}

//-----------------------
//MOVES THE ROTATION AXIS OF A BOX FROM ITS CENTER TO THE BOTTOM LEFT CORNER
module dislocateBox(w,h,d){
	translate([w/2,h,0]){
		difference(){
			box(w, h*2, d+1);
			translate([-w,0,0]) box(w, h*2, d+1);
		}
	}
}







