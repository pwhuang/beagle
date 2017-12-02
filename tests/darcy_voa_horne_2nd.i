[Mesh]
  type = GeneratedMesh
  dim = 2

  nx = 20
  ny = 20

  xmin = 0.0
  xmax = 1.0

  ymin = 0.0
  ymax = 1.0

  elem_type = QUAD9
[]

[MeshModifiers]
  active = 'side1 side2'
  [./side1]
    type = BoundingBoxNodeSet
    new_boundary = 'bottom_left'
    bottom_left = '0 0 0'
    top_right = '0.5 0 0'
  [../]
  [./side2]
    type = BoundingBoxNodeSet
    new_boundary = 'bottom_right'
    bottom_left = '0.5 0 0'
    top_right = '1.0 0 0'
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
    order = SECOND
    family = LAGRANGE
    #initial_condition = 0
  [../]
  [./vel_x]
    order = FIRST
    family = LAGRANGE
  [../]
  [./vel_y]
    order = SECOND
    family = LAGRANGE
  [../]
[]

[Functions]
  active = ''
  [./ic_func]
    type = ParsedFunction
    value = '(1.0-y)*1'
    #vars = 'alpha'
    #vals = '16'
  [../]

  [./ra_func]
    type = ParsedFunction
    value = '50*x'
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
    min = 0
    max = 1e-2
    seed = 524685
  [../]
[]


[Kernels]
  [./momentum_x]
    type = VelocityDiffusion_second
    variable = vel_x
    temperature = temp
    component_1 = 1
    component_2 = 0
    sign = -1.0
    scale = -1.0
  [../]

  [./momentum_y]
    type = VelocityDiffusion_secondu
    variable = vel_y
    temperature = temp
    component_1 = 0
    component_2 = 0
    sign = 1.0
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
    boundary = 'bottom_left bottom_right'
    value = 0
  [../]

  [./flux_bc_y]
    type = DirichletBC
    variable = vel_y
    #boundary = 'top bottom left right'
    boundary = 'top'
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
    boundary = 'bottom_left'
    value = 1.0
  [../]
[]

[Materials]
  active = 'ra_output'
  [./ra_output]
    type = RayleighMaterial
    block = 0
    function = 31.62 #'ra_func'
    min = 0
    max = 0
    seed = 363192
    outputs = exodus
  [../]
[]

[Preconditioning]
  [./SMP]
    full = true
    type = SMP
    solve_type = 'NEWTON'
  [../]
[]

[Executioner]
  type = Transient
  #solve_type = 'PJFNK'
  #abort_on_solve_fail = true
  num_steps = 3000
  #dt = 0.001
  #dtmin = 0.0001
  start_time = 0
  #end_time = 1000.0
  scheme = 'implicit-euler'
  l_max_its = 60
  nl_max_its = 20
  trans_ss_check = true
  ss_check_tol = 1e-06
  #ss_tmin = 0.2

  [./TimeStepper]
    type = PostprocessorDT
    postprocessor = CFL_time_step
    dt = 1e-3
    scale = 0.2
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
    velocity_x = vel_x
    velocity_y = vel_y
    velocity_z = 0
  [../]
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]
