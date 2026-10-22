function defaultToFileBlockNames(model_name)
%{
Sets all the To-File block names in the provided model to a the string
"default" to prevent ToFile block names from showing up in version control.
This function should be called as part of the PreSaveFcn and StopFcn
callback.

Inputs:
model_select - the name of the model being modified

%}


model_name = char(model_name);

if endsWith(model_name, ".slx")
    model_name = extractBefore(model_name, ".slx");
end

if ~bdIsLoaded(model_name)
    load_system(model_name);
end

to_file_blocks = find_system(model_name, ...
    'LookInsideSubsystemReference', 'off', ...
    'LookUnderMasks',               'all', ...
    'FollowLinks',                  'on',  ...
    'IncludeCommented',             'on',  ...
    'MatchFilter',                  @Simulink.match.allVariants, ...
    'BlockType',                    'ToFile');

for i = 1:numel(to_file_blocks)
    set_param(to_file_blocks{i}, 'Filename', 'default');
end

end