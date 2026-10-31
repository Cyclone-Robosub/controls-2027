function [cmd, integrator_reset, Rb_error, qib_u, rate_injector_setpoints, rate_injector_flags] = cmdFromJoystick(joystick_input, X, wb_tuning, dRb_tuning)
%{
This function reads the joystick and translates it to the expected commands
and inputs.

=== qib_u ===
yaw_u - Yaw target based on the robot's current yaw when the yaw signal
drops to zero.
pitch_u - Pitch target is always zero, may be ignored by injectors.
roll_u - Roll target is always zero, may be ignored by injectors.

=== Rb_error ===
To Do - used for altitude control and setpoint

=== cmd ===
Typically doesn't matter because the injectors are in use, sometimes
changes to ff duration trick depending on button states.

=== rate_injector_setpoints, rate_injector_flags ===
dRb_x
dRb_y
dRb_z
dwbx (roll)
dwby (pitch)
dwbz (yaw)


%}

x_joy = joystick_state.x;
y_joy = joystick_state.y;
rise = joystick_state.rise;
sink = joystick_state.sink;
yaw = joystick_state.yaw;
pitch = joystick_state.pitch;

rate_injector_flags = logical([x_joy;y_joy;rise+sink;yaw;pitch]);
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
