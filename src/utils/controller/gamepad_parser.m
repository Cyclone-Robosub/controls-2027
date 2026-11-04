
function [joystick_state] = gamepad_parser(input)
%{
Rearranges the order of the inputs to match downstream parsers
%}

%Pack into the joystick_bus (setup_joystick_bus.m)
joystick_state.x = double(input.y*(abs(input.y)>.1)); %switched in ros message
joystick_state.y = double(input.x*(abs(input.x)>.1));
joystick_state.rise = double(input.rise*(input.rise>.1));
joystick_state.sink = double(input.sink*(input.sink>.1));
joystick_state.yaw = double(input.yaw*(abs(input.yaw)>.1));
joystick_state.pitch = -double(input.pitch*(abs(input.pitch)>.1)); %negative to be more intuitive
joystick_state.cross_button = double(input.cross_button);
joystick_state.square_button = double(input.square_button);
joystick_state.triangle_button = double(input.triangle_button);
joystick_state.circle_button = double(input.circle_button);
joystick_state.dpad_down = double(input.dpad_down);
joystick_state.dpad_left = double(input.dpad_left);
joystick_state.dpad_up = double(input.dpad_up);
joystick_state.dpad_right = double(input.dpad_right);
joystick_state.bumper_left = double(input.bumper_left);
joystick_state.bumper_right = double(input.bumper_right);
joystick_state.start = double(input.start);
joystick_state.select = double(input.select);
joystick_state.joystick_press_left = double(input.joystick_press_left);
joystick_state.joystick_press_right = double(input.joystick_press_right);
end