[Mesh]
  type = GeneratedMesh
  dim = 2

  nx = 40
  ny = 20

  xmin = 0.0
  xmax = 0.02

  ymin = 0.0
  ymax = 0.01
  elem_type = QUAD9
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
  [./velocity_x]
    order = SECOND
    family = LAGRANGE
  [../]
[]

[AuxVariables]
  [./nodal_density]
    order = FIRST
    family = MONOMIAL
  [../]

  [./velocity_y]
    order = SECOND
    family = MONOMIAL
  [../]
[]

[Kernels]
  [./diff]
    type = PorousDiffusion
    variable = temp
    diffusivity = 1.0
  [../]

  [./pressure]
    type = DarcyPressure
    variable = pressure
    density = nodal_density
    temperature = temp
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

  [./mass_conservation]
    type = MassBalance
    variable = velocity_x
    velocity_y = velocity_y
  [../]
[]

[AuxKernels]
  [./nodal_example]
    type = AuxDensity
    variable = nodal_density
    coupled = temp
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

  [./no_slip]
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
    permeability = 1e-8
    porosity = 0.1
    temp = temp
  [../]

  [./boundary]
    type = PorousMaterial
    boundary = 'top bottom left right'
    permeability = 0
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
  num_steps = 1
  #dt = 0.001
  start_time = 0
  end_time = 100
  scheme = 'crank-nicolson'
  l_max_its = 50
  nl_max_its = 50

  #petsc_options = '-snes_mf_operator' #-ksp_monitor'
  #petsc_options_iname = '-pc_type -pc_hypre_type'
  #petsc_options_value = 'hypre boomeramg'
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]
