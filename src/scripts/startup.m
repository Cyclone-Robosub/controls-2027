%{
This script configures various settings and file paths to make sure all the
features of this codebase work correctly.
%}

clc
close all
clear all %#ok<CLALL>

%% 1 - Add files to the search path
%get the current project
try
    prj = currentProject;
catch
    error("Use the Project panel to open the controls-2027 project to run startup.m\n")
end

%build all the relevant paths
root_path = prj.RootFolder;

%top level paths
archive_path = fullfile(root_path, 'archive');
codegen_path = fullfile(root_path, 'codegen');
data_path = fullfile(root_path, 'data');
drafts_path = fullfile(root_path, 'drafts');
examples_path = fullfile(root_path, 'examples');
src_path = fullfile(root_path, 'src');
temp_path = fullfile(root_path, 'temp');
tests_path = fullfile(root_path, 'tests');

%useful sub-paths in src
inits_path = fullfile(src_path,'inits');
utils_path = fullfile(src_path,'utils');
lookups_path = fullfile(utils_path,'lookups');

%useful codegen subpaths
cache_path = fullfile(codegen_path, 'simulink_cache_files');
cpp_codegen_path = fullfile(codegen_path,'cpp_codegen_files');
asv_path = fullfile(codegen_path,'autosaves');

% %vision paths (TODO - align the format with the rest of the project)
% UCS_lookup_path = fullfile(src_path,'utils','UCS Lookups');
% vision_path = fullfile(src_path,'utils','Vision');
% UCS_path = fullfile(src_path,'utils','UCS');
% saved_images_path = fullfile(root_path, "SavedImages");
% unreal_build_path = fullfile(root_path, "DROP UCS PACKAGED BUILD HERE");

%pack everything into the project path list variable
prj_path_list.archive_path = archive_path;
prj_path_list.codegen_path = codegen_path;
prj_path_list.data_path = data_path;
prj_path_list.drafts_path = drafts_path;
prj_path_list.examples_path = examples_path;
prj_path_list.src_path = src_path;
prj_path_list.temp_path = temp_path;
prj_path_list.tests_path = tests_path;
prj_path_list.inits_path = inits_path;
prj_path_list.utils_path = utils_path;
prj_path_list.lookups_path = lookups_path;
prj_path_list.cache_path = cache_path;
prj_path_list.cpp_codegen_path = cpp_codegen_path;
prj_path_list.asv_path = asv_path;

%clear individual paths to avoid workplace clutter
clear archive_path asv_path cache_pate codegen_path cpp_codegen_path data_path examples_path inits_path lookups_path root_path src_path temp_path tests_path utils_path cache_path drafts_path prj

%% 2 - Check for and/or create missing folders
field_names = fields(prj_path_list);
for k = 1:length(field_names)
    if(~isfolder(prj_path_list.(field_names{k})))
        fprintf("Folder expected at %s is missing. Creating it now.\n",field_names{k});
        mkdir(prj_path_list.(field_names{k}));
    end

    %add the folder to the search path
    addpath(genpath(prj_path_list.(field_names{k})));
end

%clear unused variables to avoid workplace clutter
clear k field_names

%save to file system (used by getProjectPaths in case of clear all)
save(fullfile(prj_path_list.lookups_path,"prj_path_list.mat"),"prj_path_list",'-mat');


%% 3 - Configures file path for automatically generated temporary files
Simulink.fileGenControl('set',...
    'CacheFolder',prj_path_list.cache_path,...
    'CodeGenFolder',prj_path_list.codegen_path);

fprintf("Cache and CodeGen file paths are setup.\n");


%% 4 - Unreal Setup
%Facilitates changing UCS variables from matlab terminal
% run('terminalStruct_UCS.m')

%% 5 - Confirm
fprintf("Setup complete.\n\n")
