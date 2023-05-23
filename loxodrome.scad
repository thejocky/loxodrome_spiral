
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
// sphere_point_gen = function (rad) function (u, v)
//     [cos(v-0.5) * sqrt(rad^2 - ((u-1)*rad)^2), sin(v-0.5) * sqrt(rad^2 - ((u-1)*rad)^2), u*(2*rad)];

function map(u, range) = u*(range[1]-range[0]) + range[0];

sphere_point_gen = function (rad) function (u, v)
    let(theta = map(v, [0, 360]),
        phi = map(u, [-90, 90]))
    [cos(theta) * cos(phi), sin(theta) * cos(phi), sin(phi)] * rad;

cylinder_gen = function (rad, height) function (u, v)
    let (theta = map(v, [0, 360]))
    [cos(theta)*rad, sin(theta)*rad, u*height];

torus_gen = function (outerRad, rad) function (u, v)
    let(phi = map(v, [0, 360]),
	    theta = map(u, [0, 360]),
        pX = (cos(phi)*rad + outerRad) * cos(theta),
        pY = (cos(phi)*rad + outerRad) * sin(theta),
        pZ = sin(phi)*rad)
		[pX, pY, pZ];

rectangle_gen = function (outerRad, rad) function (u, v)
    let(x = map(v, [0, 50]),
	    y = map(u, [0, 50]),
        pX = x,
        pY = y,
        pZ = 0)
		[pX, pY, pZ];

// function sphere_gen(rad) = 
//     [sphere_angle_gen(rad), sphere_point_gen(rad), rad*2];

// function elypse_gen_2D(a, b) = function(u);
//     [cos(u*360)*b, sin(u*360)*a, 0];

// function rotate_2D(point, degrees) =
//     let(a0 = atan2(point.y, point.x), r=sqrt(point.x^2 + point.y^2))
//     [cos(a0+degrees), sin(a0+degrees)] * r;

// function rotate_3D(point, degrees) = 
//     let(ax0 = )

function translate(offset) = function (point)
    point + offset;

function rotateX(degree) = function(point)
    let(a0 = atan2(point.z, point.y), r=sqrt(point.y^2 + point.z^2))
    [point.x, cos(a0+degree)*r, sin(a0+degree)*r];

function rotateY(degree) = function(point)
    let(a0 = atan2(point.x, point.z), r=sqrt(point.x^2 + point.z^2))
    [sin(a0+degree)*r, point.y, cos(a0+degree)*r];

function rotateZ(degree) = function(point)
    let(a0 = atan2(point.y, point.x), r=sqrt(point.x^2 + point.y^2))
    [cos(a0+degree)*r, sin(a0+degree)*r, point.z];

function magnitude_vec3(vec3) =
    sqrt(vec3.x^2 + vec3.y^2, vec3.z^2);

// function shapedTorus_point_gen(rad, crossSection) = function(u, v)
//     translate([cos(v*360), sin(v*360), 0]) (
//         series_rotate([rotateX(90), rotateZ(v*360)]) (
//             crossSection(u)
//         )
//     )

function real_du(u, v, shape_gen, du=0.001) =
    // echo (shape_gen(u, v), shape_gen(u+du, v))
    (u > 0.5)?
        (shape_gen(u, v) - shape_gen(u-du, v))/du
    :   (shape_gen(u+du, v) - shape_gen(u, v))/du;
function real_dv(u, v, shape_gen, dv=0.001) =
    (v > 0.5)?
        (shape_gen(u, v) - shape_gen(u, v-dv))/dv:
        (shape_gen(u, v+dv) - shape_gen(u, v))/dv;







module tubify(shape_gen, points, rad, loop=false, cV=$V_COUNT) {

    function gen_circle(pos, theta, phi) =
        [for (i=[0:cV])
        translate(pos) (
            rotateZ(theta) (rotateY(phi) (
                rotateX(i*360/cV) ([0, rad, 0])
            ))
        )
        ];

