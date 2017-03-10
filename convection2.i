[Mesh]
  type = GeneratedMesh
  dim = 2

  nx = 20
  ny = 10

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
    initial_condition = 35
  [../]

  [./pressure]
    order = FIRST
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
    family = LAGRANGE
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

  [./pres]
    type = DarcyPressure
    variable = pressure
    density = nodal_density
  [../]

  [./vel_x]
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
    type = AuxVelocity#MaterialRealVectorValueAux#AuxVelocity
    variable = velocity_y
    density = nodal_density
    pressure = pressure
    component = 1
    gravity = '0 -9.81 0'
    #property = fluid_velocity
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
  [./pres]
    type = DirichletBC
    variable = pressure
    boundary = 'top'
    value = 0
  [../]

  #[./pres1]
  #  type = DirichletBC
  #  variable = pressure
  #  boundary = 'bottom'
  #  value = 9810
  #[../]

  [./vel_x_noslip_bc]
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
    porosity = 0.25
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
  num_steps = 100
  #dt = 0.001
  start_time = 0
  end_time = 100
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
