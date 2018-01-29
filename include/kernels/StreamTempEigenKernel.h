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

#ifndef StreamTempEigenKernel_H
#define StreamTempEigenKernel_H

#include "EigenKernel.h"

// Forward Declarations
class StreamTempEigenKernel;

template <>
InputParameters validParams<StreamTempEigenKernel>();

class StreamTempEigenKernel : public EigenKernel
{
public:
  StreamTempEigenKernel(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;
  virtual Real computeQpJacobian() override;
  virtual Real computeQpOffDiagJacobian(unsigned jvar) override;

private:
  const MaterialProperty<Real> & _Ra;
  const VariableGradient & _grad_stream;
  unsigned _grad_stream_var_num;
};

#endif // StreamTempEigenKernel_H
