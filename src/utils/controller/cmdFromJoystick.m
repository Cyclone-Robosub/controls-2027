function [cmd, integrator_reset, Rb_error, qib_u, rate_injector_setpoints, rate_injector_flags] = cmdFromJoystick(joystick_input, X)
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




end
