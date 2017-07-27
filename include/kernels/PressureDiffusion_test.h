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

#ifndef PressureDiffusion_test_H
#define PressureDiffusion_test_H

#include "Diffusion.h"

//Forward Declarations
class PressureDiffusion_test;

/* This class extends the Diffusion kernel to multiply by a coefficient
 * read from the input file
 */
template<>
InputParameters validParams<PressureDiffusion_test>();

class PressureDiffusion_test : public Diffusion
{
public:

  PressureDiffusion_test(const InputParameters & parameters);
  //virtual ~PressureDiffusion_test() {}

protected:
  virtual Real computeQpResidual() override;
  virtual Real computeQpJacobian() override;
  virtual Real computeQpOffDiagJacobian(unsigned jvar) override;

  const VariableValue & _temp;
  unsigned _temp_var_num;
  //const VariableGradient & _grad_temp;
  const MaterialProperty<Real> & _Ra;
  //const MaterialProperty<RealGradient> & _grad_Ra;
  unsigned _component;
  Real _sign;
};
#endif //PressureDiffusion_test_H
