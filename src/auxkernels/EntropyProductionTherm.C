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

#include "EntropyProductionTherm.h"

template<>
InputParameters validParams<EntropyProductionTherm>()
{
  InputParameters params = validParams<AuxKernel>();
  params.addRequiredCoupledVar("temp", "Entropy Production AuxKernel requires temperature");
  return params;
}

EntropyProductionTherm::EntropyProductionTherm(const InputParameters & parameters) :
    AuxKernel(parameters),
    // Get the gradient of the temperature
    _grad_temp(coupledGradient("temp"))

{}

Real
EntropyProductionTherm::computeValue()
{
  return _grad_temp[_qp]*_grad_temp[_qp];
}
