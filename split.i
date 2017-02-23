[Mesh]
  file = split.msh

  block_id = '17 18'
  block_name = 'layer1 layer2'

  boundary_id = '12 13 14 15 19 20 16'
  boundary_name = 'bottom right top left bottom_point top_point middle'

  second_order = true
[]

[Variables]
  [./temp]
    order = FIRST
    family = LAGRANGE
    initial_condition = 20
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
    order = FIRST
    family = MONOMIAL
  [../]

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

  [./pres]
    type = DarcyPressure
    variable = pressure
    density = nodal_density
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
[]

[AuxKernels]
  [./nodal_example]
    type = AuxDensity
    variable = nodal_density
    coupled = temp
  [../]

  [./nodal_vx]
    type = AuxVelocity
    variable = velocity_x
    density = nodal_density
    pressure = pressure
    component = 0
    gravity = '0 -9.81 0'
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
  #  type = DirichletBC
  #  variable = pressure
  #  boundary = 'bottom'
  #  value = 9800
  #[../]

  [./pres1]
    type = DirichletBC
    variable = pressure
    boundary = 'top_point'
    value = 0
  [../]

  #[./pres2]
  #  type = DirichletBC
  #  variable = pressure
  #  boundary = 'bottom_point left right'
  #  value = 9800
  #[../]
[]

[Materials]
  [./example]
    type = PorousMaterial
    block = 'layer1'
    permeability = 1e-9
    porosity = 0.25
    temp = temp
  [../]

  [./example1]
    type = PorousMaterial
    block = 'layer2'
    permeability = 1e-9
    porosity = 0.25
    temp = temp
  [../]

  [./boundary]
    type = PorousMaterial
    boundary = 'top bottom left right middle'
    permeability = 1e-9
    porosity = 0
    temp = temp
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
  type = Transient   # Here we use the Transient Executioner
  solve_type = 'PJFNK'
  num_steps = 100
  #dt = 0.001
  start_time = 0
  end_time = 50
  scheme = 'crank-nicolson'
  l_max_its = 40
  nl_max_its = 20

  petsc_options = '-snes_mf_operator' #-ksp_monitor'
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]
