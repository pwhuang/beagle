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

#ifndef PecletIndicator_H
#define PecletIndicator_H

#include "ElementIntegralIndicator.h"

class PecletIndicator;

template <>
InputParameters validParams<PecletIndicator>();

class PecletIndicator : public ElementIntegralIndicator
{
public:
  PecletIndicator(const InputParameters & parameters);

protected:
  virtual void computeIndicator() override;
  virtual Real computeQpIntegral() override;
private:

  const MaterialProperty<Real> & _scale;
  Real _Ra;
};

#endif /* PecletIndicator_H */
