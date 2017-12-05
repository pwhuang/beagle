[Mesh]
type = GeneratedMesh
dim = 1

nx = 150

xmin = 0.0
xmax = 1.0

[]

[Variables]
  [./pressure]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Functions]
  [./ic_func]
    type = ParsedFunction
    value = 5/7*exp(-(x-x0)*(x-x0)/l/l)
    vars = 'x0 l'
    vals = '0.1333 0.033'
  [../]
[]

[ICs]
  [./mat_1]
    type = FunctionIC
    variable = pressure
    function = ic_func
  [../]
[]

[Kernels]
  active = 'diff conv euler'
  [./diff]
    type = ExampleDiffusion
    variable = pressure
    diffusivity = 6.7e-4  #Pe = 5.0
    source = 1.0
  [../]

  [./conv]
    type = ExampleConvection
    variable = pressure
    velocity_x = 1.0
    velocity_y = 0
    velocity_z = 0
  [../]

  [./supg]
    type = Supg
    variable = pressure
    advection_speed_x = 1.0
    advection_speed_y = 0.0
    h = 0.1
    beta = 0.8
    source = 1.0
  [../]

  [./euler]
    type = ExampleTimeDerivative
    variable = pressure
    time_coefficient = 1.0
  [../]
[]

[BCs]
  [./left_bc]
    type = DirichletBC
    variable = pressure
    boundary = 'left'
    value = 0
  [../]
  [./right_bc]
    type = DirichletBC
    variable = pressure
    boundary = 'right'
    value = 0
  [../]
[]

[Materials]
  active = 'ra_output'
  [./ra_output]
    type = RayleighMaterial
    block = 0
    function = 1.0
    min = 0
    max = 0
    seed = 363192
    outputs = exodus
  [../]
[]

[Executioner]
  type = Transient
  #solve_type = 'PJFNK'
  #num_steps = 20
  dt = 0.0065
  start_time = 0
  end_time = 0.6
  scheme = 'crank-nicolson'
  l_max_its = 40
  nl_max_its = 20
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]
