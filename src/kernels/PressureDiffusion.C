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

#include "PressureDiffusion.h"

template<>
InputParameters validParams<PressureDiffusion>()
{
  InputParameters params = validParams<Diffusion>();
  // Here we will look for a parameter from the input file
  params.addCoupledVar("temperature","temperature is required for PressureDiffusion.");
  params.addParam<unsigned>("component", "x y z component");
  params.addParam<Real>("sign", "The positive or negative sign of stream");
  return params;
}

PressureDiffusion::PressureDiffusion(const InputParameters & parameters) :
    Diffusion(parameters),
    // Initialize our member variable based on a default or input file
    _temp(coupledValue("temperature")),
    _grad_temp(coupledGradient("temperature")),
    _Ra(getMaterialProperty<Real>("rayleigh_material")),
    //_grad_Ra(getMaterialProperty<RealGradient>("rayleigh")),
    _component(getParam<unsigned>("component")),
    _sign(getParam<Real>("sign"))
{}

Real
PressureDiffusion::computeQpResidual()
{
  return Diffusion::computeQpResidual() + _sign*_test[_i][_qp]*_Ra[_qp]*_grad_temp[_qp](_component);
          //+ _grad_test[_i][_qp]*_temp[_qp]/_Ra[_qp]*_grad_Ra[_qp](_component);
}

Real
PressureDiffusion::computeQpJacobian()
{
  return Diffusion::computeQpJacobian();
}
