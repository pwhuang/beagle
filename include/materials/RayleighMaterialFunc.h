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

#ifndef RayleighMaterialFunc_H
#define RayleighMaterialFunc_H

#include "Material.h"
#include "Function.h"
#include "MooseRandom.h"

//Forward Declarations
class RayleighMaterialFunc;
class Function;

template<>
InputParameters validParams<RayleighMaterialFunc>();

/**
 * Example material class that defines a few properties.
 */
class RayleighMaterialFunc : public Material
{
public:
  RayleighMaterialFunc(const InputParameters & parameters);

protected:
  virtual void computeQpProperties() override;
  //virtual void initQpStatefulProperties() override;

//private:
  MaterialProperty<Real> & _Ra;
  Function & _func;
  Real _min;
  Real _max;
  Real _range;
};

#endif //RayleighMaterialFunc_H
