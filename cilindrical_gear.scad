module cilindrical_gear_profile(d0, n, phase=0, grow=0) {
	difference() {
		union() {
			circle(d=d0);
			teeth(phase, grow);
		}
		teeth(0.5+phase, -grow);
	}
	module teeth(off=0, grow=0) for (i=[0:n]) tooth((i+off)*360/n,  grow);
	module tooth(a, grow) rotate(a) translate([d0/2,0]) circle(d=d0*pi/n/2+2*grow);
}
