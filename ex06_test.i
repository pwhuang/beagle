[Mesh]
  type = GeneratedMesh
  dim = 2

  nx = 200
  ny = 100

  xmin = 0.0
  xmax = 2.0

  ymin = 0.0
  ymax = 1.0

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

  [./euler]
    type = ExampleTimeDerivative
    variable = temp
    time_coefficient = 1.0
  [../]

  [./mass_cons]
    type = DarcyPressure
    variable = pressure
    density = nodal_density
  [../]
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
    permeability = 1e-16
    porosity = 0.25
    temp = temp
  [../]

[]

[Executioner]
  type = Transient   # Here we use the Transient Executioner
  solve_type = 'PJFNK'
  num_steps = 10
  #dt = 0.001
  start_time = 0
  end_time = 4000
  scheme = 'crank-nicolson'
  l_max_its = 50
  nl_max_its = 20
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

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]
