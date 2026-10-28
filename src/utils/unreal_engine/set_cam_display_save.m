function scene_config = set_cam_display_save(scene_config, display_LRBO, save_LRBO)
    scene_config.cameras.leftCamera.save_flag = save_LRBO(1);
    scene_config.cameras.rightCamera.save_flag = save_LRBO(2);
    scene_config.cameras.bottomCamera.save_flag = save_LRBO(3);
    scene_config.cameras.observerCamera.save_flag = save_LRBO(4);

    scene_config.cameras.leftCamera.display_flag = display_LRBO(1);
    scene_config.cameras.rightCamera.display_flag = display_LRBO(2);
    scene_config.cameras.bottomCamera.display_flag = display_LRBO(3);
    scene_config.cameras.observerCamera.display_flag = display_LRBO(4);
end