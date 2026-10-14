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

%% Parameters, Tuning, Initial Conditions, Settings
%{
Load an existing parameter structure P or create a new one. Same pattern is
also used for tuning structures T, initial condition structures I, and
simulation settings S.

To save your current configuration for future re-use, run saveParameters() 
in the Command Window or by uncommenting the call below. 
Optionally specifying a name for the test case. Parameters are saved to 
prj_path_list.lookups_path.

%}

%Parameters
parameter_set = "test"; %specify the name of the parameter set here
% P = loadParameters(parameter_set);
P = createParameters();
% saveParameters(P, parameter_set);

%Tuning
tuning_set = "test";
% T = loadTuning(tuning_set);
T = createTuning();
% saveTuning(T, tuning_set);

%Initial Conditions
inits_set = "test";
% I = loadInits(init_set);
I = createInits();
% saveInits(I, inits_set);

%Simulink Settings
sim_set = "test";
% S = loadSim(init_set);
S = createSim();
% saveSim(S, sim_set);

%% Run the Sim
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