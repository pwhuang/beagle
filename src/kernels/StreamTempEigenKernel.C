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

#include "StreamTempEigenKernel.h"

template <>
InputParameters
validParams<StreamTempEigenKernel>()
{
  InputParameters params = validParams<EigenKernel>();
  params.addClassDescription("An eigenkernel with weak form $\\lambda(\\psi_i, -u_h)$ where "
                             "$\\lambda$ is the eigenvalue.");
  params.addCoupledVar("stream_function", "stream_function is required for StreamTempEigenKernel.");
  return params;
}

StreamTempEigenKernel::StreamTempEigenKernel(const InputParameters & parameters) : EigenKernel(parameters),
  _Ra(getMaterialProperty<Real>("rayleigh_material")),
  _grad_stream(coupledGradient("stream_function")),
  _grad_stream_var_num(coupled("stream_function"))
{}

Real
StreamTempEigenKernel::computeQpResidual()
{
  return //(_Ra[_qp]*_test[_i][_qp] + _grad_test[_i][_qp]) * (_Ra[_qp]*_u[_qp] + std::sqrt(2*_grad_stream[_qp]*_grad_stream[_qp])*_grad_u[_qp]);
          _Ra[_qp]*_test[_i][_qp] * _Ra[_qp]*_u[_qp] + _grad_test[_i][_qp] * 2.0*_grad_stream[_qp]*_grad_stream[_qp]*_grad_u[_qp];
}

Real
StreamTempEigenKernel::computeQpJacobian()
{
  return //(_Ra[_qp]*_test[_i][_qp] + _grad_test[_i][_qp]) *
        //  (_Ra[_qp]*_phi[_j][_qp] + std::sqrt(2*_grad_stream[_qp]*_grad_stream[_qp])*_grad_phi[_j][_qp]);
        _Ra[_qp]*_test[_i][_qp] * _Ra[_qp]*_phi[_j][_qp] + _grad_test[_i][_qp] * 2.0*_grad_stream[_qp]*_grad_stream[_qp]*_grad_phi[_j][_qp];
}

Real StreamTempEigenKernel::computeQpOffDiagJacobian(unsigned jvar)
{
  if(jvar==_grad_stream_var_num)
    return //(_Ra[_qp]*_test[_i][_qp] + _grad_test[_i][_qp]) *
            //(2.0/std::sqrt(2*_grad_stream[_qp]*_grad_stream[_qp])*_grad_phi[_j][_qp]*_grad_phi[_j][_qp]*_grad_u[_qp]);
            _grad_test[_i][_qp] * 4.0*_grad_stream[_qp]*_grad_phi[_j][_qp]*_grad_u[_qp];
  else
    return 0;

}
