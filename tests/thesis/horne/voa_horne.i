[Mesh]
  file = '../../mesh/horne.msh'
  #second_order = true
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
  [../]
  [./vel_y]
    order = FIRST
    family = LAGRANGE
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
  [./entropy_therm]
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

  [./entropy_therm]
    type = EntropyProductionTherm
    variable = entropy_therm
    temp = temp
  [../]
[]

[BCs]
  [./no_flux_bc_x]
    type = DirichletBC
    variable = vel_x
    #boundary = 'top bottom_right bottom_left left right'
    boundary = 'left right'
    value = 0
  [../]

  [./no_flux_bc_y]
    type = DirichletBC
    variable = vel_y
    #boundary = 'top bottom_right bottom_left left right'
    boundary = 'bottom_left bottom_right'
    value = 0
  [../]

  [./flux_bc_y]
    type = DirichletBC
    variable = vel_y
    #boundary = 'top bottom_right bottom_left left right'
    boundary = 'top'
    value = 0
  [../]

  [./top_temp]
    type = DirichletBC
    variable = temp
    boundary = 'top bottom_right'
    value = 0.0
  [../]

  [./bottom_temp]
    type = DirichletBC
    variable = temp
    boundary = 'bottom_left'
    value = 1.0
  [../]
[]

[Materials]
  active = 'ra_output'
  [./ra_output]
    type = RayleighMaterial
    block = 'layer1'
    function = 31.62
    min = 0
    max = 0
    seed = 363192
    outputs = out
  [../]
[]

[Preconditioning]
  active = 'FSP'
  [./SMP]
    full = true
    type = SMP
    solve_type = 'NEWTON'
    petsc_options_iname = '-pc_type -sub_pc_type -snes_linesearch_type -ksp_gmres_restart'
    petsc_options_value = 'ksp hypre cp 301'
  [../]

  [./FSP]
    type = FSP
    full = true
    solve_type = 'NEWTON'
    topsplit = 'pt'
    [./pt]
      splitting = 'vel_x vel_y temp'
    [../]
    [./vel_x]
      vars = 'vel_x'
      petsc_options_iname = '-pc_type -sub_pc_type -snes_linesearch_type -ksp_gmres_restart'
      petsc_options_value = 'gamg hypre cp 151'
    [../]
    [./vel_y]
      vars = 'vel_y'
      petsc_options_iname = '-pc_type -sub_pc_type -snes_linesearch_type -ksp_gmres_restart'
      petsc_options_value = 'gamg hypre cp 151'
    [../]
    [./temp]
      vars = 'temp'
      petsc_options_iname = '-pc_type -sub_pc_type -snes_linesearch_type -ksp_gmres_restart'
      petsc_options_value = 'gasm hypre cp 151'
    [../]
  [../]
[]

[Executioner]
  type = Transient
  #solve_type = 'JFNK'
  #abort_on_solve_fail = true
  #num_steps = 80000
  #dt = 0.001
  #dtmin = 0.0001
  start_time = 0
  end_time = 0.25
  l_max_its = 100
  nl_max_its = 50
  trans_ss_check = false
  ss_check_tol = 1e-06
  #ss_tmin = 0.2

  nl_rel_tol = 1e-10
  nl_abs_tol = 1e-12

  [./TimeStepper]
    type = CFLDT
    postprocessor = CFL_time_step
    dt = 1e-7
    activate_time = 1e-7
    max_Ra = 31.62
    cfl = 0.5
    factor = 0
  [../]

  [./TimeIntegrator]
    type = ExplicitEuler #CrankNicolson
  [../]
[]

[Postprocessors]
  [./Nusselt]
    type = SideFluxAverage
    variable = temp
    boundary = 'top'
    diffusivity = 1.0
  [../]

  [./alive_time]
    type = PerformanceData
    event = ALIVE
    column = total_time_with_sub
  [../]

  [./CFL_time_step]
    type = LevelSetCFLCondition
    velocity_x = vel_x #This uses the magnitude of velocity and hmin to approximate CFL number
    velocity_y = vel_y
    velocity_z = 0
    #outputs = 'csv'
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
    interval = 30
  [../]
[]
