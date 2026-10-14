function Wrench = calcWrenchData(Geometry, Mass)

%matrix of thruster positions
R_o2tk = [Geometry.Ro_t1 Geometry.Ro_t2 Geometry.Ro_t3...
    Geometry.Ro_t4 Geometry.Ro_t5 Geometry.Ro_t6 Geometry.Ro_t7...
    Geometry.Ro_t8]; %converted to m


%position of the thrusters relative to the center of mass
R_cm2tk = zeros(3,8);
for k = 1:8
    R_cm2tk(:,k) = Mass.R_cm2o + R_o2tk(:,k);
end
RT_list = R_cm2tk;

%thruster pointing directions (should be no need to update this)
NTb_upper = [zeros(4,1),zeros(4,1),[-1 1 -1 1]']';
NTb_lower = sqrt(2)/2*[1 1 0;...
    -1 1 0;...
    1 -1 0;...
    -1 -1 0]';
NT_list = [NTb_upper,NTb_lower];

force_wrench = NT_list;

moment_wrench = zeros(3,8);
for k = 1:8
    moment_wrench(:,k) = cross(RT_list(:,k),NT_list(:,k));
end

%full wrench
wrench = [force_wrench;moment_wrench];
inv_wrench = pinv(wrench);

%pseudoinverse
inv_force_wrench = inv_wrench(:,1:3);
inv_moment_wrench = inv_wrench(:,4:6);

%pack into structure
Wrench.FT_wrench = force_wrench;
Wrench.MT_wrench = moment_wrench;
Wrench.invFT_wrench = inv_force_wrench;
Wrench.invMT_wrench = inv_moment_wrench;

end