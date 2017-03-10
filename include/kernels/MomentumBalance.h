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

#ifndef MOMENTUMBALANCE_H
#define MOMENTUMBALANCE_H

#include "Kernel.h"

//Forward Declarations
class MomentumBalance;

/* This class extends the Diffusion kernel to multiply by a coefficient
 * read from the input file
 */
template<>
InputParameters validParams<MomentumBalance>();

class MomentumBalance : public Kernel
{
public:

  MomentumBalance(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;
  virtual Real computeQpJacobian() override;
  virtual Real computeQpOffDiagJacobian();

  const VariableGradient & _grad_pressure;
  const VariableValue & _pressure;
  const MaterialProperty<Real> & _permeability;
  const MaterialProperty<Real> & _viscosity;
  const MaterialProperty<Real> & _density;
  RealVectorValue _gravity;
  unsigned _component;

};
#endif //EXAMPLEDIFFUSION_H
