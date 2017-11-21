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

#include "RayleighConvection3d.h"

template<>
InputParameters validParams<RayleighConvection3d>()
{
  InputParameters params = validParams<Kernel>();
  //params.addParam<Real>("Rayleigh_number", "Rayleigh_number is required for Rayleigh Convection.");
  params.addCoupledVar("stream_function1", "stream_function is required for Rayleigh Convection.");
  params.addCoupledVar("stream_function2", "stream_function is required for Rayleigh Convection.");
  return params;
}

RayleighConvection3d::RayleighConvection3d(const InputParameters & parameters) :
    Kernel(parameters),
    //_heat_capacity(getMaterialProperty<Real>("heat_capacity")),
    //_porosity(getMaterialProperty<Real>("porosity")),
    //_Ra(getParam<Real>("Rayleigh_number")),
    _Ra(getMaterialProperty<Real>("rayleigh_material")),
    _grad_stream1(coupledGradient("stream_function1")),
    _grad_stream2(coupledGradient("stream_function2")),
    _grad_stream1_var_num(coupled("stream_function1")),
    _grad_stream2_var_num(coupled("stream_function2"))
{}

Real RayleighConvection3d::computeQpResidual()
{
  RealVectorValue _advection_speed =
                  RealVectorValue(_grad_stream2[_qp](2), _grad_stream1[_qp](2)-_grad_stream2[_qp](0), -_grad_stream1[_qp](1));

  return _test[_i][_qp]*_Ra[_qp]*(_advection_speed*_grad_u[_qp]);

}

Real RayleighConvection3d::computeQpJacobian()
{
  RealVectorValue _advection_speed =
                  RealVectorValue(_grad_stream2[_qp](2), _grad_stream1[_qp](2)-_grad_stream2[_qp](0), -_grad_stream1[_qp](1));

  return _test[_i][_qp]*_Ra[_qp]*(_advection_speed*_grad_phi[_j][_qp]);
}

Real RayleighConvection3d::computeQpOffDiagJacobian(unsigned jvar)
{
  RealVectorValue _advection_speed_1 =
                  RealVectorValue(0, _grad_phi[_j][_qp](2), -_grad_phi[_j][_qp](1));
  RealVectorValue _advection_speed_2 =
                  RealVectorValue(_grad_phi[_j][_qp](2), -_grad_phi[_j][_qp](0), 0);

  if(jvar==_grad_stream1_var_num)
    return _test[_i][_qp]*_Ra[_qp]*(_advection_speed_1*_grad_u[_qp]);
  else if(jvar==_grad_stream2_var_num)
    return _test[_i][_qp]*_Ra[_qp]*(_advection_speed_2*_grad_u[_qp]);
  else
    return 0;
}
