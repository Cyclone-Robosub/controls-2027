function P = createParameters()
%{
Runs the necessary scripts and functions to create the simulation parameter
structure P. Parameters are values associated with the vehicle (e.g. Manny
vs Manatwo). This is distinct from tuning parameters T, initial conditions
I, simulation settings S, and Unreal Scene configurations.

The parameter structure must be constant be fully defined before sim() is
called to avoid codegen issues.
%}

P.Geometry = defGeometry(); %geometry definitions from Onshape & measurement
P.Constants = defConstants(); %physical constants
P.Volume = calcVolumeData(P.Geometry); %center of volume, total volume, etc
P.Mass = calcMassData(P.Geometry); %center of mass, inertia, etc
P.Wrench = calcWrenchData(P.Geometry, P.Mass); %force and moment wrench due to thrusters about CoM
P.Hydro = calcHydroData(P.Geometry, P.Constants); %added mass and inertia, drag wrench
P.Sensors = defSensors(); %constants related to sensor modeling
end