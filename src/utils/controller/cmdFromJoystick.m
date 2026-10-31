function [cmd, integrator_reset, Rb_error, qib_u, rate_injector_setpoints, rate_injector_flags, debug] =...
    cmdFromJoystick(joystick_state, X, wb_tuning, dRb_tuning,Sensors)
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

%persistent vars
persistent Ri_u Eul_u alt_u
if(isempty(Ri_u))
    Ri_u = X.Ri;
end
if(isempty(Eul_u))
    yaw_u = X.Eul(3);
    Eul_u = [0;0;yaw_u];
end
if(isempty(alt_u))
    alt_u = Sensors.dvl_alt;
end

x_joy = joystick_state.x; %double, range -1,1
y_joy = joystick_state.y; %double, range -1,1
rise = joystick_state.rise; %
sink = joystick_state.sink;
roll = 0; %not controlled by joystick, but needs placeholder for joystickRateInjector
pitch = joystick_state.pitch;
yaw = joystick_state.yaw;


%set the rate injector flag true, if the setpoint is nonzero
rate_injector_flags = logical([x_joy;y_joy;rise+sink;roll;pitch;yaw]);

wb_e = [0 0 0]';
dRb_e = [0 0 0]';

%translation
dRb_e(1)=dRb_tuning(2-logical(1+sign(x_joy)),1)*x_joy;
dRb_e(2)=dRb_tuning(2-logical(1+sign(y_joy)),2)*y_joy;
z_joy = sink-rise; %resolve 2 button input
dRb_e(3)=dRb_tuning(2-logical(1+sign(z_joy)),3)*z_joy;

%rotation
wb_e(1) = 0;
wb_e(2) = wb_tuning(2-logical(1+sign(pitch)),2)*pitch;
wb_e(3) = wb_tuning(2-logical(1+sign(yaw)),3)*yaw;

rate_injector_setpoints = [dRb_e;wb_e];

%if the vehicle is being commanded to yaw, overwrite the yaw setpoint
if(rate_injector_flags(6))
    yaw_u = X.Eul(3);
    Eul_u = [0;0;yaw_u];
end

%if the vehicle is being commanded to translate, overwrite pos setpoint
if(any(rate_injector_flags(1:3)))
    Ri_u = X.Ri;
end
if(rate_injector_flags(3))
    alt_u = Sensors.dvl_alt;
end

qib_u = eulToQuat(Eul_u);

%Rb_error
Rb_u = X.Cbi*Ri_u;
Rb_error = Rb_u - X.Rb;
Rb_error(3) = Sensors.dvl_alt - alt_u;

%if roll or pitch s large, DON'T overwrite Rb_error(3)

if(any(rate_injector_flags))
    integrator_reset = true;
else
    integrator_reset= false;
end

default_cmd.cmd_id = int8('drv_to_world_wp_');
default_cmd.wp = zeros(6,1);
default_cmd.wp_mask = zeros(6,1);
default_cmd.wp_tol = zeros(6,1);
default_cmd.hold_time = 0;
default_cmd.obj_id = int8('________________');
default_cmd.conf = 0;
default_cmd.trick_id = int8('________________');
default_cmd.exec_timeout = 0;

%barrel roll
if(logical(joystick_state.cross_button))
    default_cmd.trick_id = int8('barrel_roll_____');
elseif(logical(joystick_state.square_button))
    default_cmd.trick_id = int8('somersault______');
end

cmd = default_cmd;
debug = Rb_error;
end
