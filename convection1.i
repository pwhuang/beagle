[Mesh]
  file = layered_coarse.msh

  block_id = '12 13'
  block_name = 'layer1 layer2'

  boundary_id = '14 15 16 17'
  boundary_name = 'bottom right top left'
  second_order = true
[]


[Variables]
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
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./velocity_y]
    order = FIRST
    family = MONOMIAL
  [../]
[]

[Kernels]
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
    coupled = 20
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
  [./pres]
    type = DirichletBC
    variable = pressure
    boundary = 'top'
    value = 0
  [../]

  [./pres1]
    type = DirichletBC
    variable = pressure
    boundary = 'bottom'
    value = 100
  [../]

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
    block = 'layer1'
    permeability = 1e-8
    porosity = 0.25
    temp = 20
  [../]

  [./example1]
    type = PorousMaterial
    block = 'layer2'
    permeability = 1e-8
    porosity = 0.25
    temp = 20
  [../]

  [./boundary]
    type = PorousMaterial
    boundary = 'top bottom left right'
    permeability = 0
    porosity = 0
    temp = 20
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
  type = Steady #Transient   # Here we use the Transient Executioner
  solve_type = 'PJFNK'
  num_steps = 1000
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
