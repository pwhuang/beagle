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

#include "PressureConvection.h"

class PressureConvection_SUPG;

template<>
InputParameters validParams<PressureConvection_SUPG>();

class PressureConvection_SUPG : public PressureConvection
{
public:

  PressureConvection_SUPG(const InputParameters & parameters);

protected:

  virtual Real computeQpResidual() override;
  virtual Real computeQpJacobian() override;
  virtual Real computeQpOffDiagJacobian(unsigned jvar) override;

  virtual Real tao();
  virtual Real tao_jacobian();

private:
  const VariableValue & _vel_x;
  const VariableValue & _vel_y;
  const VariableValue & _Pe;
  bool _body_force;
};

#endif //PressureConvection_SUPG_H
