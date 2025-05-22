motor_diameter = 12;
motor_width    = 10;
motor_length   = 15.2;
motor_nub_length   = 1.16;
motor_nub_diameter = 4.97;

gearbox_length = 9.17;
gearbox_nub_diameter = 4.0;
gearbox_nub_length   = 0.50;

axle_diameter = 3.00;
axle_length   = 9.87;
axle_flat     = 2.40;

contact_width  = 1.50;
contact_length = 1.70;
contact_thickness = 0.30;
contact_hole      = 0.90;
contact_separation = 7.50;

screw_separation = 9.00;
screw_diameter   = 1.50;

// Origin = center of axle, face of gearbox.
// Axle = Z+
// Motor flat = Y+-
MicroMotorGearboxN20($fn=64);
module MicroMotorGearboxN20() {
	// Axle and flat face
	intersection() {
		cylinder(d=axle_diameter, h=axle_length);
		translate([axle_diameter-axle_flat/2, 0, 0])
			cube([2*axle_diameter, 2*axle_diameter, axle_length*3], center=true);
	}
	
	// Gearbox Nub\
	cylinder(d=gearbox_nub_diameter, h=gearbox_nub_length);
	
	// Gearbox
	translate([0, 0, -gearbox_length/2]) cube([motor_diameter, motor_width, gearbox_length], center=true);
	
	// Motor body
	translate([0, 0, -gearbox_length -motor_length/2]) intersection() {
		cube([motor_diameter, motor_width, motor_length], center=true);
		cylinder(d=motor_diameter, h=motor_length, center=true);
	}
	
	// Motor back nub
	translate([0, 0, -gearbox_length -motor_length - motor_nub_length/2]) 
		cylinder(d=motor_nub_diameter, h=motor_nub_length, center=true);
	
	// Contacts
	translate([+contact_separation/2, 0, -gearbox_length -motor_length]) _contact();
	translate([-contact_separation/2, 0, -gearbox_length -motor_length]) _contact();

	module _contact() {
		rotate([0,90,0]) {
			difference() {
				translate([0, -contact_width/2, -contact_thickness/2])
					cube([contact_length, contact_width, contact_thickness]);
				translate([contact_length/2,0,0])
					cylinder(d=contact_hole, h=contact_thickness*2, center = true);
			}
		}
	}
}