    outPoints = [for(i=[0:len(points)-2])
        // echo(points[i].x, points[i].y)
        let(pos = shape_gen(points[i].x, points[i].y),
            next = shape_gen(points[i+1].x, points[i+1].y),
            theta = atan2(next.y-pos.y, next.x-pos.x),
            phi = atan2(next.z-pos.z, -norm([next.x-pos.x, next.y-pos.y])))
        // echo(pos, next, theta, phi, norm([next.x-pos.x, next.y-pos.y]))
        // echo(phi, theta, next.y-pos.y, next.x-pos.x)
        gen_circle(pos, theta, phi),
        
        // loop?
        //     let(pos = shape_gen(points[0].x, points[0].y),
        //         next = shape_gen(points[1].x, points[1].y),
        //         theta = atan2(next.y-pos.y, next.x-pos.x),
        //         phi = atan2(next.z-pos.z, -norm([next.x-pos.x, next.y-pos.y])))
        //     gen_circle(next, theta, phi)
        // :
            let(pos = shape_gen(points[len(points)-2].x, points[len(points)-2].y),
                next = shape_gen(points[len(points)-1].x, points[len(points)-1].y),
                theta = atan2(next.y-pos.y, next.x-pos.x),
                phi = atan2(next.z-pos.z, -norm([next.x-pos.x, next.y-pos.y])))
            gen_circle(next, theta, phi)
            

    ];
    // echo(outPoints);
    formFromList(outPoints, loopU=loop);
}



module loxodrome(shape_gen, spiralAngle, rad, cU = $U_COUNT, cV = $V_COUNT, uRange=[0,1], vInit = 0, loop=false) {

    function gen_circle(u, v, shape_gen, rad) =
        let(pos = shape_gen(u, v))
        [for (i=[0:cV])
        rotateZ(atan2(pos.y, pos.x))(
            translate([norm([pos.x, pos.y]),0, pos.z]) (
                rotateY(i*360/cV) ([rad, 0, 0])
            )
        )
        ];

    function angle_vec3(vecA, vecB) = 
        atan2(norm(cross(vecA,vecB)), vecA * vecB);

    function gen_path(shape_gen, theta, dt, u=uRange[0], v=vInit) =
        (u > uRange[1])? []:
        let(du = real_du(u, v, shape_gen), dv = real_dv(u, v, shape_gen),
            phi = angle_vec3(du, dv),
            tmpU = sin(phi) * norm(du),
            uChange = (!tmpU)? dt * sin(theta) / 100 : dt * sin(theta) / tmpU,
            tmpV = sin(180-phi) * norm(dv),
            vChange = (!tmpU)? dt * sin(phi-theta) / 100 : dt * sin(phi-theta) / tmpV)
        // echo(u, v, phi, du, dv, uChange, vChange)
        concat([[u,v]], gen_path(shape_gen, theta, dt, u+uChange, v+vChange));



    
    // polyhedron(gen_circle(0, 0.5, shape_gen, rad), );
    path = gen_path(shape_gen, spiralAngle, 2);

    tubify(shape_gen, path, rad, loop=loop);
    // echo (path);

    // Generate points
    // points = [for (i=path) gen_circle(i.x, i.y, shape_gen, rad)];
    // points = [for (i=[[0,0], [.2,.2], [0.5,0.5], [.8,.8], [1,1]]) gen_circle(i.x, i.y, shape_gen, rad)];
    // echo(points);
    // for (i=[0:360/10: 359]) {
        // rotate([0,0,i])
        // formFromList(points);
    // }

    // function generate_path(height, angle=0, returnList=[], depthLeft=$fn) = 
    //     // (depthLeft=0)?
    //     let (height = h + dH)
    //     concat(returnList, )

    // path = 
    // points = [for (i = )]
}


// form(sphere_point_gen(20));

module latitude(shape_gen, u, rad, cV = $V_COUNT) {
    shape_points = [for (i=[0:cV]) [u, i/cV]];
    tubify(shape_gen, shape_points, rad);
}

