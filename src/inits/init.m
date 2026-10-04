%{
This is the master initialization file for the Cyclone Robosub Simulink.
This is intended to be the one-stop-shop for setting up and running
simulations.

If you need to make significant modifications to this file, create a copy
instead and give it an extension such as init_<varient> and place it in init
folder.

To use this codebase successfully, make sure project_startup.m has been
added to the project settings and ran and that the project is open (i.e.
the Project tab is visible at the top of the screen).

%}


%% Housekeeping and Path Management
clc
close all

%refreshes the file path in case clear all was called
if(~exist('prj_path_list','var')) 
    prj_path_list = getProjectPaths();
end

%% Physical Vehicle Parameters (P)
%{
Load an existing parameter structure P or create a new one. To save your
current configuration for future re-use, run saveParameters() in the
Command Window, optionally specifying a name for the test case. Parameters
are saved to prj_path_list.lookups_path.
%}

parameter_set = "test"; %specify the name of the parameter set here

% uncomment one of these options
% P = loadParameters(parameter_set);
P = createParameters();

%optionally, save for reuse. Sets with the same name are overwritten.
saveParameters(P, parameter_set);


%% Tuning Gains and "Magic Numbers" (T)
%{
Load an existing tuning structure T or create a new one, similar to the
parameter structure.
%}

tuning_set = "test";

%uncomment one of these options
% T = loadTuning(tuning_set);
T = createTuning();

%optionally, save for reuse. Sets with the same name are overwritten.
saveTuning(T, tuning_set);

%% Initial Conditions (I)
%{
Load an existing initial conditions set I or create a new one, similar to
parameter & tuning structures.
%}
init_set = "test";

%uncomment one of these options
% I = loadInit(init_set);
I = createInit(init_set);

%optionally, save for reuse. Sets with the same name are overwritten.
saveInit(I, init_set);


%% Simulink Configurations (S)
%{
Load an existing test set I or create a new one. You get the
idea by now. The test set contains simulation debug settings, model
configurations, injectors, and override flags. Basically everything
required to define a test that isn't a physical parameter, tuning constant,
or initial condition.

%}
sim_set = "test";

%uncomment one of these options
% S = loadSim(init_set);
S = createSim(sim_test);

%optionally, save for reuse. Sets with the same name are overwritten.
saveSim(S, sim_set);

%% TODO - move this section into the above 3
%battery voltage
const_voltage = 15;

%Simple_Joystick_SIM
const_joy = [0 0 0 0 0 0]'; %[Y, X ,Rise,Sink,Yaw,Pitch]
FT_list_test = 10*[0 0 0 0 10 -10 10 -10]';
test_pwm_list = [1500 1500 1500 1500 1500 1500 1500 1500]';
initial_joystick_mode_enabled_flag = false;

%flags are used to turn parts of the simulation on and off
do_buoyancy_flag = 1;
do_gravity_flag = 1;
do_drag_flag = 1;
do_thrusters_flag = 1;
do_time_flag = 1;
do_torque_flag = 1;
do_force_flag = 1;
use_true_state_flag = 0;
allow_PID_resets_flag = 1;

%controller tuning
do_force_cmd_flag = true;
do_moment_cmd_flag = true;

overwrite_FT_list_flag = false;
FT_list_inject = [0;0;0;0;0;0;0;0];

overwrite_rate_error_flag = false;
wb_error_inject = [0;0;0]; %[wbx; wby; wbz] rad/s
dRb_error_inject = [0;0;0]; %[dRbx; dRby; dRbz] m/s

overwrite_rate_setpoint_flag = false;
wb_sp_inject = [0;0;0]; %[wbx; wby; wbz] rad/s
dRb_sp_inject = [0;0;0]; %[dRbx; dRby; dRbz] m/s

%if true, ignores guidanceLaw, discountExecutive, and commandExecuter
overwrite_state_error_flag = false; 
eul_error_inject = [0;0;0]; %[roll; pitch; yaw] rad
Rb_error_inject = [0;0;0]; %[Rbx; Rby; Rbz] m

overwrite_state_setpoint_flag = false;
eul_sp_inject = [0;0;0];
Rb_sp_inject = [0;0;0];


%for running in sim
% Cbimu_meas = eye(3); %change tag

Cbimu_meas = [1 0 0;...
    0 -0.0370 -0.9993;...
    0 0.9993 -0.0370];

fprintf("Setting simulation config.\n")

%simulation duration
tspan = 360;

