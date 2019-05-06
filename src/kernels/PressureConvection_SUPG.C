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
#include "Assembly.h"

template<>
InputParameters validParams<PressureConvection_SUPG>()
{
  InputParameters params = validParams<PressureConvection>();
  params.addCoupledVar("velocity_x", "velocity_x is required for PressureConvection_SUPG.");
  params.addCoupledVar("velocity_y", "velocity_y is required for PressureConvection_SUPG.");
  params.addCoupledVar("Peclet", "Peclet is required for PressureConvection_SUPG.");
  params.addParam<bool>("body_force", "Does the artificial direction contain body_force term?");
  return params;
}

PressureConvection_SUPG::PressureConvection_SUPG(const InputParameters & parameters) :
    PressureConvection(parameters),
    _vel_x(coupledValue("velocity_x")),
    _vel_y(coupledValue("velocity_y")),
    _Pe(coupledValue("Peclet")),
    _body_force(getParam<bool>("body_force"))
{}

Real PressureConvection_SUPG::computeQpResidual()
{
  //RealVectorValue _advection_speed = RealVectorValue(_vel_x[_qp], _vel_y[_qp]);
  //RealVectorValue _advection_speed = RealVectorValue(-_grad_p[_qp](0), -_grad_p[_qp](1)+_Ra[_qp]*_u[_qp]);

  //This is not a general form of SUPG stabilization. I only add T_t term when body_force==1.
  if (_body_force == 1)
    return -0.5*_grad_p[_qp](_component)*_grad_test[_i][_qp](_component)*tao()
              *(_dt + _Ra[_qp]*(-_grad_p[_qp](_component)*_grad_u[_qp](_component)
                +_Ra[_qp]*_u[_qp]*_grad_u[_qp](_component))
                -_second_u[_qp](_component,_component));
  else
    return -0.5*_grad_p[_qp](_component)*_grad_test[_i][_qp](_component)*tao()
              *(_Ra[_qp]*(-_grad_p[_qp](_component)*_grad_u[_qp](_component))
                -_second_u[_qp](_component,_component));

  /*
  return _advection_speed*_grad_test[_i][_qp]*tao()
         *(_Ra[_qp]*(-_grad_p[_qp]*_grad_u[_qp]+_Ra[_qp]*_u[_qp]*_grad_u[_qp](_component))
          -_second_u[_qp](0,0)-_second_u[_qp](1,1));
  */
}

Real PressureConvection_SUPG::computeQpJacobian()
{
  //RealVectorValue _advection_speed = RealVectorValue(_vel_x[_qp], _vel_y[_qp]);
  //RealVectorValue _advection_speed = RealVectorValue(-_grad_p[_qp](0), -_grad_p[_qp](1)+_Ra[_qp]*_u[_qp]);
  if (_body_force == 1)
    return -0.5*_grad_p[_qp](_component)*_grad_test[_i][_qp](_component)*tao()
              *(_phi[_j][_qp] * _dt_old + _Ra[_qp]*(-_grad_p[_qp](_component)*_grad_phi[_j][_qp](_component)
              +_Ra[_qp]*_phi[_j][_qp]*_grad_u[_qp](_component)
              +_Ra[_qp]*_u[_qp]*_grad_phi[_j][_qp](_component))
              -_second_phi[_j][_qp](_component,_component));
  else
    return -0.5*_grad_p[_qp](_component)*_grad_test[_i][_qp](_component)*tao()
              *(_Ra[_qp]*(-_grad_p[_qp](_component)*_grad_phi[_j][_qp](_component))
              -_second_phi[_j][_qp](_component,_component));
  /*
  return _advection_speed*_grad_test[_i][_qp]*tao()
         *(_Ra[_qp]*(-_grad_p[_qp]*_grad_phi[_j][_qp]
         +_Ra[_qp]*_phi[_j][_qp]*_grad_u[_qp](_component)
         +_Ra[_qp]*_u[_qp]*_grad_phi[_j][_qp](_component))
          -_second_phi[_j][_qp](0,0)-_second_phi[_j][_qp](1,1));
  */
}

