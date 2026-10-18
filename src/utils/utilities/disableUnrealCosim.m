function disableUnrealCosim(model_name)

%Finds the unreal_cosim subsystem reference
blocks = find_system('Dynamics', 'RegExp','on', ...
    'BlockType','SubSystem', ...
    'ReferencedSubsystem','^unreal_cosim');  % prefix match, so extension doesn't matter

for k = 1:numel(blocks)
    set_param(blocks{k}, 'Commented', 'on');
end


end