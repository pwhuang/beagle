//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef FUNCTIONAMPLITUDEPOSTPROCESSOR_H
#define FUNCTIONAMPLITUDEPOSTPROCESSOR_H

#include "ElementIntegralVariablePostprocessor.h"
#include "Function.h"
#include "MooseVariableInterface.h"

// Forward Declarations
class FunctionAmplitudePostprocessor;
class Function;

template <>
InputParameters validParams<FunctionAmplitudePostprocessor>();

class FunctionAmplitudePostprocessor : public ElementIntegralVariablePostprocessor
{
public:
  FunctionAmplitudePostprocessor(const InputParameters & parameters);

protected:
  virtual Real computeQpIntegral() override;

  /// Holds the solution at current quadrature points
  const VariableValue & _u;
  Function & _func;
};

#endif
