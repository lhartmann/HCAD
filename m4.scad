function m4identity() = [
	[1, 0, 0, 0 ],
	[0, 1, 0, 0 ],
	[0, 0, 1, 0 ],
	[0, 0, 0, 1 ]
];

// Translation
function m4tr(d) = [
	[1, 0, 0, d[0] ],
	[0, 1, 0, d[1] ],
	[0, 0, 1, d[2] ],
	[0, 0, 0,  1   ]
];

// Rotation around X axis
function m4rx(a) = [
	[1, 0,       0,       0 ],
	[0, +cos(a), -sin(a), 0 ],
	[0, +sin(a), +cos(a), 0 ],
	[0, 0,       0,       1 ]
];

// Rotation around Y axis
function m4ry(a) = [
	[+cos(a), 0, +sin(a), 0 ],
	[0,       1, 0,       0 ],
	[-sin(a), 0, +cos(a), 0 ],
	[0,       0, 0,       1 ]
];

// Rotation around Z axis
function m4rz(a) = [
	[+cos(a), -sin(a), 0, 0 ],
	[+sin(a), +cos(a), 0, 0 ],
	[0,       0,       1, 0 ],
	[0,       0,       0, 1 ]
];

// Scale:
//   m4scale(2)              scales all dimensions equally
//   m4scale([sx, sy, sz])   scale each axis independently
//   m4scale([-1,  0,  0])   mirror over X axis / YZ plane
function m4scale(s) = 
	len(s) == undef ? [ 
		[s,    0,    0,    0],
		[0,    s,    0,    0],
		[0,    0,    s,    0],
		[0,    0,    0,    1]
	] : [
		[s[0], 0,    0,    0],
		[0,    s[1], 0,    0],
		[0,    0,    s[2], 0],
		[0,    0,    0,    1]
	];

// Extract only the rotation/scaling/mirroring submatrix
function m4rotm(m) = [
	[mx[0][0], mx[0][1], mx[0][2], 0],
	[mx[1][0], mx[1][1], mx[1][2], 0],
	[mx[2][0], mx[2][1], mx[2][2], 0],
	[       0,        0,        0, 1],
];

// Extract just the translation vector
function m4trv(m) = [m[0][3], m[1][3], m[2][3]];

// Aply transformation matrix to a single point
function m4_transform_point(m,p) = m4trv(m*m4tr(p));

// Matrix inversion, this code is a mess

// Expand matrix to 4x8 with identity: Row-reduced echelon format
function m4inv_mx(m) = [
	[m[0][0], m[0][1], m[0][2], m[0][3], 1, 0, 0, 0],
	[m[1][0], m[1][1], m[1][2], m[1][3], 0, 1, 0, 0],
	[m[2][0], m[2][1], m[2][2], m[2][3], 0, 0, 1, 0],
	[m[3][0], m[3][1], m[3][2], m[3][3], 0, 0, 0, 1]
];

// Swap rows to move zeros away from diagonal
function m4inv_rowswap(i,j,mx) = [
	i==0 ? mx[j] : j==0 ? mx[i] : mx[0],
	i==1 ? mx[j] : j==1 ? mx[i] : mx[1],
	i==2 ? mx[j] : j==2 ? mx[i] : mx[2],
	i==3 ? mx[j] : j==3 ? mx[i] : mx[3]
];

// Solve one step, direct solution, assume nonzero at diagonal
function m4inv_solve2(i,mx) = [
	(i==0) ? mx[i]/mx[i][i] : mx[0]-mx[i]*mx[0][i]/mx[i][i],
	(i==1) ? mx[i]/mx[i][i] : mx[1]-mx[i]*mx[1][i]/mx[i][i],
	(i==2) ? mx[i]/mx[i][i] : mx[2]-mx[i]*mx[2][i]/mx[i][i],
	(i==3) ? mx[i]/mx[i][i] : mx[3]-mx[i]*mx[3][i]/mx[i][i]
];

// Solve one step, ensure nonzero at diagonal element.
function m4inv_zero(x) = abs(x) < 1e-5;
function m4inv_solve(i,mx) = 
	         !m4inv_zero(mx[i  ][i]) ? m4inv_solve2(i,                     mx ) :
	i+1<4 && !m4inv_zero(mx[i+1][i]) ? m4inv_solve2(i, m4inv_rowswap(i,i+1,mx)) :
	i+2<4 && !m4inv_zero(mx[i+2][i]) ? m4inv_solve2(i, m4inv_rowswap(i,i+2,mx)) :
	i+3<4 && !m4inv_zero(mx[i+3][i]) ? m4inv_solve2(i, m4inv_rowswap(i,i+3,mx)) :
	m4identity(); // Singular matrix, reset to identity

// Get result from row-reduced echelon format
function m4inv_m(mx) = [
	[mx[0][4], mx[0][5], mx[0][6], mx[0][7]],
	[mx[1][4], mx[1][5], mx[1][6], mx[1][7]],
	[mx[2][4], mx[2][5], mx[2][6], mx[2][7]],
	[mx[3][4], mx[3][5], mx[3][6], mx[3][7]]
];

// Full matrix inversion using functions on top
function m4inv(m) = m4inv_m(m4inv_solve(3,m4inv_solve(2,m4inv_solve(1,m4inv_solve(0,m4inv_mx(m))))));
