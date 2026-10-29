
function [pose_inputs, mode_inputs, trick_inputs] = gamepad_parser(input)
%{
Rearranges the order of the inputs to match downstream parsers.
%}

pose_inputs = [input.x;
               input.y;
               input.rise;
               input.sink;
               input.yaw;
               input.pitch];

% mode_inputs = [input.cross_button;
%                input.square_button;
%                input.triangle_button;
%                input.circle_button;
%                input.dpad_down;
%                input.dpad_left;
%                input.dpad_up;
%                input.dpad_right;
%                input.bumper_left;
%                input.bumper_right;
%                input.start;
%                input.select;
%                input.joystick_press_left;
%                input.joystick_press_right];

mode_inputs = input.circle_button;
trick_inputs = [input.cross_button;input.square_button;input.triangle_button];
end