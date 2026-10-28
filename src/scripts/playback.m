%{
Script to visualize and analyze Pool Test data from Matlab & William Bag.
%}
clear all; clc; close all;

%% William Bag
william_bag_path =  "/home/kjhaydon/Documents/Robosub/Pool-Test-William-Bag-Data";

files = dir(william_bag_path);
names = {files.name};

%names of traces to plot
drr_plots = {'position_x','position_y','position_z','angle_x','angle_y','angle_z','pos_std'};
vr_plots = {'velocity_x','velocity_y','velocity_z','altitude','fom'};
imu_plots = {'angular_velocity_x','angular_velocity_y','angular_velocity_z',...
    'linear_acceleration_x','linear_acceleration_y','linear_acceleration_z',...
    'magnetic_field_x','magnetic_field_y','magnetic_field_z'};
pwm_plots = {'thruster_0','thruster_1','thruster_2','thruster_3','thruster_4',...
    'thruster_5','thruster_6','thruster_7'};

%load each table into the workspace
tables = {};
strip_names = {};

% figure
% plot(timestampToSeconds(tables{2}.time))
% title("VR Timestamps")
% xlabel("Index")
% ylabel("Time (s)")


for k = 1:numel(names)
    if(~strcmp(names{k},'.') && ~strcmp(names{k},'..'))
        tables{end+1} = readtable(fullfile(william_bag_path, names{k}));
        %plot, if the name matches
        if(contains(names{k},'pwm'))
            plotWBPWMS(tables{end},pwm_plots);
        elseif(contains(names{k},'dvl-drr'))
            plotWBDRR(tables{end},drr_plots);
        elseif(contains(names{k},'dvl-vr'))
            plotWBVR(tables{end},vr_plots);
        elseif(contains(names{k},'imu'))
            plotWBIMU(tables{end},imu_plots);
        end
    end
end

function plotWBVR(vr_table, vr_plots)
t = timestampToSeconds(vr_table.time);
set(groot, 'defaultTextInterpreter', 'none');
set(groot, 'defaultAxesTickLabelInterpreter', 'none');
set(groot, 'defaultLegendInterpreter', 'none');    
figure
subplot(3,1,1)
plot(t, vr_table.(vr_plots{1}))
hold on
plot(t, vr_table.(vr_plots{2}))
plot(t, vr_table.(vr_plots{3}))
title("VR Velocity")
xlabel("Time (s)")
ylabel("Velocity (m/s)")
legend(["dRbx", "dRby", "dRbz"])
subplot(3,1,2)
plot(t, vr_table.(vr_plots{4}))
title("VR Altitude")
xlabel("Time (s)")
ylabel("Altitude (m)")
subplot(3,1,3)
plot(t, vr_table.(vr_plots{5}))
title("VR Figure of Merit")
xlabel("Time (s)")
ylabel("FoM")
sgtitle('William Bag VR')

end

function plotWBDRR(drr_table, drr_plots)
    t = timestampToSeconds(drr_table.time);
    set(groot, 'defaultTextInterpreter', 'none');
    set(groot, 'defaultAxesTickLabelInterpreter', 'none');
    set(groot, 'defaultLegendInterpreter', 'none');    
    figure
    subplot(3,1,1)
    plot(t, drr_table.(drr_plots{1}))
    hold on
    plot(t, drr_table.(drr_plots{2}))
    plot(t, drr_table.(drr_plots{3}))
    title("DRR Position")
    xlabel("Time (s)")
    ylabel("Position (m)")
    legend(["Rix", "Riy", "Riz"])
    subplot(3,1,2)
    plot(t, drr_table.(drr_plots{4}))
    hold on
    plot(t, drr_table.(drr_plots{5}))
    plot(t, drr_table.(drr_plots{6}))
    title("DRR Angle")
    xlabel("Time (s)")
    ylabel("Angle (deg)")
    legend(["Roll", "Pitch", "Yaw"])
    subplot(3,1,3)
    plot(t, drr_table.(drr_plots{7}))
    title("DRR Figure of Merit")
    xlabel("Time (s)")
    ylabel("FoM")
    sgtitle('William Bag DRR')

