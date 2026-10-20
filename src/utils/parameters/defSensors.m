function Sensors = defSensors()
%{
Defines the imu and dvl constants for the noise models.
%}

%TODO - handle imu misalignment in a smarter way
Eul_bimu = [0 0 0]; %misaligned by 30 degrees for testing
imu.Cbimu = eulToRotm(Eul_bimu); %Rotation matrix from the sensor frame to body frame
imu.Cimub = imu.Cbimu';

%for running in sim
imu.Cbimu_meas = eye(3); 
% imu.Cbimu_meas = [1 0 0;...
%     0 -0.0370 -0.9993;...
%     0 0.9993 -0.0370];

imu.T = 25;
imu.Bi = [ 27.5550,-2.4169,-16.0849];

imu.acc.meas_range = 16 *9.81; %+/- 16 g to m/s
imu.acc.res = 122e-6 * 9.81; %122 ug to m/s
imu.acc.const_bias = [0, 0, 0];
imu.acc.axes_skew = 100*eye(3);
%0.02 m/s/sqrt(hr) divided by sqrt(3600) to (m/s^2)/sqrt(Hz)
imu.acc.vel_rand_walk = 3.333e-4*ones(1,3); %aka noise density (m/s^2)/sqrt(Hz)
imu.acc.bias_inst = [0, 0, 0]; %(m/s^2) %need Allan Variance data to find this number
imu.acc.bias_inst_num_coeffs = 1;
imu.acc.bias_inst_den_coeffs = [1, -0.5];
imu.acc.acc_rand_walk = [0, 0, 0]; %(m/s^2)*sqrt(Hz) %need Allan Variance data to find this number
imu.acc.temp_bias = [0, 0, 0]; %(m/s^2)/C %not modeled
imu.acc.temp_scale_factor = [0, 0, 0]; % %/C

imu.gyro.max_read = 4000 * pi/180; %+/- 4000 deg/s to rad/s
imu.gyro.res = 0.0076 * pi/180; %0.0076 deg/s to rad/s
imu.gyro.const_bias = [0, 0, 0]; %
imu.gyro.axes_skew = 100*eye(3); 
imu.gyro.bias_from_acc = [0, 0, 0]; %(rad/s)/(m/s^2)
imu.gyro.angle_rand_walk = 4.654e-5*ones(1,3); %aka noise density ((rad/s)/sqrt(Hz))
imu.gyro.bias_inst = [0, 0, 0]; %rad/s %need Allan Variance data to find this number
imu.gyro.bias_inst_filter_num_coeffs = 1;
imu.gyro.bias_inst_filter_den_coeffs = [1, -0.5];
imu.gyro.rate_rand_walk = [0, 0, 0]; %((rad/s)*sqrt(Hz)) %need Allan Variance data to find this number
imu.gyro.temp_bias = [0, 0, 0]; %(rad/s)/C
imu.gyro.temp_scale_factor = [0, 0, 0]; % %/C

imu.mag.max_read = 2500;
imu.mag.res = 0.3; %(uT)/LSB
imu.mag.const_bias = [0, 0, 0]; %uT
imu.mag.axes_skew = 100*eye(3);
imu.mag.white_noise_psd = 0.2*ones(1,3); %aka noise density, (uT)/sqrt(Hz)
imu.mag.bias_inst = [0, 0, 0]; %uT %need Allan Variance data to find this number
imu.mag.bias_inst_filter_num_coeffs = 1;
imu.mag.bias_isnt_filter_den_coeffs = [1, -0.5];
imu.mag.rand_walk = [0, 0, 0]; %(uT)*sqrt(Hz) %need Allan Variance data to find this number
imu.mag.temp_bias = [0, 0, 0]; %uT/C
imu.mag.temp_scale_factor = [0, 0, 0]; % %/C

%TODO - do this in a smarter way
dvl.pool_depth = 2.25; %[m]
dvl.start_depth = 0.05; %[m] 

% dvl.noise_sigma = [0.01, 0.01, 0.015]'; %noise standard deviation 
% dvl.bias_sigma_ss = 0.01; %steady-state standard deviation of bias
dvl.bias_dt = 0.01; %update rate for bias update (dt_control)
dvl.noise_sigma = [0 0 0]';
dvl.bias_tau = 300;
dvl.bias_sigma_ss = 0;

Sensors.dvl = dvl;
Sensors.imu = imu;
end