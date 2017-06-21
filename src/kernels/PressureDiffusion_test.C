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

#include "PressureDiffusion_test.h"

template<>
InputParameters validParams<PressureDiffusion_test>()
{
  InputParameters params = validParams<Diffusion>();
  // Here we will look for a parameter from the input file
  //params.addCoupledVar("temperature","temperature is required for PressureDiffusion_test.");
  params.addParam<unsigned>("component", "x y z component");
  params.addParam<Real>("sign", "The positive or negative sign of stream");
  return params;
}

PressureDiffusion_test::PressureDiffusion_test(const InputParameters & parameters) :
    Diffusion(parameters),
    // Initialize our member variable based on a default or input file
    //_temp(coupledValue("temperature")),
    //_grad_temp(coupledGradient("temperature")),
    _Ra(getMaterialProperty<Real>("rayleigh_material")),
    //_grad_Ra(getMaterialProperty<RealGradient>("rayleigh")),
    _component(getParam<unsigned>("component")),
    _sign(getParam<Real>("sign"))
{}

Real
PressureDiffusion_test::computeQpResidual()
{
  RealVectorValue _gravity = RealVectorValue(0, -1.0, 0);
  return Diffusion::computeQpResidual() + _sign*_grad_test[_i][_qp]*_Ra[_qp]*_gravity;
}

Real
PressureDiffusion_test::computeQpJacobian()
{
  return Diffusion::computeQpJacobian();
}
