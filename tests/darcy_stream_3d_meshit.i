[Mesh]
  file = 'tests/2layer.e' #'tests/darcy_stream_3d_msh_in.e'
  block_id = '0 1'
  block_name = 'layer1 layer2'


  boundary_id = '1 2 3 4 5 6'
  boundary_name = 'bottom top back right front left'

  #parallel_type = DISTRIBUTED
  #partitioner = parmetis
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
  [./psi_1]
    order = FIRST
    family = LAGRANGE
  [../]
  [./psi_2]
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
  #active = ''
  [./velocity_x]
    order = FIRST
    family = MONOMIAL
  [../]

  [./velocity_y]
    order = FIRST
    family = MONOMIAL
  [../]

  [./velocity_z]
    order = FIRST
    family = MONOMIAL
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
    min = -1e-4
    max = 1e-4
    seed = 52468
  [../]
[]

[Kernels]
  active = 'mass stream1 stream2 diff conv euler'
  [./mass]
    type = MassBalance
    variable = temp
    velocity_x = psi_1
    velocity_y = psi_2
  [../]

  [./stream1]
    type = StreamDiffusion
    variable = psi_1
    component = 1
    sign = 1.0
    temperature = temp
  [../]

  [./stream2]
    type = StreamDiffusion
    variable = psi_2
    component = 0
    sign = -1.0
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
  #active = ''
  [./velocity_x_aux]
    type = VariableGradientSign
    variable = velocity_x
    gradient_variable = psi_2
    component = 'z'
    sign = -1.0
  [../]

  [./velocity_y_aux]
    type = VariableGradientSign
    variable = velocity_y
    gradient_variable = psi_1
    component = 'z'
    sign = 1.0
  [../]

  [./velocity_z_aux]
    type = StreamVelocityZ
    variable = velocity_z
    stream_function1 = psi_1
    stream_function2 = psi_2
  [../]
[]

[BCs]
  #active = 'no_flow_1 no_flow_2 top_temp bottom_temp'
  [./no_flow_1]
    type =  DirichletBC
    variable = psi_1
    boundary = 'bottom top left right'
    #boundary = 'bottom top left right front back'
    value = 0
  [../]

  [./no_flow_2]
    type = DirichletBC
    variable = psi_2
    boundary = 'bottom top front back'
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
  [./ra_output1]
    type = RayleighMaterial
    block = 'layer1'
    function = 'ra_func'
    min = 0
    max = 0
    seed = 363192
    outputs = exodus
  [../]

  [./ra_output2]
    type = RayleighMaterial
    block = 'layer2'
    function = '40'
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
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'
  #num_steps = 20
  #dt = 1e-2
  #dtmin = 0.001
  start_time = 0
  end_time = 100000.0
  scheme = 'crank-nicolson'
  l_max_its = 40
  nl_max_its = 20
  trans_ss_check = true
  ss_check_tol = 1e-07

  [./TimeStepper]
    type = PostprocessorDT
    postprocessor = CFL_time_step
    dt = 1e-5
    scale = 0.9
    factor = 0
  [../]
  #petsc_options = '-snes_mf_operator' #-ksp_monitor'
  #petsc_options_iname = '-pc_type -pc_hypre_type'
  #petsc_options_value = 'hypre boomeramg'
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
    velocity_x = velocity_x
    velocity_y = velocity_y
    velocity_z = velocity_z
  [../]
[]

[Outputs]
  execute_on = 'initial timestep_end'
  exodus = true
[]
