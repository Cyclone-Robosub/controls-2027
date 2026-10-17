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
clear results 

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
% P = loadParameters();
P = createParameters();
% saveParameters(P);

%Tuning
% T = loadTuning();
T = createTuning();
% saveTuning(T);

%Initial Conditions
% I = loadInits();
I = createInits();
% saveInits(I);

%Simulink Settings
% S = loadSim();
S = createSim();
% saveSim(S);

model_name = "Dynamics";

%if true, data is deleted from file system but saved in the workspace for post processing
delete_data_flag = false; 
prj_path_list.prior_run_path = configureToFileBlocks(model_name, prj_path_list.data_path); 

%Unreal setup (handled separately w/ XML format)
do_unreal_flag = 1; %if false, the unreal_cosim subsystem is commented out
if(do_unreal_flag)
    % Load UCS Scene Configuration and Variables
    scene_config_name = "example_scene_config.xml";
    scene_config = readstruct(scene_config_name);
    dt_sample = scene_config.scene_states.dt_sample;
    
    %other unreal stuff
    M_WorldToUCS = [1 0 0 0 0 0; 0 1 0 0 0 0; 0 0 -1 0 0 0; 0 0 0 (180 / pi) 0 0; 0 0 0 0 (180 / pi) 0; 0 0 0 0 0 (180 / pi)];
    M_UCSToWorld = [1 0 0 0 0 0; 0 1 0 0 0 0; 0 0 -1 0 0 0; 0 0 0 (pi / 180) 0 0; 0 0 0 0 (pi / 180) 0; 0 0 0 0 0 (pi / 180)];
    ground_Z = scene_config.scene_states.ground_Z;
    waterLevel_Z = scene_config.scene_states.waterLevel_Z;

    configure_scene(model_name, scene_config, prj_path_list.executables_path, prj_path_list.prior_run_path);
else
    disableUnrealCosim(model_name);
end


run('setup_cmd_bus.m');
run('setup_FF_maneuvers_bus.m');
run('setup_state_bus.m');
run('setup_sensor_bus.m');
run('setup_RSFF_maneuvers_bus.m');
run('setup_imu_bus.m');
run('setup_dvl_bus.m');

%overrides for common settings
S.tspan = 3;
S.FT_list_test = FF_maneuvers.forward;

%{
Note, if you receive an error from the ROS blocks saying something about a
different model that is not the one you have selected not being loaded this
is a limitation from using ros blocks in subsystem references. The fix for
this is running`bdclose('all')` then resetting your model.
%}
%% Run the Sim
mission_file_name = "mission_file.txt"; 

%setup for bus objects (necessary to use structures in Simulink)
max_commands_in_mission = 64; 
%import the mission text file as an array of cmd objects
mission_file_path = fullfile(prj_path_list.inits_path,mission_file_name);
mission = importMission(mission_file_path, max_commands_in_mission);

%setup the sim
simIn = Simulink.SimulationInput(model_name);
%set the parameter `mission` containing all the cmd structures
mission = Simulink.Parameter(mission);
simIn = simIn.setVariable('mission', mission);
%run the sim
results = sim(simIn);

results = repackSimData(results, delete_data_flag, prj_path_list.prior_run_path);

%reset all Unreal values to default (TODO - move to model save callback)
deconfigure_scene(model_name);
clear mission_file_path mission_file_name max_commands_in_mission scene_config_name

%% Plotting
close all
run('setup_plots.m')

% Enter the names of all the plots as a comma separated cell array
% Refer to setup_plots.m to see the valid plot names
plot_names = {"X","thrusters"};
plotAllOutputs(plots,results,plot_names);
% 
% %Publish Controller Report
% % run('controller_report.m');
% % publish('controller_report.m','format','pdf','outputDir',prj_path_list.prior_run_data_path,'evalCode',true,'showCode',false);
% % saveCalibrationData(results, prj_path_list.prior_run_data_path);
% % saveStateGif(results,prj_path_list.prior_run_data_path,'test')
% 
% %Save to file Camera Stream
% % saveUCSCameraStream(save_camera_feed_flag, saved_images_path, results, tspan, dt_sample);
% 
% fprintf("\nDone.\n\n")