//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "FunctionAmplitudePostprocessor.h"

template <>
InputParameters
validParams<FunctionAmplitudePostprocessor>()
{
  InputParameters params = validParams<ElementIntegralVariablePostprocessor>();
  params.addRequiredParam<FunctionName>("function", "The function of amplitudes.");
  return params;
}

FunctionAmplitudePostprocessor::FunctionAmplitudePostprocessor(const InputParameters & parameters)
  : ElementIntegralVariablePostprocessor(parameters),
  _u(coupledValue("variable")),
  _func(getFunction("function"))
{
  addMooseVariableDependency(mooseVariable());
}

Real
FunctionAmplitudePostprocessor::computeQpIntegral()
{
  return _u[_qp]*_func.value(_t, _q_point[_qp]);
}
