function S = createSim()
%{
Defines the set of simulation settings and constants.
%}

%% Timing
%simulation duration
S.tspan = 360;

%timesteps for various simulation components
S.dt_sim = 1/100; %sim timestep %change tag
S.dt_data = roundToSimTimestep(1/30, S.dt_sim); %data saving timestep
S.dt_control = roundToSimTimestep(1/100, S.dt_sim); %controller timestep
S.dt_dvl_drr = roundToSimTimestep(1/5, S.dt_sim);
S.dt_dvl_vr = roundToSimTimestep(1/20, S.dt_sim);
S.dt_imu = roundToSimTimestep(1/100, S.dt_sim);
S.dt_debug = roundToSimTimestep(1/10, S.dt_sim); %for debug publisher
S.dt_heartbeat = roundToSimTimestep(1/2, S.dt_sim);

%% Configs
%Simple_Joystick_SIM
S.const_joy = [0 0 0 0 0 0]'; %[Y, X ,Rise,Sink,Yaw,Pitch]
S.FT_list_test = 10*[0 0 0 0 10 -10 10 -10]';
S.test_pwm_list = [1500 1500 1500 1500 1500 1500 1500 1500]';
S.initial_joystick_mode_enabled_flag = false;

%flags are used to turn parts of the simulation on and off
S.do_buoyancy_flag = 1;
S.do_gravity_flag = 1;
S.do_drag_flag = 1;
S.do_thrusters_flag = 1;
S.do_time_flag = 1;
S.do_torque_flag = 1;
S.do_force_flag = 1;
S.use_true_state_flag = 0;
S.allow_PID_resets_flag = 1;

%controller tuning
S.do_force_cmd_flag = true;
S.do_moment_cmd_flag = true;

S.overwrite_FT_list_flag = false;
S.FT_list_inject = [0;0;0;0;0;0;0;0];

S.overwrite_rate_error_flag = false;
S.wb_error_inject = [0;0;0]; %[wbx; wby; wbz] rad/s
S.dRb_error_inject = [0;0;0]; %[dRbx; dRby; dRbz] m/s

S.overwrite_rate_setpoint_flag = false;
S.wb_sp_inject = [0;0;0]; %[wbx; wby; wbz] rad/s
S.dRb_sp_inject = [0;0;0]; %[dRbx; dRby; dRbz] m/s

%if true, ignores guidanceLaw, discountExecutive, and commandExecuter
S.overwrite_state_error_flag = false; 
S.eul_error_inject = [0;0;0]; %[roll; pitch; yaw] rad
S.Rb_error_inject = [0;0;0]; %[Rbx; Rby; Rbz] m

S.overwrite_state_setpoint_flag = false;
S.eul_sp_inject = [0;0;0];
S.Rb_sp_inject = [0;0;0];

end