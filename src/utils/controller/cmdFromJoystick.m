function [cmd, integrator_reset, Rb_error, qib_u, rate_injector_setpoints, rate_injector_flags] =...
    cmdFromJoystick(joystick_state, X, wb_tuning, dRb_tuning)
%{
This function reads the joystick and translates it to the expected commands
and inputs. When the user is commanding body x, y, or z the xy inertial
waypoint and altitude setpoint are continuously updated. When the user
releases the sticks, these setpoints are made persistent. Altitude control
may be unreliable if the robot is operated at large angles or over uneven
surfaces. 

When the user commands yaw, the yaw setpoint is continuously updated and
made persistent upon release as well. When not being commanded, the roll
and pitch setpoint default to zero. 

The PID integrators are reset continuously whenever the user is commanding
the robot.

qib_u and Rb_error are calculated based on the persistent yaw setpoint, xy
setpoint, and altitude setpoint. The altitude to Rb_error conversion may
give unexpected results at large angles or over uneven terrain. 

%}

x_joy = joystick_state.x; %double, range -1,1
y_joy = joystick_state.y; %double, range -1,1
rise = joystick_state.rise; %
sink = joystick_state.sink;
roll = 0; %not controlled by joystick, but needs placeholder for joystickRateInjector
pitch = joystick_state.pitch;
yaw = joystick_state.yaw;


%set the rate injector flag true, if the setpoint is nonzero
rate_injector_flags = logical([x_joy;y_joy;rise+sink;roll;pitch;yaw]);

%map joystick states to rates 
wb_e_inject = [0;pitch;yaw]

%{
%sensitivities
r_sensitivity = T.js_wb_e;
t_sensitivity = T.js_dRb_e;

%x_body and y_body mapping
x = y_joy;
y = x_joy;

wb_e = [0 0 0]';
dRb_e = [0 0 0]';

%translation
dRb_e(1)=t_sensitivity(2-logical(1+sign(x)),1)*x;
dRb_e(2)=t_sensitivity(2-logical(1+sign(y)),2)*y;
z = sink-rise;
dRb_e(3)=t_sensitivity(2-logical(1+sign(z)),3)*z;

%rotation
wb_e(2) = r_sensitivity(2-logical(1+sign(pitch)),2)*pitch;
wb_e(3) = r_sensitivity(2-logical(1+sign(yaw)),3)*yaw;

%}

end
