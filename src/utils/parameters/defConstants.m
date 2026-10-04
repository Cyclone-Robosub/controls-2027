function Constants = defConstants()
%{
Constants that do not depend on the robot's geometry or mass.
%}

%max force delivered by a T200 thruster
Constants.max_thruster_force = 40;

%density of water
Constants.rho = 998; %[kg/m3] at 20 C

%gravity
Constants.gi = [0;0;-9.806];

%refreshes the file path in case clear all was called
if(~exist('prj_path_list','var')) 
    prj_path_list = getProjectPaths();
end

try
    voltage = coder.load(fullfile(prj_path_list.lookups_path,"voltage.mat"));
    Constants.voltage = table2array(voltage.t200_updatedS2);

    cw_pwm = coder.load(fullfile(prj_path_list.lookups_path,"cw_pwm.mat"));
    Constants.cw_pwm = table2array(cw_pwm.t200_updatedS2);

    ccw_pwm = coder.load(fullfile(prj_path_list.lookups_path,"ccw_pwm.mat"));
    Constants.ccw_pwm = table2array(ccw_pwm.t200_updatedS3);

    ccw_force = coder.load(fullfile(prj_path_list.lookups_path,"ccw_force.mat"));
    Constants.ccw_force = table2array(ccw_force.t200_updatedS3);

    cw_force = coder.load(fullfile(prj_path_list.lookups_path,"cw_force.mat"));
    Constants.cw_force = table2array(cw_force.t200_updatedS2);
catch
    error("Unable to load thruster data. Fix the path in your constants file.")
end


end