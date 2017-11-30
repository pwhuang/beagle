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

#include "VelocityDiffusionZ.h"

template<>
InputParameters validParams<VelocityDiffusionZ>()
{
  InputParameters params = validParams<Diffusion>();
  // Here we will look for a parameter from the input file
  params.addCoupledVar("temperature","temperature is required for VelocityDiffusionZ.");
  //params.addParam<unsigned>("component", "x y z component");
  //params.addParam<Real>("sign", "The positive or negative sign of VelocityDiffusionZ");
  return params;
}

VelocityDiffusionZ::VelocityDiffusionZ(const InputParameters & parameters) :
    Diffusion(parameters),
    // Initialize our member variable based on a default or input file
    _temp(coupledValue("temperature")),
    _grad_temp(coupledGradient("temperature")),
    _temp_var_num(coupled("temperature")),
    _Ra(getMaterialProperty<Real>("rayleigh_material"))
    //_grad_Ra(getMaterialProperty<RealGradient>("rayleigh")),
    //_component(getParam<unsigned>("component")),
    //_sign(getParam<Real>("sign"))
{}

Real
VelocityDiffusionZ::computeQpResidual()
{
  return Diffusion::computeQpResidual()
  -_Ra[_qp]*(_grad_test[_i][_qp](0)*_grad_temp[_qp](0) + _grad_test[_i][_qp](2)*_grad_temp[_qp](2));
}

Real
VelocityDiffusionZ::computeQpJacobian()
{
  return Diffusion::computeQpJacobian();
}


Real
VelocityDiffusionZ::computeQpOffDiagJacobian(unsigned jvar)
{
  if(jvar == _temp_var_num)
    return -_Ra[_qp]*(_grad_test[_i][_qp](0)*_grad_phi[_j][_qp](0) + _grad_test[_i][_qp](2)*_grad_phi[_j][_qp](2));
  else
    return 0;
}
