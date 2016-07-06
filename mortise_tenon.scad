/* mortise_tenon.scad: Creates mortise and tenon joints on arbitrarypoints of a model.
 *
 * Originally by Lucas V. Hartmann <lhartmann@github.com>, 2016.
 * Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later
 */

include <m4.scad>

//mortise_tenon_demo();
module mortise_tenon_demo() {
    BIG=1000;
    t = $t;

//    intersection() {
    difference() {
        mortise_tenon(5, 2, 0.5, m4tr([12.5,0,12.5])*m4ry(t*360)) 
            rotate([t, 2*t, 3*t]*360) {
                sphere(r=25);
                cylinder(r=25, h=50);
                rotate([0,90,0]) 
                    cylinder(r=25, h=50);
            }
        
        // Slice the object so you can see the mortise-tennon joint.
        cube([100,100,100]);
//        rotate([-90,0,0])
//            cylinder(r=1000, h=1000);
    }
}

module mortise_tenon(l=0, wall=1, clear=0, at=m4identity(), BIG=1000) {
	// Position the model, cut, return to original position.
    multmatrix(at) __mortise_tenon() multmatrix(m4inv(at)) children();

	// True functionality
	//  Cut plane at Z=0
	//  Tenon points to Z+
    module __mortise_tenon() {
        difference() {
            children();
            difference() {
                union() {
//                    cylinder(r=BIG, h=clear, center = true);
                    linear_extrude(height=clear, center=true) 
                        large_profile(clear) children();
                    linear_extrude(height=l+clear)
                        small_profile(wall-clear/2)
                        children();
                }
                linear_extrude(height=2*l, center=true)
                    small_profile(wall+clear/2)
                    children();
            }
        }
    }
    
    // Creates the cut profile, where the model separates.
    // r = how much to grow from the model.
    module large_profile(r=0) {
        minkowski() {
            projection(cut=true) children();
            circle(r=r);
        }
    }
    
    // Creates a reduced version of the baseprofile.
    // r = how much to shrink.
    module small_profile(r=0) {
        difference() {
            base_profile() children();
            minkowski() {
                difference() {
                    minkowski() {
                        base_profile() children();
                        circle();
                    }
                    base_profile() children();
                }
                circle(r=r);
            }
        }
    }
    
    // Finds out where in the model it is safe to create a joint.
    // This requires the model to be solid for Z in [-wall, l+wall]
    module base_profile() {
        difference() {
            projection(cut=false) children();
            projection(cut=false) difference() {
                translate([0,0,-wall]) cylinder(d=BIG, h=l+2*wall);
                children();
            }
        }
    }
}
