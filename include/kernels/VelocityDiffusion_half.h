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

#ifndef VelocityDiffusion_half_H
#define VelocityDiffusion_half_H

#include "Diffusion.h"

//Forward Declarations
class VelocityDiffusion_half;

/* This class extends the Diffusion kernel to multiply by a coefficient
 * read from the input file
 */
template<>
InputParameters validParams<VelocityDiffusion_half>();

class VelocityDiffusion_half : public Diffusion
{
public:

  VelocityDiffusion_half(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;
  virtual Real computeQpJacobian() override;
  virtual Real computeQpOffDiagJacobian(unsigned jvar) override;

  const VariableValue & _temp;
  const VariableGradient & _grad_temp;
  //const VariableSecond & _second_temp;
  //const VariableSecond & _second_u;
  //const VariableTestSecond & _second_test;
  //const VariablePhiSecond & _second_phi;
  unsigned _temp_var_num;
  const MaterialProperty<Real> & _Ra;
  //const MaterialProperty<RealGradient> & _grad_Ra;
  unsigned _component_1;
  unsigned _component_2;
  Real _sign;
  Real _scale;
};
#endif //VelocityDiffusion_half_H
