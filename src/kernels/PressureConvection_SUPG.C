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
#include "math.h"

template<>
InputParameters validParams<PressureConvection_SUPG>()
{
  InputParameters params = validParams<PressureConvection>();
  params.addCoupledVar("pressure", "Pressure is required for PressureConvection.");
  params.addParam<unsigned>("component", "Component to add for Rayleigh effect.");
  params.addCoupledVar("velocity_x", "velocity_x is required for PressureConvection_SUPG.");
  params.addCoupledVar("velocity_y", "velocity_y is required for PressureConvection_SUPG.");
  params.addCoupledVar("Peclet", "Peclet is required for PressureConvection_SUPG.");
  return params;
}

PressureConvection_SUPG::PressureConvection_SUPG(const InputParameters & parameters) :
    PressureConvection(parameters),
    _vel_x(coupledValue("velocity_x")),
    _vel_y(coupledValue("velocity_y")),
    _Pe(coupledValue("Peclet"))
{}

Real PressureConvection_SUPG::computeQpResidual()
{
  //Use the velocity of previous time step to balance the advection. Can this work???
  RealVectorValue _advection_speed = RealVectorValue(_vel_x[_qp], _vel_y[_qp]);
  //RealVectorValue _advection_speed = RealVectorValue(_vel_x[_qp], _vel_y[_qp]);

  return _advection_speed*_grad_test[_i][_qp]*tao()
         *_Ra[_qp]*(-_grad_p[_qp]*_grad_u[_qp]+_Ra[_qp]*_u[_qp]*_grad_u[_qp](_component));
}

Real PressureConvection_SUPG::computeQpJacobian()
{
  RealVectorValue _advection_speed = RealVectorValue(_vel_x[_qp], _vel_y[_qp]);
  return _advection_speed*_grad_test[_i][_qp]*tao()
         *_Ra[_qp]*(-_grad_p[_qp]*_grad_phi[_j][_qp]
         +_Ra[_qp]*_phi[_j][_qp]*_grad_u[_qp](_component)
         +_Ra[_qp]*_u[_qp]*_grad_phi[_j][_qp](_component));
}

Real PressureConvection_SUPG::computeQpOffDiagJacobian(unsigned jvar)
{
  RealVectorValue _advection_speed = RealVectorValue(_vel_x[_qp], _vel_y[_qp]);
  if (jvar == _grad_p_var_num)
    return -_advection_speed*_grad_test[_i][_qp]*tao()*_Ra[_qp]*_grad_phi[_j][_qp]*_grad_u[_qp];
  else
    return 0;
}

Real PressureConvection_SUPG::tao()
{
  if(_Pe[_qp]>1e-2)
    return (std::cosh(_Pe[_qp])/std::sinh(_Pe[_qp]) - 1.0/_Pe[_qp]) * _current_elem->hmax()
    *(_vel_x[_qp]+_vel_y[_qp])*0.5 /(_vel_x[_qp]*_vel_x[_qp]+_vel_y[_qp]*_vel_y[_qp]);
  else
    return 0;
}
