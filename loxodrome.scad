
/* Shape definitions:
 *
 * - point_generator ----------------------------
 * u, v - Position on plane of shape 
 * returns coord at angle a and height h
 * 
 * - angle_generator ----------------------------
 * u, v - Position on plane of shape
 * returns angle at position on shape
 *
 */ 


// Define sphere shape

// Get angle perpendicular to vertical axis
// rad - radius of defined sphere
// h - height from bottom
// a - angle around vertical axis (unused)
sphere_angle_gen = function (rad) function (u, v)
    asin((h-rad)/rad);

// Get coord on sphere 
// rad - radius of defined sphere
// h - height from bottom
// a - angle around vertical axis (unused)
sphere_point_gen = function (rad) function (u, v)
    [cos(v) * sqrt(rad^2 - ((u-1)*rad)^2), sin(v) * sqrt(rad^2 - ((u-1)*rad)^2), u*(2*rad)];

function sphere_gen(rad) = 
    [sphere_angle_gen(rad), sphere_point_gen(rad), rad*2];

module loxodrome(shape_gen, spiralAngle, spiralCount) {
    dH = 1/$fn;

    // function generate_path(height, angle=0, returnList=[], depthLeft=$fn) = 
    //     // (depthLeft=0)?
    //     let (height = h + dH)
    //     concat(returnList, )

    // path = 
    // points = [for (i = )]
}

module form(shape_gen, cU = $U_COUNT, cV = $V_COUNT) {
    dU = 1/cU;
    dV = 1/cV;
    points = [for (u=[0:cU]) for (v=[0:cV])
        shape_gen(u*dU, v*dV)
    ];

    faces = [for (u=[0:cU-1]) for (v=[0:0])
        [u+v*cV, (u+1)+v*cV, (u+1)+(v+1)*cV, u+(v+1)*cV]
    ];
    echo (points);
    echo (faces);
    polyhedron(points, faces);

}

module formFromList(shapeList) {
    uCount = len(shapeList[0]);
    vCount = len(shapeList);
    shape_gen = function (u, v)
        shapeList[round(v*vCount)][round(u*uCount)];
    
    form(shape_gen, uCount, vCount);
}

$U_COUNT = 5;
$V_COUNT = 5;

include <shape_list.scad>
formFromList(SHAPE_LIST);
shere = sphere_gen(20);
form(shere[1]);
// sphere(5);
// cube(10);