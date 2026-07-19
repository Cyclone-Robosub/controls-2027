close all %closes any open figures
clc %clears the command window
clear results %clear the variable `results`

%set the model name and open it
model_name = "SIM_example.slx";
open_system(model_name);

%choose your data saving preferences (change the fcn arg to true/false)
%do not change the order of these function calls to avoid errors
saveDataToWorkspace(true);
saveDataToFile(true);

%run the model `SIM_example.slx` and store the output in `results`
results = sim("SIM_example.slx");

%