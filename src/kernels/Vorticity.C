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

#include "Vorticity.h"

template<>
InputParameters validParams<Vorticity>()
{
  InputParameters params = validParams<Kernel>();
  // Here we will look for a parameter from the input file
  params.addCoupledVar("temperature","temperature is required for Vorticity.");
  params.addCoupledVar("velocity_1", "velocity_1");
  params.addCoupledVar("velocity_2", "velocity_2");
  params.addParam<unsigned>("component_1", "x y z component");
  params.addParam<unsigned>("component_2", "x y z component");
  params.addParam<unsigned>("component_3", "x y z component");
  params.addParam<Real>("sign", "The positive or negative sign of grad_temp (Voritcity)");
  return params;
}

Vorticity::Vorticity(const InputParameters & parameters) :
    Kernel(parameters),
    // Initialize our member variable based on a default or input file
    _grad_temp(coupledGradient("temperature")),
    _grad_vel_1(coupledGradient("velocity_1")),
    _grad_vel_2(coupledGradient("velocity_2")),
    _Ra(getMaterialProperty<Real>("rayleigh_material")),
    _temp_var_num(coupled("temperature")),
    _vel_1_var_num(coupled("velocity_1")),
    _vel_2_var_num(coupled("velocity_2")),
    _component_1(getParam<unsigned>("component_1")),
    _component_2(getParam<unsigned>("component_2")),
    _component_3(getParam<unsigned>("component_3")),
    _sign(getParam<Real>("sign"))
{}

Real
Vorticity::computeQpResidual()
{
  return //_test[_i][_qp]*(_grad_vel_1[_qp](_component_1) - _grad_vel_2[_qp](_component_2) + _sign*_Ra[_qp]*_grad_temp[_qp](_component_3));
  _test[_i][_qp]*(_grad_u[_qp](_component_1) - _grad_vel_1[_qp](_component_2) + _sign*_Ra[_qp]*_grad_temp[_qp](_component_3));
}

Real
Vorticity::computeQpJacobian()
{
  return _test[_i][_qp]*_grad_phi[_j][_qp](_component_1);
}


Real
Vorticity::computeQpOffDiagJacobian(unsigned jvar)
{
  if(jvar == _temp_var_num)
    return _test[_i][_qp]*_sign*_Ra[_qp]*_grad_phi[_j][_qp](_component_3);

  else if(jvar == _vel_1_var_num)
    return -_test[_i][_qp]*_grad_phi[_j][_qp](_component_2);

  //else if(jvar == _vel_2_var_num)
  //  return -_test[_i][_qp]*_grad_phi[_j][_qp](_component_2);

  else
    return 0;
}
