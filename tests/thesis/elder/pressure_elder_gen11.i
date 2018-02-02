[Mesh]
  type = GeneratedMesh
  dim = 2

  nx = 128
  ny = 32

  xmin = 0.0
  xmax = 4.0

  ymin = 0.0
  ymax = 1.0

  elem_type = QUAD4
  #uniform_refine = 1
[]

[MeshModifiers]
  [./side]
    type = BoundingBoxNodeSet
    new_boundary = 'bottom_half'
    bottom_left = '1 0 0'
    top_right = '3 0 0'
  [../]
  [./corner_node]
    type = AddExtraNodeset
    new_boundary = 'pinned_node'
    #nodes = '0'
    coord = '0.0 1.0'
  [../]

  [./corner_node2]
    type = AddExtraNodeset
    new_boundary = 'pinned_node2'
    #nodes = '0'
    coord = '4.0 1.0'
  [../]
[]

[Variables]
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
  [./velocity_x]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./velocity_y]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./Peclet]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0
  [../]
  [./CFL]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./entropy]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]


[Kernels]
  active = 'mass diff conv euler supg_x supg_y'
  [./mass]
    type = PressureDiffusion_test
    variable = pressure
    temperature = temp
    component = 1
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
  [../]

  [./supg_x]
    type = PressureConvection_SUPG
    variable = temp
    pressure = pressure
    component = 0
    body_force = 0
    velocity_x = velocity_x
    velocity_y = velocity_y
    Peclet = Peclet
  [../]

  [./supg_y]
    type = PressureConvection_SUPG
    variable = temp
    pressure = pressure
    component = 1
    body_force = 1
    velocity_x = velocity_x
    velocity_y = velocity_y
    Peclet = Peclet
  [../]

  [./euler]
    type = ExampleTimeDerivative
    variable = temp
    time_coefficient = 1.0
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

  [./cell_peclet]
    type = CellPeclet
    variable = Peclet
    velocity_x = velocity_x
    velocity_y = velocity_y
    velocity_z = 0
  [../]

  [./cell_CFL]
    type = CellCFL
    variable = CFL
    velocity_x = velocity_x
    velocity_y = velocity_y
    velocity_z = 0
  [../]

  [./entropy]
    type = EntropyProduction
    variable = entropy
    temp = temp
    velocity_x = velocity_x
    velocity_y = velocity_y
    velocity_z = 0
    T_bar = 16
    deltaT = 8
    alpha = 1.6163e-4
    cf = 4184
    d = 150
  [../]
[]

[BCs]
  [./no_flux_bc]
    type = DirichletBC
    variable = pressure
    boundary = 'pinned_node pinned_node2'
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
    boundary = 'bottom_half'
    value = 1.0
  [../]
[]

[Materials]
  active = 'ra_output'
  [./ra_output]
    type = RayleighMaterial
    block = 0
    function = 22.832
    min = 0
    max = 0
    seed = 363192
    #outputs = exodus
  [../]
[]

[Preconditioning]
  active = 'FSP'
  [./SMP]
    type = SMP
    full = true
    solve_type = 'NEWTON'
    petsc_options_iname = '-pc_type -sub_pc_type -snes_linesearch_type -ksp_gmres_restart -pc_gamg_sym_graph'
    petsc_options_value = 'gasm hypre cp 301 true'
  [../]

  [./FSP]
    type = FSP
    full = true
    solve_type = 'NEWTON'
    topsplit = 'pt'
    [./pt]
      splitting = 'pressure temp'
    [../]
    [./pressure]
      vars = 'pressure'
      petsc_options_iname = '-pc_type -sub_pc_type -snes_linesearch_type -ksp_gmres_restart'
      petsc_options_value = 'gamg hypre cp 151'
    [../]
    [./temp]
      vars = 'temp'
      petsc_options_iname = '-pc_type -sub_pc_type -snes_linesearch_type -ksp_gmres_restart'
      petsc_options_value = 'gasm hypre cp 151'
    [../]
  [../]
[]

[Executioner]
  type = Transient
  #solve_type = 'PJFNK'
  #num_steps = 1000
  #dt = 2e-5
  start_time = 0
  end_time = 2e-1 #5e-2
  l_max_its = 60
  nl_max_its = 30
  #trans_ss_check = true
  #ss_check_tol = 1e-06

  nl_rel_tol = 1e-10
  nl_abs_tol = 1e-12

  #[./TimeStepper]
  #  type = PostprocessorDT
  #  postprocessor = CFL_time_step
  #  dt = 1e-4
  #  scale = 1e-3
  #  factor = 0
  #[../]

  [./TimeIntegrator]
    type = CrankNicolson
  [../]

  [./TimeStepper]
    type = CFLDT
    postprocessor = CFL_time_step
    dt = 2e-5
    activate_time = 2e-4
    max_Ra = 22.832
    cfl = 0.5
    factor = 0
  [../]
[]

[Postprocessors]
  [./Nusselt]
    type = SideFluxAverage
    variable = temp
    boundary = 'top'
    diffusivity = 1.0
  [../]

  [./alive_time]
    type = PerformanceData
    event = ALIVE
    column = total_time_with_sub
  [../]

  [./CFL_time_step]
    type = LevelSetCFLCondition
    velocity_x = velocity_x
    velocity_y = velocity_y
  [../]

  [./L2_temp]
    type = ElementL2Norm
    variable = temp
    outputs = 'csv'
  [../]

  [./L2_pres]
    type = ElementL2Norm
    variable = pressure
    outputs = 'csv'
  [../]

  [./max_Peclet]
    type = ElementExtremeValue
    variable = Peclet
  [../]

  [./max_CFL]
    type = ElementExtremeValue
    variable = CFL #This is the orginal CFL number (approximated with hmin)
  [../]

  [./N_S]
    type = ElementAverageValue
    variable = entropy
  [../]

  [./res]
    type = Residual
    execute_on = timestep_end
    residual_type = FINAL
  [../]
[]

[Outputs]
  execute_on = 'timestep_end'
  csv = true
  [./out]
    type = Exodus
    interval = 10
  [../]
[]
