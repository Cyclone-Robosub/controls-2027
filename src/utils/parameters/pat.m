function J = pat(I,R_obj2newpoint,m)
%{
Uses the parallel axis theorem to shift the inertia matrix from one point
to another.
%}

%calculate J
J = I + m*((dot(R_obj2newpoint,R_obj2newpoint)*eye(3)...
    - R_obj2newpoint*R_obj2newpoint'));

end