
module MicroMotorGearboxN20() {
	mirror([0,0,1])
		cylinder(d=3, h=10);
		
	mirror([0,0,1])
		cylinder(d=4, h=1);
		
	translate([0,0,9/2])
		cube([12, 10, 9], center=true);
		
	translate([0,0,9+16/2]) intersection() {
		cube([12, 10, 16], center=true);
		cylinder(d=12, h=16, center=true);
	}
}
