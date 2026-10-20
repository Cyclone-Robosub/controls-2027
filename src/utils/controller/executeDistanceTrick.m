function [cmd_status, hold_timer, X_u, hold_timer_start_time, cmd_specific_wp, debug] = ...
            executeDistanceTrick(cmd, idle_wp, X, hold_timer_start_time,...
            t, new_cmd_reset, cmd_specific_wp)

persistent body_relative_wp
persistent wp_defined_latch

if(isempty(body_relative_wp))
    body_relative_wp = [0; 0; 0]; %[xb yb zb]
end
if(isempty(wp_defined_latch))
    wp_defined_latch = false;
end


%find target states, setting uncontrolled states to the idle wp
%target quat
Eul_u = idle_wp(4:6).*(~cmd.wp_mask(4:6)) +...
    cmd.wp(4:6).*(cmd.wp_mask(4:6));

%convert to the quaternion
qib_u = eulToQuat(Eul_u);

%target position
Rb_u = cmd.wp(1:3);

if(~wp_defined_latch)
    %this keeps triggering every line for some reason
    body_relative_wp = X.Cib*(Rb_u + X.Rb);
    wp_defined_latch = true;
end
Ri_u = body_relative_wp;

%pack up state bus
X_u.Ri = Ri_u;
X_u.Rb = X.Cbi*Ri_u; %target waypoint in body frame at CURRENT attitude
X_u.Eul = quatToEul(qib_u);
X_u.qib = qib_u;
X_u.Cib = quatToRotm(qib_u);
X_u.Cbi = X_u.Cib';
X_u.dRi = zeros(3,1);
X_u.dRb = zeros(3,1);
X_u.wb = zeros(3,1);
X_u.wi = zeros(3,1);
X_u.ddRi = zeros(3,1);
X_u.ddRb = zeros(3,1);

%update the hold timer if we are at our waypoint
if(withinWPTol(X,X_u, cmd))
    hold_timer = t - hold_timer_start_time;
else
    %otherwise keep pushing the start time so the hold timer starts
    %small on the next timestep
    hold_timer_start_time = t;
    hold_timer = 0;
end

%see if the hold_time has been met so we can return a success
if(hold_timer >= cmd.hold_time)
    cmd_status = int8('SUCC');
    hold_timer_start_time = t;
    wp_defined_latch = false;
else
    %otherwise report that we are still running
    cmd_status = int8('RUNN');
end
debug = double(new_cmd_reset);

end





