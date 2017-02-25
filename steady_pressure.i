#Kernel for variable 'pressure':
#(1,0) Off-diagonal Jacobian for variable 'temp' needs to be implemented

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

  [./pressure_bottom]
    type = DirichletBC
    variable = pressure
    boundary = 'bottom'
    value = 9735
  [../]
[]

[Materials]
  [./example]
    type = PorousMaterial
    block = 'layer1'
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

#[Preconditioning]
#  [./SMP]
#    type = FDP
#    full = true
#  [../]
#[]


[Executioner]
  type = Steady   # Here we use the Transient Executioner
  solve_type = 'PJFNK'
  l_max_its = 40
  nl_max_its = 20

  #petsc_options = '-snes_mf_operator' #-ksp_monitor'
  #petsc_options_iname = '-pc_type -pc_hypre_type'
  #petsc_options_value = 'hypre boomeramg'
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]
