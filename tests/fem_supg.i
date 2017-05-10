[Mesh]
type = GeneratedMesh
dim = 1

nx = 10

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
  [./source_func]
    type = ParsedFunction
    value = 10*exp(-5*x)-4*exp(-x)
    #vars = 'alpha'
    #vals = '16'
  [../]
[]

[Kernels]
  [./diff]
    type = ExampleDiffusion
    variable = pressure
    diffusivity = 0.01  #Pe = 5.0
    source = 1.0
  [../]

  [./conv]
    type = ExampleConvection
    variable = pressure
    advection_speed_x = 1.0
    advection_speed_y = 0
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

  #[./euler]
  #  type = ExampleTimeDerivative
  #  variable = temp
  #  time_coefficient = 1.0
  #[../]
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
    value = 1
  [../]
[]

[Executioner]
  type = Steady
  solve_type = 'PJFNK'
  num_steps = 20
  #dt = 0.001
  start_time = 0
  end_time = 0.1
  scheme = 'crank-nicolson'
  l_max_its = 40
  nl_max_its = 20
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]
