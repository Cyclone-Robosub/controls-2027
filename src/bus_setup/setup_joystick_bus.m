%{
Bus to store joystick inputs.
%}

joystick_bus = Simulink.Bus;

el = Simulink.BusElement;
el.Name = 'x';
el.Dimensions = [1 1];
joystick_bus.Elements(end+1) = el;

el = Simulink.BusElement;
el.Name = 'y';
el.Dimensions = [1 1];
joystick_bus.Elements(end+1) = el;

el = Simulink.BusElement;
el.Name = 'rise';
el.Dimensions = [1 1];
joystick_bus.Elements(end+1) = el;

el = Simulink.BusElement;
el.Name = 'sink';
el.Dimensions = [1 1];
joystick_bus.Elements(end+1) = el;

el = Simulink.BusElement;
el.Name = 'yaw';
el.Dimensions = [1 1];
joystick_bus.Elements(end+1) = el;

el = Simulink.BusElement;
el.Name = 'pitch';
el.Dimensions = [1 1];
joystick_bus.Elements(end+1) = el;

el = Simulink.BusElement;
el.Name = 'cross_button';
el.Dimensions = [1 1];
joystick_bus.Elements(end+1) = el;

el = Simulink.BusElement;
el.Name = 'square_button';
el.Dimensions = [1 1];
joystick_bus.Elements(end+1) = el;

el = Simulink.BusElement;
el.Name = 'triangle_button';
el.Dimensions = [1 1];
joystick_bus.Elements(end+1) = el;

el = Simulink.BusElement;
el.Name = 'circle_button';
el.Dimensions = [1 1];
joystick_bus.Elements(end+1) = el;

el = Simulink.BusElement;
el.Name = 'dpad_down';
el.Dimensions = [1 1];
joystick_bus.Elements(end+1) = el;

el = Simulink.BusElement;
el.Name = 'dpad_left';
el.Dimensions = [1 1];
joystick_bus.Elements(end+1) = el;

el = Simulink.BusElement;
el.Name = 'dpad_up';
el.Dimensions = [1 1];
joystick_bus.Elements(end+1) = el;

el = Simulink.BusElement;
el.Name = 'dpad_right';
el.Dimensions = [1 1];
joystick_bus.Elements(end+1) = el;

el = Simulink.BusElement;
el.Name = 'bumper_left';
el.Dimensions = [1 1];
joystick_bus.Elements(end+1) = el;

el = Simulink.BusElement;
el.Name = 'bumper_right';
el.Dimensions = [1 1];
joystick_bus.Elements(end+1) = el;

el = Simulink.BusElement;
el.Name = 'start';
el.Dimensions = [1 1];
joystick_bus.Elements(end+1) = el;

el = Simulink.BusElement;
el.Name = 'select';
el.Dimensions = [1 1];
joystick_bus.Elements(end+1) = el;

el = Simulink.BusElement;
el.Name = 'joystick_press_left';
el.Dimensions = [1 1];
joystick_bus.Elements(end+1) = el;

el = Simulink.BusElement;
el.Name = 'joystick_press_right';
el.Dimensions = [1 1];
joystick_bus.Elements(end+1) = el;

clear el