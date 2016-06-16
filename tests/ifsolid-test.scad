include <../ifsolid.scad>

// Visual aid,same condition as the intersection test
translate([0,2,0]) {
    cube();
    translate([3*sin(360*$t),0,0]) cube();
}

ifsolid() {
    // Condition solid. VOID = false, anything else = true.
    intersection() {
        cube();
        translate([3*sin(360*$t),0,0]) cube();
    }
    
    // Returned solid if conditon is true
    cube(center=true);
    
    // Returned solid if condition is false
    sphere();
}
