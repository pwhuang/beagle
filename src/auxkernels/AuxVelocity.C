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

#include "AuxVelocity.h"
#include <math.h>

template<>
InputParameters validParams<AuxVelocity>()
{
  InputParameters params = validParams<AuxKernel>();
  params.addRequiredCoupledVar("pressure", "pressure");
  params.addRequiredParam<unsigned>("component", "0,1,2 depending on if we are solving the x,y,z component of the momentum equation");
  params.addRequiredParam<RealVectorValue>("gravity", "0 0 -9.81");

  return params;
}

AuxVelocity::AuxVelocity(const InputParameters & parameters) :
    AuxKernel(parameters),

    // We can couple in a value from one of our kernels with a call to coupledValueAux
    _permeability(getMaterialProperty<Real>("permeability")),
    _viscosity(getMaterialProperty<Real>("viscosity")),
    _density(getMaterialProperty<Real>("density")),
    _grad_pressure(coupledGradient("pressure")),
    _gravity(getParam<RealVectorValue>("gravity")),
    _component(getParam<unsigned>("component"))
{}

/**
 * Auxiliary Kernels override computeValue() instead of computeQpResidual().  Aux Variables
 * are calculated either one per elemenet or one per node depending on whether we declare
 * them as "Elemental (Constant Monomial)" or "Nodal (First Lagrange)".  No changes to the
 * source are necessary to switch from one type or the other.
 */
Real
AuxVelocity::computeValue()
{
  return -_permeability[_qp]/_viscosity[_qp]*(_grad_pressure[_qp](_component)
          -_density[_qp]*_gravity(_component));
}
