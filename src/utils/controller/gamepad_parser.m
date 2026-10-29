
function [joystick_state, joystick_circle_button] = gamepad_parser(input)
%{
Rearranges the order of the inputs to match downstream parsers.
%}

%Pack into the joystick_bus (sese setup_joystick_bus.m)
joystick_state.x = input.x;
joystick_state.y = input.y;
joystick_state.rise = input.rise;
joystick_state.sink = input.sink;
joystick_state.yaw = input.yaw;
joystick_state.pitch = input.pitch;
joystick_state.cross_button = input.cross_button;
joystick_state.square_button = input.square_button;
joystick_state.triangle_button = input.triangle_button;
joystick_state.circle_button = input.circle_button;
joystick_state.dpad_down = input.dpad_down;
joystick_state.dpad_left = input.dpad_left;
joystick_state.dpad_up = input.dpad_up;
joystick_state.dpad_right = input.dpad_right;
joystick_state.bumper_left = input.bumper_left;
joystick_state.bumper_right = input.bumper_right;
joystick_state.start = input.start;
joystick_state.select = input.select;
joystick_state.joystick_press_left = input.joystick_press_left;
joystick_state.joystick_press_right = input.joystick_press_right;

%Break out the button to switch to and from mission manager mode
joystick_circle_button = input.circle_button;




pose_inputs = [input.x;
               input.y;
               input.rise;
               input.sink;
               input.yaw;
               input.pitch];



mode_inputs = input.circle_button;
trick_inputs = [input.cross_button;input.square_button;input.triangle_button];
end