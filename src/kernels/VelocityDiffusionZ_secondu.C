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

#include "VelocityDiffusionZ_secondu.h"

template<>
InputParameters validParams<VelocityDiffusionZ_secondu>()
{
  InputParameters params = validParams<Diffusion>();
  // Here we will look for a parameter from the input file
  params.addCoupledVar("temperature","temperature is required for VelocityDiffusionZ.");
  //params.addParam<unsigned>("component", "x y z component");
  params.addParam<Real>("sign", "The positive or negative sign of VelocityDiffusionZ");
  return params;
}

VelocityDiffusionZ_secondu::VelocityDiffusionZ_secondu(const InputParameters & parameters) :
    Diffusion(parameters),
    // Initialize our member variable based on a default or input file
    _temp(coupledValue("temperature")),
    _grad_temp(coupledGradient("temperature")),
    _second_temp(coupledSecond("temperature")),
    _second_u(second()),
    _second_test(secondTest()),
    _second_phi(secondPhi()),
    _temp_var_num(coupled("temperature")),
    _Ra(getMaterialProperty<Real>("rayleigh_material")),
    //_grad_Ra(getMaterialProperty<RealGradient>("rayleigh")),
    //_component(getParam<unsigned>("component")),
    _sign(getParam<Real>("sign"))
{}

Real
VelocityDiffusionZ_secondu::computeQpResidual()
{
  return Diffusion::computeQpResidual()
         + _sign*_Ra[_qp]*_test[_i][_qp]*(_second_temp[_qp](0, 0) + _second_temp[_qp](2, 2));
}

Real
VelocityDiffusionZ_secondu::computeQpJacobian()
{
  return Diffusion::computeQpJacobian();
}


Real
VelocityDiffusionZ_secondu::computeQpOffDiagJacobian(unsigned jvar)
{
  if(jvar == _temp_var_num)
    return  _sign*_Ra[_qp]*_test[_i][_qp]*(_second_phi[_j][_qp](0, 0) + _second_phi[_j][_qp](2, 2));
  else
    return 0;
}
