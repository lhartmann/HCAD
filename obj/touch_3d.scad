use <HCAD/m4.scad>
include <MCAD/units.scad>

// Measurements
touch3d_body_height      = 36.51 * mm;
touch3d_body_width       = 13.00 * mm;
touch3d_body_depth       = 13.84 * mm;
touch3d_flange_height    =  2.25 * mm;
touch3d_flange_width     = 25.76 * mm;
touch3d_flange_depth     = 11.30 * mm;
touch3d_flange_flat_width = 8.00 * mm;
touch3d_neck_diameter    = 11.30 * mm;
touch3d_neck_height      =  7.53 * mm;
touch3d_pin_length_short =  5.85 * mm;
touch3d_pin_length_long  = 10.56 * mm;
touch3d_pin_diameter     =  2.00 * mm;
touch3d_screw_distance   = 17.60 * mm;
touch3d_screw_diameter   =  3.00 * mm;
touch3d_flange_roundover = touch3d_screw_diameter/2 + 2.5 * mm;
touch3d_funnel_height    =  2.69 * mm; 
touch3d_funnel_diameter0 =  4.88 * mm; 
touch3d_funnel_diameter1 = touch3d_body_width;

// Get a M4 matrix for points of interest.
// Only translation is applied.
function touch3d_tm(ref, extended=false) = 
	ref == "top center" ? m4identity() :
	ref == "flange base center" ? m4tr([0, 0, -touch3d_flange_height]) :
	ref == "neck base center"   ? m4tr([0, 0, -touch3d_flange_height-touch3d_neck_height]) :
	ref == "body base center"   ? m4tr([0, 0, -touch3d_body_height]) :
	ref == "tip" && extended    ? m4tr([0, 0, -touch3d_body_height-touch3d_pin_length_long]) :
	ref == "tip"                ? m4tr([0, 0, -touch3d_body_height-touch3d_pin_length_short]) :
	ref == "left screw top"     ? m4tr([-touch3d_screw_distance/2, 0, 0]) :
	ref == "right screw top"    ? m4tr([+touch3d_screw_distance/2, 0, 0]) :
	ref == "left screw base"    ? m4tr([-touch3d_screw_distance/2, 0, -touch3d_flange_height]) :
	ref == "right screw base"   ? m4tr([+touch3d_screw_distance/2, 0, -touch3d_flange_height]) :
	ref == "neck center"        ? m4tr([0, 0, -touch3d_flange_height-touch3d_neck_height/2]) :
	m4identity();

//
module touch3d_at(ref, extended=false) {
	multmatrix(touch3d_tm(ref, extended)) 
		children();
}

touch3d("", false, $fn = 128);
module touch3d(ref="top center", extended=false) {
	multmatrix(m4inv(touch3d_tm(ref, extended))) difference() {
		union() {
			// Flange
			hull() {
				touch3d_at("left screw base", extended)
					cylinder(r=touch3d_flange_roundover, h=touch3d_flange_height);
				touch3d_at("right screw base", extended)
					cylinder(r=touch3d_flange_roundover, h=touch3d_flange_height);
				translate([0,0,-touch3d_flange_height/2])
					cube([touch3d_flange_flat_width, touch3d_flange_depth, touch3d_flange_height], center=true);
			}
			
			// Neck
			touch3d_at("neck base center", extended)
				cylinder(d=touch3d_neck_diameter, h=touch3d_neck_height);
			
			// Body
			touch3d_at("body base center", extended) intersection() {
				bh = touch3d_body_height - touch3d_flange_height - touch3d_neck_height;
				translate([-touch3d_body_width, -touch3d_flange_depth, 0] / 2) 
					cube([touch3d_body_width, touch3d_body_depth, bh]);
				
				k  = ceil(touch3d_body_height / touch3d_funnel_height);
				r1 = touch3d_funnel_diameter0/2;
				r2 = k * (touch3d_funnel_diameter1/2 - r1) + r1;
				h  = k * touch3d_funnel_height;
				cylinder(r1=r1, r2=r2, h);
			}
			
			// Pin
			touch3d_at("tip", extended)
				cylinder(d = touch3d_pin_diameter, h = touch3d_pin_length_long);
		}
		
		// Screw holes
		touch3d_at("left screw base", extended) minkowski() {
			cylinder(d = touch3d_screw_diameter/2, h = touch3d_flange_height);
			cylinder(d = touch3d_screw_diameter/2, h = 0.1, center = true);
		}
		touch3d_at("right screw base", extended) minkowski() {
			cylinder(d = touch3d_screw_diameter/2, h = touch3d_flange_height);
			cylinder(d = touch3d_screw_diameter/2, h = 0.1, center = true);
		}
	}

}
