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

#include "VelocityDiffusion.h"

template<>
InputParameters validParams<VelocityDiffusion>()
{
  InputParameters params = validParams<Diffusion>();
  // Here we will look for a parameter from the input file
  params.addCoupledVar("temperature","temperature is required for VelocityDiffusion.");
  params.addParam<unsigned>("component_1", "x y z component");
  params.addParam<unsigned>("component_2", "x y z component");
  params.addParam<Real>("sign", "The positive or negative sign of VelocityDiffusion");
  params.addParam<Real>("scale", "The scale of the cross differentiation term. VelocityDiffusion");
  return params;
}

VelocityDiffusion::VelocityDiffusion(const InputParameters & parameters) :
    Diffusion(parameters),
    // Initialize our member variable based on a default or input file
    _temp(coupledValue("temperature")),
    _grad_temp(coupledGradient("temperature")),
    _temp_var_num(coupled("temperature")),
    _Ra(getMaterialProperty<Real>("rayleigh_material")),
    //_grad_Ra(getMaterialProperty<RealGradient>("rayleigh")),
    _component_1(getParam<unsigned>("component_1")),
    _component_2(getParam<unsigned>("component_2")),
    _sign(getParam<Real>("sign")),
    _scale(getParam<Real>("scale"))
{}

Real
VelocityDiffusion::computeQpResidual()
{
  return Diffusion::computeQpResidual()
         + _sign*_Ra[_qp]*(_scale * _grad_test[_i][_qp](_component_1)*_grad_temp[_qp](_component_2)
         +  (1.0-_scale) * _grad_test[_i][_qp](_component_2)*_grad_temp[_qp](_component_1));
}

Real
VelocityDiffusion::computeQpJacobian()
{
  return Diffusion::computeQpJacobian();
}


Real
VelocityDiffusion::computeQpOffDiagJacobian(unsigned jvar)
{
  if(jvar == _temp_var_num)
    return _sign*_Ra[_qp]*(_scale * _grad_test[_i][_qp](_component_1)*_grad_phi[_j][_qp](_component_2)
           +(1.0-_scale) * _grad_test[_i][_qp](_component_2)*_grad_phi[_j][_qp](_component_1));
  else
    return 0;
}
