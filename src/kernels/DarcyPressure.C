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

#include "DarcyPressure.h"


template<>
InputParameters validParams<DarcyPressure>()
{
  // Start with the parameters from our parent
  InputParameters params = validParams<Diffusion>();
  params.addRequiredCoupledVar("density", "density is required for calculating darcy pressure.");
  params.addRequiredCoupledVar("temperature", "temperature is required for off-diagonals.");
  return params;
}


DarcyPressure::DarcyPressure(const InputParameters & parameters) :
    Diffusion(parameters),
    _permeability(getMaterialProperty<Real>("permeability")),
    _viscosity(getMaterialProperty<Real>("viscosity")),
    _grad_density(coupledGradient("density")),
    _grad_temperature(coupledGradient("temperature"))

{
}

DarcyPressure::~DarcyPressure()
{
}

Real
DarcyPressure::computeQpResidual()
{
  // K/mu * grad_u * grad_phi[i]
  return _permeability[_qp]/_viscosity[_qp] *
          (-Diffusion::computeQpResidual() - _grad_density[_qp](1)*(-9.81)*_test[_i][_qp]);
}

Real
DarcyPressure::computeQpJacobian()
{
  // K/mu * grad_phi[j] * grad_phi[i]
  return _permeability[_qp]/_viscosity[_qp]*
          -Diffusion::computeQpJacobian();
  //return _grad_phi[_j][_qp] * _grad_test[_i][_qp];

}
