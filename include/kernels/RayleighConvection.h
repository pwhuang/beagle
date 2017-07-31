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

#ifndef RAYLEIGHCONVECTION_H
#define RAYLEIGHCONVECTION_H

#include "Kernel.h"

class RayleighConvection;

template<>
InputParameters validParams<RayleighConvection>();

class RayleighConvection : public Kernel
{
public:

  RayleighConvection(const InputParameters & parameters);

protected:

  virtual Real computeQpResidual() override;

  virtual Real computeQpJacobian() override;
  virtual Real computeQpOffDiagJacobian(unsigned jvar) override;

private:

  //const MaterialProperty<Real> & _heat_capacity;
  const MaterialProperty<Real> & _Ra;
  //Real _Ra;
  const VariableGradient & _grad_stream;
  unsigned _grad_stream_var_num;
};

#endif //RAYLEIGHCONVECTION_H
