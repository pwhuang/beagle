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

#include "FunctionSource.h"
#include "Function.h"

template<>
InputParameters validParams<FunctionSource>()
{
  InputParameters params = validParams<Kernel>();
  params.addParam<FunctionName>("source", 0.0, "Source term");
  params.addParam<Real>("elem_num", 1.0, "Element numbers");
  return params;
}

FunctionSource::FunctionSource(const InputParameters & parameters) :
    Kernel(parameters),
    // Initialize our member variable based on a default or input file
    _source(getFunction("source")),
    _elem_num(getParam<Real>("elem_num"))
{}

Real
FunctionSource::computeQpResidual()
{
  return -_source.value(_t, _q_point[_qp])*_test[_i][_qp];
}

Real
FunctionSource::computeQpJacobian()
{
  return 0;
}
