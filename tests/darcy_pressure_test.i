[Mesh]
type = GeneratedMesh
dim = 2

nx = 100
ny = 50

xmin = 0.0
xmax = 2.0

ymin = 0.0
ymax = 1.0

elem_type = TRI3
[]

[MeshModifiers]
  active = 'corner_node'
  [./corner_node]
    type = AddExtraNodeset
    new_boundary = 'pinned_node'
    #nodes = '0'
    coord = '0.0 1.0'
  [../]
[]

[Variables]
  active = 'pressure'
  [./pressure]
    order = FIRST
    family = LAGRANGE
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
  active = 'ra_func'
  [./ra_func]
    type = ParsedFunction
    value = '10'#'(1.0-y)*100'
    #vars = 'alpha'
    #vals = '16'
  [../]
[]


[Kernels]
  active = 'mass' # diff conv euler'
  [./mass]
    type = PressureDiffusion_test
    variable = pressure
    temperature = temp
    component = 1
    sign = 1 #positive
  [../]

  [./euler]
    type = ExampleTimeDerivative
    variable = pressure
    time_coefficient = 1.0
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
  active = 'pressure_point_bc'#'pressure_bc bottom_bc'
  [./pressure_point_bc]
    type = DirichletBC
    variable = pressure
    boundary = 'pinned_node'
    value = 0.0
  [../]

  [./pressure_bc]
    type = DirichletBC
    variable = pressure
    boundary = 'top'
    value = 0.0
  [../]
  [./bottom_bc]
    type = DirichletBC
    variable = pressure
    boundary = 'bottom'
    value = 100.0
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
[]

[Postprocessors]
  [./alive_time]
    type = RunTime
    time_type = alive
  [../]
[]

[Outputs]
  execute_on = 'initial timestep_end'
  exodus = true
[]
