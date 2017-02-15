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

#include "PorousConvection.h"

template<>
InputParameters validParams<PorousConvection>()
{
  InputParameters params = validParams<Kernel>();
  params.addCoupledVar("advection_speed_x", "advection_speed_x");
  params.addCoupledVar("advection_speed_y", "advection_speed_y");
  return params;
}

PorousConvection::PorousConvection(const InputParameters & parameters) :
    Kernel(parameters),
    _heat_capacity(getMaterialProperty<Real>("heat_capacity")),
    _porosity(getMaterialProperty<Real>("porosity")),
    _advection_speed_x(coupledValue("advection_speed_x")),
    _advection_speed_y(coupledValue("advection_speed_y"))
{}

Real PorousConvection::computeQpResidual()
{
  RealVectorValue _advection_speed = RealVectorValue(_advection_speed_x[ _qp ], _advection_speed_y[ _qp ]);
  return _test[_i][_qp]*(_heat_capacity[_qp]*_porosity[_qp]
          *_advection_speed*_grad_u[_qp]);

}

Real PorousConvection::computeQpJacobian()
{
  RealVectorValue _advection_speed = RealVectorValue(_advection_speed_x[ _qp ], _advection_speed_y[ _qp ]);
  return _test[_i][_qp]*(_heat_capacity[_qp]*_porosity[_qp]
          *_advection_speed*_grad_phi[_j][_qp]);

}
