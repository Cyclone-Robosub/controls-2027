function configure_scene(model_name, scene_config, executables_path, data_path)
    
    %create save paths and exe path
    exe_path = fullfile(executables_path, scene_config.scene_states.executable_version + "\Windows\EllingtonPoolSim.exe");
    
    save_data_path = fullfile(data_path, string(datetime('now','Format','uuuu_MM_dd_HH_mm_ss')));
    if(~isfolder(save_data_path))
        mkdir(save_data_path);
    end

    save_camera_feeds_path = fullfile(save_data_path, "camera_feeds");
    if(~isfolder(save_camera_feeds_path))
        mkdir(save_camera_feeds_path);
    end

    save_scripts_path = fullfile(save_data_path, "scripts");
    if(~isfolder(save_scripts_path))
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
    end
    
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

        if (scene_config.cameras.(camera_name).save_flag)
            file_name = fullfile(save_camera_feeds_path, camera_name + ".mp4");
            set_param(to_multimedia_blocks{i}, 'outputFilename', file_name);
            set_param(to_multimedia_blocks{i}, 'Commented', 'off');
        end
    end
    
    %Sets the save path or comments out depending on flags in config
    for i = 1:numel(to_video_display_blocks)
        var_name  = get_param(to_video_display_blocks{i}, 'Name');
        camera_name = string(extractBefore(var_name, "_display"));
        if (scene_config.cameras.(camera_name).display_flag)
            set_param(to_video_display_blocks{i}, 'Commented', 'off');
        end
    end

end