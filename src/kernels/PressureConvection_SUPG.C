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

#include "PressureConvection_SUPG.h"
#include "PressureDiffusion_test.h"
#include "PressureConvection.h"
#include "math.h"

template<>
InputParameters validParams<PressureConvection_SUPG>()
{
  InputParameters params = validParams<Kernel>();
  params.addCoupledVar("pressure", "Pressure is required for PressureConvection_SUPG.");
  params.addCoupledVar("velocity_x", "velocity_x is required for PressureConvection_SUPG.");
  params.addCoupledVar("velocity_y", "velocity_y is required for PressureConvection_SUPG.");
  params.addCoupledVar("Peclet", "Peclet is required for PressureConvection_SUPG.");
  params.addParam<unsigned>("component", "Component to add for Rayleigh effect.");
  return params;
}

PressureConvection_SUPG::PressureConvection_SUPG(const InputParameters & parameters) :
    Kernel(parameters),
    //_Ra(getParam<Real>("Rayleigh_number")),
    _grad_p(coupledGradient("pressure")),
    _p(coupledValue("pressure")),
    _second_temp(coupledSecond("pressure")),
    _second_u(second()),
    _second_test(secondTest()),
    _second_phi(secondPhi()),
    _grad_p_var_num(coupled("pressure")),
    _vel_x(coupledValue("velocity_x")),
    _vel_y(coupledValue("velocity_y")),
    _Ra(getMaterialProperty<Real>("rayleigh_material")),
    _component(getParam<unsigned>("component")),
    _Pe(coupledValue("Peclet"))
    //_advection_speed(RealVectorValue(-_grad_p[_qp](0), -_grad_p[_qp](1), -_grad_p[_qp](2)))
{}

Real PressureConvection_SUPG::computeQpResidual()
{
  //Use the velocity of previous time step to balance the advection. Can this work???
  RealVectorValue _advection_speed = RealVectorValue(_vel_x[_qp], _vel_y[_qp]);
  Real _tao = (cosh(_Pe[_qp])/sinh(_Pe[_qp]) - 1/_Pe[_qp]) * _current_elem->hmax() *(_vel_x[_qp]+_vel_y[_qp])*0.5
              /sqrt(_vel_x[_qp]*_vel_x[_qp]+_vel_y[_qp]*_vel_y[_qp]);

  return _advection_speed*_grad_test[_i][_qp]*_tao*(PressureDiffusion_test::computeQpResidual() + PressureConvection::computeQpResidual());
}

Real PressureConvection_SUPG::computeQpJacobian()
{
  return _advection_speed*_grad_test[_i][_qp]*_tao*(PressureDiffusion_test::computeQpJacobian() + PressureConvection::computeQpJacobian());
}

Real PressureConvection_SUPG::computeQpOffDiagJacobian(unsigned jvar)
{
  return PressureConvection::computeQpOffDiagJacobian(unsigned jvar);
  /*
  if (jvar == _grad_p_var_num)
    return -_test[_i][_qp]*_Ra[_qp]*(_grad_phi[_j][_qp]*_grad_u[_qp]);
  else
    return 0;
  */
}
