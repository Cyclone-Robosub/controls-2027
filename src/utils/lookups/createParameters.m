function P = createParameters()
%{
Runs the necessary scripts and functions to create the simulation parameter
structure P. Parameters are values associated with the vehicle (e.g. Manny
vs Manatwo). This is distinct from tuning parameters, which belong in the
tuning structure T, and Unreal scene configurations which belong in TBD.

The parameter structure must be constant be fully defined before sim() is
called to avoid codegen issues.
%}



P.Geometry = defGeometry(); %geometry definitions from Onshape & measurement
P.Constants = defConstants(); %physical constants
P.Volume = calcVolumeData(); %center of volume, total volume, etc
P.Mass = calcMassData(); %center of mass, inertia, etc
P.Wrench = calcWrenchData(P.Mass); %force and moment wrench due to thrusters about CoM
P.Hydro = calcHydroData(); %added mass and inertia, drag wrench

end