function I = createInits()
%{
Defines the initial state of the robot.
%}
%initial intertial position
xi_0 = 0; yi_0 = 0; zi_0 = 0;
I.Ri_0 = [xi_0; yi_0; zi_0];

%initial intertial velocity
ui_0 = 0; vi_0 = 0; wi_0 = 0;
I.dRi_0 = [ui_0; vi_0; wi_0];

%initial euler angles
phi_0 = 0; theta_0 = 0; psi_0 = 0;
I.Eul_0 = [phi_0; theta_0; psi_0]; %[roll, pitch, yaw]

%other attitude representations
I.Cib_0 = eulToRotm(I.Eul_0);
I.q_0 = eulToQuat(I.Eul_0); %[vector; scalar]

%initial angular velocity
wbx_0 = 0; wby_0 = 0; wbz_0 = 0;
I.wb_0 = [wbx_0; wby_0; wbz_0];

%pack initial state
I.X0 = [I.Ri_0;I.q_0;I.dRi_0;I.wb_0];

%voltages
I.VBatt0 = 15;
end