include <../../mortise_tenon.scad>

t = $t;
at = m4tr([0,0,50+40*sin(t*360)]);

$vpt = [-9.51, 25.47, 35.45];
$vpr = [71.1, 0, 46.9];
$vpd = 325.23;

render() intersection() {
    mortise_tenon(l=5, wall=2, clear=0.5, at=at)
        resize([0,0,100], auto=true)
        import("charmander.stl");
    
    cube([30,200,200],center=true);
}
