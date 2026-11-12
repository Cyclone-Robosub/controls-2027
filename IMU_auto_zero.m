% NOTE: not very good at predicting yaw
g_o = 9.80665;%[m/^2]
gi_ideal = [0;0;-g_o];
test_data = 1;

%% Test Data
if test_data
num_points = 10000;
test_rotation = [110*pi/180,15*pi/180,-10*pi/180]';
Cis = eulToRotm(test_rotation); %rotation for inertial to sensor frame
Cis_mess = zeros(3,3,num_points);
for i = 1:num_points
    Cis_mess(:,:,i) = eulToRotm(awgn(test_rotation,50));
end
imu_accl_meas_clean = Cis*gi_ideal;
imu_accl_meas = zeros(3,1,num_points);
for i = 1:num_points
    imu_accl_meas(:,:,i) = squeeze(Cis_mess(:,:,i))*awgn(gi_ideal,500); %snr is whatever I feel like
end
figure
plot(squeeze(imu_accl_meas(1,:,:)))
hold on;
plot(squeeze(imu_accl_meas(2,:,:)))
plot(squeeze(imu_accl_meas(3,:,:)))
end
%% Preprocessing
sensor_read = zeros(3,1);
itter = 5;
guess = zeros([3,1,itter]);
guess(:,:,1) = [0*pi/180;0*pi/180;0*pi/180];

for i = 1:3
    if test_data
        sensor_read(i) = mean(imu_accl_meas(i,:,:));
    else
        sensor_read(i) = mean(results.sensors_imu_lin_acc.Data(i,:,:));
    end
end
options = optimoptions("fsolve",...
    Display="none",FunctionTolerance=1e-10);
%% Fsolve - doubt that iteration is useful
for i = 1:itter
    fun = @(x)rotation(x,gi_ideal,sensor_read);
    guess(:,:,(i+1))=fsolve(fun,guess(:,:,i),options);
end

%% Evaluation
Cis
C_approx = eulToRotm(guess(:,:,end))
sensor_read
sensor_recreation = C_approx*gi_ideal
figure
plot(1:length(guess(1,:,:)),squeeze(guess(1,:,:)))
figure
plot(1:length(guess(2,:,:)),squeeze(guess(2,:,:)))
figure 
plot(1:length(guess(3,:,:)),squeeze(guess(3,:,:)))
norm_error = zeros(length(sensor_recreation),3);
for i = 1:length(guess)
    C = eulToRotm(guess(:,:,i));
    norm_error(i,:) = (sensor_read)-(C*gi_ideal);
end
figure
plot(1:length(guess),norm_error)
ylim("tight")

%% Helper function
function F = rotation(x,gi_ideal,sensor_read)
F = sqrt(((cos(x(2))*cos(x(3)) * gi_ideal(1)...
    +cos(x(2))*sin(x(3)) * gi_ideal(2)...
    -sin(x(2))*gi_ideal(3))-sensor_read(1))^2+...
    ((cos(x(1))*sin(x(2)) + sin(x(1))*sin(x(2))*cos(x(3)))*gi_ideal(1)...
    +(cos(x(1))*cos(x(3)) + sin(x(1)*sin(x(2))*sin(x(3))))*gi_ideal(2)...
    +sin(x(1))*cos(x(2))*gi_ideal(3)...
    - sensor_read(2))^2+...
    ((sin(x(1))*sin(x(3))+cos(x(1))*sin(x(2))*cos(x(3)))*gi_ideal(1)...
    +(-sin(x(1))*cos(x(3))+cos(x(1))*sin(x(2))*sin(x(3)))*gi_ideal(2)...
    +(cos(x(1))*cos(x(2)))*gi_ideal(3) ...
    -sensor_read(3))^2);
end
