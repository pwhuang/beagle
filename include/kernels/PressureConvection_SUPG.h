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

#ifndef PressureConvection_SUPG_H
#define PressureConvection_SUPG_H

#include "Kernel.h"
#include "PressureConvection.h"
#include "PressureDiffusion_test.h"

class PressureConvection_SUPG;

template<>
InputParameters validParams<PressureConvection_SUPG>();

class PressureConvection_SUPG : public Kernel
{
public:

  PressureConvection_SUPG(const InputParameters & parameters);

protected:

  virtual Real computeQpResidual() override;
  virtual Real computeQpJacobian() override;
  virtual Real computeQpOffDiagJacobian(unsigned jvar) override;

private:

  //const MaterialProperty<Real> & _heat_capacity;
  //Real _Ra;
  const VariableGradient & _grad_p;
  const VariableValue & _p;
  const VariableSecond & _second_temp;
  const VariableSecond & _second_u;
  const VariableTestSecond & _second_test;
  const VariablePhiSecond & _second_phi;
  unsigned _grad_p_var_num;
  const VariableValue & _vel_x;
  const VariableValue & _vel_y;
  const MaterialProperty<Real> & _Ra;
  const unsigned _component;
  const VariableValue & _Pe;
  //RealVectorValue _advection_speed;
};

#endif //PressureConvection_SUPG_H
