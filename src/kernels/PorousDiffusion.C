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

#include "PorousDiffusion.h"

template<>
InputParameters validParams<PorousDiffusion>()
{
  InputParameters params = validParams<Diffusion>();
  // Here we will look for a parameter from the input file
  params.addParam<Real>("diffusivity", 1.0, "Diffusivity Coefficient");
  return params;
}

PorousDiffusion::PorousDiffusion(const InputParameters & parameters) :
    Diffusion(parameters),
    // Initialize our member variable based on a default or input file
    _diffusivity(getParam<Real>("diffusivity")),
    _thermal_diffusivity(getMaterialProperty<Real>("thermal_diffusivity"))
{}

Real
PorousDiffusion::computeQpResidual()
{
  return _diffusivity*_thermal_diffusivity[_qp]*Diffusion::computeQpResidual();
}

Real
PorousDiffusion::computeQpJacobian()
{
  return _diffusivity*_thermal_diffusivity[_qp]*Diffusion::computeQpJacobian();
}
