[Mesh]
  type = GeneratedMesh
  dim = 3

  nx = 20
  ny = 20
  nz = 20

  xmin = 0.0
  xmax = 1.0

  ymin = 0.0
  ymax = 1.0

  zmin = 0.0
  zmax = 1.0

  elem_type = HEX8
  
  parallel_type = DISTRIBUTED
  partitioner = default
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
    #initial_condition = 0
  [../]
[]

[AuxVariables]
  active = ''
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
    value = '50' #'(1.0-y)*100'
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
    min = -0.01
    max = 0.01
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
    #Rayleigh_number = 100.0
  [../]

  [./euler]
    type = ExampleTimeDerivative
    variable = temp
    time_coefficient = 1.0
  [../]
[]

[AuxKernels]
  active = ''
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

  [./velocity_z_aux2]
    type = VariableGradientSign
    variable = velocity_z
    gradient_variable = psi_2
    component = 'x'
    sign = 1.0
  [../]

  [./velocity_z_aux1]
    type = VariableGradientSign
    variable = velocity_z
    gradient_variable = psi_1
    component = 'y'
    sign = -1.0
  [../]
[]

[BCs]
  active = 'no_flow_1 no_flow_2 top_temp bottom_temp'

  [./Periodic]
      active = ''
      # Can use auto_direction with Generated Meshes
      [./auto_1]
        variable = psi_1
        auto_direction = 'x y'
      [../]
      [./auto_2]
        variable = psi_2
        auto_direction = 'x y'
      [../]
      [./auto_3]
        variable = temp
        auto_direction = 'x y'
      [../]
  [../]

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

  [./no_flow_z1]
    type = DirichletBC
    variable = psi_1
    boundary = 'front back'
    value = 0.0
  [../]

  [./no_flow_z2]
    type = DirichletBC
    variable = psi_2
    boundary = 'front back'
    value = 0.0
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
  active = 'ra_output'
  [./ra_output]
    type = RayleighMaterial
    block = 0
    function = 'ra_func'
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
  dt = 0.1
  dtmin = 0.001
  start_time = 0
  end_time = 10.0
  scheme = 'crank-nicolson'
  l_max_its = 80
  nl_max_its = 30
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

  [./alive_time]
    type = RunTime
    time_type = alive
  [../]
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]
