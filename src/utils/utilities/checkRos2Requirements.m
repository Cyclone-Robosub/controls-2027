function status = checkRos2Requirements()
%{
This function checks if you have the following dependencies installed and
available to Matlab.

1. ROS2 Toolbox, Simulink Coder, GPU Coder
2. Python
3. A C++ Compiler

Reference: https://www.mathworks.com/help/ros/gs/ros-system-requirements.html

%}



status = true;

toolbox_info = ver();
toolbox_names = {toolbox_info.Name};
fprintf("\n===== Checking requirements to run ROS2 code. =====\n")
%Toolboxes
if(any(contains(toolbox_names,'GPU Coder')))
    fprintf("GPU Coder toolbox found.\n")
else
    fprintf("TODO: GPU Coder toolbox not found. Install it using the Add-Ons menu.\n")
    status = false;
end

if(any(contains(toolbox_names,'Simulink Coder')))
    fprintf("Simulink Coder toolbox found.\n")
else
    fprintf("TODO: Simulink Coder toolbox not found. Install it using the Add-Ons menu.\n")
    status = false;
end

if(any(contains(toolbox_names,'ROS Toolbox')))
    fprintf("ROS Toolbox found.\n")
else
    fprintf("TODO: ROS Toolbox not found. Install it using the Add-Ons menu.\n")
    status = false;
end

%Matlab Version
matlab_version = version('-release');
if(isequal(matlab_version,'2026a'))
    fprintf("Matlab version 2026a found.\n");
else
    fprintf("TODO: Matlab version %s found. Please use 2026a to avoid unexpected issues.\n",matlab_version)
    status = false;
end

% C++ Compiler
try
    mex -setup C++
catch
    fprintf("TODO: No valid C++ compiler found for the ROS2 toolbox.\n");
    status = false;
    if(ispc)
        fprintf("Windows computer detected: ");
        fprintf("Docs recommend installing Visual Studio 2019 or 2022 configured for C++ workload.\n");
        fprintf("Install it using `winget install Microsoft.VisualStudio.2022.Community`\n");
        fprintf("You will have to re-launch the installer once it finishes and use 'Modify' to add the C++ workload.\n");
    elseif(isunix)
        fprintf("Linux computer detected: ");
        fprintf("Docs recommend installing GCC.\n");
        fprintf("See instructions here: TBA\n");
    end
end

% Python
pyPath = ros.ros2.internal.createOrGetLocalPython();
[~, cmdout] = system(['"' pyPath '" --version']);


if((any(contains(cmdout, "Python 3.10.")) || any(contains(cmdout, "Python 3.9."))))
    fprintf("Python 3.9 or 3.10 found.\n")
else
    status = false;
    fprintf("TODO: Python 3.9 or 3.10 is missing or not set as the ROS2 Python Environment.\n")
    if ispc
        fprintf("Install using `winget install Python.Python.3.10` then create the environment in Home -> Settings -> ROS Toolbox\n");
    elseif isunix
        fprintf("Install using TBA then create the environment in Home -> Settings -> ROS Toolbox\n");
    end
end

if(status)
    fprintf("All requirements for ROS2 found.\n")
else
    fprintf("Missing some requirements for ROS2. Fix the TODO items before proceeding.\n");
end

