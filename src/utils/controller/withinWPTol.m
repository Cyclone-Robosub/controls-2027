function tf = withinWPTol(X, X_u, cmd)
    %{
    Return true if the vehicle is within the specified tolerance of the
    waypoint. Note, that to prevent uncontrolled behavior, STATES USING THE
    IDLE WAYPOINT ARE ALSO USED TO VALIDATE WITHIN TOLERANCE.
    %}
    Ri = X.Ri;
    qib = X.qib;

    Ri_u = X_u.Ri;
    qib_u = X_u.qib;
    
    R_error = abs(Ri - Ri_u);
    quat_error = quatError(qib, qib_u);
    eul_error = abs(quatToEul(quat_error));
    
    
    tf_mask = [R_error;eul_error] < cmd.wp_tol;
    tf = all(tf_mask); 

end %withinWPTol