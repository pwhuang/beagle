[Mesh]
  file = 'tests/mesh_fine.msh'
  dim = 2
[]

[MeshModifiers]
  [./scale]
    type = Transform
    transform = SCALE
    vector_value = '0.0000645 0.0000645 0.0000645'
  [../]
[]

[Variables]
  active = 'pressure temp'
  [./pressure]
    order = FIRST
    family = LAGRANGE
  [../]
  [./temp]
    order = FIRST
    family = LAGRANGE
    initial_condition = 0.0
  [../]
[]

[AuxVariables]
  #active = ''
  [./velocity_x]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./velocity_y]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Functions]
  active = 'ic_func ra_func ic_func_temp'
  [./ic_func]
    type = ParsedFunction
    value = '(1.0-y)*10'
    #vars = 'alpha'
    #vals = '16'
  [../]

  [./ic_func_temp]
    type = ParsedFunction
    value = '(1.0-y)*1'
    #vars = 'alpha'
    #vals = '16'
  [../]

  [./ra_func]
    type = ParsedFunction
    value = '40' #'40.0' #Rayleigh_number is set to be negative due to downwards gravity.
    #vars = 'alpha'
    #vals = '16'
  [../]
[]

[ICs]
  active = ''
  [./mat_1]
    type = FunctionIC
    variable = pressure
    function = ic_func
  [../]

  [./mat_2]
    type = FunctionRandomIC
    variable = temp
    function = ic_func_temp
    min = 0
    max = 0
    seed = 524685
  [../]
[]


[Kernels]
  active = 'mass diff conv euler'
  [./mass]
    type = PressureDiffusion_test
    variable = pressure
    temperature = temp
    component = 1
    sign = -1.0 #negative
  [../]

  [./diff]
    type = ExampleDiffusion
    variable = temp
    diffusivity = 1.0
  [../]

  [./conv]
    type = PressureConvection
    variable = temp
    pressure = pressure
    component = 1
    #Rayleigh_number = 61.36
  [../]

  [./euler]
    type = ExampleTimeDerivative
    variable = temp
    time_coefficient = 1.0
  [../]

  [./supg_x]
    type = Supg
    variable = temp
    advection_speed = velocity_x
    h = 0.05
    beta = 1.0
    component = 0
  [../]

  [./supg_y]
    type = Supg
    variable = temp
    advection_speed = velocity_y
    h = 0.005
    beta = 1.0
    component = 1
  [../]
[]

[AuxKernels]
  [./velocity_x_aux]
    type = DarcyVelocity
    variable = velocity_x
    pressure = pressure
    temperature = 0
    component = 0
  [../]

  [./velocity_y_aux]
    type = DarcyVelocity
    variable = velocity_y
    pressure = pressure
    temperature = temp
    component = 1
  [../]
[]

[BCs]
  active = 'no_flux_bc top_temp bottom_temp'
  [./no_flux_bc]
    type = DirichletBC
    variable = pressure
    boundary = 'top' #'pinned_node'
    value = 0.0
  [../]

  [./top_temp]
    type = DirichletBC
    variable = temp
    boundary = 'top'
    value = 0.0
  [../]

  [./bottom_temp]
    type = DirichletBC
    variable = temp
    boundary = 'bottom'
    value = 1.0
  [../]
[]

[Materials]
  [./basement]
   type = RayleighMaterial
   block = 'basement'
   function = -0.02
   min = 0
   max = 0
   seed = 363192
   outputs = exodus
  [../]

  [./cattamarra_Coal_Measures]
   type = RayleighMaterial
   block = 'coal_layer'
   function = -0.16
   min = 0
   max = 0
   seed = 363192
   outputs = exodus
  [../]

  [./west_block]
   type = RayleighMaterial
   block = 'west_block'
   function = -1.88
   min = 0
   max = 0
   seed = 363192
   outputs = exodus
  [../]

  [./aquifer_near_surface] # Yarragadee
   type = RayleighMaterial
   block = 'aquifer_near_surface'
   function = -383.86
   min = 0
   max = 0
   seed = 363192
   outputs = exodus
  [../]

  [./surface_layers] #neocomian uncorformity
   type = RayleighMaterial
   block = 'surface_layers'
   function = -208.977
   min = 0
   max = 0
   seed = 363192
   outputs = exodus
  [../]

  [./aquifer_subsurface]
   type = RayleighMaterial
   block = 'aquifer_subsurface'
   function = -15.6266
   min = 0
   max = 0
   seed = 363192
   outputs = exodus
  [../]

  [./moho]
   type = RayleighMaterial
   block = 'moho'
   function = -0.02
   min = 0
   max = 0
   seed = 363192
   outputs = exodus
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
  type = Transient
  solve_type = 'PJFNK'
  #num_steps = 20
  dt = 0.2
  dtmin = 0.001
  start_time = 0
  end_time = 8.0
  scheme = 'crank-nicolson'
  l_max_its = 200
  nl_max_its = 200
  #petsc_options = '-snes_mf_operator' #-ksp_monitor'
  #petsc_options_iname = '-pc_type -pc_hypre_type'
  #petsc_options_value = 'hypre boomeramg'
[]

[Postprocessors]
  [./Nusselt]
    type = SideFluxAverage
    variable = temp
    boundary = 'top'
    diffusivity = 1.0
  [../]

  [./alive_time]
    type = RunTime
    time_type = alive
  [../]
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]
