%{
This script is designed to act on the data files saved from pool testing to
provide comparison of the experimental vs simulated response.
%}
%% Settings
gif_playback = true;
unreal_playback = false;

%if true, simulates robot using logged pwms and ICs
plot_comparison = false;
gif_comparison = false;
unreal_comparison = false;

path = "C:\Users\koryh\Documents\Robosub\Pool Test 10_17_26\Initial_Run_Standard";

%% Import

files = dir(path);
files = files(~ismember({files.name},{'.','..'}));
drr_file = files(contains({files.name},'dvl-drr'));
vr_file = files(contains({files.name},'dvl-vr'));
imu_file = files(contains({files.name},'imu'));

drr_data = readtable(fullfile(drr_file.folder, drr_file.name));
vr_data = readtable(fullfile(vr_file.folder, vr_file.name));
imu_data = readtable(fullfile(imu_file.folder, imu_file.name));

%manually chop off the leading duplicates and non-monotonic times
drr_data = drr_data(11:end,:);
vr_data = vr_data(11:end,:);
imu_data = imu_data(11:end-7,:);

%add the time in seconds column
datetimes = datetime(drr_data.time,"InputFormat","yyyy-MM-dd-HH-mm-ss-SSS");
drr_data.seconds = seconds(datetimes - datetimes(1));
datetimes = datetime(vr_data.time,"InputFormat","yyyy-MM-dd-HH-mm-ss-SSS");
vr_data.seconds = seconds(datetimes - datetimes(1));
datetimes = datetime(imu_data.time,"InputFormat","yyyy-MM-dd-HH-mm-ss-SSS");
imu_data.seconds = seconds(datetimes - datetimes(1));

%% Run Dynamics_SIM using logged PWMs.
%todo

%% Visualization
%todo
close all;

%2D Path
figure();
plot(drr_data.position_x,drr_data.position_y)
set(gca,'Ydir','reverse')

%3D Path
figure();
plot3(drr_data.position_x, drr_data.position_y, drr_data.position_z)
set(gca,'Zdir','reverse')
set(gca,'Ydir','reverse')
%% Helpers
