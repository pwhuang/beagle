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

#ifndef PressureConvection_H
#define PressureConvection_H

#include "Kernel.h"

class PressureConvection;

template<>
InputParameters validParams<PressureConvection>();

class PressureConvection : public Kernel
{
public:

  PressureConvection(const InputParameters & parameters);

protected:

  virtual Real computeQpResidual() override;

  virtual Real computeQpJacobian() override;

private:

  //const MaterialProperty<Real> & _heat_capacity;
  //Real _Ra;
  const VariableGradient & _grad_p;
  const MaterialProperty<Real> & _Ra;
  const unsigned _component;
  //RealVectorValue _advection_speed;
};

#endif //PressureConvection_H
