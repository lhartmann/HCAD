module minkowskibox(flattop, square, wall, clear, clear_tight, flatbottom=true, small=0.01, big=100) {
	module bar(ax, start, end) {
		rotate(
			ax == 0 ? [  0, 90, 0] : // Along X
			ax == 1 ? [-90,  0, 0] : // Along Y
			          [  0,  0, 0]   // Along Z
		) translate([0,0,start]) cylinder(r=small, h=end-start);
	}
	
	// Creates a bounding box with the XY profile of the object
	module bounds_shaped() {
		intersection() {
			minkowski() {
				minkowski() {
					children();
					sphere(r=wall+clear);
				}
				bar(2, flatbottom ? -big : 0, flattop ? big : 0);
			}
			minkowski() {
				children();
				cylinder(r=big, h=2*(wall+clear), center=true);
			}
		}
	}
	
	// Creates a bounding "cube" for the object
	module bounds_square() {
		intersection() {
			minkowski() {
				bounds_shaped() children();
				bar(0, -big, +big);
			}
			minkowski() {
				bounds_shaped() children();
				bar(1, -big, +big);
			}
		}
	}
	
	// Call appropriate bounding box
	module bounds() {
		if (square) bounds_square() children();
		else bounds_shaped() children();
	}
	
	// Create the standoffs for the object
	module stands() {
		intersection() {
			bounds_shaped() children();
			difference() {
				minkowski() {
					children();
					bar(2,-big,+big);
				}
				minkowski() {
					children();
					sphere(r=clear);
				}
			}
		}
	}
	
	// Hollow space for the object, assuming it must slide towards Z=0
	module object_hollow() {
		// Top segment projected down
		// Enables cover to be removed without pulling the object
		intersection() {
			minkowski() {
				children();
				sphere(r=clear);
				bar(2,-big,0);
			}
			cylinder(r=big,h=big);
		}
		
		// Bottom segment projected up
		// Enables object to be removed without pulling up the box base
		intersection() {
			minkowski() {
				children();
				sphere(r=clear);
				bar(2,0,+big);
			}
			mirror([0,0,1]) cylinder(r=big,h=big);
		}
	}
	
	module stuffWhoseNameIDoNotKnow() {
		module sub() {
			intersection() {
				bounds() children();
				mirror([0,0,1]) cylinder(r=big, h=wall);
			}
		}
		
		difference() {
			sub() children();
			
			// Outter rim
			translate([0,0,clear_tight]) minkowski() {
				difference() {
					minkowski() {
						sub() children();
						cylinder(r=wall, h=small);
					}
					bounds() children();
				}
				cylinder(r=(wall-clear_tight)/2, h=small);
			}
			
			// Inner rim
			translate([0,0,-clear_tight]) difference() {
				sub() children();
				minkowski() {
					difference() {
						minkowski() {
							sub() children();
							cylinder(r=wall, h=small);
						}
						bounds() children();
					}
					cylinder(r=(wall+clear_tight)/2, h=small);
				}
			}
		}
	}
	
	difference() {
		bounds() children();
		
		object_hollow() children();
		
//		cylinder(r=big, h=clear_tight, center=true);
		stuffWhoseNameIDoNotKnow() children();
	}
	stands() children();
}

module minkowskibox_testcut(flattop, square, wall, clear, clear_tight, flatbottom=true, small=0.01, big=100) {
	intersection() {
		minkowskibox(
			flattop = flattop,
			flatbottom = flatbottom,
			square = square,
			wall = wall,
			clear = clear,
			clear_tight = clear_tight
		) children();
		
		translate([0,big/2,0]) cube([big,big,big], center=true);
	}
	
	color([0.5,0.5,0.5,0.5]) children();
}

minkowskibox_test = false;
if (minkowskibox_test) {
	minkowskibox_testcut(
		flattop = false,
		flatbottom = true,
		square = false,
		wall = 3,
		clear = 1,
		clear_tight = 0.25,
		$fn=8//32
	) sphere(r=20, $fn=32);
}
