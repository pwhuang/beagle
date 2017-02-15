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

#ifndef POROUSCONVECTION_H
#define POROUSCONVECTION_H

#include "Kernel.h"

class PorousConvection;

template<>
InputParameters validParams<PorousConvection>();

class PorousConvection : public Kernel
{
public:

  PorousConvection(const InputParameters & parameters);

protected:

  virtual Real computeQpResidual() override;

  virtual Real computeQpJacobian() override;

private:

  const MaterialProperty<Real> & _heat_capacity;
  const MaterialProperty<Real> & _porosity;
  const VariableValue & _advection_speed_x;
  const VariableValue & _advection_speed_y;
};

#endif //PorousConvection_H
