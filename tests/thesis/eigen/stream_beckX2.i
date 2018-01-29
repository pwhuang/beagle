[Mesh]
  file = '../../mesh/beckX2.msh'
  second_order = true
[]

[Variables]
  [./psi_1]
    order = FIRST
    family = LAGRANGE
  [../]
  [./psi_2]
    order = FIRST
    family = LAGRANGE
  [../]
  [./temp]
    order = SECOND
    family = LAGRANGE
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

  [./velocity_z]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./Peclet]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./CFL]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./entropy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./sum]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Functions]
  [./ic_func]
    type = ParsedFunction
    value = '1.0-y'
  [../]
[]

[ICs]
  active = 'mat_2'
  [./mat_1]
    type = FunctionIC
    variable = temp
    function = ic_func
  [../]

  [./mat_2]
    type = FunctionRandomIC
    variable = temp
    function = ic_func
    min = -1e-2
    max = 1e-2
    seed = 52468
  [../]
[]

[Kernels]
  [./mass]
    type = MassBalance
    variable = temp
    velocity_x = psi_1
    velocity_z = psi_2
  [../]

  [./stream1]
    type = StreamDiffusion
    variable = psi_1
    component = 2
    sign = -1.0
    temperature = temp
  [../]

  [./stream2]
    type = StreamDiffusion
    variable = psi_2
    component = 0
    sign = 1.0
    temperature = temp
  [../]

  [./diff]
    type = ExampleDiffusion
    variable = temp
    diffusivity = 1.0
  [../]

  [./conv]
    type = RayleighConvection3d
    variable = temp
    stream_function1 = psi_1
    stream_function2 = psi_2
  [../]

  [./rhs_psi_1]
    type = MassEigenKernel
    variable = psi_1
  [../]

  [./rhs_psi_2]
    type = MassEigenKernel
    variable = psi_2
  [../]

  [./rhs_T]
    type = MassEigenKernel
    variable = T
  [../]
[]

[AuxKernels]
  [./velocity_x_aux]
    type = VariableGradientSign
    variable = velocity_x
    gradient_variable = psi_2
    component = 'y'
    sign = 1.0
  [../]

  [./velocity_y_aux]
    type = StreamVelocityZ
    variable = velocity_y
    stream_function1 = psi_1
    stream_function2 = psi_2
  [../]

  [./velocity_z_aux]
    type = VariableGradientSign
    variable = velocity_z
    gradient_variable = psi_1
    component = 'y'
    sign = -1.0
  [../]

  [./cell_peclet]
    type = CellPeclet
    variable = Peclet
    velocity_x = velocity_x
    velocity_y = velocity_y
    velocity_z = velocity_z
  [../]
  [./cell_CFL]
    type = CellCFL
    variable = CFL
    velocity_x = velocity_x
    velocity_y = velocity_y
    velocity_z = velocity_z
  [../]

  [./entropy]
    type = EntropyProduction
    variable = entropy
    temp = temp
    velocity_x = velocity_x
    velocity_y = velocity_y
    velocity_z = velocity_z
    T_bar = 16
    deltaT = 8
    alpha = 1.6163e-4
    cf = 4184
    d = 150
  [../]

  [./sum_aux]
    type = ParsedAux
    variable = sum
    execute_on = LINEAR
    args = 'temp psi_1 psi_2'
    function = 'sqrt(temp*temp + psi_1*psi_1 + psi_2*psi_2)'
  [../]
[]

[BCs]
  [./no_flow_1]
    type = PresetBC
    variable = psi_1
    boundary = 'bottom top front back'
    value = 0
  [../]

  [./no_flow_2]
    type = PresetBC
    variable = psi_2
    boundary = 'bottom top left right'
    #boundary = 'bottom top left right front back'
    value = 0
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
  [./ra_output]
    type = RayleighMaterial
    block = 'layer1'
    function = 7
    min = 0
    max = 0
    seed = 363192
    outputs = out
  [../]
[]

[Preconditioning]
  active = 'FSP'
  [./SMP]
    type = SMP
    full = true
    solve_type = 'NEWTON'
    petsc_options_iname = '-pc_type -sub_pc_type -snes_linesearch_type -ksp_gmres_restart -pc_gamg_sym_graph'
    petsc_options_value = 'gamg hypre cp 301 true'
  [../]
  [./FSP]
    type = FSP
    full = true
    solve_type = 'NEWTON'
    topsplit = 'pt'
    [./pt]
      splitting = 'psi_1 psi_2 temp'
    [../]
    [./psi_1]
      vars = 'psi_1'
      petsc_options_iname = '-pc_type -sub_pc_type -snes_linesearch_type -ksp_gmres_restart'
      petsc_options_value = 'gamg hypre cp 151'
    [../]
    [./psi_2]
      vars = 'psi_2'
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
  type = NonlinearEigen #InversePowerMethod
  bx_norm = 'unorm'
  Chebyshev_acceleration_on = false
  #auto_initialization = true
  #line_search = cp

  free_power_iterations = 0

  source_abs_tol = 1e-12
  #source_rel_tol = 1e-50
  k0 = 0.1
  output_after_power_iterations = true

  l_max_its = 50
  nl_max_its = 5000
  solve_type = PJFNK
[]

[Postprocessors]
  [./Nusselt]
    type = SideFluxAverage
    variable = temp
    boundary = 'top'
    diffusivity = 1.0
    outputs = 'csv console'
  [../]

  [./alive_time]
    type = PerformanceData
    event = ALIVE
    column = total_time_with_sub
  [../]

  [./L2_temp]
    type = ElementL2Norm
    variable = temp
    outputs = 'csv'
  [../]

  [./L2_psi_1]
    type = ElementL2Norm
    variable = psi_1
    outputs = 'csv'
  [../]

  [./L2_psi_2]
    type = ElementL2Norm
    variable = psi_2
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

  [./CFL_time_step]
    type = LevelSetCFLCondition
    velocity_x = velocity_x
    velocity_y = velocity_y
    velocity_z = velocity_z
  [../]

  [./N_S]
    type = ElementAverageValue
    variable = entropy
  [../]

  [./unorm]
    type = ElementL2Norm #ElementIntegralVariablePostprocessor
    function = 0
    variable = sum
    # execute on residual is important for nonlinear eigen solver!
    execute_on = linear
    outputs = 'csv'
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
    interval = 200
    additional_execute_on = TIMESTEP_END
  [../]
[]
