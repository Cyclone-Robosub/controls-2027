function T = createTuning()
%{
Defines the set of tuning constants and other settings like tolerances.
%}

max_thruster_force_fmd = 80;
T.ff_force_max = 2*sqrt(2)*max_thruster_force_fmd;

%tolerance for mode switching in the guidance law
T.Ri_e_tol = 0.1; %only leave this large for testing sliding maneuvers
T.Eul_e_tol = 5*pi/180; %If I make this too small the controller bounces a lot on edges. As low as 10 works

%Controller gains for position --> velocity
T.Rb_PID.Kp = [0.5;0.5;1]; T.Rb_PID.Ki = [0.1;0.1;0.1]; T.Rb_PID.Kd = [0;0;0];
T.Rb_PID.N = 100; %filter coefficient for the derivative term
T.Rb_PID.output_sat = 5; %PID saturation point for velocity output
T.Rb_PID.int_sat = 1; %integral term saturation limit

%Controller gains for velocity --> force %DRB
T.dRb_PID.Kp = [60; 60; 100]; T.dRb_PID.Ki = [20; 20; 20]; T.dRb_PID.Kd = [0; 0; 0];
T.dRb_PID.N = 100; %filter coefficient for the derivative term
T.dRb_PID.output_sat = 200; %PID saturation point for velocity output
T.dRb_PID.int_sat = 100; %integral term saturation limit

%Controller gains for quaternion --> angular velocity [roll, pitch, yaw,
%scalar]
T.qib_PID.Kp = [10;10;5;10]; T.qib_PID.Ki = [0;0;0;0]; T.qib_PID.Kd = [0;0;0;0];
T.qib_PID.Kp = [1;1;1;1];
T.qib_PID.N = 100; %filter coefficient for the derivative term (unused)
T.qib_PID.output_sat = 4*pi; %PID saturation point for velocity output
T.qib_PID.int_sat = pi/3; %integral term saturation limit

%Controller gains for angular velocity --> torque 
T.wb_PID.Kp = [1;5;5]; T.wb_PID.Ki = [1;5;5]; T.wb_PID.Kd = [0;0;0];
T.wb_PID.N = 100; %filter coefficient for the derivative term
T.wb_PID.output_sat = 40; %PID saturation point for velocity output
T.wb_PID.int_sat = 10; %integral term saturation limit

%pwm cmd clamping
T.pwm_lower_limit = 1100;
T.pwm_upper_limit = 1900;
T.pwm_zero_set = int32(1500.*ones(8,1));

% %initial conditions for the state estimator
T.q0_ekf = [0 0 0 1]';
T.q0_est = [0 0 0 1]';
T.P0_ekf = 0.1*eye(6); 
T.B0_ekf = zeros(3,1);

% Joy stick input to error
T.js_wb_scale = [2 1 2; 1 1 3]; % positive and negative tuning values
T.js_dRb_scale = [2 1 2; 1 1 3];% idea was in case of hardware depreciation 
end