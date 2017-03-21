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

#ifndef AUXVELOCITY_H
#define AUXVELOCITY_H

#include "AuxKernel.h"


//Forward Declarations
class AuxVelocity;

template<>
InputParameters validParams<AuxVelocity>();

/**
 * Coupled auxiliary value
 */
class AuxVelocity : public AuxKernel
{
public:

  /**
   * Factory constructor, takes parameters so that all derived classes can be built using the same
   * constructor.
   */
  AuxVelocity(const InputParameters & parameters);

protected:
  virtual Real computeValue() override;

  const MaterialProperty<Real> & _permeability;
  const MaterialProperty<Real> & _viscosity;
  const VariableValue & _density;
  const VariableValue & _temperature;
  const VariableGradient & _grad_pressure;
  RealVectorValue _gravity;
  unsigned _component;
  //Real _value;
};

#endif //EXAMPLEAUX_H
