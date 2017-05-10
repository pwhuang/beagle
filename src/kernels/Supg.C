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

#include "Supg.h"
#include "Function.h"

template<>
InputParameters validParams<Supg>()
{
  InputParameters params = validParams<Kernel>();
  // Here we will look for a parameter from the input file
  params.addCoupledVar("advection_speed", 1.0, "advection_speed");
  //params.addParam<Real>("advection_speed_y", 1.0, "advection_speed y");
  params.addParam<Real>("h", 1.0, "node distance h");
  params.addParam<Real>("beta", 1.0, "beta term, range from 0 to 1. Beta = 1 for full upwind solution.");
  params.addParam<unsigned>("component", "x y z component");
  params.addParam<FunctionName>("source", 0.0, "Source Term");
  return params;
}

Supg::Supg(const InputParameters & parameters) :
    Kernel(parameters),
    // Initialize our member variable based on a default or input file
    _a(coupledValue("advection_speed")),
    //_advection_speed_y(getParam<Real>("advection_speed_y")),
    _h(getParam<Real>("h")),
    _beta(getParam<Real>("beta")),
    _component(getParam<unsigned>("component")),
    _source(getFunction("source"))
{}

Real
Supg::computeQpResidual()
{
  Real _tau = _beta*_a[_qp]*_h/2.0;
  //Real _a = _advection_speed;//RealVectorValue(_advection_speed_x, _advection_speed_y);
  return _a[_qp]*_grad_test[_i][_qp](_component)*_tau*(_a[_qp]*_grad_u[_qp](_component) - _source.value(_t, _q_point[_qp]));
}

Real
Supg::computeQpJacobian()
{
  Real _tau = _beta*_a[_qp]*_h/2.0;
  //Real _a = _advection_speed;//RealVectorValue(_advection_speed_x, _advection_speed_y);
  return _a[_qp]*_grad_test[_i][_qp](_component)*_tau*(_a[_qp]*_grad_phi[_j][_qp](_component));
}
