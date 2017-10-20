[Mesh]
  file = 'tests/3d_1e-1.msh' #'tests/darcy_stream_3d_msh_in.e'
  block_id = '33'
  block_name = 'layer1'

  boundary_id = '25 27 26 29 30 28'
  boundary_name = 'top bottom front back right left'

  #parallel_type = DISTRIBUTED
  #partitioner = parmetis
  second_order = true
[]

[MeshModifiers]
  active = ''
  [./corner_node]
    type = AddExtraNodeset
    new_boundary = 'pinned_node'
    #nodes = '0'
    coord = '0 0 0'
  [../]
[]

[Variables]
  [./temp]
    order = FIRST
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

[Functions]
  active = 'ic_func ra_func'
  [./ic_func]
    type = ParsedFunction
    value = '1.0-z'
    #vars = 'alpha'
    #vals = '16'
  [../]

  [./ra_func]
    type = ParsedFunction
    value = 200
    #vars = 'alpha'
    #vals = '16'
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
    min = 0
    max = 1e-2
    seed = 52468
  [../]
[]

[Kernels]
  [./mass]
    type = MassBalance
    variable = temp
    velocity_x = vel_x
    velocity_y = vel_y
    velocity_z = vel_z
  [../]

  [./momentum_x]
    type = VelocityDiffusion
    variable = vel_x
    temperature = temp
    component = 0
    sign = 0
  [../]

  [./momentum_y]
    type = VelocityDiffusion
    variable = vel_y
    temperature = temp
    component = 1
    sign = 0
  [../]

  [./momentum_z]
    type = VelocityDiffusionZ
    variable = vel_z
    temperature = temp
    component = 0
    sign = 0
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
    type =  PresetBC
    variable = vel_x
    #boundary = 'front back'
    boundary = 'front back left right top bottom'
    value = 0
  [../]

  [./no_flow_2]
    type = PresetBC
    variable = vel_y
    #boundary = 'left right'
    boundary = 'front back left right top bottom'
    value = 0
  [../]

  [./no_flow_3]
    type = PresetBC
    variable = vel_z
    #boundary = 'top bottom'
    boundary = 'front back left right top bottom'
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
  active = 'ra_output'
  [./ra_output]
    type = RayleighMaterial
    block = 'layer1'
    function = 'ra_func'
    min = 0
    max = 0
    seed = 363192
    outputs = exodus
  [../]
[]

[Preconditioning]
  active = ''
  [./SMP]
    type = SMP
    full = true
    solve_type = 'NEWTON'
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'
  num_steps = 1000
  #dt = 1e-3
  #dtmin = 0.001
  start_time = 0
  #end_time = 100000.0
  scheme = 'crank-nicolson'
  l_max_its = 100
  nl_max_its = 30
  trans_ss_check = true
  ss_check_tol = 1e-07

  [./TimeStepper]
    type = PostprocessorDT
    postprocessor = CFL_time_step
    dt = 1e-3
    scale = 0.2
    factor = 0
  [../]
  #petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  #petsc_options_value = 'hypre    boomeramg      101'
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
    velocity_z = vel_z
  [../]
[]

[Outputs]
  execute_on = 'initial timestep_end'
  exodus = true
[]
