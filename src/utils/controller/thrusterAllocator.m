function FT_cmd_list = thrusterAllocator(FT_moment_list, FT_force_list, max_thruster_force)

%Eventually we want a smarter way to do this

FT_cmd_list = FT_moment_list + FT_force_list;
FT_cmd_list = max(-max_thruster_force, min(FT_cmd_list, max_thruster_force));

end