include <../m4.scad>

function is_near(a, b=m4identity(), err=1e-10) = 
    max([max((a-b)[0]), max((a-b)[1]), max((a-b)[2]), max((a-b)[3])]) < +err &&
    min([min((a-b)[0]), min((a-b)[1]), min((a-b)[2]), min((a-b)[3])]) > -err;

function randnum() = rands(-100,+100,1)[0];
function random_matrix_row(seed) =
    [ randnum(seed+0), randnum(seed+1), randnum(seed+2), randnum(seed+3) ];
function random_matrix(seed) = [ 
    random_matrix_row(seed*16 +  0),
    random_matrix_row(seed*16 +  4),
    random_matrix_row(seed*16 +  8),
    random_matrix_row(seed*16 + 12)
];

// m4inv test
for (i=[0:100]) {
    M = random_matrix(i);
    echo(is_near(M*m4inv(M)));
}