module longitude(shape_gen, v, rad, range=[0,1], cU = $U_COUNT) {
    shape_points = [for (i=[0:cU]) [i/cU * (range[1]-range[0]) + range[0], v]];
    tubify(shape_gen, shape_points, rad);
    // echo(shape_points);
}
    

module form(shape_gen, cap=true, loopU=false, cU = $U_COUNT, cV = $V_COUNT) {
    dU = 1/cU;
    dV = 1/(cV);
    points = [for (u=[0:cU]) for (v=[0:cV])
        shape_gen(u*dU, v*dV)
    ];
    
    faces =
    loopU? [
        for (u=[0:cU-1]) for (v=[0:cV-1]) [(u+1)*(cV+1)+v, u*(cV+1)+v, (u+1)*(cV+1)+(v+1)],
        for (u=[0:cU-1]) for (v=[0:cV-1]) [(u+1)*(cV+1)+(v+1), u*(cV+1)+v, u*(cV+1)+(v+1)],
        for (v=[0:cV-1]) [v + cU*(cV+1), v + 1, v],
        for (v=[0:cV-1]) [v + cU*(cV+1), v + 1 + cU*(cV+1), v + 1]
    ] : cap? [
        for (v=[1:cV-1]) [0,v,v+1],
        for (u=[0:cU-1]) for (v=[0:cV-1]) [u*(cV+1)+v, (u+1)*(cV+1)+v, (u+1)*(cV+1)+(v+1)],
        for (u=[0:cU-1]) for (v=[0:cV-1]) [u*(cV+1)+v, (u+1)*(cV+1)+(v+1), u*(cV+1)+(v+1)],
        for (v=[1:cV-1]) [v+1 + cU*(cV+1), v + cU*(cV+1), 0 + cU*(cV+1)]
    ] : [
        for (u=[0:cU-1]) for (v=[0:cV-1]) [u*(cV+1)+v, (u+1)*(cV+1)+v, (u+1)*(cV+1)+(v+1)],
        for (u=[0:cU-1]) for (v=[0:cV-1]) [u*(cV+1)+v, (u+1)*(cV+1)+(v+1), u*(cV+1)+(v+1)],
    ];
    // echo (points);
    // echo (len(points));
    // echo (faces);
    // echo (len(faces));
    polyhedron(points, faces);

}

module formFromList(shapeList, cap = false, loopU=false) {
    vCount = len(shapeList[0]);
    uCount = len(shapeList);
    // echo(vCount);
    // echo(uCount);
    shape_gen = function (u, v)
        // echo(u*(uCount-1), v*(vCount-1), [round(u*(uCount-1)), round(v*(vCount-1))])
        shapeList[round(u*(uCount-1))][round(v*(vCount-1))];
    
    form(shape_gen, cap, loopU, uCount-1, vCount-1);
}

$U_COUNT = 100;
$V_COUNT = 100;
// shape = sphere_point_gen(20);
shape = torus_gen(10, 5);
loxodrome(shape, 46.0983, 0.6, 1, 40, uRange=[0,3], vInit=0, loop=true);
// shape = rectangle_gen(10, 5);
// form();
// for (i=[0:1/1:0.999]) {
    // rotate([0,0,i])
    // loxodrome(shape, 30, 0.6, 1, 40, uRange=[0,2], vInit=0, loop=true);
    // loxodrome(shape, 44.703, 0.6, 1, 40, uRange=[3.95,4.05], vInit=0);
// }
form(shape, cap=false);

// for (i=[1/9:1/9:0.999])
// //     latitude(sphere_point_gen(20), i, 0.5);
// for (i=[0:1/1:0.999])
//     longitude(shape, i+0.25/2, 0.5);

$fn = 50;
// translate([0,0,-5.7])
// difference () {
// cylinder(3,12,12);
// translate([0,0,-0.1])
// cylinder(3.2,8,8);
// }

