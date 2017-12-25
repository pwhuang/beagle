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

#include "PecletIndicator.h"

#include "MooseVariable.h"
#include "libmesh/quadrature.h"

template <>
InputParameters
validParams<PecletIndicator>()
{
  InputParameters params = validParams<ElementIntegralIndicator>();
  params.addParam<Real>("Ra", 1, "The Ra.");
  return params;
}

PecletIndicator::PecletIndicator(const InputParameters & parameters)
  : ElementIntegralIndicator(parameters),
  _scale(getMaterialProperty<Real>("rayleigh_material")),
  _Ra(getParam<Real>("Ra"))
{
}


void
PecletIndicator::computeIndicator()
{
  Real sum = 0;
  for (_qp = 0; _qp < _qrule->n_points(); _qp++)
    sum += computeQpIntegral();//_JxW[_qp] * _coord[_qp] * computeQpIntegral();

  //  sum = std::sqrt(sum);

  _field_var.setNodalValue(sum);
}


Real
PecletIndicator::computeQpIntegral()
{
  //Real jump = (_grad_u[_qp] - _grad_u_neighbor[_qp]) * _normals[_qp];

  return _u[_qp]/_qrule->n_points();
}
