function X_pid = calcDerivedPIDStates(Rb_pid, dRb_pid, qib_pid, wb_pid, X)

%current rotation matrices (NOT pid targets)
Cib = X.Cib;

%pack into bus (matches setup_X_bus.m))
X_pid.Ri = Cib*Rb_pid;
X_pid.Rb = Rb_pid;
X_pid.Eul = quatToEul(qib_pid);
X_pid.qib = qib_pid;
X_pid.Cib = quatToRotm(qib_pid);
X_pid.Cbi = quatToRotm(qib_pid)';
X_pid.dRi = Cib*dRb_pid;
X_pid.dRb = dRb_pid;
X_pid.wb = wb_pid;
X_pid.wi = Cib*wb_pid;
X_pid.ddRi = zeros(3,1);
X_pid.ddRb = zeros(3,1);

end