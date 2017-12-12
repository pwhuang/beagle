[Mesh]
  file = 'tests/mesh/horne_full.msh'
[]

[Variables]
  [./temp]
    order = FIRST
    family = LAGRANGE
    #initial_condition = 0
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
[]

[Functions]
  active = ''
  [./ic_func]
    type = ParsedFunction
    value = '(1.0-y)*1'
    #vars = 'alpha'
    #vals = '16'
  [../]

  [./ra_func]
    type = ParsedFunction
    value = '50*x'
    #vars = 'alpha'
    #vals = '16'
  [../]
[]

[ICs]
  active = ''
  [./mat_1]
    type = FunctionIC
    variable = temp
    function = ic_func
  [../]

  [./mat_2]
    type = FunctionRandomIC
    variable = temp
    function = ic_func
    min = 0
    max = 1e-2
    seed = 524685
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
    boundary = 'bottom'
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
    boundary = 'top'
    value = 0.0
  [../]

  [./bottom_temp]
    type = NeumannBC
    variable = temp
    boundary = 'bottom'
    value = 1.0
  [../]
[]

[Materials]
  active = 'ra_output'
  [./ra_output]
    type = RayleighMaterial
    block = 'layer1'
    function = 31.62 #'ra_func'
    min = 0
    max = 0
    seed = 363192
    outputs = exodus
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
    solve_type = 'NEWTON'
    petsc_options_iname = '-pc_type -sub_pc_type -snes_linesearch_type -ksp_gmres_restart'
    petsc_options_value = 'gamg hypre basic 251'
  [../]
[]

[Executioner]
  type = Transient
  #solve_type = 'PJFNK'
  #abort_on_solve_fail = true
  num_steps = 3000
  #dt = 0.001
  #dtmin = 0.0001
  start_time = 0
  #end_time = 1000.0
  l_max_its = 60
  nl_max_its = 20
  trans_ss_check = false
  ss_check_tol = 1e-06
  #ss_tmin = 0.2
  #nl_rel_step_tol = 1e-10
  nl_rel_tol = 1e-10
  nl_abs_tol = 1e-12

  [./TimeStepper]
    type = PostprocessorDT
    postprocessor = CFL_time_step
    dt = 1e-3
    scale = 0.025
    factor = 0
  [../]

  [./TimeIntegrator]
    type = CrankNicolson
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
    velocity_x = vel_x
    velocity_y = vel_y
    velocity_z = 0
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
  exodus = true
[]
