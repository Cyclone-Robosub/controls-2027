function [wb_e, dRb_e] = joystickRateInjector(cmd, wb_e, dRb_e, joystick_rate_overwrite_flags, wb_error_inject, dRb_error_inject)
%{
This function acts by modifying the velocity and angular velocity error
based on the joystick state before they are fed into the corresponding PID controllers. 

Inputs:
cmd (cmd_bus) - only cmd.trick_id is used to command either a front flip or
a barrel roll based on joystick inputs
wb_e (3x1 double) - error from upstream quat PID
dRb_e (3x1 double) - error from upstream position PID

%}


%delete this for the joystick version
if(joystick_rate_overwrite_flags)
    wb_e = wb_error_inject;
    dRb_e = dRb_error_inject;
end

%same for position
wb_e = wb_e*(~joystick_rate_overwrite_flags(4:6)) + wb_error_inject*joystick_rate_overwrite_flags(4:6);
