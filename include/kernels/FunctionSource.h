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

#ifndef FUNCTIONSOURCE_H
#define FUNCTIONSOURCE_H

#include "Kernel.h"

//Forward Declarations
class FunctionSource;

template<>
InputParameters validParams<FunctionSource>();

class FunctionSource : public Kernel
{
public:

  FunctionSource(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;

  virtual Real computeQpJacobian() override;

  Function & _source;
  Real _elem_num;
};
#endif //FUNCTIONSOURCE_H
