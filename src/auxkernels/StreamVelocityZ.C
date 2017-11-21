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
#include "StreamVelocityZ.h"

template <>
InputParameters
validParams<StreamVelocityZ>()
{
  MooseEnum component("x=0 y=1 z=2");
  InputParameters params = validParams<AuxKernel>();
  params.addRequiredCoupledVar("stream_function1",
                               "The variable from which to compute the gradient component");
  params.addRequiredCoupledVar("stream_function2",
                               "The variable from which to compute the gradient component");

  //params.addParam<MooseEnum>("component", component, "The gradient component to compute");
  //params.addParam<Real>("sign", 1, "The sign. It should be -1 or 1.");
  return params;
}

StreamVelocityZ::StreamVelocityZ(const InputParameters & parameters)
  : AuxKernel(parameters),
    _str1(coupledGradient("stream_function1")),
    _str2(coupledGradient("stream_function2")),
    _scale(getMaterialProperty<Real>("rayleigh_material"))
    //_component(getParam<MooseEnum>("component")),
    //_sign(getParam<Real>("sign"))
{
}

Real
StreamVelocityZ::computeValue()
{
  return _scale[_qp]*(_str1[_qp](2)-_str2[_qp](0));
}
