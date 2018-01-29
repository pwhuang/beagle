[Mesh]
  type = GeneratedMesh
  dim = 2

  nx = 400 #20
  ny = 200 #10

  xmin = 0.0
  xmax = 2.0

  ymin = 0.0
  ymax = 1.0

  elem_type = QUAD9
[]

[MeshModifiers]
  active = ''
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
    coord = '0 0.8'
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
    [./InitialCondition]
      type = FunctionRandomIC
      function = '1-y'
      max = 0
      min = 0
      seed = 1234
    []
  [../]
[]

[AuxVariables]
  active = 'sum'
  [./sum]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Kernels]
  #active = 'mass diff conv rhs_T'
  [./mass]
    type = StreamDiffusion
    variable = stream
    temperature = temp
    component = 0
    sign = 1 #This is intended to be 1. Do not change this!
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

  [./rhs_psi]
    type = StreamEigenKernel
    variable = stream
  [../]

  [./rhs_T]
    type = StreamTempEigenKernel
    variable = temp
    stream_function = stream
  [../]
[]

[AuxKernels]
  active = 'sum_aux'
  [./sum_aux]
    type = ParsedAux
    variable = sum
    execute_on = LINEAR
    args = 'temp stream'
    function = 'sqrt(temp*temp + stream*stream)'
  [../]
[]

[BCs]
  [./no_flux_bc]
    type = DirichletBC
    variable = stream
    boundary = 'top bottom left right'
    #boundary = 'top bottom left right'
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
  [./ra_output]
    type = RayleighMaterial
    block = 0 #layer1'
    function = 20 #22.832
    min = 0
    max = 0
    seed = 363192
    outputs = out
  [../]
[]

[Preconditioning]
  active = ''
  [./SMP]
    type = SMP
    full = true
    solve_type = 'NEWTON'
    petsc_options_iname = '-pc_type -snes_linesearch_type -ksp_gmres_restart'
    petsc_options_value = 'jacobi l2 301'
  [../]

  [./FSP]
    type = FSP
    full = true
    solve_type = 'NEWTON'
    topsplit = 'st'
    [./st]
      splitting = 'stream temp'
    [../]
    [./stream]
      vars = 'stream'
      petsc_options_iname = '-pc_type -sub_pc_type -snes_linesearch_type -ksp_gmres_restart'
      petsc_options_value = 'gamg hypre basic 201'
    [../]
    [./temp]
      vars = 'temp'
      petsc_options_iname = '-pc_type -sub_pc_type -snes_linesearch_type -ksp_gmres_restart'
      petsc_options_value = 'gasm hypre basic 201'
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
  solve_type = NEWTON #PJFNK
[]


[Postprocessors]
  active = 'unorm'
  [./unorm]
    type = ElementL2Norm #ElementIntegralVariablePostprocessor
    function = 0
    variable = sum
    # execute on residual is important for nonlinear eigen solver!
    execute_on = linear
    outputs = 'csv'
  [../]
[]

[Outputs]
  execute_on = 'timestep_end'
  csv = true
  [./console]
    type = Console
    execute_postprocessors_on = 'INITIAL TIMESTEP_END'
    #output_postprocessors = false
  [../]
  [./out]
    type = Exodus
    interval = 1
  [../]
[]
