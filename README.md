# Overview
The purpose of this Matlab/Simulink project is the development, testing, and validation
of software for controls, sensor fusion, computer vision, and software-core. The project
contains many variants of the same Simulink models meant to test different parts of the
project under different conditions and subsystem readiness. 

The primary deliverable from the controls team is one or more ROS2 Nodes. At minimum, this includes
the `Matlab Node`, which contains the control loop and DVL/IMU sensor fusion. It remains to
be determined how much of the vision system lives in the `Matlab Node` or external ROS2 nodes. 

# Quick Start
1. Open the Project
In Matlab, open the `controls-2027.prj` file in the repo root folder. If prompted
to trust project authors, choose Yes so the project `startup.m` file can run.

2. Open `init.m`
Located at `<root>/src/inits/`, or opened by running `open init.m` in the Command Window.

3. Choose parameters, tunings, initial conditions, and simulation settings. See the corresponding
section in `init.m`.

4. Choose a model using the `model_name` variable.

5. Run `init.m`. 

6. Modify the post processing section as needed.

# Model Guide
All models can be launched from the same `init.m` file at `<root>/src/inits/`. 
Models can be found at `<root>/src/models/`. The subystem blocks that make up models
can be found under `<root>/src/subsystems/`. 
This script sets up the pre-requesite workspace variables required to run the sim, 
so it is not recommended to run the model directly. Here is a list of the all 
existing or planned models as well as a description of their purpose. 

## Dynamics_SIM
Open loop system dynamics for validation and debugging. Input force an be set using
either `S.FT_list_inject` or `S.pwm_list_inject` depending on the state of the
`S.overwrite_FT_list_flag and `S.overwrite_pwms_flag flags.

### Requirements
ROS - No\
Unreal - No\
Ubuntu-Ros Container - No

## Dynamics_UCS
Same as `Dynamics_SIM`, but the output state is piped into the `unreal_cosim` subystem for
analysis. 

### Requirements
ROS - No\
Unreal - Yes\
Ubuntu-Ros Container - No\
Robot - No


## Matlab_Controller_SIM
Full controller simulated including a minimal copy of Mission Manager. This model
is designed to be run entirely in Matlab with no code running externally in Unreal Engine,
Software-Core containers, or on hardware. This model is useful for controller 
development and validation, but has limited value to vision processing, sensor
fusion, or Mission Manager development because the outputs of the vision stack must be faked.

### Requirements
ROS - Yes\
Unreal - No\
Ubuntu-Ros Container - No\
Robot - No

## Matlab_Controller_UCS
Full controller simulated including a minimal copy of Mission Manager. This model
is designed to be run entirely in Matlab + the Unreal Executable with no code running in
Software-Core containers, or on hardware. This model is useful for controller and 
vision processing development, but runs much slower than Full_Controller_SIM due
to the vision system overhead.

### Requirements
ROS - Yes\
Unreal - No\
Ubuntu-Ros Container - No\
Robot - No

## Full_Controller_SIM
Similar to `Matlab_Controller_SIM`, but uses the real Mission Manager running in the
Software Team's `ubuntu-ros` container. Useful for testing the Controller Node
and Mission Manager

### Requirements
ROS - Yes\
Unreal - No\
Ubuntu-Ros Container - Yes\
Robot - No

## Full_Controller_UCS
Similar to `Full_Controller_SIM`, but includes the Unreal Cosim. This model is the most complicated
to run because it requires the Ubuntu-Ros container and Unreal, but it is the most
complete sim involving the most real systems.

### Requirements
ROS - Yes\
Unreal - Yes\
Ubuntu-Ros Container - Yes\
Robot - No

## Matlab_Controller_HIL
Dynamics and sensor models is replaced by ROS connections to the real robot, but Software Team's
Mission Manager is not used. This is useful for collecting parameter estimation data and tuning.

ROS - Yes\
Unreal - No\
Ubuntu-Ros Container - No\
Robot - Yes


## Full_Controller_HIL
Dynamics and sensor models is replaced by ROS connections to the real robot.
The real Mission Manager is used.

ROS - Yes\
Unreal - No\
Ubuntu-Ros Container - No\
Robot - Yes

