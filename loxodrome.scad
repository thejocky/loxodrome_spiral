
/* Shape definitions:
 * [angle_generator, point_generator, object_height]
 * 
 * - angle_generator ----------------------------
 * h - height from bottom
 * a - angle around vertical axis (unused)
 * returns angle perpendicular to vertical plane at angle a
 *
 * - point_generator ----------------------------
 * h - height from bottom
 * a - angle around vertical axis (unused)
 * returns coord at angle a and height h


// Define sphere shape

// Get angle perpendicular to vertical axis
// rad - radius of defined sphere
// h - height from bottom
// a - angle around vertical axis (unused)
sphere_angle_gen = function (rad) function (h, a) =
    asin((h-rad)/rad);

// Get coord on sphere 
// rad - radius of defined sphere
// h - height from bottom
// a - angle around vertical axis (unused)
sphere_point_gen = function (rad) function (h, a) =
    [cos(a) * sqrt(rad^2 - ((h-1)*rad)^2), sin(a) * sqrt(rad^2 - (h-rad)^2), h]

function sphere_gen(rad) = 
    [sphere_angle_gen(rad), sphere_point_gen, rad*2];

module loxodrome(shape_gen, spiralAngle, spiralCount) {
    dH = 1/$fn;

    function generate_path(height, angle=0, returnList=[], depthLeft=$fn) = 
        (depthLeft=0)
        let (height = h + dH)
        concat(returnList, )

    path = 
    points = [for (i = )]
}
    
sphere = sphere_gen(5);
loxodrome(sphere, 45, 5);