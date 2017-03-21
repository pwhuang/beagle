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

#include "AuxDensity.h"
#include <math.h>

template<>
InputParameters validParams<AuxDensity>()
{
  InputParameters params = validParams<AuxKernel>();
  //params.addParam<Real>("value", 0.0, "Scalar value used for our auxiliary calculation");
  params.addRequiredCoupledVar("nodal_temperature", "temperature on nodes");
  params.addParam<Real>("reference_temperature", 0, "reference temperature");
  return params;
}

AuxDensity::AuxDensity(const InputParameters & parameters) :
    AuxKernel(parameters),

    // We can couple in a value from one of our kernels with a call to coupledValueAux
    _nodal_temp(coupledValue("nodal_temperature")),
    _ref_temp(getParam<Real>("reference_temperature"))


    // Set our member scalar value from InputParameters (read from the input file)
    //_value(getParam<Real>("value"))
{}

/**
 * Auxiliary Kernels override computeValue() instead of computeQpResidual().  Aux Variables
 * are calculated either one per elemenet or one per node depending on whether we declare
 * them as "Elemental (Constant Monomial)" or "Nodal (First Lagrange)".  No changes to the
 * source are necessary to switch from one type or the other.
 */
Real
AuxDensity::computeValue()
{
  //DIPPR105 Equation
  //input temperature degC, valid from 0 to 375 degC
  //output density kg/m^3
  return 0.14395/pow(0.0112, 1+pow(1.0-(_nodal_temp[_qp]+273.0)/649.727, 0.05107))
        -0.14395/pow(0.0112, 1+pow(1.0-(_ref_temp+273.0)/649.727, 0.05107));
  //Real rho0 = 0.14395/pow(0.0112, 1+pow(1.0-(_ref_temp+273.0)/649.727, 0.05107));
  //return rho0*(1.0 - 6.9e-5*(_nodal_temp[_qp]-_ref_temp));
}
