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

#ifndef Vorticity_H
#define Vorticity_H

#include "Kernel.h"

//Forward Declarations
class Vorticity;

/* This class extends the Diffusion kernel to multiply by a coefficient
 * read from the input file
 */
template<>
InputParameters validParams<Vorticity>();

class Vorticity : public Kernel
{
public:

  Vorticity(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;
  virtual Real computeQpJacobian() override;
  virtual Real computeQpOffDiagJacobian(unsigned jvar) override;

  const VariableGradient & _grad_temp;
  const VariableGradient & _grad_vel_1;
  const VariableGradient & _grad_vel_2;
  const MaterialProperty<Real> & _Ra;
  unsigned _temp_var_num;
  unsigned _vel_1_var_num;
  unsigned _vel_2_var_num;
  unsigned _component_1;
  unsigned _component_2;
  unsigned _component_3;
  Real _sign;
};
#endif //Vorticity_H
