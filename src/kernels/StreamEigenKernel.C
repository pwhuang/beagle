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

#include "StreamEigenKernel.h"

template <>
InputParameters
validParams<StreamEigenKernel>()
{
  InputParameters params = validParams<EigenKernel>();
  params.addClassDescription("An eigenkernel with weak form $\\lambda(\\psi_i, -u_h)$ where "
                             "$\\lambda$ is the eigenvalue.");
  return params;
}

StreamEigenKernel::StreamEigenKernel(const InputParameters & parameters) : EigenKernel(parameters) {}

Real
StreamEigenKernel::computeQpResidual()
{
  return 1.414 * _grad_test[_i][_qp] * _grad_u[_qp];
}

Real
StreamEigenKernel::computeQpJacobian()
{
  return 1.414 * _grad_test[_i][_qp] * _grad_phi[_j][_qp];
}
