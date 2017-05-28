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

#include "RayleighMaterial.h"

template<>
InputParameters validParams<RayleighMaterial>()
{
  InputParameters params = validParams<Material>();
  params.addRequiredParam<FunctionName>("function", "The initial condition function.");
  params.addParam<Real>("min", 0.0, "Lower bound of the randomly generated values");
  params.addParam<Real>("max", 1.0, "Upper bound of the randomly generated values");
  params.addParam<unsigned int>("seed", 0, "Seed value for the random number generator");

  return params;
}

RayleighMaterial::RayleighMaterial(const InputParameters & parameters) :
    Material(parameters),
    // Declare that this material is going to provide a Real
    // valued property named "permeability" that Kernels can use.
    _Ra(declareProperty<Real>("rayleigh_material")),
    _func(getFunction("function")),
    _min(getParam<Real>("min")),
    _max(getParam<Real>("max")),
    _range(_max - _min)
{}



void
RayleighMaterial::computeQpProperties()
{
  Real rand_num = MooseRandom::rand();

  // Between 0 and range
  rand_num *= _range;

  // Between min and max
  rand_num += _min;

  _Ra[_qp] = _func.value(_t, _q_point[_qp]) + rand_num;
}
