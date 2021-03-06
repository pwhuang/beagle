[Mesh]
  type = GeneratedMesh
  dim = 3

  ny = 10
  ymin = 0.0
  ymax = 1.0

  nz = 12
  zmin = 0.0
  zmax = 1.189

  nx = 12
  xmin = 0.0
  xmax = 1.189

  elem_type = HEX27
[]

[Variables]
  [./temp]
    order = SECOND
    family = LAGRANGE
  [../]

  [./vel_x]
    order = FIRST
    family = LAGRANGE
  [../]

  [./vel_y]
    order = FIRST
    family = LAGRANGE
  [../]

  [./vel_z]
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
  [./y]
    order = SECOND
    family = LAGRANGE
  [../]
  [./convected_temp]
    order = SECOND
    family = LAGRANGE
  [../]
[]

[Functions]
  [./ic_func_T]
    type = ParsedFunction

  [../]

  [./ic_func_u]
    type = ParsedFunction

  [../]

  [./ic_func_v]
    type = ParsedFunction

  [../]

  [./ic_func_w]
    type = ParsedFunction

  [../]

  [./y_func]
    type = ParsedFunction
    value = 'y'
  [../]

  [./amp_func01]
    type = ParsedFunction
    value = 'sin(pi*y)*cos(pi*z/1.189)*4/pow(1.189,2)'
  [../]

  [./amp_func10]
    type = ParsedFunction
    value = 'sin(pi*y)*cos(pi*x/1.189)*4/pow(1.189,2)'
  [../]

  [./amp_func11]
    type = ParsedFunction
    value = 'sin(pi*y)*cos(pi*x/1.189)*cos(pi*z/1.189)*8/pow(1.189,2)'
  [../]
[]

[ICs]
  active = 'mat_t mat_u mat_v mat_w'
  [./mat_t]
    type = FunctionIC
    variable = temp
    function = ic_func_T
  [../]

  [./mat_u]
    type = FunctionIC
    variable = vel_x
    function = ic_func_u
  [../]

  [./mat_v]
    type = FunctionIC
    variable = vel_y
    function = ic_func_v
  [../]

  [./mat_w]
    type = FunctionIC
    variable = vel_z
    function = ic_func_w
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
    boundary = 'top bottom'
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
    boundary = 'bottom'
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
  [./entropy]
    type = EntropyProduction
    variable = entropy
    temp = temp
    velocity_x = vel_x
    velocity_y = vel_y
    velocity_z = vel_z
    T_bar = 16
    deltaT = 8
    alpha = 1.6163e-4
    cf = 4184
    d = 150
  [../]
  [./y_aux]
    type = FunctionAux
    variable = y
    function = y_func
  [../]
  [./convected_temp_kernel]
    type = ParsedAux
    variable = convected_temp
    args = 'temp y'
    function = 'temp - 1 + y'
  [../]
[]

[Materials]
  [./ra_output]
    type = RayleighMaterial
    block = 0
    function = 6.5 #Ra = 42.25
    min = 0
    max = 0
    seed = 363192
    #outputs = exodus
  [../]
[]

[Preconditioning]
  active = 'FSP'
  [./SMP]
    type = SMP
    full = true
    solve_type = 'NEWTON'
    petsc_options_iname = '-pc_type -sub_pc_type -snes_linesearch_type -ksp_gmres_restart -pc_gamg_sym_graph'
    petsc_options_value = 'gamg none cp 151 true'
  [../]

  [./FSP]
    type = FSP
    full = true
    solve_type = 'NEWTON'
    topsplit = 'pt'
    [./pt]
      splitting = 'vel_x vel_y vel_z temp'
    [../]
    [./vel_x]
      vars = 'vel_x'
      petsc_options_iname = '-pc_type -sub_pc_type -snes_linesearch_type -ksp_gmres_restart'
      petsc_options_value = 'gamg ilu cp 151'
    [../]
    [./vel_y]
      vars = 'vel_y'
      petsc_options_iname = '-pc_type -sub_pc_type -snes_linesearch_type -ksp_gmres_restart'
      petsc_options_value = 'gamg ilu cp 151'
    [../]
    [./vel_z]
      vars = 'vel_z'
      petsc_options_iname = '-pc_type -sub_pc_type -snes_linesearch_type -ksp_gmres_restart'
      petsc_options_value = 'gamg ilu cp 151'
    [../]
    [./temp]
      vars = 'temp'
      petsc_options_iname = '-pc_type -sub_pc_type -snes_linesearch_type -ksp_gmres_restart'
      petsc_options_value = 'gasm ilu cp 151'
    [../]
  [../]
