function [enable, result_msg] = statusKwdToBool(cmd_status, msg_template)

%{
This function populates the Results message for sys-arch.

Inputs:
cmd_status [4x1 int8]

Outputs:
enable [1x1 bool]
results_msg [SL_Bus_custom_interfaces_Result]
    .status [1x1 bool]


%}

% Check the message definition file for CommandResult to verify these
SUCCESS=uint8(0);
FAILURE=uint8(1);
result_msg = msg_template;

switch char(cmd_status')
    case 'SUCC'
        enable = true;
        result_msg.state = SUCCESS;
    case 'FAIL'
        enable = true;
        result_msg.state = FAILURE;
    case 'RUNN'
        enable = false;
        result_msg.state = FAILURE;
    otherwise
        enable = false;
        result_msg.state = FAILURE;
end

end