%timesteps for various simulation components
dt_sim = 1/100; %sim timestep %change tag
dt_data = roundToSimTimestep(1/30, dt_sim); %data saving timestep
dt_control = roundToSimTimestep(1/100, dt_sim); %controller timestep
dt_dvl_drr = roundToSimTimestep(1/5, dt_sim);
dt_dvl_vr = roundToSimTimestep(1/20, dt_sim);
dt_imu = roundToSimTimestep(1/100, dt_sim);
dt_debug = roundToSimTimestep(1/10, dt_sim); %for debug publisher
dt_heartbeat = roundToSimTimestep(1/2, dt_sim);

%mission file and model %change tag
mission_file_name = "mission_file.txt"; 
% model_select = "FB_Controller_SIM";
% model_select = "Integrated_Joystick_HIL";
% model_select = "Mission_Manager_SIM";
model_select = "Mission_Manager_HIL";
% model_select = "CodeGen_Tester_HIL";

%{
Note, if you receive an error from the ROS blocks saying something about a
different model that is not the one you have selected not being loaded this
is a limitation from using ros blocks in subsystem references. The fix for
this is running`bdclose('all')` then resetting your model.
%}

% Unreal Cosim Toggles
show_camera_feed_flag = true;
save_camera_feed_flag = false;
showCameraFeed(model_select,show_camera_feed_flag);
setUnrealScenePath(model_select);

%setup for bus objects (necessary to use structures in Simulink)
max_commands_in_mission = 64; 
setup_buses_flag = true;
if(setup_buses_flag)
    fprintf("Setting up busses.\n")
    run('setup_cmd_bus.m');
    run('setup_FF_maneuvers_bus.m');
    run('setup_state_bus.m');
    run('setup_sensor_bus.m');
    run('setup_RSFF_maneuvers_bus.m');
    run('setup_imu_bus.m');
    run('setup_dvl_bus.m');
end


%constants file for Unreal Cosim
run('constants_UCS.m');
run('constants_Props_UCS.m')

%constant overrides for Unreal. Comment out to use defaults
%manateeOriginPose = [0 0 0 0 0 0]; %Keep roll pitch yaw 0 0 0 for now.

fprintf("Configuring toWorkspace and toFile Blocks.\n")

%set To-File block names %change tag
enableToFileBlocks(model_select);
% disableToFileBlocks(model_select);
to_file_block_path = setToFileBlockNames(model_select, prj_path_list.user_data_path);
prj_path_list.prior_run_data_path = to_file_block_path;

%Data stores for debug
% enableDebugDataStores(model_select); %change tag
disableDebugDataStores(model_select);

%comment or uncomment the to-workspace blocks (for performance reasons)
enableToWorkspaceBlocks(model_select);
% disableToWorkspaceBlocks(model_select)

%Override disableToWorkspaceBlocks for saving camera feed
if save_camera_feed_flag
    set_param('FB_Controller_UCS/Camera Model/Save Camera Feed/To Workspace Left', 'Commented', 'off');
    set_param('FB_Controller_UCS/Camera Model/Save Camera Feed/To Workspace Right', 'Commented', 'off');
    %set_param('FB_Controller_UCS/Camera Model/Save Camera Feed/To Workspace Bottom', 'Commented', 'off');
end

%import the mission text file as an array of cmd objects
mission_file_path = fullfile(prj_path_list.inits_path,mission_file_name);
mission = importMission(mission_file_path, max_commands_in_mission);

%% Execution
fprintf("Running the sim.\n");

%setup the sim
simIn = Simulink.SimulationInput(model_select);

%set the parameter `mission` containing all the cmd structures
mission = Simulink.Parameter(mission);
simIn = simIn.setVariable('mission', mission);

%run the sim
results = sim(simIn);

defaultToFileBlockNames(model_select);

%% Post Processing
close all
fprintf("Running Post-Processing.\n")

run('setup_plots.m')

% Add any the outputs of ToFile blocks to the results structure
results = fileToResults(results, to_file_block_path);

% Enter the names of all the plots as a comma separated cell array
% Refer to setup_plots.m to see the valid plot names
plot_names = {"X", "X_est", "pwm_cmd", "cmd_status", "dvl", "est_vs_true", "est_vs_true_imu", "est_vs_true_body_vel"};
plotAllOutputs(plots,results,plot_names);

%Publish Controller Report
% run('controller_report.m');
% publish('controller_report.m','format','pdf','outputDir',prj_path_list.prior_run_data_path,'evalCode',true,'showCode',false);
% saveCalibrationData(results, prj_path_list.prior_run_data_path);
% saveStateGif(results,prj_path_list.prior_run_data_path,'test')

%Save to file Camera Stream
% saveUCSCameraStream(save_camera_feed_flag, saved_images_path, results, tspan, dt_sample);

fprintf("\nDone.\n\n")