module deminkowski() {
    difference() { // Stage 4
        children(0);
        render() minkowski() { // Stage 3
            difference() { // Stage 2
                render() minkowski() { // Stage 1
                    children(0);
                    cube(center=true);
                }
                children(0);
            }
            children(1);
        }
    }
}

