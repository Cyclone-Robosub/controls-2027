function Volume = calcVolumeData(Geometry)
%{
Calculates the total volume and the position of the center of volume. Also
defines the position and size a fictitious volume that can be tuned 
manually to cause the buoyant moment and force in sim to match experimental
data.

Inputs:
Geometry structure created by defGeometry.m

Outputs: 
Volume structure containing fields
    V_total - total volume
    Ro_cv - calculated center of volume position in the Onshape coordinate
    frame


%}
end