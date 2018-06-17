[Mesh]
  type = GeneratedMesh
  dim = 3


  ny = 20
  ymin = 0.0
  ymax = 1.0

  zmin = 0.0
  xmin = 0.0

  xmax = 1.5
  zmax = 1.0

  nx = 30
  nz = 20

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
[]

[Functions]
  [./ic_func]
    type = ParsedFunction
    value = '1.0-y'
  [../]
[]

[ICs]
  active = 'mat_2'
  [./mat_1]
    type = FunctionIC
    variable = temp
    function = ic_func
  [../]

  [./mat_2]
    type = FunctionRandomIC
    variable = temp
    function = ic_func
    min = -1e-2
    max = 1e-2
    #WRITE_HERE!!!
    
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
[]

[Materials]
  [./ra_output]
    type = RayleighMaterial
    block = 0
    function = 8 #Ra = 64
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
    petsc_options_value = 'gamg hypre cp 351 true'
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
      petsc_options_value = 'gamg hypre cp 151'
    [../]
    [./vel_y]
      vars = 'vel_y'
      petsc_options_iname = '-pc_type -sub_pc_type -snes_linesearch_type -ksp_gmres_restart'
      petsc_options_value = 'gamg hypre cp 151'
    [../]
    [./vel_z]
      vars = 'vel_z'
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
  #solve_type = PJFNK
  #num_steps = 10000
  #dt = 1e-5
  #dtmin = 0.001
  start_time = 0
  end_time = 3.0
  l_max_its = 50
  nl_max_its = 30
  #trans_ss_check = true
  #ss_check_tol = 1e-06
  #ss_tmin = 30
  nl_rel_tol = 1e-10
  nl_abs_tol = 1e-12

  [./TimeStepper]
    type = CFLDT
    postprocessor = CFL_time_step
    dt = 1e-3
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
    #interval = 200
    execute_on = 'FINAL'
  [../]
[]
