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
#include "CellCFL.h"

template <>
InputParameters
validParams<CellCFL>()
{
  MooseEnum component("x=0 y=1 z=2");
  InputParameters params = validParams<AuxKernel>();
  params.addRequiredCoupledVar("velocity_x", "The velocity in x component");
  params.addRequiredCoupledVar("velocity_y", "The velocity in y component");
  params.addRequiredCoupledVar("velocity_z", "The velocity in z component");
  //params.addParam<MooseEnum>("component", component, "The gradient component to compute");
  //params.addParam<Real>("sign", 1, "The sign. It should be -1 or 1.");
  return params;
}

CellCFL::CellCFL(const InputParameters & parameters)
  : AuxKernel(parameters),
    _feproblem(dynamic_cast<FEProblemBase &>(_subproblem)),
    _velocity_x(coupledValue("velocity_x")),
    _velocity_y(coupledValue("velocity_y")),
    _velocity_z(coupledValue("velocity_z")),
    _scale(getMaterialProperty<Real>("rayleigh_material"))
    //_component(getParam<MooseEnum>("component")),
    //_sign(getParam<Real>("sign"))
{
}

Real
CellCFL::computeValue()
{
  return _scale[_qp]*(std::abs(_velocity_x[_qp]) + std::abs(_velocity_y[_qp]) + std::abs(_velocity_z[_qp]))*_feproblem.dt()/_current_elem->hmin();
}
