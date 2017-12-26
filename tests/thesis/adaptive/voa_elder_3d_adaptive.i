[Mesh]
  file = '../../mesh/elder_3d_coarse.msh'
  second_order = true
[]

[Variables]
  [./temp]
    order = SECOND
    family = LAGRANGE
    initial_condition = 0
  [../]

  [./vel_x]
    order = FIRST
    family = LAGRANGE
    initial_condition = 0
  [../]

  [./vel_y]
    order = FIRST
    family = LAGRANGE
    initial_condition = 0
  [../]

  [./vel_z]
    order = FIRST
    family = LAGRANGE
    initial_condition = 0
  [../]
[]

[AuxVariables]
  [./Peclet]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./CFL]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Kernels]
  [./momentum_x]
    type = VelocityDiffusion_half
    variable = vel_x
    temperature = temp
    component_1 = 1
    component_2 = 0
    sign = 1
    scale = 1.0
  [../]

  [./momentum_y]
    type = VelocityDiffusionZ
    variable = vel_y
    temperature = temp
  [../]

  [./momentum_z]
    type = VelocityDiffusion_half
    variable = vel_z
    temperature = temp
    component_1 = 1
    component_2 = 2
    sign = 1
    scale = 1.0
  [../]

  [./diff]
    type = ExampleDiffusion
    variable = temp
    diffusivity = 1.0
  [../]

  [./conv]
    type = ExampleConvection
    variable = temp
    velocity_x = vel_x
    velocity_y = vel_y
    velocity_z = vel_z
  [../]

  [./euler]
    type = ExampleTimeDerivative
    variable = temp
    time_coefficient = 1.0
  [../]
[]

[BCs]
  [./no_flow_1]
    type =  DirichletBC
    variable = vel_x
    boundary = 'left right'
    #boundary = 'front back left right top bottom'
    value = 0
  [../]

  [./no_flow_2]
    type = DirichletBC
    variable = vel_y
    boundary = 'top bottom_in bottom_out'
    #boundary = 'front back left right top bottom'
    value = 0
  [../]

  [./no_flow_3]
    type = DirichletBC
    variable = vel_z
    boundary = 'front back'
    #boundary = 'front back left right top bottom'
    value = 0
  [../]

  [./top_temp]
    type = DirichletBC
    variable = temp
    boundary = 'top'
    value = 0.0
  [../]

  [./bottom_temp]
    type = DirichletBC
    variable = temp
    boundary = 'bottom_in'
    value = 1.0
  [../]
[]

[AuxKernels]
  [./cell_peclet]
    type = CellPeclet
    variable = Peclet
    velocity_x = vel_x
    velocity_y = vel_y
    velocity_z = vel_z
  [../]
  [./cell_CFL]
    type = CellCFL
    variable = CFL
    velocity_x = vel_x
    velocity_y = vel_y
    velocity_z = vel_z
  [../]
[]

[Materials]
  [./ra_output]
    type = RayleighMaterial
    block = 'layer1'
    function = 20.0
    min = 0
    max = 0
    seed = 363192
    #outputs = exodus
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
    solve_type = 'NEWTON'
    petsc_options_iname = '-pc_type -sub_pc_type -snes_linesearch_type -ksp_gmres_restart -pc_gamg_sym_graph'
    petsc_options_value = 'gamg hypre cp 351 true'
  [../]
[]

[Executioner]
  type = Transient
  #solve_type = PJFNK
  #num_steps = 10000
  #dt = 2e-5
  #dtmin = 0.001
  start_time = 0
  end_time = 1.1e-1
  l_max_its = 40
  nl_max_its = 30
  #trans_ss_check = true
  #ss_check_tol = 1e-06
  #ss_tmin = 30
  nl_rel_tol = 1e-10
  nl_abs_tol = 1e-12

  [./TimeStepper]
    type = PostprocessorDT
    postprocessor = CFL_time_step
    dt = 1e-5
    scale = 2e-2
    factor = 2e-6
  [../]

  [./TimeIntegrator]
    type = CrankNicolson
  [../]
[]

[Adaptivity]
  marker = errorfrac
  [./Indicators]
    [./error]
      type = PecletIndicator
      variable = Peclet
    [../]
  [../]

  [./Markers]
    [./errorfrac]
      type = ErrorToleranceMarker
      refine = 0.85
      coarsen = 0.4
      indicator = error
    [../]
  [../]
[]

[Postprocessors]
  [./Nusselt]
    type = SideFluxAverage
    variable = temp
    boundary = 'top'
    diffusivity = 1.0
    outputs = 'csv console'
  [../]

  [./alive_time]
    type = PerformanceData
    event = ALIVE
    column = total_time_with_sub
  [../]

  [./CFL_time_step]
    type = LevelSetCFLCondition
    velocity_x = vel_x
    velocity_y = vel_y
    velocity_z = vel_z
    outputs = 'csv'
  [../]

  [./L2_temp]
    type = ElementL2Norm
    variable = temp
    outputs = 'csv'
  [../]

  [./L2_vel_x]
    type = ElementL2Norm
    variable = vel_x
    outputs = 'csv'
  [../]

  [./L2_vel_y]
    type = ElementL2Norm
    variable = vel_y
    outputs = 'csv'
  [../]

  [./L2_vel_z]
    type = ElementL2Norm
    variable = vel_z
    outputs = 'csv'
  [../]

  [./max_Peclet]
    type = ElementExtremeValue
    variable = Peclet
  [../]

  [./max_CFL]
    type = ElementExtremeValue
    variable = CFL #This is the orginal CFL number (approximated with hmin)
  [../]

  [./res]
    type = Residual
    execute_on = timestep_end
    residual_type = FINAL
  [../]

  [./mem]
    type = MemoryUsage
    execute_on = timestep_end
    mem_type = physical_memory
    value_type = max_process
  [../]
[]

[Outputs]
  interval = 1
  execute_on = 'timestep_end'
  exodus = true
  csv = true
[]
