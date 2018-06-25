[Mesh]
type = GeneratedMesh
dim = 1

nx = 50

xmin = 0.0
xmax = 1.0

elem_type = EDGE
[]

[MeshModifiers]
  active = ''
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
    #initial_condition = 0
  [../]
[]

[AuxVariables]
  active = ''
  [./velocity_x]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./velocity_y]
    order = CONSTANT
    family = MONOMIAL
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
    value = '31.42' #'x*50'
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
    min = -0.01
    max = 0.01
    seed = 524685
  [../]
[]


[Kernels]
  active = 'diff'
  [./mass]
    type = StreamDiffusion
    variable = stream
    temperature = temp
    component = 0
    sign = 1 #This is intended to be 1. Do not change this!
  [../]

  [./diff]
    type = ExampleDiffusion
    variable = temp
    diffusivity = 10.0
  [../]

  [./conv]
    type = RayleighConvection
    variable = temp
    stream_function = stream
  [../]

  [./euler]
    type = ExampleTimeDerivative
    variable = temp
    time_coefficient = 1.0
  [../]

  [./supg_x]
    type = Supg
    variable = temp
    advection_speed = velocity_x
    h = 0.05
    beta = 1.0
    component = 0
  [../]

  [./supg_y]
    type = Supg
    variable = temp
    advection_speed = velocity_y
    h = 0.05
    beta = 1.0
    component = 1
  [../]
[]

[AuxKernels]
  active = ''
  [./velocity_x_aux]
    type = VariableGradientComponent
    variable = velocity_x
    gradient_variable = stream
    component = 'y'
  [../]

  [./velocity_y_aux]
    type = VariableGradientComponent
    variable = velocity_y
    gradient_variable = stream
    component = 'x'
  [../]
[]

[BCs]
  active = 'top_temp bottom_temp'
  [./no_flux_bc]
    type = DirichletBC
    variable = stream
    boundary = 'top bottom left right'
    value = 0.0
  [../]

  [./top_temp]
    type = DirichletBC
    variable = temp
    boundary = 'left'
    value = 0.0
  [../]

  [./bottom_temp]
    type = NeumannBC
    variable = temp
    boundary = 'right'
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
  type = Steady #Transient
  solve_type = 'PJFNK'
  #num_steps = 20
  dt = 0.001
  #dtmin = 0.001
  start_time = 0
  end_time = 300.0
  scheme = 'crank-nicolson'
  l_max_its = 40
  nl_max_its = 20
  #petsc_options = '-snes_mf_operator' #-ksp_monitor'
  #petsc_options_iname = '-pc_type -pc_hypre_type'
  #petsc_options_value = 'hypre boomeramg'
[]

[Postprocessors]
  [./Nusselt]
    type = SideFluxAverage
    variable = temp
    boundary = 'left'
    diffusivity = 1.0
  [../]

  [./alive_time]
    type = PerformanceData
    event = ALIVE
    column = total_time_with_sub
  [../]
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]
