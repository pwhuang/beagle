/****************************************************************/
/*               DO NOT MODIFY THIS HEADER                      */
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*           (c) 2010 Battelle Energy Alliance, LLC             */
/*                   ALL RIGHTS RESERVED                        */
/*                                                              */
/*          Prepared by Battelle Energy Alliance, LLC           */
/*            Under Contract No. DE-AC07-05ID14517              */
/*            With the U. S. Department of Energy               */
/*                                                              */
/*            See COPYRIGHT for full restrictions               */
/****************************************************************/

#include "ExampleConvection.h"

template<>
InputParameters validParams<ExampleConvection>()
{
  InputParameters params = validParams<Kernel>();
  params.addCoupledVar("velocity_x", "velocity_x");
  params.addCoupledVar("velocity_y", "velocity_y");
  params.addCoupledVar("velocity_z", "velocity_z");
  return params;
}

ExampleConvection::ExampleConvection(const InputParameters & parameters) :
    Kernel(parameters),
    _advection_speed_x(coupledValue("velocity_x")),
    _advection_speed_y(coupledValue("velocity_y")),
    _advection_speed_z(coupledValue("velocity_z")),
    _vel_x_var_num(coupled("velocity_x")),
    _vel_y_var_num(coupled("velocity_y")),
    _vel_z_var_num(coupled("velocity_z")),
    _Ra(getMaterialProperty<Real>("rayleigh_material"))
{}

Real ExampleConvection::computeQpResidual()
{
  RealVectorValue _advection_speed = RealVectorValue(_advection_speed_x[ _qp ], _advection_speed_y[ _qp ], _advection_speed_z[ _qp ]);
  return _test[_i][_qp]*_Ra[_qp]*(_advection_speed*_grad_u[_qp]);
}

Real ExampleConvection::computeQpJacobian()
{
  RealVectorValue _advection_speed = RealVectorValue(_advection_speed_x[ _qp ], _advection_speed_y[ _qp ], _advection_speed_z[ _qp ]);
  return _test[_i][_qp]*_Ra[_qp]*(_advection_speed*_grad_phi[_j][_qp]);
}

Real ExampleConvection::computeQpOffDiagJacobian(unsigned jvar)
{

  if (jvar == _vel_x_var_num)
    return _Ra[_qp]*_phi[_j][_qp] * _grad_u[_qp](0) * _test[_i][_qp];

  else if (jvar == _vel_y_var_num)
    return _Ra[_qp]*_phi[_j][_qp] * _grad_u[_qp](1) * _test[_i][_qp];

  else if (jvar == _vel_z_var_num)
    return _Ra[_qp]*_phi[_j][_qp] * _grad_u[_qp](2) * _test[_i][_qp];

  else
    return 0;
}
