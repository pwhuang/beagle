[Mesh]
  file = 'tests/billy_fault_coarse.e'

  boundary_id = '1 2 3 4 5 6'
  boundary_name = 'back front left right bottom top'

  parallel_type = DEFAULT
[]

[MeshModifiers]
  [./scale]
    type = Transform
    transform = SCALE
    vector_value = '0.0002 0.0002 0.0002'
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
    #initial_condition = 0
  [../]
[]

[AuxVariables]
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
    value = '-z'
    #vars = 'alpha'
    #vals = '16'
  [../]

  [./ra_func]
    type = ParsedFunction
    value = '50'#'(1.0-y)*100'
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
    min = -1e-2
    max = 1e-2
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
  active = 'no_flow_1 no_flow_2 top_temp bottom_temp'
  [./no_flow_1]
    type = DirichletBC
    variable = psi_1
    boundary = 'front back bottom top'
    value = 0
  [../]

  [./no_flow_2]
    type = DirichletBC
    variable = psi_2
    boundary = 'front back left right'
    value = 0
  [../]

  [./top_temp]
    type = DirichletBC
    variable = temp
    boundary = 'front'
    value = 0.0
  [../]

  [./bottom_temp]
    type = DirichletBC
    variable = temp
    boundary = 'back'
    value = 1.0
  [../]
[]

[Materials]
  [./ra_output_top]
    type = RayleighMaterial
    block = 2
    function = '30'
    min = 0
    max = 0
    seed = 363192
    outputs = exodus
  [../]

  [./ra_output_middle]
    type = RayleighMaterial
    block = 1
    function = '100'
    min = 0
    max = 0
    seed = 363192
    outputs = exodus
  [../]

  [./ra_output_bottom]
    type = RayleighMaterial
    block = 0
    function = '45'
    min = 0
    max = 0
    seed = 363192
    outputs = exodus
  [../]

  [./ra_output_fault1]
    type = RayleighMaterial
    block = 3
    function = '2000'
    min = 0
    max = 0
    seed = 363192
    outputs = exodus
  [../]

  [./ra_output_fault2]
    type = RayleighMaterial
    block = 4
    function = '1600'
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
  #dt = 0.01
  #dtmin = 0.001
  start_time = 0
  #end_time = 2.0
  scheme = 'crank-nicolson'
  l_max_its = 80
  nl_max_its = 30

  [./TimeStepper]
    type = PostprocessorDT
    postprocessor = CFL_time_step
    dt = 1e-4
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
    boundary = 'front'
    diffusivity = 1.0
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
