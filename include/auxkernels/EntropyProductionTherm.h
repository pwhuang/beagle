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

#ifndef EntropyProductionTherm_H
#define EntropyProductionTherm_H

#include "AuxKernel.h"

// Forward Declarations
class EntropyProductionTherm;

template<>
InputParameters validParams<EntropyProductionTherm>();

/**
 * Auxiliary kernel responsible for computing the Darcy velocity given
 * several fluid properties and the pressure gradient.
 */
class EntropyProductionTherm : public AuxKernel
{
public:
  EntropyProductionTherm(const InputParameters & parameters);

  virtual ~EntropyProductionTherm() {}

protected:
  /**
   * AuxKernels MUST override computeValue.  computeValue() is called on
   * every quadrature point.  For Nodal Auxiliary variables those quadrature
   * points coincide with the nodes.
   */
  virtual Real computeValue() override;

  /// The gradient of a coupled variable
  const VariableGradient & _grad_temp;

};

#endif // EntropyProductionTherm_H
