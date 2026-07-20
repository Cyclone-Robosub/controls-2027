This is the repository for the Cyclone Robosub Controls Team. 

# New User Guide

## First Time Set-Up
Depending on your operating system and various other version shenanigans, some scripts and models may be broken on your machine. Let's start by first checking your setup and installing any necessary dependencies. 

### Open the Project
Launching the Matlab Project is a requirement for various packages to behave correctly. Click the `...` menu on the left (or right) sidebar to open the  `Open Panels` dialog. Click the `Project` panel icon, which looks like a file box. Click on `Open Project`, then select `controls-2027.prj`. The first time you do so you may be prompted to confirm that you trust the authors of the project in order to run the startup scripts. You may notice the project startup scripts move your current working folder and create any missing folders in the repository file system.

### Run the Examples
There are several example models in the `controls-2027/Examples` folder. These examples are intended to verify you can run certain parts of the codebase. There are three examples intended to test your computer's ability to run a) fully simulated models purely in Matlab/Simulink (SIM), b) models that require ROS2 communication like communication with Software Team containers or the robot for hardware-in-loop testing (ROS), and c) models that require Unreal Engine Co-Simulation (UCS). There are also additional models for codegeneration with the CGN name, but these are not intended to be ran directly in Matlab.

Start by running `init_SIM_example.m`. When you do so, a Simulink model called `SIM_example.slx` will open, along with a plot showing the response of an example system. 

Next, run `init_ROS_example.m`. The first time you do so you will receive outputs directly you to install CMake
## Adding Code to the Project
New files you create in the project are not automatically added to the project search path and contained under source control. This is intentional to prevent drafts, temporary scripts for testing code snippets, and data files from bloating the project. When you add a file that you intend to place in the project, you need to right click on the file (or containing folder) in the `Project` panel and select `Add to Project` or `Add to Folder to Project (Including Contents)`. 