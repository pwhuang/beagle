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

#include "RayleighConvection.h"

template<>
InputParameters validParams<RayleighConvection>()
{
  InputParameters params = validParams<Kernel>();
  //params.addParam<Real>("Rayleigh_number", "Rayleigh_number is required for Rayleigh Convection.");
  params.addCoupledVar("stream_function", "stream_function is required for Rayleigh Convection.");
  return params;
}

RayleighConvection::RayleighConvection(const InputParameters & parameters) :
    Kernel(parameters),
    _Ra(getMaterialProperty<Real>("rayleigh_material")),
    //_Ra(getParam<Real>("Rayleigh_number")),
    _grad_stream(coupledGradient("stream_function")),
    _grad_stream_var_num(coupled("stream_function"))
{}

Real RayleighConvection::computeQpResidual()
{
  RealVectorValue _advection_speed = RealVectorValue(_grad_stream[_qp](1), -1.0*_grad_stream[_qp](0));
  //return _test[_i][_qp]*(_heat_capacity[_qp]*_porosity[_qp]
  //        *_advection_speed*_grad_u[_qp]);
  return _test[_i][_qp]*_Ra[_qp]*(_advection_speed*_grad_u[_qp]);

}

Real RayleighConvection::computeQpJacobian()
{
  RealVectorValue _advection_speed = RealVectorValue(_grad_stream[_qp](1), -1.0*_grad_stream[_qp](0));
  //return _test[_i][_qp]*(_heat_capacity[_qp]*_porosity[_qp]
  //        *_advection_speed*_grad_phi[_j][_qp]);
  return _test[_i][_qp]*_Ra[_qp]*(_advection_speed*_grad_phi[_j][_qp]);
}


Real RayleighConvection::computeQpOffDiagJacobian(unsigned jvar)
{
  RealVectorValue _advection_speed = RealVectorValue(_grad_phi[_j][_qp](1), -1.0*_grad_phi[_j][_qp](0));
  if(jvar==_grad_stream_var_num)
    return _test[_i][_qp]*_Ra[_qp]*(_advection_speed*_grad_u[_qp]);
  else
    return 0;

}
