[Mesh]
  file = layered_coarse.msh

  block_id = '12 13'
  block_name = 'layer1 layer2'

  boundary_id = '14 15 16 17'
  boundary_name = 'bottom right top left'
[]

[Variables]
  [./temp]
    order = FIRST
    family = LAGRANGE
    initial_condition = 20
  [../]
  #[./pressure]
  #  order = FIRST
  #  family = LAGRANGE
  #[../]
[]

[AuxVariables]
  [./nodal_density]
    order = FIRST
    family = LAGRANGE
  [../]

  [./velocity_x]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./velocity_y]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Kernels]
  [./diff]
    type = PorousDiffusion
    variable = temp
    diffusivity = 1.0
  [../]

  #[./conv]
  #  type = PorousConvection
  #  variable = temp
  #  advection_speed_x = velocity_x
  #  advection_speed_y = velocity_y
  #[../]

  [./euler]
    type = ExampleTimeDerivative
    variable = temp
    time_coefficient = 1.0
  [../]
[]

[AuxKernels]
  [./nodal_example]
    type = AuxDensity
    variable = nodal_density
    coupled = temp
  [../]
[]

[BCs]
  [./bottom_diffused]
    type = PresetBC
    variable = temp
    boundary = 'bottom'
    value = 50
  [../]

  [./top_diffused]
    type = PresetBC
    variable = temp
    boundary = 'top'
    value = 20
  [../]

  #[./pres]
  #  type = PresetBC
  #  variable = pressure
  #  boundary = 'right left'
  #  value = 0
  #[../]
[]

[Materials]
  [./example]
    type = PorousMaterial
    block = 'layer1'
    permeability = 1e-8
    porosity = 0.25
    temp = temp
  [../]

  [./example1]
    type = PorousMaterial
    block = 'layer2'
    permeability = 1e-8
    porosity = 0.25
    temp = temp
  [../]
[]

[Executioner]
  type = Transient   # Here we use the Transient Executioner
  solve_type = 'PJFNK'
  num_steps = 20
  #dt = 0.001
  start_time = 0
  end_time = 1000000
  scheme = 'crank-nicolson'
  l_max_its = 40
  nl_max_its = 20
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]
