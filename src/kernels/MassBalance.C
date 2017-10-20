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

#include "MassBalance.h"

template<>
InputParameters validParams<MassBalance>()
{
  InputParameters params = validParams<Kernel>();
  params.addCoupledVar("velocity_x","velocity_x");
  params.addCoupledVar("velocity_y","velocity_y");
  params.addCoupledVar("velocity_z","velocity_z");
  return params;
}

MassBalance::MassBalance(const InputParameters & parameters) :
    Kernel(parameters),
    // Initialize our member variable based on a default or input file
    _grad_velocity_x(coupledGradient("velocity_x")),
    _grad_velocity_y(coupledGradient("velocity_y")),
    _grad_velocity_z(coupledGradient("velocity_z")),
    _u_vel_var_number(coupled("velocity_x")),
    _v_vel_var_number(coupled("velocity_y")),
    _w_vel_var_number(coupled("velocity_z"))
{}

Real
MassBalance::computeQpResidual()
{
  return //(_grad_velocity_x[_qp](0) + _grad_velocity_y[_qp](1) + _grad_velocity_z[_qp](2)) * _test[_i][_qp];
  (_grad_velocity_x[_qp](0) + _grad_u[_qp](1) ) * _test[_i][_qp];
}



Real
MassBalance::computeQpJacobian()
{
  return _grad_phi[_j][_qp](1)*_test[_i][_qp];
}


Real
MassBalance::computeQpOffDiagJacobian(unsigned jvar)
{

  if (jvar == _u_vel_var_number)
    return _grad_phi[_j][_qp](0) * _test[_i][_qp];

  //else if (jvar == _v_vel_var_number)
    //return _grad_phi[_j][_qp](1) * _test[_i][_qp];

  else if (jvar == _w_vel_var_number)
    return _grad_phi[_j][_qp](2) * _test[_i][_qp];

  else
    return 0;
}
