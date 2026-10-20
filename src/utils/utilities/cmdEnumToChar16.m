function cmd_char = cmdEnumToChar16(cmd_id)

%This list must match the Command.msg definition
IDLE=0;
DRIVE_TO_WORLD_WAYPOINT=1;
DRIVE_TO_WORLD_WAYPOINT_SEEKING=2;
TRACK_OBJECT_WAYPOINT=3;
DURATION_TRICK=4;
DISTANCE_TRICK=5;

%replace the full cmd names with 16 char shorthands
switch cmd_id
    case DRIVE_TO_WORLD_WAYPOINT
        cmd_id = 'drv_to_world_wp_';
    case DRIVE_TO_WORLD_WAYPOINT_SEEKING
        cmd_id = 'drv_to_wp_seek__';
    case 'idle'
        cmd_id = 'idle____________';
    case 'track_object_waypoint'
        cmd_id = 'track_obj_wp____';
    case DURATION_TRICK
        cmd_id = 'duration_trick__';
    case DISTANCE_TRICK
        cmd_id = 'distance_trick__';
    case IDLE
        cmd_id = 'idle____________';
    otherwise
        cmd_id = 'idle____________';
end

cmd_char = int8(cmd_id);

end