end

function plotWBPWMS(pwm_table, pwm_plots)
    t = timestampToSeconds(pwm_table.time);
    figure
    set(groot, 'defaultTextInterpreter', 'none');
    set(groot, 'defaultAxesTickLabelInterpreter', 'none');
    set(groot, 'defaultLegendInterpreter', 'none');    
    subplot(4,2,1)
    plot(t,pwm_table.(pwm_plots{1}))
    xlabel("Time (s)")
    ylabel("PWM (us)")
    title(pwm_plots{1})
    subplot(4,2,2)
    plot(t,pwm_table.(pwm_plots{2}))
    xlabel("Time (s)")
    ylabel("PWM (us)")
    title(pwm_plots{2})
    subplot(4,2,3)
    plot(t,pwm_table.(pwm_plots{3}))
    xlabel("Time (s)")
    ylabel("PWM (us)")
    title(pwm_plots{3})
    subplot(4,2,4)
    plot(t,pwm_table.(pwm_plots{4}))
    xlabel("Time (s)")
    ylabel("PWM (us)")
    title(pwm_plots{4})
    subplot(4,2,5)
    plot(t,pwm_table.(pwm_plots{5}))
    xlabel("Time (s)")
    ylabel("PWM (us)")
    title(pwm_plots{5})
    subplot(4,2,6)
    plot(t,pwm_table.(pwm_plots{6}))
    xlabel("Time (s)")
    ylabel("PWM (us)")
    title(pwm_plots{6})
    subplot(4,2,7)
    plot(t,pwm_table.(pwm_plots{7}))
    xlabel("Time (s)")
    ylabel("PWM (us)")
    title(pwm_plots{7})
    subplot(4,2,8)
    plot(t,pwm_table.(pwm_plots{8}))
    xlabel("Time (s)")
    ylabel("PWM (us)")
    title(pwm_plots{8})
    sgtitle('William Bag PWMS')

end

function t = timestampToSeconds(times)
    datetimes = datetime(times,"InputFormat","uuuu-MM-dd-HH-mm-ss-SSS");
    t = seconds(datetimes - datetimes(1));

end

function plotWBIMU(imu_table, imu_plots)

t = timestampToSeconds(imu_table.time);
set(groot, 'defaultTextInterpreter', 'none');
set(groot, 'defaultAxesTickLabelInterpreter', 'none');
set(groot, 'defaultLegendInterpreter', 'none');    
figure
subplot(3,1,1)
plot(t, imu_table.(imu_plots{1}))
hold on
plot(t, imu_table.(imu_plots{2}))
plot(t, imu_table.(imu_plots{3}))
title("IMU Angular Velocity")
xlabel("Time (s)")
ylabel("Angular Velocity (rad/s)")
legend(["wsx", "wsy", "wsz"])
subplot(3,1,2)
plot(t, imu_table.(imu_plots{4}))
hold on
plot(t, imu_table.(imu_plots{5}))
plot(t, imu_table.(imu_plots{6}))
title("IMU Linear Acceleration")
xlabel("Time (s)")
ylabel("Acceleration (m/s2)")
legend(["ddRsx", "ddRsy", "ddRsz"])
subplot(3,1,3)
plot(t, imu_table.(imu_plots{7}))
hold on
plot(t, imu_table.(imu_plots{8}))
plot(t, imu_table.(imu_plots{9}))
title("IMU Magnetic Field")
xlabel("Time (s)")
ylabel("Magnetic Field (uT)")
legend(["Bsx", "Bsy", "Bsz"])
sgtitle('William Bag IMU')

end

%% Matlab
matlab_data_path = "/home/kjhaydon/Documents/Github/controls-2027/data/2026_10_24_17_36_18";

if(~exist('results','var'))
    results = Simulink.SimulationOutput;
end
results = repackSimData(results, false, matlab_data_path);

if(~exist('plots_setup_flag','var')) 
    run('setup_plots.m');
end

% Enter the names of all the plots as a comma separated cell array
plot_names = {"pwms"}; % Refer to setup_plots.m to see the valid plot names
plotAllOutputs(plots,results,plot_names);