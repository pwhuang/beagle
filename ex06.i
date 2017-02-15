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
    initial_condition = 30
  [../]
  [./pressure]
    order = FIRST
    family = LAGRANGE
  [../]
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

  [./conv]
    type = PorousConvection
    variable = temp
    advection_speed_x = velocity_x
    advection_speed_y = velocity_y
  [../]

  #[./euler]
  #  type = ExampleTimeDerivative
  #  variable = temp
  #  time_coefficient = 1.0
  #[../]

  [./mass_cons]
    type = DarcyPressure
    variable = pressure
    density = nodal_density
  [../]

  #[./euler1]
  #  type = ExampleTimeDerivative
  #  variable = pressure
  #  time_coefficient = 1.0
  #[../]
[]

[AuxKernels]
  [./nodal_example]
    type = AuxDensity
    variable = nodal_density
    coupled = temp
  [../]

  [./velocity_x_aux]
    type = AuxVelocity
    variable = velocity_x
    pressure = pressure
    component = 0
    gravity = '0 -9.81 0'
  [../]

  [./velocity_y_aux]
    type = AuxVelocity
    variable = velocity_y
    pressure = pressure
    component = 1
    gravity = '0 -9.81 0'
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

  [./pres_top]
    type = PresetBC
    variable = pressure
    boundary = 'top'
    value = 0
  [../]

  [./pres_bottom]
    type = PresetBC
    variable = pressure
    boundary = 'bottom'
    value = 9800
  [../]
[]
[Materials]
  [./example]
    type = PorousMaterial
    block = 'layer1'
    permeability = 1e-24
    porosity = 0.25
    temp = temp
  [../]

  [./example1]
    type = PorousMaterial
    block = 'layer2'
    permeability = 1e-24
    porosity = 0.25
    temp = temp
  [../]
[]

[Adaptivity]
  marker = errorfrac
  steps = 2
  [./Indicators]
    [./error]
      type = GradientJumpIndicator
      variable = temp
      outputs = none
    [../]
  [../]
  [./Markers]
    [./errorfrac]
      type = ErrorFractionMarker
      refine = 0.5
      coarsen = 0
      indicator = error
      outputs = none
    [../]
  [../]
[]

[Executioner]
  type = Steady   # Here we use the Transient Executioner
  solve_type = 'PJFNK'
  num_steps = 5
  #dt = 0.001
  start_time = 0
  end_time = 0.2
  scheme = 'crank-nicolson'
  l_max_its = 40
  nl_max_its = 20
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]
