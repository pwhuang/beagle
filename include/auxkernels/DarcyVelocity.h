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

#ifndef DarcyVelocity_H
#define DarcyVelocity_H

#include "AuxKernel.h"


//Forward Declarations
class DarcyVelocity;

template<>
InputParameters validParams<DarcyVelocity>();

/**
 * Coupled auxiliary value
 */
class DarcyVelocity : public AuxKernel
{
public:

  /**
   * Factory constructor, takes parameters so that all derived classes can be built using the same
   * constructor.
   */
  DarcyVelocity(const InputParameters & parameters);

protected:
  virtual Real computeValue() override;

  //const MaterialProperty<Real> & _permeability;
  //const MaterialProperty<Real> & _viscosity;
  //const MaterialProperty<Real> & _density;
  const VariableGradient & _grad_pressure;
  const VariableValue & _temp;
  //RealVectorValue _gravity;
  unsigned _component;
  const MaterialProperty<Real> & _Ra;
  Real _temp_ref;
  //Real _value;
};

#endif //EXAMPLEAUX_H
