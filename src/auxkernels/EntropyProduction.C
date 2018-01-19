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

#include "EntropyProduction.h"

template<>
InputParameters validParams<EntropyProduction>()
{
  InputParameters params = validParams<AuxKernel>();

  params.addParam<Real>("T_bar", "Average temperature between top and bottom (K)");
  params.addParam<Real>("deltaT", "Temperature difference between top and bottom (K)");
  params.addParam<Real>("alpha", "Thermal expansion coefficient (T^-1)");
  params.addParam<Real>("d", "Length between top and bottom boundaries (m)");
  params.addParam<Real>("cf", "Heat capacity of the fluid");
  params.addRequiredCoupledVar("temp", "Entropy Production AuxKernel requires temperature");
  params.addRequiredCoupledVar("velocity_x", "Entropy Production AuxKernel requires velocity_x");
  params.addCoupledVar("velocity_y", "Entropy Production AuxKernel: velocity_y");
  params.addCoupledVar("velocity_z", "Entropy Production AuxKernel: velocity_z");
  return params;
}

EntropyProduction::EntropyProduction(const InputParameters & parameters) :
    AuxKernel(parameters),
    // Get the gradient of the temperature
    _T_bar(getParam<Real>("T_bar")),
    _delta_T(getParam<Real>("deltaT")),
    _alpha(getParam<Real>("alpha")),
    _d(getParam<Real>("d")),
    _cf(getParam<Real>("cf")),
    _grad_temp(coupledGradient("temp")),
    _temp(coupledValue("temp")),
    _vel_x(coupledValue("velocity_x")),
    _vel_y(coupledValue("velocity_y")),
    _vel_z(coupledValue("velocity_z"))

    // Snag thermal conductivity from the Material system.
    // Only AuxKernels operating on Elemental Auxiliary Variables can do this
    //_thermal_conductivity(getMaterialProperty<Real>("thermal_conductivity"))

{}

Real
EntropyProduction::computeValue()
{
  return _grad_temp[_qp]*_grad_temp[_qp]
         + _alpha*_d*_T_bar*9.81/(_delta_T*_cf)*(_vel_x[_qp]*_vel_x[_qp] + _vel_y[_qp]*_vel_y[_qp] + _vel_z[_qp]*_vel_z[_qp]);
}
