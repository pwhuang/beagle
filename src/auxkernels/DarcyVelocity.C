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

#include "DarcyVelocity.h"

template<>
InputParameters validParams<DarcyVelocity>()
{
  InputParameters params = validParams<AuxKernel>();
  params.addRequiredCoupledVar("pressure", "pressure");
  params.addCoupledVar("temperature", "temperature");
  params.addRequiredParam<unsigned>("component", "0,1,2 depending on if we are solving the x,y,z component of the momentum equation");
  //params.addRequiredParam<RealVectorValue>("gravity", "0 0 -9.81");

  return params;
}

DarcyVelocity::DarcyVelocity(const InputParameters & parameters) :
    AuxKernel(parameters),
    _grad_pressure(coupledGradient("pressure")),
    _temp(coupledValue("temperature")),
    _component(getParam<unsigned>("component")),
    _Ra(getMaterialProperty<Real>("rayleigh_material"))
{}

/**
 * Auxiliary Kernels override computeValue() instead of computeQpResidual().  Aux Variables
 * are calculated either one per elemenet or one per node depending on whether we declare
 * them as "Elemental (Constant Monomial)" or "Nodal (First Lagrange)".  No changes to the
 * source are necessary to switch from one type or the other.
 */
Real
DarcyVelocity::computeValue()
{
  return -_grad_pressure[_qp](_component) + _temp[_qp];
}
