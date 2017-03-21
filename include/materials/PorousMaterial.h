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

#ifndef POROUSMATERIAL_H
#define POROUSMATERIAL_H

#include "Material.h"
#include "LinearInterpolation.h"

//Forward Declarations
class PorousMaterial;

template<>
InputParameters validParams<PorousMaterial>();

/**
 * Example material class that defines a few properties.
 */
class PorousMaterial : public Material
{
public:
  PorousMaterial(const InputParameters & parameters);

protected:
  virtual void computeQpProperties() override;
  //virtual void initQpStatefulProperties() override;

//private:
  MaterialProperty<Real> & _permeability;
  Real _permeability_param;
  MaterialProperty<Real> & _heat_capacity;
  MaterialProperty<Real> & _viscosity;
  MaterialProperty<Real> & _density;
  //MaterialProperty<Real> & _density_old;
  //MaterialProperty<Real> & _density_diff;
  const VariableValue & _temp;
  //Real _initial_temp;
  MaterialProperty<Real> & _porosity;
  Real _porosity_param;
  MaterialProperty<Real> & _thermal_conductivity;
  MaterialProperty<Real> & _thermal_diffusivity;
};

#endif //POROUSMATERIAL_H
