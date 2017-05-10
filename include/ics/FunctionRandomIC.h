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

#ifndef FunctionRandomIC_H
#define FunctionRandomIC_H

#include "InitialCondition.h"
#include "InputParameters.h"

#include <string>

// Forward Declarations
class FunctionRandomIC;
class Function;

template <>
InputParameters validParams<FunctionRandomIC>();

/**
 * Defines a boundary condition that forces the value to be a user specified
 * function at the boundary.
 */
class FunctionRandomIC : public InitialCondition
{
public:
  FunctionRandomIC(const InputParameters & parameters);

protected:
  /**
   * Evaluate the function at the current quadrature point and timestep.
   */
  Real f();

  /**
   * The value of the variable at a point.
   */
  virtual Real value(const Point & p) override;

  /**
   * The value of the gradient at a point.
   */
  //virtual RealGradient gradient(const Point & p) override;

  Function & _func;
  Real _min;
  Real _max;
  Real _range;
};

#endif // FunctionRandomIC_H
