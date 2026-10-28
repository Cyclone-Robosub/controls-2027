function results = repackSimData(results, delete_flag, path)
%{
This function loads all the .mat files found at the path, packs all the 
timeseries into the results Simulation.Output structure, deletes the
individual .mat files, and either saves the resulting Simulation.Output
structure or deletes the folder of data depending on the delete_flag.

%}

files = dir(fullfile(path, '*.mat'));

results_found_flag = false;
%make sure there isn't already a results file here
for k = 1:length(files)
    fname = files(k).name;
    if(contains(fname,'results'))
        results_found_flag = true;
    end
end

if(~results_found_flag)
    for k = 1:length(files)
        fname = files(k).name;
        data_struct_k = load(fullfile(path, fname));
        %if the type of the data structure is timeseries, stick in into results
        varName = matlab.lang.makeValidName(erase(fname, '.mat'));
        data_k = data_struct_k.(varName);
    
        if(isa(data_k,'timeseries') || istimetable(data_k))
            results.(varName) = data_k;
        elseif(isa(data_k,'struct'))
            field_names = fieldnames(data_k);
            for j = 1:length(field_names)
                extended_name = sprintf("%s_%s",varName,field_names{j});
                results.(extended_name) = data_k.(field_names{j});
            end
        end
    
        %delete the file now that it is in the results structure
        delete(fullfile(path, fname));
    end
    
    if(delete_flag)
        rmdir(path);
    else
        save(fullfile(path, "results.mat"),"results",'-mat');
    end
else
    results = load(fullfile(path, "results.mat"),"results").results;
    
    warning("Results.mat found in file. Cannot add results.mat to results. Skipping this folder.\n")
end



end