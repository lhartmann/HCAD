/* nut.scad
 *
 * Originally by Lucas V. Hartmann <lhartmann@github.com>, 2016.
 * Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later
 */
 
include <MCAD/units.scad>

// Nuts = [UTS/ISO Dmaj, outer diameter, width, height]
NUT_1_8_INCH  = [1/8*inch, 6.22*mm, 6.22*cos(30)*mm, 2.62*mm];
function nutDmaj(nut)     = nut[0];
function nutDiameter(nut) = nut[1];
function nutWidth(nut)    = nut[2]; // Tool required to hold the nut
function nutHeight(nut)   = nut[3];

// Factory / setter for nuts.
// Usage:
//   Postional constructor:
//     mynut = nutSet(false, inch/8, 3*mm, 8*mm, 2*mm);
//   Name-oriented constructor:
//     mynut = nutSet(Dmaj=inch/8, d=3*mm, w=8*mm, h=2*mm);
//   Modify existing nuts:
//     other = nutSet(mynut, h=15*mm);

function nutSet(n=NUT_1_8_INCH, Dmaj=false, d=false, w=false, h=false) =
    [
        Dmaj != false ? Dmaj : nutDmaj(n),
        d    != false ? d    : nutDiameter(n),
        w    != false ? w    : nutWidth(n),
        h    != false ? h    : nutHeight(n)
    ];

module nut(model=NUT_1_8_INCH, ref="center", clear=0) {
	T =
		ref == "base" ? [0,0,+nutHeight(model)/2] :
		ref == "top"  ? [0,0,-nutHeight(model)/2] :
		[0,0,0]; // center
	
	translate(T) difference() {
		intersection() {
			// Proper dimension at tool contact faces
			cylinder(d=(nutWidth(model)+clear)/cos(30), h=nutHeight(model)+2*clear, $fn=6, center=true);
			// Proper dimension at rounded edges
			cylinder(d=nutDiameter(model)+clear, h=nutHeight(model)+2*clear, $fn=6*6, center=true);
		}
		// Bolt hole
		cylinder(r=nutDmaj(model)/2+clear, h=nutHeight(model)*3, $fn=16, center=true);
	}
}
