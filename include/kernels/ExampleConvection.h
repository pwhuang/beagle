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

#ifndef EXAMPLECONVECTION_H
#define EXAMPLECONVECTION_H

#include "Kernel.h"

class ExampleConvection;

template<>
InputParameters validParams<ExampleConvection>();

class ExampleConvection : public Kernel
{
public:

  ExampleConvection(const InputParameters & parameters);

protected:

  virtual Real computeQpResidual() override;

  virtual Real computeQpJacobian() override;
  virtual Real computeQpOffDiagJacobian(unsigned jvar) override;

private:

  //const MaterialProperty<Real> & _heat_capacity;
  //const MaterialProperty<Real> & _porosity;
  const VariableValue & _advection_speed_x;
  const VariableValue & _advection_speed_y;
  const VariableValue & _advection_speed_z;
  unsigned _vel_x_var_num;
  unsigned _vel_y_var_num;
  unsigned _vel_z_var_num;
  const MaterialProperty<Real> & _Ra;
};

#endif //EXAMPLECONVECTION_H
