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

#include "VelocityDiffusion_second.h"

template<>
InputParameters validParams<VelocityDiffusion_second>()
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

VelocityDiffusion_second::VelocityDiffusion_second(const InputParameters & parameters) :
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
    _component_1(getParam<unsigned>("component_1")),
    _component_2(getParam<unsigned>("component_2")),
    _sign(getParam<Real>("sign")),
    _scale(getParam<Real>("scale"))
{}

Real
VelocityDiffusion_second::computeQpResidual()
{
  return Diffusion::computeQpResidual()
         //+ _sign*_Ra[_qp]*(_scale * _grad_test[_i][_qp](_component_1)*_grad_temp[_qp](_component_2)
         //+  (1.0-_scale) * _grad_test[_i][_qp](_component_2)*_grad_temp[_qp](_component_1));
         + _sign*_Ra[_qp]*_second_test[_i][_qp](_component_1, _component_2)*_temp[_qp];
         //+ _sign*_Ra[_qp]*_test[_i][_qp]*_second_temp[_qp](_component_1, _component_2);
}

Real
VelocityDiffusion_second::computeQpJacobian()
{
  return Diffusion::computeQpJacobian();
}


Real
VelocityDiffusion_second::computeQpOffDiagJacobian(unsigned jvar)
{
  if(jvar == _temp_var_num)
    return //_sign*_Ra[_qp]*(_scale * _grad_test[_i][_qp](_component_1)*_grad_phi[_j][_qp](_component_2)
           //+(1.0-_scale) * _grad_test[_i][_qp](_component_2)*_grad_phi[_j][_qp](_component_1));
           _sign*_Ra[_qp]*_second_test[_i][_qp](_component_1, _component_2)*_phi[_j][_qp];
           //_sign*_Ra[_qp]*_test[_i][_qp]*_second_phi[_j][_qp](_component_1, _component_2);
  else
    return 0;
}
