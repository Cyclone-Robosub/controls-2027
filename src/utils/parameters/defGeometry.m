function Geometry = defGeometry()
%{
This function defines the geometry structure containing all measurements of
Manny. Measurements are taken from the Onshape CAD or the robot.

Linear dimensions are denoted l_<object>_<axis>, for example l_plate_x is
the length of the plate in the x-direction. Axis directions are defined in
the Onshape coordinate system. Radial dimensions are given as l_<object>.
All measurements are expressed in inches, then converted to meters.

The position of an object is expressed as the position vector from the
Onshape origin to the geometric center of the shape.

For simplicity, all objects are modeled as point masses, right circular
cylinders, or right rectangular prisms. 
%}
in2m = 0.0254;

%main cylinder (right circular cylinder)
Geometry.l_cyl_x = 19.295*in2m;
Geometry.r_cyl = 3.25*in2m;
Geometry.Ro_cyl = [0;0;4.375]*in2m;

%base plate (right rectangular prism)
A_plate = 282.296*in2m;
l_plate_x_max = 24.8*in2m;
l_plate_y_max = 20.8*in2m;
%model as a rectangular plate with the same aspect ratio as the max dim
Geometry.l_plate_x = A_plate/l_plate_y_max;
Geometry.l_plate_y = A_plate/l_plate_x_max;
Geometry.l_plate_z = 0.250*in2m;
Geometry.Ro_plate = [0;0;0.125]*in2m;

%thrusters 1-8 (right circular cylinder)
Geometry.l_t_z = 4.6*in2m;
Geometry.r_t = 1.6*in2m;
Geometry.Ro_t1 = [9.95 -8 -1.675]'*in2m;
Geometry.Ro_t2 = [9.95 8 -1.675]'*in2m;
Geometry.Ro_t3 = [-9.95 -8 -1.675]'*in2m;
Geometry.Ro_t4 = [-9.95 8 -1.675]'*in2m;
Geometry.Ro_t5 = [7.03 -4.95 1.93]'*in2m;
Geometry.Ro_t6 = [7.03 4.95 1.93]'*in2m;
Geometry.Ro_t7 = [-8.3 -3.7 1.93]'*in2m;
Geometry.Ro_t8 = [-8.3 3.7 1.93]'*in2m;

%dvl (right circular cylinder)
Geometry.l_dvl_z = 0.984*in2m;
Geometry.r_dvl = 1.299*in2m;
Geometry.Ro_dvl = [4.505; 0; 2.242]*in2m;

%floats, aka pool noodles (right circular cylinders)
Geometry.r_float = 3*in2m;
Geometry.l_x_float = 11.5*in2m;
Geometry.Ro_float1 = [0 -8.012 0.125]'*in2m;
Geometry.Ro_float2 = [0 8.012 0.125]'*in2m;


%{
Not currently modeled:
- flashlight
- DFC enclosure
- FFC enclosures
- Kill switch
%}

