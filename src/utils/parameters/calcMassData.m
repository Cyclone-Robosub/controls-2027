function Mass = calcMassData(Geometry, Hydro)
%Measurements from Mechanical team
Mass.m = 15.06; %kg
m_cyl = 5.5;
m_t = 0.427;
m_dvl = 0.17;
%assume the rest of the uncounted mass is spread evenly across the plate
m_plate = Mass.m - m_cyl - 8*m_t - m_dvl;

%Main cylinder
I_cyl = diag([0.5*m_cyl*Geometry.r_cyl^2,...
    1/12*m_cyl*(3*Geometry.r_cyl^2+Geometry.l_cyl_x^2),...
    1/12*m_cyl*(3*Geometry.r_cyl^2+Geometry.l_cyl_x^2)]);

%DVL cylinder
I_dvl = diag([1/12*m_dvl*(3*Geometry.r_dvl^2+Geometry.l_dvl_z^2), ...
    1/12*m_dvl*(3*Geometry.r_dvl^2+Geometry.l_dvl_z^2),...
    0.5*m_dvl*Geometry.r_dvl^2]);

%Base plate
I_plate = diag([1/12*m_plate*(Geometry.l_plate_y^2+Geometry.l_plate_z^2),...
    1/12*m_plate*(Geometry.l_plate_x^2 + Geometry.l_plate_z^2), ...
    1/12*m_plate*(Geometry.l_plate_x^2+Geometry.l_plate_y^2)]);

%Thrusters (modeled as point mass)
I_t = zeros(3,3); 


%apply the parallel axis theorem to find the mass moment of inertia about
%the onshape origin
J = pat(I_cyl,-Geometry.Ro_cyl,m_cyl) + pat(I_t,-Geometry.Ro_t1,m_t) +...
    pat(I_t,-Geometry.Ro_t2,m_t) + pat(I_t,-Geometry.Ro_t3,m_t) +...
    pat(I_t,-Geometry.Ro_t4,m_t) + pat(I_t,-Geometry.Ro_t5,m_t) +...
    pat(I_t,-Geometry.Ro_t6,m_t) + pat(I_t,-Geometry.Ro_t7,m_t) +...
    pat(I_t,-Geometry.Ro_t8,m_t) + pat(I_dvl,-Geometry.Ro_dvl,m_dvl) +...
    pat(I_plate,-Geometry.Ro_plate,m_plate);

%{
WARNING - This is the moment of inertia about the onshape origin, not the
moment of inertia about the center of mass. We need to identify the vector
from onshape origin to the center of mass then use the parallel axis thm
again.
%}

%origin to center of mass
R_o2cm = (m_cyl*Geometry.Ro_cyl + m_plate*Geometry.Ro_plate +...
    m_dvl*Geometry.Ro_dvl + m_t*(Geometry.Ro_t1 + Geometry.Ro_t2 +...
    Geometry.Ro_t3 + Geometry.Ro_t4 + Geometry.Ro_t5 + Geometry.Ro_t6 +...
    Geometry.Ro_t7 + Geometry.Ro_t8))./Mass.m;
Mass.R_o2cm = R_o2cm;

%calculate the vector from the center of mass to origin 
R_cm2o = -R_o2cm;
Mass.R_cm2o = R_cm2o;

Mass.I = J - Mass.m*((dot(R_cm2o,R_cm2o)*eye(3) - R_cm2o*R_cm2o'));

%mass matrix
Mass.M = diag([Mass.m, Mass.m, Mass.m]);

%add the added mass and inertia from the hydro structure
Mass.M = Mass.M + Hydro.M_added;
Mass.invM = inv(Mass.M);

Mass.I = Mass.I + Hydro.I_added;
Mass.invI = inv(Mass.I);
end