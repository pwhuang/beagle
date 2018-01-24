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

#ifndef AuxPerturb_H
#define AuxPerturb_H

#include "AuxKernel.h"

// Forward Declarations
class AuxPerturb;

template<>
InputParameters validParams<AuxPerturb>();

/**
 * Auxiliary kernel responsible for computing the Darcy velocity given
 * several fluid properties and the pressure gradient.
 */
class AuxPerturb : public AuxKernel
{
public:
  AuxPerturb(const InputParameters & parameters);

  virtual ~AuxPerturb() {}

protected:
  /**
   * AuxKernels MUST override computeValue.  computeValue() is called on
   * every quadrature point.  For Nodal Auxiliary variables those quadrature
   * points coincide with the nodes.
   */
  virtual Real computeValue() override;

  const VariableValue & _temp;
  Real _min;
  Real _max;
  Real _range;

};

#endif // AuxPerturb_H
