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
  virtual ~PressureConvection() {}

protected:

  virtual Real computeQpResidual() override;
  virtual Real computeQpJacobian() override;
  virtual Real computeQpOffDiagJacobian(unsigned jvar) override;

//private:

  //const MaterialProperty<Real> & _heat_capacity;
  //Real _Ra;
  const VariableGradient & _grad_p;
  const VariableValue & _p;
  const VariableSecond & _second_temp;
  const VariableSecond & _second_u;
  const VariableTestSecond & _second_test;
  const VariablePhiSecond & _second_phi;
  unsigned _grad_p_var_num;
  //const VariableValue & _vel_x;
  //const VariableValue & _vel_y;
  const MaterialProperty<Real> & _Ra;
  const unsigned _component;
  //RealVectorValue _advection_speed;
};

#endif //PressureConvection_H
