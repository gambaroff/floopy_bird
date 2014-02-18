define_stage :demo do
  # render_with :my_renderer
  requires :pipe_layer

  curtain_up do
    @score_keeper = create_actor :score, x: viewport.width/2, y: 40, font_size: 50
    @bird = create_actor :bird, x: 10, y:viewport.height/2
    @bird.input.map_input '+space' => :flap
    @bird.when(:hit_ground) { bird_death }

    create_actor :background

    pipe_layer.when(:lay_top_pipe) { |args| create_actor :top_pipe, args } 
    pipe_layer.when(:lay_bottom_pipe) { |args| create_actor :bottom_pipe, args }
    pipe_layer.when(:score_zone) { |args| create_actor :score_zone, args }

    input_manager.reg :down, KbSpace do
      @bird.waiting = false
    end

    on_collision_of :bird, [:top_pipe, :bottom_pipe] do |bird, pipe|
      bird_death
    end

    on_collision_of :bird, :score_zone do |bird, score_zone|
      @score_keeper.score = score_zone.score
    end

    viewport.stay_centered_on @bird, 
      offset_x: 300, 
      offset_y: 0, 
      x_chain_length: 0, 
      y_chain_length: viewport.height

  end

  helpers do
    def bird_death
      fire :restart_stage
    end
  end
end
