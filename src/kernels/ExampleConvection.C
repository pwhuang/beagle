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

#include "ExampleConvection.h"

template<>
InputParameters validParams<ExampleConvection>()
{
  InputParameters params = validParams<Kernel>();
  params.addCoupledVar("advection_speed_x", "advection_speed_x");
  params.addCoupledVar("advection_speed_y", "advection_speed_y");
  params.addCoupledVar("advection_speed_z", "advection_speed_z");
  return params;
}

ExampleConvection::ExampleConvection(const InputParameters & parameters) :
    Kernel(parameters),
    //_heat_capacity(getMaterialProperty<Real>("heat_capacity")),
    //_porosity(getMaterialProperty<Real>("porosity")),
    _advection_speed_x(coupledValue("advection_speed_x")),
    _advection_speed_y(coupledValue("advection_speed_y")),
    _advection_speed_z(coupledValue("advection_speed_z"))
{}

Real ExampleConvection::computeQpResidual()
{
  RealVectorValue _advection_speed = RealVectorValue(_advection_speed_x[ _qp ], _advection_speed_y[ _qp ], _advection_speed_z[ _qp ]);
  //return _test[_i][_qp]*(_heat_capacity[_qp]*_porosity[_qp]
  //        *_advection_speed*_grad_u[_qp]);
  return _test[_i][_qp]*(_advection_speed*_grad_u[_qp]);

}

Real ExampleConvection::computeQpJacobian()
{
  RealVectorValue _advection_speed = RealVectorValue(_advection_speed_x[ _qp ], _advection_speed_y[ _qp ], _advection_speed_z[ _qp ]);
  //return _test[_i][_qp]*(_heat_capacity[_qp]*_porosity[_qp]
  //        *_advection_speed*_grad_phi[_j][_qp]);
  return _test[_i][_qp]*(_advection_speed*_grad_phi[_j][_qp]);
}
