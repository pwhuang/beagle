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

#include "MomentumBalance.h"

template<>
InputParameters validParams<MomentumBalance>()
{
  InputParameters params = validParams<Kernel>();
  params.addCoupledVar("pressure", "pressure");
  params.addRequiredParam<RealVectorValue>("gravity", "0 0 -9.81");
  params.addRequiredParam<unsigned>("component", "0,1,2 depending on if we are solving the x,y,z component of the momentum equation");
  return params;
}

MomentumBalance::MomentumBalance(const InputParameters & parameters) :
    Kernel(parameters),
    // Initialize our member variable based on a default or input file
    _grad_pressure(coupledGradient("pressure")),
    _pressure(coupledValue("pressure")),
    _permeability(getMaterialProperty<Real>("permeability")),
    _viscosity(getMaterialProperty<Real>("viscosity")),
    _density(getMaterialProperty<Real>("density")),
    _gravity(getParam<RealVectorValue>("gravity")),
    _component(getParam<unsigned>("component"))
{}

Real
MomentumBalance::computeQpResidual()
{
  return _test[_i][_qp]*_u[_qp] + _permeability[_qp]/_viscosity[_qp]*(_grad_pressure[_qp](_component)-_density[_qp]*_gravity(_component));
}



Real
MomentumBalance::computeQpJacobian()
{
  return _test[_i][_qp]*_grad_u[_qp](_component);
}
Real
MomentumBalance::computeQpOffDiagJacobian()
{
  return 0;
}
