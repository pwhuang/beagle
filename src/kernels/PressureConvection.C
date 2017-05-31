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

#include "PressureConvection.h"

template<>
InputParameters validParams<PressureConvection>()
{
  InputParameters params = validParams<Kernel>();
  //params.addParam<Real>("Rayleigh_number", "Rayleigh_number is required for Rayleigh Convection.");
  params.addCoupledVar("pressure", "Pressure is required for PressureConvection.");
  params.addParam<unsigned>("component", "Component to add for Rayleigh effect.");
  return params;
}

PressureConvection::PressureConvection(const InputParameters & parameters) :
    Kernel(parameters),
    //_Ra(getParam<Real>("Rayleigh_number")),
    _grad_p(coupledGradient("pressure")),
    _Ra(getMaterialProperty<Real>("rayleigh_material")),
    _component(getParam<unsigned>("component"))
    //_advection_speed(RealVectorValue(-_grad_p[_qp](0), -_grad_p[_qp](1), -_grad_p[_qp](2)))
{}

Real PressureConvection::computeQpResidual()
{
  RealVectorValue _advection_speed = RealVectorValue(-_grad_p[_qp](0), -_grad_p[_qp](1));//, -_grad_p[_qp](2));
  //return _test[_i][_qp]*(_heat_capacity[_qp]*_porosity[_qp]
  //        *_advection_speed*_grad_u[_qp]);
  //_advection_speed(_component) += _Ra[_qp]*_u[_qp];
  return _test[_i][_qp]*(_advection_speed*_grad_u[_qp]);

}

Real PressureConvection::computeQpJacobian()
{
  RealVectorValue _advection_speed = RealVectorValue(-_grad_p[_qp](0), -_grad_p[_qp](1));//, -_grad_p[_qp](2));
  //return _test[_i][_qp]*(_heat_capacity[_qp]*_porosity[_qp]
  //        *_advection_speed*_grad_phi[_j][_qp]);
  //_advection_speed(_component) += _Ra[_qp]*_u[_qp];
  return _test[_i][_qp]*(_advection_speed*_grad_phi[_j][_qp]);
}
