function Floor = defFloor()
%{
Defines the inertial position -> pool depth lookup table.

These values will be used in a lookup table to simulate the altitude
sensor. A zi value of zero corresponds with the waters surface level.
%}

%% Flat
xi = [0 1]; 
yi = [0 1];
depth_surface = 2*ones(2,2); %2m depth, constant across the grid

Floor.xi = xi;
Floor.yi = yi;
Floor.depth_surface = depth_surface;

%% Sloped
%TODO

end