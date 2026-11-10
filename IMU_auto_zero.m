% NOTE: not very good at predicting yaw
g_o = 9.80665;%[m/^2]
gi_ideal = [0;0;-g_o];
%{
%% Test Data
num_points = 10000;
test_rotation = [130*pi/180,5*pi/180,-1*pi/180]';
Cis = eulToRotm(test_rotation) %rotation for inertial to sensor frame
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
%}

sensor_read = zeros(3,1);
itter = 100;
guess = zeros([3,1,itter]);
guess(:,:,1) = [0*pi/180;0*pi/180;0*pi/180];

for i = 1:3
    %sensor_read(i) = mean(imu_accl_meas(i,:,:));
    sensor_read(i) = mean(results.sensors_imu_lin_acc.Data(i,:,:));
end


for i = 1:itter
    fun = @(x)rotation(x,gi_ideal,sensor_read);
    options = optimoptions("fsolve",...
        Display="none",FunctionTolerance=1e-10);
    problem.objective = @rotation;
    problem.x0 = guess;
    problem.solver = "fsolve";
    guess(:,:,(i+1))=fsolve(fun,guess(:,:,i),options);
    C_approx = (eulToRotm(guess(:,:,i+1)));
    rem_error = C_approx*gi_ideal;
    rem_error = rem_error(2)-sensor_read(2);
    if abs(rem_error)>.000001
        guess(3,:,i+1) = guess(3,:,i+1)-sign(rem_error)*.0001;
    end
end
C_approx = (eulToRotm(guess(:,:,end)))

function F = rotation(x,gi_ideal,sensor_read)
F = [(cos(x(2))*cos(x(3))*gi_ideal(1)...
    +cos(x(2))*sin(x(3))*gi_ideal(2)...
    -sin(x(2))*gi_ideal(3)) - sensor_read(1)

    ((-cos(x(1))*sin(x(3))+sin(x(1))*sin(x(2))*cos(x(3)))*gi_ideal(1)...
    +(cos(x(1))*cos(x(3))+sin(x(1))*sin(x(2))*sin(x(3)))*gi_ideal(2)...
    +(sin(x(1))*cos(x(2)))*gi_ideal(3))-sensor_read(2)

    ((sin(x(1))*sin(x(3))+cos(x(1))*sin(x(2))*cos(x(3)))*gi_ideal(1)...
    +(-sin(x(1))*cos(x(3))+cos(x(1))*sin(x(2))*sin(x(3)))*gi_ideal(2)...
    +(cos(x(1))*cos(x(2)))*gi_ideal(3))-sensor_read(3)];
end