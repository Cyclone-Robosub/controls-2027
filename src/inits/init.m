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
tic
clc
clear results 



%refreshes the file path in case clear all was called
if(~exist('prj_path_list','var')) 
    prj_path_list = getProjectPaths();
end

%% Parameters, Tuning, Initial Conditions, Settings

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

% Bus Setup
run('setup_cmd_bus.m');
run('setup_FF_maneuvers_bus.m');
run('setup_state_bus.m');
run('setup_sensor_bus.m');
run('setup_RSFF_maneuvers_bus.m');
run('setup_imu_bus.m');
run('setup_dvl_bus.m');

%{
Note, if you receive an error from the ROS blocks saying something about a
different model that is not the one you have selected not being loaded this
is a limitation from using ros blocks in subsystem references. The fix for
this is running`bdclose('all')` then resetting your model.
%}

%overrides for common settings
S.tspan = 6;
S.FT_list_inject = FF_maneuvers.yawRight;

model_name = "Dynamics_UCS";

%mission file import
mission_file_name = "mission_file.txt"; 
max_commands_in_mission = 64; 
mission_file_path = fullfile(prj_path_list.inits_path,mission_file_name);
mission = importMission(mission_file_path, max_commands_in_mission);

%% Data
%if true, data is deleted from file system but saved in the workspace for post processing
delete_data_flag = false; 
prj_path_list.prior_run_path = configureToFileBlocks(model_name, prj_path_list.data_path); 


%% Unreal Setup
do_unreal_cosim_flag = detectUnrealBlocks(model_name);

if(do_unreal_cosim_flag)
    % Load UCS Scene Configuration and Variables
    scene_config_name = "default_scene_config.xml"; 
    scene_config = readstruct(scene_config_name);
    dt_sample = scene_config.scene_states.dt_sample;
    
    %other unreal stuff
    M_WorldToUCS = [1 0 0 0 0 0; 0 1 0 0 0 0; 0 0 -1 0 0 0; 0 0 0 (180 / pi) 0 0; 0 0 0 0 (180 / pi) 0; 0 0 0 0 0 (180 / pi)];
    M_UCSToWorld = [1 0 0 0 0 0; 0 1 0 0 0 0; 0 0 -1 0 0 0; 0 0 0 (pi / 180) 0 0; 0 0 0 0 (pi / 180) 0; 0 0 0 0 0 (pi / 180)];
    ground_Z = scene_config.scene_states.ground_Z;
    waterLevel_Z = scene_config.scene_states.waterLevel_Z;

    configure_scene(model_name, scene_config, delete_data_flag, prj_path_list.executables_path, prj_path_list.prior_run_path);
end



%% SIM
%setup the sim
simIn = Simulink.SimulationInput(model_name);

%set the parameter `mission` containing all the cmd structures
mission = Simulink.Parameter(mission);
simIn = simIn.setVariable('mission', mission);

%run the sim
results = sim(simIn);

%repackage all the data into a single results obj, flattening structures
results = repackSimData(results, delete_data_flag, prj_path_list.prior_run_path);

%Saves The scene configuration
if(~delete_data_flag && do_unreal_cosim_flag)
    writestruct(scene_config,fullfile(prj_path_list.prior_run_path,"scene_config.xml"));
end

clear mission_file_path mission_file_name max_commands_in_mission scene_config_name dt_sample M_WorldToUCS M_UCSToWorld ground_Z waterLevel_Z

%% Plotting
close all

if(~exist('plots_setup_flag','var')) 
    run('setup_plots.m')
end

% Enter the names of all the plots as a comma separated cell array
plot_names = {"X"}; % Refer to setup_plots.m to see the valid plot names
plotAllOutputs(plots,results,plot_names);


% saveStateGif(results,prj_path_list.prior_run_data_path,'test')