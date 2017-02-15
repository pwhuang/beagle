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

#ifndef MASSBALANCE_H
#define MASSBALANCE_H

#include "Kernel.h"

//Forward Declarations
class MassBalance;

/* This class extends the Diffusion kernel to multiply by a coefficient
 * read from the input file
 */
template<>
InputParameters validParams<MassBalance>();

class MassBalance : public Kernel
{
public:

  MassBalance(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;
  virtual Real computeQpJacobian() override;
  virtual Real computeQpOffDiagJacobian(unsigned jvar);

  const VariableGradient & _grad_velocity_x;
  const VariableGradient & _grad_velocity_y;
  unsigned _u_vel_var_number;
  unsigned _v_vel_var_number;
  const MaterialProperty<Real> & _permeability;
  const MaterialProperty<Real> & _viscosity;
  const MaterialProperty<Real> & _density;
};
#endif //EXAMPLEDIFFUSION_H
