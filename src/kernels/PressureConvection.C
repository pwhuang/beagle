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
  params.addCoupledVar("pressure", "Pressure is required for PressureConvection.");
  //params.addCoupledVar("velocity_x", "velocity_x is required for PressureConvection.");
  //params.addCoupledVar("velocity_y", "velocity_y is required for PressureConvection.");
  params.addParam<unsigned>("component", "Component to add for Rayleigh effect.");
  return params;
}

PressureConvection::PressureConvection(const InputParameters & parameters) :
    Kernel(parameters),
    //_Ra(getParam<Real>("Rayleigh_number")),
    _grad_p(coupledGradient("pressure")),
    _p(coupledValue("pressure")),
    _second_temp(coupledSecond("pressure")),
    _second_u(second()),
    _second_test(secondTest()),
    _second_phi(secondPhi()),
    _grad_p_var_num(coupled("pressure")),
    //_vel_x(coupledValue("velocity_x")),
    //_vel_y(coupledValue("velocity_y")),
    _Ra(getMaterialProperty<Real>("rayleigh_material")),
    _component(getParam<unsigned>("component"))
    //_advection_speed(RealVectorValue(-_grad_p[_qp](0), -_grad_p[_qp](1), -_grad_p[_qp](2)))
{}

Real PressureConvection::computeQpResidual()
{
  //RealVectorValue _advection_speed = RealVectorValue(_vel_x[_qp], _vel_y[_qp]);

  return //_grad_test[_i][_qp]*_Ra[_qp]*(_p[_qp]*_grad_u[_qp])
          - _Ra[_qp]*(_second_test[_i][_qp](0,0)+_second_test[_i][_qp](1,1)+_second_test[_i][_qp](2,2))*_p[_qp]*_u[_qp]
          + _Ra[_qp]*_grad_test[_i][_qp]*_grad_u[_qp]*_p[_qp]
          + _Ra[_qp]*0.5*(_second_u[_qp](0,0)+_second_u[_qp](1,1)+_second_u[_qp](2,2))*_test[_i][_qp]*_p[_qp]
          //+ _test[_i][_qp]*_Ra[_qp]*_u[_qp]*_grad_u[_qp](_component);
          - _grad_test[_i][_qp](_component)*_Ra[_qp]*_u[_qp]*_u[_qp];

  //return _grad_test[_i][_qp]*_grad_p[_qp]*_u[_qp] - _grad_test[_i][_qp](_component)*_Ra[_qp]*_u[_qp]*_u[_qp];

}

Real PressureConvection::computeQpJacobian()
{
  //RealVectorValue _advection_speed = RealVectorValue(_vel_x[_qp], _vel_y[_qp]);

  return //_grad_test[_i][_qp]*_Ra[_qp]*(_p[_qp]*_grad_phi[_j][_qp])
        - _Ra[_qp]*(_second_test[_i][_qp](0,0)+_second_test[_i][_qp](1,1)+_second_test[_i][_qp](2,2))*_p[_qp]*_phi[_j][_qp]
        + _Ra[_qp]*_grad_test[_i][_qp]*_grad_phi[_j][_qp]*_p[_qp]
        + _Ra[_qp]*0.5*(_second_phi[_j][_qp](0,0)+_second_phi[_j][_qp](1,1)+_second_phi[_j][_qp](2,2))*_test[_i][_qp]*_p[_qp]
          //+ _test[_i][_qp]*_Ra[_qp]*_phi[_j][_qp]*_grad_u[_qp](_component)
          //+ _test[_i][_qp]*_Ra[_qp]*_u[_qp]*_grad_phi[_j][_qp](_component);
          - 2*_grad_test[_i][_qp](_component)*_Ra[_qp]*_phi[_j][_qp]*_u[_qp];


  //return _grad_test[_i][_qp]*_grad_p[_qp]*_phi[_j][_qp] - 2*_grad_test[_i][_qp](_component)*_Ra[_qp]*_u[_qp]*_phi[_j][_qp];

}

Real PressureConvection::computeQpOffDiagJacobian(unsigned jvar)
{
  if (jvar == _grad_p_var_num)
    return - _Ra[_qp]*(_second_test[_i][_qp](0,0)+_second_test[_i][_qp](1,1)+_second_test[_i][_qp](2,2))*_phi[_j][_qp]*_u[_qp]
    + _Ra[_qp]*_grad_test[_i][_qp]*_grad_u[_qp]*_phi[_j][_qp]
    + _Ra[_qp]*0.5*(_second_u[_qp](0,0)+_second_u[_qp](1,1)+_second_u[_qp](2,2))*_test[_i][_qp]*_phi[_j][_qp];
    //_grad_test[_i][_qp]*_Ra[_qp]*(_phi[_j][_qp]*_grad_u[_qp]);

    //return _grad_test[_i][_qp]*_grad_phi[_j][_qp]*_u[_qp];
  else
    return 0;
}
