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

  //params.addRequiredParam<Real>("temp", "Temperature variable from input file");
  // Add a "coupling paramater" to get a variable from the input file.
  //params.addRequiredParam<Real>("temp", "Temperature for entropy calculation");
  params.addRequiredCoupledVar("temp", "Temperature for entropy calculation");
  return params;
}

EntropyProduction::EntropyProduction(const InputParameters & parameters) :
    AuxKernel(parameters),


    // Get the gradient of the temperature
    _temperature_gradient(coupledGradient("temp")),

    _temperature(coupledValue("temp")),

    // Snag thermal conductivity from the Material system.
    // Only AuxKernels operating on Elemental Auxiliary Variables can do this
    _thermal_conductivity(getMaterialProperty<Real>("thermal_conductivity"))

{}

Real
EntropyProduction::computeValue()
{
  // Access the gradient of the pressure at this quadrature point
  // Then pull out the "component" of it we are looking for (x, y or z)
  // Note that getting a particular component of a gradient is done using the
  // parenthesis operator

  //RealVectorValue entropy_production= (_thermal_conductivity[_qp] )
  return (_thermal_conductivity[_qp] /(_temperature[_qp] * _temperature[_qp])) * _temperature_gradient[_qp] * _temperature_gradient[_qp];

}
