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

#ifndef StreamVelocityZ_H
#define StreamVelocityZ_H

// MOOSE includes
#include "AuxKernel.h"

// Forward declarations
class StreamVelocityZ;

template <>
InputParameters validParams<StreamVelocityZ>();

/**
 * Extract a component from the gradient of a variable
 */
class StreamVelocityZ : public AuxKernel
{
public:
  /**
   * Class constructor
   * @param parameters Input parameters for the object
   */
  StreamVelocityZ(const InputParameters & parameters);

protected:
  virtual Real computeValue() override;

private:
  /// Reference to the gradient of the coupled variable
  const VariableGradient & _str1;
  const VariableGradient & _str2;

  // Scaling Material Property
  const MaterialProperty<Real> & _scale;

  /// Desired component
  //int _component;
  //Real _sign;
};

#endif // StreamVelocityZ_H
