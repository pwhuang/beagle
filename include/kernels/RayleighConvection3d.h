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

#ifndef RayleighConvection3d_H
#define RayleighConvection3d_H

#include "Kernel.h"

class RayleighConvection3d;

template<>
InputParameters validParams<RayleighConvection3d>();

class RayleighConvection3d : public Kernel
{
public:

  RayleighConvection3d(const InputParameters & parameters);

protected:

  virtual Real computeQpResidual() override;

  virtual Real computeQpJacobian() override;

private:

  //const MaterialProperty<Real> & _heat_capacity;
  //const MaterialProperty<Real> & _porosity;
  Real _Ra;
  const VariableGradient & _grad_stream1;
  const VariableGradient & _grad_stream2;
};

#endif //RayleighConvection3d_H
