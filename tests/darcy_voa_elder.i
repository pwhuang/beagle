[Mesh]
  file = 'tests/mesh/elder.msh'
  #second_order = true
  #type = GeneratedMesh
  #dim = 2

  #nx = 200
  #ny = 50

  #xmin = 0.0
  #xmax = 4.0

  #ymin = 0.0
  #ymax = 1.0

  #elem_type = QUAD8
[]

[MeshModifiers]
  active = ''
  [./side]
    type = BoundingBoxNodeSet
    new_boundary = 'bottom_half'
    bottom_left = '1 0 0'
    top_right = '3 0 0'
  [../]
  [./corner_node]
    type = AddExtraNodeset
    new_boundary = 'pinned_node'
    #nodes = '0'
    coord = '0 0.8'
  [../]
[]

[Variables]
  [./temp]
    order = FIRST
    family = LAGRANGE
    initial_condition = 0
  [../]

  [./vel_x]
    order = SECOND
    family = LAGRANGE
  [../]

  [./vel_y]
    order = SECOND
    family = LAGRANGE
  [../]
[]

[Functions]
  active = 'ic_func ra_func'
  [./ic_func]
    type = ParsedFunction
    value = '(1.0-y)*1'
    #vars = 'alpha'
    #vals = '16'
  [../]

  [./ra_func]
    type = ParsedFunction
    value = 400 #'x*50'
    #vars = 'alpha'
    #vals = '17'
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
    function = '0' #ic_func
    min = 0
    max = 0.01
    seed = 524685
  [../]
[]

[Kernels]
  [./momentum_x]
    type = VelocityDiffusion
    variable = vel_x
    temperature = temp
    component_1 = 1
    component_2 = 0
    sign = -1.0
    scale = 0.0
  [../]

  [./momentum_y]
    type = VelocityDiffusion
    variable = vel_y
    temperature = temp
    component_1 = 0
    component_2 = 0
    sign = 1.0
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

[BCs]
  active = 'no_flux_bc_x no_flux_bc_y top_temp bottom_temp'
  [./no_flux_bc_x]
    type = DirichletBC
    variable = vel_x
    #boundary = 'top bottom left right'
    boundary = 'left right'
    value = 0
  [../]

  [./no_flux_bc_y]
    type = DirichletBC
    variable = vel_y
    #boundary = 'top bottom left right'
    boundary = 'top bottom_half bottom_out'
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
    boundary = 'bottom_half'
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
  #active = ''
  [./SMP]
    type = SMP
    full = true
    solve_type = 'NEWTON'
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'
  num_steps = 2000
  dt = 1e-3
  #dtmin = 0.001
  start_time = 0
  #end_time = 300.0
  scheme = 'crank-nicolson'
  l_max_its = 100
  nl_max_its = 30
  trans_ss_check = true
  ss_check_tol = 1e-06

  #[./TimeStepper]
  #  type = PostprocessorDT
  #  postprocessor = CFL_time_step
  #  dt = 1e-3
  #  scale = 0.9/400.0
  #  factor = 0
  #[../]

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
    velocity_x = vel_x
    velocity_y = vel_y
  [../]

  [./L2_temp]
    type = ElementL2Norm
    variable = temp
  [../]

  [./L2_vel_x]
    type = ElementL2Norm
    variable = vel_x
  [../]

  [./L2_vel_y]
    type = ElementL2Norm
    variable = vel_y
  [../]
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
  csv = true
[]
