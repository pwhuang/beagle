[Mesh]
  file = 'stream_beck20_out.e'
  second_order = true
[]

[Variables]
  [./psi_1]
    order = FIRST
    family = LAGRANGE
    initial_from_file_timestep = LATEST
    initial_from_file_var = 'psi_1'
  [../]
  [./psi_2]
    order = FIRST
    family = LAGRANGE
    initial_from_file_timestep = LATEST
    initial_from_file_var = 'psi_2'
  [../]
  [./temp]
    order = SECOND
    family = LAGRANGE
    initial_from_file_timestep = LATEST
    initial_from_file_var = 'temp'
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

  [./velocity_z]
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
  [./entropy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./perturbed_temp]
    order = SECOND
    family = LAGRANGE
  [../]
[]

[Kernels]
  [./mass]
    type = MassBalance
    variable = temp
    velocity_x = psi_1
    velocity_z = psi_2
  [../]

  [./stream1]
    type = StreamDiffusion
    variable = psi_1
    component = 2
    sign = -1.0
    temperature = temp
  [../]

  [./stream2]
    type = StreamDiffusion
    variable = psi_2
    component = 0
    sign = 1.0
    temperature = temp
  [../]

  [./diff]
    type = ExampleDiffusion
    variable = temp
    diffusivity = 1.0
  [../]

  [./conv]
    type = RayleighConvection3d
    variable = temp
    stream_function1 = psi_1
    stream_function2 = psi_2
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
    gradient_variable = psi_2
    component = 'y'
    sign = 1.0
  [../]

  [./velocity_y_aux]
    type = StreamVelocityZ
    variable = velocity_y
    stream_function1 = psi_1
    stream_function2 = psi_2
  [../]

  [./velocity_z_aux]
    type = VariableGradientSign
    variable = velocity_z
    gradient_variable = psi_1
    component = 'y'
    sign = -1.0
  [../]

  [./cell_peclet]
    type = CellPeclet
    variable = Peclet
    velocity_x = velocity_x
    velocity_y = velocity_y
    velocity_z = velocity_z
  [../]
  [./cell_CFL]
    type = CellCFL
    variable = CFL
    velocity_x = velocity_x
    velocity_y = velocity_y
    velocity_z = velocity_z
  [../]

  [./entropy]
    type = EntropyProduction
    variable = entropy
    temp = temp
    velocity_x = velocity_x
    velocity_y = velocity_y
    velocity_z = velocity_z
    T_bar = 16
    deltaT = 8
    alpha = 1.6163e-4
    cf = 4184
    d = 150
  [../]

  [./perturbation] #Trying to decrease its energy
    type = AuxPerturb
    variable = perturbed_temp
    temp = temp
    max = 0
    min = -1e-1
    seed = 52468
    execute_on = INITIAL
  [../]
[]

[BCs]
  [./no_flow_1]
    type = DirichletBC
    variable = psi_1
    boundary = 'bottom top front back'
    value = 0
  [../]

  [./no_flow_2]
    type = DirichletBC
    variable = psi_2
    boundary = 'bottom top left right'
    #boundary = 'bottom top left right front back'
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
    boundary = 'bottom'
    value = 1.0
  [../]
[]

[Materials]
  [./ra_output]
    type = RayleighMaterial
    block = 'layer1'
    function = 7
    min = 0
    max = 0
    seed = 363192
    outputs = out
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
    solve_type = 'NEWTON'
    petsc_options_iname = '-pc_type -sub_pc_type -snes_linesearch_type -ksp_gmres_restart -pc_gamg_sym_graph'
    petsc_options_value = 'gamg hypre cp 301 true'
  [../]
[]

[Executioner]
  type = Transient
  #solve_type = 'JFNK'
  num_steps = 0
  #dt = 1e-5
  #dtmin = 0.001
  start_time = 0
  #end_time = 3.0
  l_max_its = 40
  nl_max_its = 20

  nl_rel_tol = 1e-10
  nl_abs_tol = 1e-12

  #trans_ss_check = false
  #ss_check_tol = 1e-06
  #ss_tmin = 100

  [./TimeIntegrator]
    type = CrankNicolson
  [../]

  [./TimeStepper]
    type = PostprocessorDT
    postprocessor = CFL_time_step
    dt = 1e-5
    scale = 0.02
    factor = 0
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

  [./L2_psi_1]
    type = ElementL2Norm
    variable = psi_1
    outputs = 'csv'
  [../]

  [./L2_psi_2]
    type = ElementL2Norm
    variable = psi_2
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

  [./CFL_time_step]
    type = LevelSetCFLCondition
    velocity_x = velocity_x
    velocity_y = velocity_y
    velocity_z = velocity_z
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
  execute_on = 'initial timestep_end'
  csv = true
  [./out]
    type = Exodus
    interval = 1
  [../]
[]
