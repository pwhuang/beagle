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

#ifndef PressureDiffusion_H
#define PressureDiffusion_H

#include "Diffusion.h"

//Forward Declarations
class PressureDiffusion;

/* This class extends the Diffusion kernel to multiply by a coefficient
 * read from the input file
 */
template<>
InputParameters validParams<PressureDiffusion>();

class PressureDiffusion : public Diffusion
{
public:

  PressureDiffusion(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;

  virtual Real computeQpJacobian() override;

  const VariableValue & _temp;
  const VariableGradient & _grad_temp;
  const MaterialProperty<Real> & _Ra;
  //const MaterialProperty<RealGradient> & _grad_Ra;
  unsigned _component;
  Real _sign;
};
#endif //PressureDiffusion_H
