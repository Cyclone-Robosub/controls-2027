function Hydro = calcHydroData(Geometry, Constants)

%Reference dimensions of a prism of the same volume as Manny
%TODO - have this pull from Geometry instead
l = 0.4572;
a = l/2;
w = 0.16;
b = w/2;
h = 0.2256;
c = h/2;
V = l*w*h;

Cd = 1.1; %assumed for linear

%projected areas 
Ayz = 4*b*c;
Axz = 4*a*c;
Axy = 4*a*b;

%linear drag portion
D_lin = 0.5*Constants.rho*diag([Cd*Ayz Cd*Axz Cd*Axy]);

Cr = 0.2; %assumed for rotational

%rotational drag reference lengths
Lyz = sqrt(b^2 + c^2);
Lxz = sqrt(a^2 + c^2);
Lxy = sqrt(a^2 + b^2);

D_rot = 0.5*Constants.rho*diag([Cr*Ayz*Lyz^2 Cr*Axz*Lxz^2 Cr*Axy*Lxy^2]);

%fudge factor to better match experimental data
D_rot = D_rot + diag([10,20,20]);
drag_wrench = [[D_lin, zeros(3)];[zeros(3), D_rot]];

%testing linear and quadratic drag wrenches
Hydro.drag_wrench_lin = zeros(6);
Hydro.drag_wrench_quad = drag_wrench;

%{
This script gets a starting guess for Manatee's added rotational inertia
and mass by assuming Manny is a rectangular prism.
%}

% dimensionless added mass coefficients for rectangular prism
Cx = 0.15;
Cy = 0.55;
Cz = 0.55;
alpha = 0.2; 

%dimensions of a prism of the same volume as Manny
l = 0.4572;
w = 0.16;
h = 0.2256;
V = l*w*h;



Hydro.M_added = diag([Constants.rho*V*Cx, Constants.rho*V*Cy, Constants.rho*V*Cz]);
Hydro.I_added = diag([Constants.rho*alpha*(w/2)^2*V, Constants.rho*alpha*(l/2)^2*V, Constants.rho*alpha*((l/2)^2 + (w/h)^2)*V]);
end