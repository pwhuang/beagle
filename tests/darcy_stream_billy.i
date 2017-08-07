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
  [./stream]
    order = FIRST
    family = LAGRANGE
  [../]
  [./temp]
    order = FIRST
    family = LAGRANGE
    initial_condition = 0
  [../]
[]

[AuxVariables]
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
  active = 'ic_func ra_func'
  [./ic_func]
    type = ParsedFunction
    value = '(1.0-y)*1'
    #vars = 'alpha'
    #vals = '16'
  [../]

  [./ra_func]
    type = ParsedFunction
    value = 'x*50'#'(1.0-y)*100'
    #vars = 'alpha'
    #vals = '16'
  [../]
[]

[ICs]
  active = ''
  [./mat_1]
    type = FunctionIC
    variable = temp
    function = ic_func
  [../]

  [./mat_2]
    type = FunctionRandomIC
    variable = temp
    function = ic_func
    min = -0.01
    max = 0.01
    seed = 524685
  [../]
[]


[Kernels]
  active = 'mass diff conv euler'
  [./mass]
    type = StreamDiffusion
    variable = stream
    temperature = temp
    component = 0
    sign = -1 #This is intended to be -1. Do not change this!
  [../]

  [./diff]
    type = ExampleDiffusion
    variable = temp
    diffusivity = 1.0
  [../]

  [./conv]
    type = RayleighConvection
    variable = temp
    stream_function = stream
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
    h = 0.05
    beta = 1.0
    component = 1
  [../]
[]

[AuxKernels]
  [./velocity_x_aux]
    type = VariableGradientComponent
    variable = velocity_x
    gradient_variable = stream
    component = 'y'
  [../]

  [./velocity_y_aux]
    type = VariableGradientComponent
    variable = velocity_y
    gradient_variable = stream
    component = 'x'
  [../]
[]

[BCs]
  active = 'no_flux_bc top_temp bottom_temp'
  [./no_flux_bc]
    type = DirichletBC
    variable = stream
    boundary = 'top bottom left right'
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
   function = 0.02
   min = 0
   max = 0
   seed = 363192
   outputs = exodus
  [../]

  [./cattamarra_Coal_Measures]
   type = RayleighMaterial
   block = 'coal_layer'
   function = 0.16
   min = 0
   max = 0
   seed = 363192
   outputs = exodus
  [../]

  [./west_block]
   type = RayleighMaterial
   block = 'west_block'
   function = 1.88
   min = 0
   max = 0
   seed = 363192
   outputs = exodus
  [../]

  [./aquifer_near_surface] # Yarragadee
   type = RayleighMaterial
   block = 'aquifer_near_surface'
   function = 383.86
   min = 0
   max = 0
   seed = 363192
   outputs = exodus
  [../]

  [./surface_layers] #neocomian uncorformity
   type = RayleighMaterial
   block = 'surface_layers'
   function = 208.977
   min = 0
   max = 0
   seed = 363192
   outputs = exodus
  [../]

  [./aquifer_subsurface]
   type = RayleighMaterial
   block = 'aquifer_subsurface'
   function = 15.6266
   min = 0
   max = 0
   seed = 363192
   outputs = exodus
  [../]

  [./moho]
   type = RayleighMaterial
   block = 'moho'
   function = 0.02
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
  dt = 0.01
  dtmin = 0.00001
  start_time = 0
  end_time = 20.0
  scheme = 'crank-nicolson'
  l_max_its = 80
  nl_max_its = 30
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
  execute_on = 'initial timestep_end'
  exodus = true
[]
