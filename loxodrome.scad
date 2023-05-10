
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
sphere_angle_gen = function (rad) function (h, a)
    asin((h-rad)/rad);

// Get coord on sphere 
// rad - radius of defined sphere
// h - height from bottom
// a - angle around vertical axis (unused)
sphere_point_gen = function (rad) function (h, a)
    [cos(a) * sqrt(rad^2 - ((h-1)*rad)^2), sin(a) * sqrt(rad^2 - ((h-1)*rad)^2)];

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
    
shere = sphere_gen(20);
// loxodrome(sphere, 45, 5);
h=10;
linear_extrude(1)
polygon([for (i=[0:10]) (shere[1](h, i))]);