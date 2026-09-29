close all 
clc 
clear results


% Load UCS Scene Configuration and Variables
scene_config_name = "example_scene_config.xml";
scene_config = readstruct(scene_config_name);
dt_sample = scene_config.scene_states.dt_sample;
clear scene_config_name;

M_WorldToUCS = [1 0 0 0 0 0; 0 1 0 0 0 0; 0 0 -1 0 0 0; 0 0 0 (180 / pi) 0 0; 0 0 0 0 (180 / pi) 0; 0 0 0 0 0 (180 / pi)];
M_UCSToWorld = [1 0 0 0 0 0; 0 1 0 0 0 0; 0 0 -1 0 0 0; 0 0 0 (pi / 180) 0 0; 0 0 0 0 (pi / 180) 0; 0 0 0 0 0 (pi / 180)];
ground_Z = scene_config.scene_states.ground_Z;
waterLevel_Z = scene_config.scene_states.waterLevel_Z;


% Settings
tspan = scene_config.scene_states.tspan;
dt_sim = scene_config.scene_states.dt_sim;

model_name = "UCS_example.slx";
open_system(model_name);

%configure the to-file blocks for data saving
example_UCS_data_path = fullfile(prj_path_list.examples_path,'UCS Example', 'UCS_example_data');
prj_path_list.prior_run_path = configureToFileBlocks(model_name, example_UCS_data_path); 

%configure file names and video saving from scene config
configure_scene(model_name, scene_config, prj_path_list.executables_path, example_UCS_data_path);

%run the model `UCS_example.slx` and store the output in `results`
results = sim(model_name);

%clear parameters
clear ground_z waterLevel_z dt_sample dt_sim example_UCS_data_path M_UCSToWorld M_WorldToUCS scene_config tspan model_name;