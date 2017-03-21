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

#ifndef AUXDENSITY_H
#define AUXDENSITY_H

#include "AuxKernel.h"


//Forward Declarations
class AuxDensity;

template<>
InputParameters validParams<AuxDensity>();

/**
 * Coupled auxiliary value
 */
class AuxDensity : public AuxKernel
{
public:

  /**
   * Factory constructor, takes parameters so that all derived classes can be built using the same
   * constructor.
   */
  AuxDensity(const InputParameters & parameters);

protected:
  virtual Real computeValue() override;

  const VariableValue & _nodal_temp;
  Real _ref_temp;
  //Real _value;
};

#endif //AuxDensity_H
