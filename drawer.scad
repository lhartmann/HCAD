// Creates a sliding drawer.
// Volume below z=0 slides towards x=-inf
// Requires 2 children nodes:
// 1 - Positive solid of joined parts.
// 2 - Negative solid, volume of the hollow space inside cildren(1).
module drawer_bottom(depth, wall, big=100, small=0.001) {
	difference() {
		drawer_aux_bottom(depth, big, small) { children(0); children(1); }
		drawer_top(depth, wall, big, small) { children(0); children(1); }
	}
}
module drawer_top(depth, wall, big=100, small=0.001) {
	difference() {
		drawer_aux_top(depth, big, small) { children(0); children(1); }
		minkowski() {
			minkowski() {
				drawer_aux_slice(big,small) children(1);
				drawer_aux_slider(depth, wall);
			}
			translate([-big/2,0,0]) cube([big,small,small], center=true);
		}
	}
}
module drawer_aux_slice(big,small) {
	intersection() {
		children();
		cube([big,big,small], center = true);
	}
}
module drawer_aux_top(depth,big,small) {
	intersection() {
		difference() {
			children(0);
			children(1);
		}
		translate([0,0,big/2-depth/2]) cube([big,big,big], center = true);
	}
}
module drawer_aux_bottom(depth,big,small) {
	intersection() {
		difference() {
			children(0);
			children(1);
		}
		translate([0,0,-big/2+depth/2]) cube([big,big,big], center = true);
	}
}
module drawer_aux_slider(depth, wall) {
	cylinder(r1=wall/3, r2=wall*2/3, h=depth, center=true);
}


// Testig code
/*
module core_solid() {
	cube([50,30,5], center=true);
}

module hollow_volume() {
	minkowski() {
		core_solid();
		cube([1,1,1], center = true); // Enclosed object + clearance
	}
}

module shell_volume() {
	minkowski() {
		core_solid();
		sphere(r=2.5, $fn=32);
	}
}

drawer_bottom(1,2) {
	shell_volume();
	hollow_volume();
}
*/
