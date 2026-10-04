function prj_paths_list = getProjectPaths()
%{
This function finds and loads the variable prj_path_list.mat, which is
created by the project startup script, startup.m.

%}

%this code jumps around the file system, so save the original location
origin_dir = pwd; 


in_root_flag = false;
root_name = 'controls-2027';

while(~in_root_flag)
    [parent,folder] = fileparts(pwd);

    %if 'controls-2027 is a substring of parent, move up a level
    if(contains(parent,root_name))
        cd ..;
    %if we are in 'controls-2027', stay here
    elseif(isequal(folder,root_name))
        in_root_flag = true;
    %otherwise, search recursively for the 'controls-2027' folder
    else
        %search for the the folder with SimulinkPlant folder and go to it
        try
            target_dir = dir(fullfile(pwd,'**',root_name));
            cd(target_dir(1).folder);
            in_root_flag = true;
        catch
            error("Attempting to call getProjectPath from an invalid location. Knock it off.");
        end
    end
end

%we should now be within the root folder, so load the prj_path_list
try
    cd(fullfile('src','utils','lookups')); 
    temp = load('prj_path_list.mat');
    prj_paths_list = temp.prj_path_list;
catch
    error("Unable to load prj_path_list from %s.\nMake sure you have entered the controls-2027 project to run the startup script.\n ",fullfile('src','utils','lookups'))
end

try
    cd(origin_dir);
catch
    warning("Original directory was missing or deleted. Leaving you here.")
end
end