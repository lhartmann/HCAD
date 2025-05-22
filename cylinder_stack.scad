// Spec is [ [height, radius, radius?]* ]
module cylinder_stack(spec=[], center=false) {
    tr(0) step(0);

    module tr(i) {
        if (i < len(spec))
            translate(center ? [0,0,-spec[i][0]/2] : [0,0,0]) tr(i+1) children();
        else
            children();
    }

    module step(i) {
        if (i < len(spec)) {
            h  = spec[i][0];
            r1 = spec[i][1];
            r2 = len(spec[i])>2 ? spec[i][2] : r1;

            cylinder(h=h, r1=r1, r2=r2);

            translate([0,0,h]) step(i+1);
        }
    }
}


module cylinder_s(h, r1, r2, r, d, d1, d2) {
    _r1 =
        r1 != undef ? r1   :
        d1 != undef ? d1/2 :
        r  != undef ? r    : 1 ;

    _r2 =
        r2 != undef ? r2   :
        d2 != undef ? d2/2 : _r1;

    cylinder(h, _r1, _r2);

    translate([0,0,h]) children();
}
