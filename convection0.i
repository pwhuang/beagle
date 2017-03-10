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

  [./velocity_x]
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
[]

[AuxKernels]
  [./nodal_example]
    type = AuxDensity
    variable = nodal_density
    coupled = 20
  [../]

  [./nodal_vx]
    type = AuxVelocity #MaterialRealVectorValueAux
    variable = velocity_x
    density = nodal_density
    pressure = pressure
    component = 0
    gravity = '0 0 0'
    property = fluid_velocity
  [../]

  [./nodal_vy]
    type = AuxVelocity #MaterialRealVectorValueAux
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
  type = Steady#Transient   # Here we use the Transient Executioner
  solve_type = 'PJFNK'
  num_steps = 500
  #dt = 0.001
  start_time = 0
  end_time = 5000
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
