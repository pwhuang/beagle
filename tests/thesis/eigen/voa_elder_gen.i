[Mesh]
  type = GeneratedMesh
  dim = 2

  nx = 120
  ny = 32

  xmin = 0.0
  xmax = 4.0

  ymin = 0.0
  ymax = 1.0

  elem_type = QUAD4
[]

[MeshModifiers]
  active = 'side'
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
  [./temp]
    order = FIRST
    family = LAGRANGE
    initial_condition = 0
  [../]

  [./vel_x]
    order = FIRST
    family = LAGRANGE
  [../]

  [./vel_y]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxVariables]
  active = 'sum'
  [./sum]
    order = FIRST
    family = MONOMIAL
  [../]
[]

[Kernels]
  active = 'momentum_x momentum_y diff conv rhs_vel_x rhs_vel_y rhs_T'
  [./momentum_x]
    type = VelocityDiffusion_half
    variable = vel_x
    temperature = temp
    component_1 = 1
    component_2 = 0
    sign = 1.0
    scale = 1.0
  [../]

  [./momentum_y]
    type = VelocityDiffusion_half
    variable = vel_y
    temperature = temp
    component_1 = 0
    component_2 = 0
    sign = -1.0
    scale = 0.0
  [../]

  [./diff]
    type = ExampleDiffusion
    variable = temp
    diffusivity = 1.0
  [../]

  [./conv]
    type = ExampleConvection
    variable = temp
    velocity_x = vel_x
    velocity_y = vel_y
    velocity_z = 0
  [../]

  [./rhs_vel_x]
    type = MassEigenKernel
    variable = vel_x
  [../]

  [./rhs_vel_y]
    type = MassEigenKernel
    variable = vel_y
  [../]

  [./rhs_T]
    type = MassEigenKernel
    variable = temp
  [../]

  [./euler]
    type = ExampleTimeDerivative
    variable = temp
    time_coefficient = 1.0
  [../]
[]

[BCs]
  [./no_flux_bc_x]
    type = DirichletBC
    variable = vel_x
    #boundary = 'top bottom_half bottom_out left right'
    boundary = 'left right'
    value = 0
  [../]

  [./no_flux_bc_y]
    type = DirichletBC
    variable = vel_y
    #boundary = 'top bottom_half bottom_out left right'
    boundary = 'top bottom'
    #boundary = 'top bottom'
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
    boundary = 'bottom_half'
    value = 1.0
  [../]
[]

[AuxKernels]
  active = 'sum_aux'
  [./sum_aux]
    type = ParsedAux
    variable = sum
    execute_on = LINEAR
    args = 'temp vel_x vel_y'
    function = 'temp + vel_x + vel_y'
  [../]
[]

[Materials]
  [./ra_output]
    type = RayleighMaterial
    block = 0 #'layer1'
    function = 22.832
    min = 0
    max = 0
    seed = 363192
    #outputs = exodus
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
    solve_type = 'PJFNK'
    petsc_options_iname = '-pc_type -snes_linesearch_type -ksp_gmres_restart'
    petsc_options_value = 'asm cp 301'
  [../]
[]

[Executioner]
  type = NonlinearEigen
  bx_norm = 'unorm'

  free_power_iterations = 4

  source_abs_tol = 1e-12
  source_rel_tol = 1e-50
  k0 = 1.0
  output_after_power_iterations = false

  l_max_its = 50
  nl_max_its = 100
  [./TimeIntegrator]
    type = CrankNicolson
  [../]
[]

[Postprocessors]
  active = 'unorm'
  [./unorm]
    type = ElementIntegralVariablePostprocessor
    variable = sum
    # execute on residual is important for nonlinear eigen solver!
    execute_on = linear
  [../]
[]

[Outputs]
  execute_on = 'timestep_end'
  csv = true
  [./out]
    type = Exodus
    interval = 1
  [../]
[]
