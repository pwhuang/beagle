[Mesh]
type = GeneratedMesh
dim = 2

nx = 80
ny = 40

xmin = 0.0
xmax = 4.0

ymin = 0.0
ymax = 1.0

elem_type = QUAD4
[]

[MeshModifiers]
  active = ''
  [./corner_node]
    type = AddExtraNodeset
    new_boundary = 'pinned_node'
    #nodes = '0'
    coord = '0.0 1.0'
  [../]
[]

[Variables]
  active = 'pressure temp'
  [./pressure]
    order = FIRST
    family = LAGRANGE
  [../]
  [./temp]
    order = FIRST
    family = LAGRANGE
    initial_condition = 0.0
  [../]
[]

[AuxVariables]
  #active = ''
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
  active = 'ic_func ra_func ic_func_temp'
  [./ic_func]
    type = ParsedFunction
    value = '(1.0-y)*10'
    #vars = 'alpha'
    #vals = '16'
  [../]

  [./ic_func_temp]
    type = ParsedFunction
    value = '(1.0-y)*1'
    #vars = 'alpha'
    #vals = '16'
  [../]

  [./ra_func]
    type = ParsedFunction
    value = '50.0' #Rayleigh_number is set to be negative due to downwards gravity.
    #vars = 'alpha'
    #vals = '16'
  [../]
[]

[ICs]
  active = ''
  [./mat_1]
    type = FunctionIC
    variable = pressure
    function = ic_func
  [../]

  [./mat_2]
    type = FunctionRandomIC
    variable = temp
    function = ic_func_temp
    min = 0
    max = 0
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
    sign = 1.0
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
    #Rayleigh_number = 61.36
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
    h = 0.005
    beta = 1.0
    component = 1
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
    boundary = 'top' #'pinned_node'
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
  dt = 0.2
  dtmin = 0.001
  start_time = 0
  end_time = 100.0
  scheme = 'crank-nicolson'
  l_max_its = 200
  nl_max_its = 200
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
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]
