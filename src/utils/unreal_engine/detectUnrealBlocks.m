function flag = detectUnrealBlocks(model_name)
%{
Detect the presence of an Unreal Scene Configuration block in the model 
and return true if one is found, false otherwise. This flag is used to
determine whether subsequent Unreal configuration steps are necessary.

%}

%strip the .slx from the model name, if it was included
if(contains(model_name, ".slx"))
    model_name = extractBefore(model_name, ".slx");
end

%open the system if it is not loaded
if ~bdIsLoaded(model_name)
    open_system(model_name);
end

%Finds all (hopefully only 1) scene configuration blocks.
scene_configuration_blocks = find_system(model_name, ...
    'IncludeCommented','on',...
    'LookUnderMasks', 'all', ...
    'FollowLinks',    'on',  ...
    'MatchFilter', @Simulink.match.allVariants,...
    'MaskType',      'Simulation 3D Scene Configuration');

if(isempty(scene_configuration_blocks))
    flag = false;
else
    flag = true;
end


end