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

#include "CFLDT.h"

template <>
InputParameters
validParams<CFLDT>()
{
  InputParameters params = validParams<TimeStepper>();
  params.addRequiredParam<PostprocessorName>("postprocessor",
                                             "The name of the postprocessor that computes the dt");
  params.addRequiredParam<Real>("max_Ra",
                                "Maximum sqrt(Ra)");
  params.addParam<Real>("dt", "Initial value of dt");
  params.addParam<Real>("cfl", 1, "Desired CFL value.");
  params.addParam<Real>("factor", 0, "Add a factor to the supplied postprocessor value.");
  return params;
}

CFLDT::CFLDT(const InputParameters & parameters)
  : TimeStepper(parameters),
    PostprocessorInterface(this),
    _pps_value(getPostprocessorValue("postprocessor")),
    _max_Ra(getParam<Real>("max_Ra")),
    _has_initial_dt(isParamValid("dt")),
    _initial_dt(_has_initial_dt ? getParam<Real>("dt") : 0.),
    //_Ra(getMaterialProperty<Real>("rayleigh_material")),
    _cfl_num(getParam<Real>("cfl")),
    _factor(getParam<Real>("factor"))
{
}

Real
CFLDT::computeInitialDT()
{
  if (_has_initial_dt)
    return _initial_dt;
  else
    return computeDT();
}

Real
CFLDT::computeDT()
{
  return _cfl_num / _max_Ra * _pps_value + _factor;
}
