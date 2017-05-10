[Mesh]
  file = single_layer.msh

  block_id = '11'
  block_name = 'layer1'

  boundary_id = '5 6 7 8'
  boundary_name = 'bottom right top left'
  second_order = true
[]

[Variables]
  [./temp]
    order = FIRST
    family = LAGRANGE
    initial_condition = 20
  [../]
  [./pressure]
    order = SECOND
    family = LAGRANGE
  [../]
  [./velocity_x]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxVariables]
  [./nodal_density]
    order = FIRST
    family = MONOMIAL
  [../]

  #[./velocity_x]
  #  order = FIRST
  #  family = MONOMIAL
  #[../]

  [./velocity_y]
    order = FIRST
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
    advection_speed_x = 0#velocity_x
    advection_speed_y = velocity_y
  [../]

  [./euler]
    type = ExampleTimeDerivative
    variable = temp
    time_coefficient = 1.0
  [../]

  [./mass]
    type = MassBalance
    variable = velocity_x
    velocity_x = velocity_x
    velocity_y = velocity_y
  [../]

  [./pressure]
    type = DarcyPressure
    variable = pressure
    density = nodal_density
    temperature = temp
  [../]
[]

[AuxKernels]
  [./nodal_example]
    type = AuxDensity
    variable = nodal_density
    coupled = temp
    reference = 20
  [../]

  [./nodal_vy]
    type = AuxVelocity
    variable = velocity_y
    density = nodal_density
    pressure = pressure
    component = 1
    gravity = '0 -9.81 0'
  [../]

[]

[BCs]
  [./bottom_diffused]
    type = DirichletBC
    variable = temp
    boundary = 'bottom'
    value = 50
  [../]

  [./top_diffused]
    type = DirichletBC
    variable = temp
    boundary = 'top'
    value = 20
  [../]

  [./pressure_top]
    type = DirichletBC
    variable = pressure
    boundary = 'top'
    value = 0
  [../]

  #[./pressure_bottom]
  #  type = DirichletBC
  #  variable = pressure
  #  boundary = 'bottom'
  #  value = 9810
  #[../]

  [./no_slip_x]
    type = DirichletBC
    variable = velocity_x
    boundary = 'top bottom left right'
    value = 0
  [../]

[]

[Materials]
  [./example]
    type = PorousMaterial
    #block = 'layer1'
    permeability = 1e-9
    porosity = 1.0
    temp = temp
    initial_temp = 20
  [../]
[]



[Executioner]
  type = Transient   # Here we use the Transient Executioner
  solve_type = 'PJFNK'
  #num_steps = 100
  dt = 100
  start_time = 0
  end_time = 30000
  scheme = 'crank-nicolson'
  l_max_its = 30
  nl_max_its = 30

  petsc_options = '-snes_mf_operator' #-ksp_monitor'
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]
