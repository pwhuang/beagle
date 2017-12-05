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

#ifndef CellCFL_H
#define CellCFL_H

// MOOSE includes
#include "AuxKernel.h"

// Forward declarations
class CellCFL;

template <>
InputParameters validParams<CellCFL>();

/**
 * Extract a component from the gradient of a variable
 */
class CellCFL : public AuxKernel
{
public:
  /**
   * Class constructor
   * @param parameters Input parameters for the object
   */
  CellCFL(const InputParameters & parameters);

protected:
  virtual Real computeValue() override;
  FEProblemBase & _feproblem;

private:
  /// Reference to the gradient of the coupled variable
  //const VariableGradient & _gradient;
  const VariableValue & _velocity_x;
  const VariableValue & _velocity_y;
  const VariableValue & _velocity_z;

  // Scaling Material Property
  const MaterialProperty<Real> & _scale;

  /// Desired component
  //int _component;
  //Real _sign;
};

#endif // CellCFL_H
