% NOTE: not very good at predicting yaw
g_o = 9.80665;%[m/^2]
gi_ideal = [0;0;-g_o];
test_data = 0;

%% Preprocessing
sensor_read = zeros(3,1);
guess = zeros([3,1,2]);
guess(:,:,1) = [0*pi/180;0*pi/180;0*pi/180];
for i = 1:3
    sensor_read(i) = mean(results.sensors_imu_lin_acc.Data(i,:,:));
end
options = optimoptions("fsolve",...
    Display="none",FunctionTolerance=1e-10);
%% Fsolve - doubt that iteration is useful
fun = @(x)rotation(x,gi_ideal,sensor_read);
guess(:,:,(2))=fsolve(fun,guess(:,:,1),options);

%% Evaluation
C_approx = eulToRotm(guess(:,:,end))
sensor_read
sensor_recreation = C_approx*gi_ideal

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
