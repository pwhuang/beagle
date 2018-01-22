[Mesh]
  file = '../../../mesh/elder_coarse.msh'
  second_order = true
  uniform_refine = 2
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
  [./entropy]
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
    sign = 1.0
    scale = 1.0
  [../]

  [./momentum_y]
    type = VelocityDiffusion_half
    variable = vel_y
    temperature = temp
    component_1 = 0
    component_2 = 0
    sign = -1.0
    scale = 0.0
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
    velocity_z = 0
  [../]

  [./euler]
    type = ExampleTimeDerivative
    variable = temp
    time_coefficient = 1.0
  [../]
[]

[BCs]
  [./no_flux_bc_x]
    type = DirichletBC
    variable = vel_x
    #boundary = 'top bottom_half bottom_out left right'
    boundary = 'left right'
    value = 0
  [../]

  [./no_flux_bc_y]
    type = DirichletBC
    variable = vel_y
    #boundary = 'top bottom_half bottom_out left right'
    boundary = 'top bottom_half bottom_out'
    #boundary = 'top bottom'
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
    boundary = 'bottom_half'
    value = 1.0
  [../]
[]

[AuxKernels]
  [./cell_peclet]
    type = CellPeclet
    variable = Peclet
    velocity_x = vel_x
    velocity_y = vel_y
    velocity_z = 0
  [../]
  [./cell_CFL]
    type = CellCFL
    variable = CFL
    velocity_x = vel_x
    velocity_y = vel_y
    velocity_z = 0
  [../]
  [./entropy]
    type = EntropyProduction
    variable = entropy
    temp = temp
    velocity_x = vel_x
    velocity_y = vel_y
    velocity_z = 0
    T_bar = 16
    deltaT = 8
    alpha = 1.6163e-4
    cf = 4184
    d = 150
  [../]
[]

[Materials]
  [./ra_output]
    type = RayleighMaterial
    block = 'layer1'
    function = 22.832
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
    petsc_options_iname = '-pc_type -sub_pc_type -snes_linesearch_type -ksp_gmres_restart'
    petsc_options_value = 'gamg hypre cp 351'
  [../]
[]

[Executioner]
  type = Transient
  #solve_type = PJFNK
  #num_steps = 10000
  dt = 5e-6
  #dtmin = 0.001
  start_time = 0
  end_time = 5e-2
  l_max_its = 50
  nl_max_its = 30
  #trans_ss_check = true
  #ss_check_tol = 1e-06
  #ss_tmin = 30
  nl_rel_tol = 1e-10
  nl_abs_tol = 1e-12

  #[./TimeStepper]
  #  type = PostprocessorDT
  #  postprocessor = CFL_time_step
  #  dt = 1e-5
  #  scale = 4e-2
  #  factor = 0
  #[../]

  [./TimeIntegrator]
    type = CrankNicolson
  [../]
[]

[Adaptivity]
  marker = errorfrac
  [./Indicators]
    [./error]
      type = PecletIndicator
      variable = entropy
      #function = 0
    [../]
  [../]

  [./Markers]
    [./errorfrac]
      type = ErrorToleranceMarker
      refine = 3.0
      coarsen = 1.0
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

  [./max_Peclet]
    type = ElementExtremeValue
    variable = Peclet
  [../]

  [./max_CFL]
    type = ElementExtremeValue
    variable = CFL #This is the orginal CFL number (approximated with hmin)
  [../]

  [./N_S]
    type = ElementAverageValue
    variable = entropy
  [../]

  [./res]
    type = Residual
    execute_on = timestep_end
    residual_type = FINAL
  [../]
[]

[Outputs]
  execute_on = 'timestep_end'
  csv = true
  [./out]
    type = Exodus
    interval = 500
  [../]
[]
