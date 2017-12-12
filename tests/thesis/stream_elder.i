[Mesh]
  file = 'tests/mesh/elder.msh'
  #second_order = true
[]

[Variables]
  [./stream]
    order = FIRST
    family = LAGRANGE
  [../]
  [./temp]
    order = FIRST
    family = LAGRANGE
    initial_condition = 0
  [../]
[]

[AuxVariables]
  [./velocity_x]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./velocity_y]
    order = CONSTANT
    family = MONOMIAL
  [../]
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
  [./mass]
    type = StreamDiffusion
    variable = stream
    temperature = temp
    component = 0
    sign = 1 #This is intended to be 1. Do not change this!
  [../]

  [./diff]
    type = ExampleDiffusion
    variable = temp
    diffusivity = 1.0
  [../]

  [./conv]
    type = RayleighConvection
    variable = temp
    stream_function = stream
  [../]

  [./euler]
    type = ExampleTimeDerivative
    variable = temp
    time_coefficient = 1.0
  [../]
[]

[AuxKernels]
  [./velocity_x_aux]
    type = VariableGradientSign
    variable = velocity_x
    gradient_variable = stream
    component = 'y'
    sign = 1.0
  [../]

  [./velocity_y_aux]
    type = VariableGradientSign
    variable = velocity_y
    gradient_variable = stream
    component = 'x'
    sign = -1.0
  [../]

  [./cell_peclet]
    type = CellPeclet
    variable = Peclet
    velocity_x = velocity_x
    velocity_y = velocity_y
    velocity_z = 0
  [../]
  [./cell_CFL]
    type = CellCFL
    variable = CFL
    velocity_x = velocity_x
    velocity_y = velocity_y
    velocity_z = 0
  [../]
[]

[BCs]
  [./no_flux_bc]
    type = DirichletBC
    variable = stream
    boundary = 'top bottom_half bottom_out left right'
    #boundary = 'top bottom left right'
    value = 0.0
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

[Materials]
  [./ra_output]
    type = RayleighMaterial
    block = 'layer1'
    function = 20
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
  #solve_type = 'JFNK'
  #num_steps = 20
  dt = 0.002
  dtmin = 0.001
  start_time = 0
  #end_time = 300.0
  l_max_its = 40
  nl_max_its = 20

  nl_rel_tol = 1e-10
  nl_abs_tol = 1e-12

  trans_ss_check = true
  ss_check_tol = 1e-06
  ss_tmin = 100

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
    outputs = 'csv console'
  [../]

  [./alive_time]
    type = PerformanceData
    event = ALIVE
    column = total_time_with_sub
  [../]

  [./L2_temp]
    type = ElementL2Norm
    variable = temp
    outputs = 'csv'
  [../]

  [./L2_stream]
    type = ElementL2Norm
    variable = stream
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
  csv = true
[]
