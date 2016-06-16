/*
 * Bearing model.
 *
 * Originally by Hans Häggström, 2010.
 * Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later
 */

include <MCAD/units.scad>
include <MCAD/materials.scad>

// Example, uncomment to view
//test_bearing();
//test_bearing_hole();

module test_bearing(){
    bearing();
    bearing(pos=[5*cm, 0,0], angle=[90,0,0]);
    bearing(pos=[-2.5*cm, 0,0], model=688);
}

module test_bearing_hole(){
    difference(){
      translate([0, 0, 3.5]) cube(size=[30, 30, 7-10*epsilon], center=true);
      bearing(outline=true);
    }
}

BEARING_INNER_DIAMETER = 0;
BEARING_OUTER_DIAMETER = 1;
BEARING_WIDTH = 2;
function bearingSet(b, id=false, od=false, w=false) = [
    id != false ? id : bearingInnerDiameter(b),
    od != false ? od : bearingOuterDiameter(b),
    w  != false ? w  : bearingWidthDiameter(b)
];

// Common bearing names
SkateBearing = 608;

// Bearing dimensions
// model == XXX ? [inner dia, outer dia, width]:
function bearingDimensions(model) =
  len(model) == 3 ? model :
  model == 608 ? [8*mm, 22*mm, 7*mm]:
  model == 623 ? [3*mm, 10*mm, 4*mm]:
  model == 624 ? [4*mm, 13*mm, 5*mm]:
  model == 627 ? [7*mm, 22*mm, 7*mm]:
  model == 688 ? [8*mm, 16*mm, 4*mm]:
  model == 698 ? [8*mm, 19*mm, 6*mm]:
  model == "lm8uu" ? [8*mm, 15*mm, 24*mm]:
  [8*mm, 22*mm, 7*mm]; // this is the default

function bearingWidth        (model) = bearingDimensions(model)[BEARING_WIDTH];
function bearingInnerDiameter(model) = bearingDimensions(model)[BEARING_INNER_DIAMETER];
function bearingOuterDiameter(model) = bearingDimensions(model)[BEARING_OUTER_DIAMETER];

module bearing(pos=[0,0,0], angle=[0,0,0], model=SkateBearing, outline=false,
               material=Steel, sideMaterial=Brass, center=false) {
	
  w = bearingWidth(model);
  innerD = outline==false ? bearingInnerDiameter(model) : 0;
  outerD = bearingOuterDiameter(model);

  innerRim = innerD + (outerD - innerD) * 0.2;
  outerRim = outerD - (outerD - innerD) * 0.2;
  midSink = min(w, innerD) * 0.1;

  translate(pos) rotate(angle) translate(center ? [0,0,-w/2] : [0,0,0]) union() {
    difference() {
      // Basic ring
      Ring([0,0,0], outerD, innerD, w, material, material);

      if (outline==false) {
        // Side shields
        Ring([0,0,-epsilon], outerRim, innerRim, epsilon+midSink, sideMaterial, material);
        Ring([0,0,w-midSink], outerRim, innerRim, epsilon+midSink, sideMaterial, material);
      }
    }
  }

  module Ring(pos, od, id, h, material, holeMaterial) {
    color(material) {
      translate(pos)
        difference() {
          cylinder(r=od/2, h=h,  $fs = 0.01);
          color(holeMaterial)
            translate([0,0,-10*epsilon])
              cylinder(r=id/2, h=h+20*epsilon,  $fs = 0.01);
        }
    }
  }

}
