function Volume = calcVolumeData(Geometry)
%{
Calculates the total volume and the position of the center of volume. Also
defines the position and size a fictitious volume that can be tuned 
manually to cause the buoyant moment and force in sim to match experimental
data.

Inputs:
Geometry structure created by defGeometry.m

Outputs: 
Volume structure containing fields
    V_total - total volume
    Ro_cv - calculated center of volume position in the Onshape coordinate
    frame


%}
in2m = Geometry.in2m;

%Fictitious volume for tuning to make buoyancy match observations
%Fg = 147.74 N
l_fict = -0.2265; %negative because calcs make robot much too buoyant
w_fict = l_fict;
h_fict = l_fict;
Ro_fict = [-0.005 0 0.0432]'*in2m;

%calculate all the volumes
V_cyl = pi*Geometry.r_cyl^2*Geometry.l_cyl_x; %main cylinder
V_t = pi*Geometry.r_t^2*Geometry.l_t_z; %thrusters
V_plate = Geometry.l_plate_x*Geometry.l_plate_y*Geometry.l_plate_z; %plate
V_dvl = pi*Geometry.r_dvl^2*Geometry.l_dvl_z; %dvl
V_r_float = pi*Geometry.r_float^2*Geometry.l_x_float; %right float
V_l_float = V_r_float; %left float
V_fict = l_fict*w_fict*h_fict; %tuning volume

V = [V_cyl V_t V_t V_t V_t V_t V_t V_t V_t V_plate...
    V_dvl V_r_float V_l_float V_fict];

%pack of positions
R_o2obj = [Geometry.Ro_cyl Geometry.Ro_t1 Geometry.Ro_t2 Geometry.Ro_t3...
    Geometry.Ro_t4 Geometry.Ro_t5 Geometry.Ro_t6 Geometry.Ro_t7...
    Geometry.Ro_t8 Geometry.Ro_plate Geometry.Ro_dvl Geometry.Ro_float1...
    Geometry.Ro_float2 Ro_fict];

%loop through the objects and calculate the centroid
R_o2cv = zeros(3,1);
for k = 1:length(V)
    R_o2cv = R_o2cv + V(k)*R_o2obj(:,k);
end

Volume.V_total = sum(V);
Volume.R_o2cv = R_o2cv/Volume.V_total;



end