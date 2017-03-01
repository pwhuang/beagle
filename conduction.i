[Mesh]
  file = layered_coarse.msh

  block_id = '12 13'
  block_name = 'layer1 layer2'

  boundary_id = '14 15 16 17'
  boundary_name = 'bottom right top left'
  #second_order = true
[]

[Variables]
  [./temp]
    order = FIRST
    family = LAGRANGE
    initial_condition = 35
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

  #[./euler]
  #  type = ExampleTimeDerivative
  #  variable = temp
  #  time_coefficient = 1.0
  #[../]
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
    boundary = 'top bottom left right'
    permeability = 0
    porosity = 0
    temp = temp
  [../]
[]


[Executioner]
  type = Steady#Transient   # Here we use the Transient Executioner
  solve_type = 'PJFNK'
  num_steps = 200
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
