function configure_scene(model_name, scene_config, delete_data_flag, executables_path, save_data_path)
    
    %Check if unreal_cosim subsystem is open, and if it is, then close and save it.
    %There are problems if subsystem is open and run externally.
    if (bdIsLoaded("unreal_cosim"))
        close_system("unreal_cosim", 1);
    end

    %create save paths and exe path
    exe_path = fullfile(executables_path, scene_config.scene_states.executable_version + "\Windows\EllingtonPoolSim2.exe");
    
    if(~isfolder(save_data_path))
        mkdir(save_data_path);
    end
    
    save_camera_feeds_path = fullfile(save_data_path, "camera_feeds");
    if(~isfolder(save_camera_feeds_path)&& ~delete_data_flag)
        mkdir(save_camera_feeds_path);
    end
    
    save_scripts_path = fullfile(save_data_path, "scripts");
    if(~isfolder(save_scripts_path) && ~delete_data_flag)
        mkdir(save_scripts_path);
    end
    
    %strip the .slx from the model name
    if(contains(model_name, ".slx"))
        model_name = extractBefore(model_name, ".slx");
    end

    if ~bdIsLoaded(model_name)
        open_system(model_name);
    end
    
    %Finds all (hopefully only 1) scene configuration blocks.
    scene_configuration_blocks = find_system(model_name, ...
        'LookUnderMasks', 'all', ...
        'FollowLinks',    'on',  ...
        'MatchFilter', @Simulink.match.allVariants,...
        'MaskType',      'Simulation 3D Scene Configuration');

    
    %Sets the path to the executable and picks the correct level.
    for i = 1:numel(scene_configuration_blocks)
        set_param(scene_configuration_blocks{i}, "ProjectName", exe_path);
        set_param(scene_configuration_blocks{i}, "ScenePath", "/Game/" + scene_config.scene_states.scene_level);
        set_param(scene_configuration_blocks{i}, 'Commented', 'off');
        if(scene_config.scene_states.editor_view)
            set_param(scene_configuration_blocks{i}, 'EnableWindow', 'on');
        else
            set_param(scene_configuration_blocks{i}, 'EnableWindow', 'off');
        end
    end
    
    %Finds all camera blocks.
    camera_blocks = find_system(model_name, ...
        'LookUnderMasks', 'all', ...
        'FollowLinks',    'on',  ...
        'MatchFilter', @Simulink.match.allVariants,...
        'IncludeCommented', 'on',...
        'MaskType',      'Simulation 3D Camera');


    %Finds all video saving blocks.
    to_multimedia_blocks = find_system(model_name, ...
        'LookUnderMasks', 'all', ...
        'FollowLinks',    'on',  ...
        'MatchFilter', @Simulink.match.allVariants,...
        'IncludeCommented', 'on',...
        'FunctionName',      'sdspwmmfo2');
    
    %Finds all video display blocks
    to_video_display_blocks = find_system(model_name, ...
        'LookUnderMasks', 'all', ...
        'FollowLinks',    'on',  ...
        'MatchFilter', @Simulink.match.allVariants,...
        'IncludeCommented', 'on',...
        'FunctionName',      'svipwvo2');

    %Sets the save path or comments out depending on flags in config
    for i = 1:numel(to_multimedia_blocks)
        var_name  = get_param(to_multimedia_blocks{i}, 'Name');
        camera_name = string(extractBefore(var_name, "_save"));
        if(~delete_data_flag) 
            if (scene_config.cameras.(camera_name).save_flag)
                file_name = fullfile(save_camera_feeds_path, camera_name + ".mp4");
                set_param(to_multimedia_blocks{i}, 'outputFilename', file_name);
                set_param(to_multimedia_blocks{i}, 'Commented', 'off');
            end
        else
            file_name = fullfile(save_camera_feeds_path, camera_name + ".mp4");
            set_param(to_multimedia_blocks{i}, 'outputFilename', file_name);
            set_param(to_multimedia_blocks{i}, 'Commented', 'on');
        end
    end
    
    %Sets the display windows to commented depending on flags in config
    for i = 1:numel(to_video_display_blocks)
        var_name  = get_param(to_video_display_blocks{i}, 'Name');
        camera_name = string(extractBefore(var_name, "_display"));
        if (scene_config.cameras.(camera_name).display_flag)
            set_param(to_video_display_blocks{i}, 'Commented', 'off');
        else
            set_param(to_video_display_blocks{i}, 'Commented', 'on');
        end
    end
    
    %Checks the level if camera blocks need to be commented out. Some
    %levels only contain a subset of cameras.
    if(contains(scene_config.scene_states.scene_level, "_Cams"))
        exeTokens = split(string(extractBefore(scene_config.scene_states.scene_level, "_Cams")), '_');
        exTSize = size(exeTokens);
        camToken = exeTokens(exTSize(1));
        for i = 1:numel(camera_blocks)
            var_name  = get_param(camera_blocks{i}, 'Name');
            if (contains(camToken, var_name(1)))
                set_param(camera_blocks{i}, 'Commented', 'off');
                
            else
                set_param(camera_blocks{i}, 'Commented', 'on');
            end
        end
        
        %Retroactively go back and comment out display and saves.
        for i = 1:numel(to_video_display_blocks)
            var_name  = get_param(to_video_display_blocks{i}, 'Name');
            if (~contains(camToken, var_name(1), IgnoreCase=true))
                set_param(to_video_display_blocks{i}, 'Commented', 'on'); 
            end
        end
        for i = 1:numel(to_multimedia_blocks)
            var_name  = get_param(to_multimedia_blocks{i}, 'Name');
            if (~contains(camToken, var_name(1), IgnoreCase=true))
                set_param(to_multimedia_blocks{i}, 'Commented', 'on'); 
            end
        end
    end

end