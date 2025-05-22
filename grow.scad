module grow(r, BIG=-1) {
	if (r>0) minkowski() {
		children();
		sphere(r=r);
	} else if (r<0) {
        difference() {
            children();
            grow(-r) difference() {
                grow(1) hull() children();
                children();
            }
        }
	} else children();
}

module grow2d(r, BIG=-1) {
	if (r>0) minkowski() {
		children();
		circle(r=r);
	} else if (r<0) {
        difference() {
            children();
            grow2d(-r) difference() {
                grow2d(1) hull() children();
                children();
            }
        }
	} else children();
}
