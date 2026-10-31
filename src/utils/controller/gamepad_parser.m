
function [joystick_state] = gamepad_parser(input)
%{
Rearranges the order of the inputs to match downstream parsers.
%}

%Pack into the joystick_bus (sese setup_joystick_bus.m)
joystick_state.x = input.x*(abs(input.x)>.1);
joystick_state.y = input.y*(abs(input.y)>.1);
joystick_state.rise = input.rise*(input.rise>.1);
joystick_state.sink = input.sink*(input.sink>.1);
joystick_state.yaw = input.yaw*(abs(input.yaw)>.1);
joystick_state.pitch = input.pitch(abs(input.pitch)>.1);
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
end