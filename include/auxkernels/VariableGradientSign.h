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

#ifndef VariableGradientSign_H
#define VariableGradientSign_H

// MOOSE includes
#include "AuxKernel.h"

// Forward declarations
class VariableGradientSign;

template <>
InputParameters validParams<VariableGradientSign>();

/**
 * Extract a component from the gradient of a variable
 */
class VariableGradientSign : public AuxKernel
{
public:
  /**
   * Class constructor
   * @param parameters Input parameters for the object
   */
  VariableGradientSign(const InputParameters & parameters);

protected:
  virtual Real computeValue() override;

private:
  /// Reference to the gradient of the coupled variable
  const VariableGradient & _gradient;

  /// Desired component
  int _component;
  Real _sign;
};

#endif // VariableGradientSign_H
