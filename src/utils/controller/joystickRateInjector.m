function [wb_e, dRb_e] = joystickRateInjector(cmd, wb_e, dRb_e, joystick_rate_overwrite_flags, wb_error_inject, dRb_error_inject)
%{
This function acts by modifying the velocity and angular velocity error
based on the joystick state before they are fed into the corresponding PID controllers. 

Inputs:
cmd (cmd_bus) - only cmd.trick_id is used to command either a front flip or
a barrel roll based on joystick inputs
wb_e (3x1 double) - error from upstream quat PID
dRb_e (3x1 double) - error from upstream position PID
joystick_rate_overwrite_flags (6x1 bool) - if true, error from PID is
overwritten by error setpoint from joystick
wb_error_inject (3x1 double) - error setpoint from joystick for wb
dRb_error_inject (3x1 double) - error setpoint from joystick for dRb

%}

wb_e = wb_e(:);
dRb_e = dRb_e(:);
joystick_rate_overwrite_flags = joystick_rate_overwrite_flags(:);
wb_error_inject = wb_error_inject(:);
dRb_error_inject = dRb_error_inject(:);

%special trick inputs
if(strcmp(char(cmd.trick_id),'barrel_roll_____'))
    wb_error_inject(1) = 1; %add overwrite for roll rate w/ error
    joystick_rate_overwrite_flags(4) = true;
    dRb_error_inject(3) = 0;
    joystick_rate_overwrite_flags(3) = true;
elseif(strcmp(char(cmd.trick_id),'somersault______'))
    wb_error_inject(2) = 1; %add overwrite for pitch rate w/ error
    joystick_rate_overwrite_flags(5) = true;
    dRb_error_inject(3) = 0;
    joystick_rate_overwrite_flags(3) = true;
end

%TODO - think of a smarter way to block z-axis control when Manny crooked



%if the overwrite flag is true, use the state from joystick, otherwise PID
wb_e = wb_e.*(~joystick_rate_overwrite_flags(4:6)) + wb_error_inject.*joystick_rate_overwrite_flags(4:6);
dRb_e = dRb_e.*(~joystick_rate_overwrite_flags(1:3)) + dRb_error_inject.*joystick_rate_overwrite_flags(1:3);