[]

[Executioner]
  type = Transient
  #solve_type =LINEAR
  num_steps = 2000
  #dt = 1e-5
  #dtmin = 0.001
  #abort_on_solve_fail = true
  start_time = 0
  #end_time = 15.0
  l_max_its = 200
  nl_max_its = 100
  #trans_ss_check = true
  #ss_check_tol = 1e-06
  #ss_tmin = 30
  #nl_rel_tol = 1e-10
  nl_abs_tol = 1e-13
  l_tol = 1e-10


  [./TimeStepper]
    type = CFLDT
    postprocessor = CFL_time_step
    dt = 1e-2
    activate_time = 1e-2
    max_Ra = 6.5
    cfl = 0.5
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
    outputs = 'csv console'
    execute_on = 'INITIAL TIMESTEP_END'
  [../]

  [./Nu_x]
    type = SideFluxAverage
    variable = temp
    boundary = 'left'
    diffusivity = 1.0
    outputs = 'csv console'
    execute_on = 'INITIAL TIMESTEP_END'
  [../]

  [./Nu_z]
    type = SideFluxAverage
    variable = temp
    boundary = 'front'
    diffusivity = 1.0
    outputs = 'csv console'
    execute_on = 'INITIAL TIMESTEP_END'
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
  [../]

  [./L2_temp]
    type = ElementL2Norm
    variable = temp
    outputs = 'csv'
  [../]

  [./L2_vel_x]
    type = ElementIntegralVariablePostprocessor
    variable = vel_x
    outputs = 'console csv'
  [../]

  [./L2_vel_y]
    type = ElementIntegralVariablePostprocessor
    variable = vel_y
    outputs = 'console csv'
  [../]

  [./L2_vel_z]
    type = ElementIntegralVariablePostprocessor
    variable = vel_z
    outputs = 'console csv'
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
    execute_on = 'INITIAL TIMESTEP_END'
  [../]

  [./res]
    type = Residual
    execute_on = timestep_end
    residual_type = FINAL
  [../]

  [./amp01]
    type = FunctionAmplitudePostprocessor
    variable = convected_temp
    function = amp_func01
    execute_on = 'INITIAL TIMESTEP_END'
  [../]

  [./amp10]
    type = FunctionAmplitudePostprocessor
    variable = convected_temp
    function = amp_func10
    execute_on = 'INITIAL TIMESTEP_END'
  [../]

  [./amp11]
    type = FunctionAmplitudePostprocessor
    variable = convected_temp
    function = amp_func11
    execute_on = 'INITIAL TIMESTEP_END'
  [../]

  [./amp01_dt]
    type = ChangeOverTimePostprocessor
    postprocessor = amp01
    change_with_respect_to_initial = false
    take_absolute_value = true
    execute_on = 'INITIAL TIMESTEP_END'
  [../]

  [./amp11_dt]
    type = ChangeOverTimePostprocessor
    postprocessor = amp11
    change_with_respect_to_initial = false
    take_absolute_value = true
    execute_on = 'INITIAL TIMESTEP_END'
  [../]

  [./N_S_dt]
    type = ChangeOverTimePostprocessor
    postprocessor = N_S
    change_with_respect_to_initial = false
    take_absolute_value = true
    execute_on = 'INITIAL TIMESTEP_END'
  [../]
[]

[UserObjects]
  [./kill]
    type = Terminator
    expression = '(amp01_dt < 1e-5) & (amp11_dt < 1e-5) & (N_S_dt < 1e-5)'
  [../]
[]

[Outputs]
  execute_on = 'timestep_end'
  csv = true
  [./out]
    type = Exodus
    #interval = 200
    execute_on = 'INITIAL FINAL'
  [../]
[]