Real PressureConvection_SUPG::computeQpOffDiagJacobian(unsigned jvar)
{
  //RealVectorValue _advection_speed = RealVectorValue(_vel_x[_qp], _vel_y[_qp]);
  //RealVectorValue _advection_speed = RealVectorValue(-_grad_p[_qp](0), -_grad_p[_qp](1)+_Ra[_qp]*_u[_qp]);
  if (jvar == _grad_p_var_num)
    //return -2.0*_grad_p[_qp](_component)*_grad_test[_i][_qp](_component)*tao()
    //          *(_Ra[_qp]*(-_grad_phi[_j][_qp](_component)*_grad_u[_qp](_component)));
    return 0;/*-0.5*_grad_phi[_j][_qp](_component)*_grad_test[_i][_qp](_component)*tao()
              *(_u_dot[_qp] + _Ra[_qp]*(-_grad_p[_qp](_component)*_grad_u[_qp](_component)
                +_Ra[_qp]*_u[_qp]*_grad_u[_qp](_component))
                -_second_u[_qp](_component,_component))

              -0.5*_grad_p[_qp](_component)*_grad_test[_i][_qp](_component)*tao()
              *( _Ra[_qp]*(-_grad_phi[_j][_qp](_component)*_grad_u[_qp](_component)))

              -0.5*_grad_p[_qp](_component)*_grad_test[_i][_qp](_component)*tao_jacobian()
              *(_u_dot[_qp] + _Ra[_qp]*(-_grad_p[_qp](_component)*_grad_u[_qp](_component)
              +_Ra[_qp]*_u[_qp]*_grad_u[_qp](_component))
              -_second_u[_qp](_component,_component));*/
  else
    return 0;

  /*
  if (jvar == _grad_p_var_num)
    return -_advection_speed*_grad_test[_i][_qp]*tao()*_Ra[_qp]*_grad_phi[_j][_qp]*_grad_u[_qp];
  else
    return 0;
  */
}

Real PressureConvection_SUPG::tao()
{
  /*
  if(_Pe[_qp]>1e-2)
    return (std::cosh(_Pe[_qp])/std::sinh(_Pe[_qp]) - 1.0/_Pe[_qp]) * _current_elem->hmax()
    *(_vel_x[_qp]+_vel_y[_qp])*0.5 /(_vel_x[_qp]*_vel_x[_qp]+_vel_y[_qp]*_vel_y[_qp]);
  else
    return 0;
  */
  /*
  return 1/(2/_dt + 2*std::sqrt(_vel_x[_qp]*_vel_x[_qp]+_vel_y[_qp]*_vel_y[_qp])/_current_elem->hmax()
            + 4/_current_elem->hmax()/_current_elem->hmax());
  */
  Real _advection;
  if (_body_force==1)
    _advection = -_Ra[_qp]*_grad_p[_qp](_component) + _Ra[_qp]*_Ra[_qp]*_u[_qp];
  else
    _advection = -_Ra[_qp]*_grad_p[_qp](_component);

  return 1.0/(2.0/_dt + 2.0*_advection/_current_elem->hmax()
            + 4.0/_current_elem->hmax()/_current_elem->hmax());

}

Real PressureConvection_SUPG::tao_jacobian()
{
  Real _advection;
  if (_body_force==1)
    _advection = -_Ra[_qp]*_grad_phi[_j][_qp](_component) + _Ra[_qp]*_Ra[_qp]*_u[_qp];
  else
    _advection = -_Ra[_qp]*_grad_phi[_j][_qp](_component);

  return 1.0/(2.0/_dt + 2.0*_advection/_current_elem->hmax()
            + 4.0/_current_elem->hmax()/_current_elem->hmax());

}
