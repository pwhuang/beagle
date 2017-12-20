[Mesh]
  file = 'tests/single_layer.msh'
  block_id = '11'
  block_name = 'layer1'

  boundary_id = '5 6 7 8'
  boundary_name = 'bottom right top left'

  #parallel_type =
  #partitioner = metis
  second_order = true
[]

[MeshModifiers]
  [./corner_node]
    type = AddExtraNodeset
    new_boundary = 'pinned_node'
    #nodes = '0'
    coord = '0.0 1.0'
  [../]

  [./corner_node2]
    type = AddExtraNodeset
    new_boundary = 'pinned_node2'
    #nodes = '0'
    coord = '2.0 1.0'
  [../]
[]

[Variables]
  [./pressure]
    order = FIRST
    family = LAGRANGE
  [../]
  [./temp]
    order = SECOND
    family = LAGRANGE
    #initial_condition = 0.0
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
[]

[Functions]
  active = 'ic_func ra_func ic_func_temp'
  [./ic_func]
    type = ParsedFunction
    value = '-(1.0-y)*(1.0-y)*100'
  [../]

  [./ic_func_temp]
    type = ParsedFunction
    value = '(1.0-y)*1'
  [../]

  [./ra_func]
    type = ParsedFunction
    value = '200'
  [../]
[]

[ICs]
  active = 'mat_1 mat_2'
  [./mat_1]
    type = FunctionIC
    variable = pressure
    function = ic_func
  [../]

  [./mat_2]
    type = FunctionRandomIC
    variable = temp
    function = ic_func_temp
    min = -1e-2
    max = 1e-2
    seed = 524685
  [../]
[]


[Kernels]
  active = 'mass diff conv euler'
  [./mass]
    type = PressureDiffusion_test
    variable = pressure
    temperature = temp
    component = 1
  [../]

  [./diff]
    type = ExampleDiffusion
    variable = temp
    diffusivity = 1.0
  [../]

  [./conv]
    type = PressureConvection
    variable = temp
    pressure = pressure
    component = 1
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
    type = DarcyVelocity
    variable = velocity_x
    pressure = pressure
    temperature = 0
    component = 0
  [../]

  [./velocity_y_aux]
    type = DarcyVelocity
    variable = velocity_y
    pressure = pressure
    temperature = temp
    component = 1
  [../]
[]

[BCs]
  active = 'no_flux_bc top_temp bottom_temp'
  [./no_flux_bc]
    type = DirichletBC
    variable = pressure
    boundary = 'pinned_node pinned_node2'
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
    #outputs = exodus
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
    solve_type = 'NEWTON'
    petsc_options_iname = '-pc_type -sub_pc_type -snes_linesearch_type -ksp_gmres_restart'
    petsc_options_value = 'gamg hypre cp 301'
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'
  #num_steps = 20
  #dt = 0.02
  #dtmin = 0.001
  start_time = 0
  #end_time = 8.0
  scheme = 'crank-nicolson'
  l_max_its = 40
  nl_max_its = 60
  trans_ss_check = true
  ss_check_tol = 1e-06


  [./TimeStepper]
    type = PostprocessorDT
    postprocessor = CFL_time_step
    dt = 1e-5
    scale = 0.005
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

  [./CFL_time_step]
    type = LevelSetCFLCondition
    velocity_x = velocity_x
    velocity_y = velocity_y
  [../]
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]
