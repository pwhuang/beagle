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

#include "CoupledNeumannBC.h"

template <>
InputParameters
validParams<CoupledNeumannBC>()
{
  InputParameters params = validParams<IntegratedBC>();

  params.addRequiredCoupledVar("stream_function2", "stream_function2 or phi2");
  return params;
}

CoupledNeumannBC::CoupledNeumannBC(const InputParameters & parameters)
  : IntegratedBC(parameters),
    //_str1(coupledGradient("stream_function1")),
    _str2(coupledGradient("stream_function2"))
{
}

Real
CoupledNeumannBC::computeQpResidual()
{
  return -_test[_i][_qp] * (-_grad_u[_qp](1)+_str2[_qp](0));
}
