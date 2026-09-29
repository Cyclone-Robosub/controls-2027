function deconfigure_scene(model_name)

    
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
    
    %Sets the path to the executable to default.
    for i = 1:numel(scene_configuration_blocks)
        set_param(scene_configuration_blocks{i}, "ProjectName", "default");
        set_param(scene_configuration_blocks{i}, "ScenePath", "default");
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
        set_param(to_multimedia_blocks{i}, 'outputFilename', "default");
        set_param(to_multimedia_blocks{i}, 'Commented', 'on');
    end
    
    %Sets the save path or comments out depending on flags in config
    for i = 1:numel(to_video_display_blocks)
        set_param(to_video_display_blocks{i}, 'Commented', 'on');
    end

end