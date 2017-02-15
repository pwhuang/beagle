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

#include "PorousMaterial.h"
#include "math.h"

template<>
InputParameters validParams<PorousMaterial>()
{
  InputParameters params = validParams<Material>();
  params.addParam<Real>("permeability", "permeability");
  params.addParam<Real>("porosity", "porosity");
  params.addCoupledVar("temp", "temperature will be used to calculate viscosity");

  return params;
}

PorousMaterial::PorousMaterial(const InputParameters & parameters) :
    Material(parameters),
    // Declare that this material is going to provide a Real
    // valued property named "permeability" that Kernels can use.
    _permeability(declareProperty<Real>("permeability")),
    _permeability_param(getParam<Real>("permeability")),
    _heat_capacity(declareProperty<Real>("heat_capacity")),
    _viscosity(declareProperty<Real>("viscosity")),
    _density(declareProperty<Real>("density")),
    //_density_old(getMaterialPropertyOld<Real>("density")), //This is very expensive!
    //_density_ratio(declareProperty<Real>("density_ratio")), // rho/rho_0
    _temp(coupledValue("temp")),
    _porosity(declareProperty<Real>("porosity")),
    _porosity_param(getParam<Real>("porosity")),
    _thermal_conductivity(declareProperty<Real>("thermal_conductivity")),
    _thermal_diffusivity(declareProperty<Real>("thermal_diffusivity"))

{}


/*
void
PorousMaterial::initQpStatefulProperties()
{
  // init the diffusivity property (this will become
  // _diffusivity_old in the first call of computeProperties)
  _density[_qp] = 0.14395/pow(0.0112, 1+pow(1.0-(_temp[_qp]+273.0)/649.727, 0.05107));

  Real rock_rho = 2800;  // (kg/m^3)

  // Now actually set the value at the quadrature point
  _density[_qp] = _porosity[_qp]*_density[_qp] + (1.0-_porosity[_qp])*rock_rho;
}
*/


void
PorousMaterial::computeQpProperties()
{
  _permeability[_qp] = _permeability_param;
  _porosity[_qp] = _porosity_param;

  double T = _temp[_qp]-20;

  //R. C. Weast, 1983, CRC Handbook of Chemistry
  //and Physics, 64th edition, CRC Press, Boca Raton, FL
  //input temperature degC, valid from 0 to 100 degC
  //output dynamic viscosity kg/(m*s)
  if(_temp[_qp]<=20)
    _viscosity[_qp] = 0.001*pow(10,1301/(998.333+8.1855*T+0.00585*T*T)-1.30223);
  else
    _viscosity[_qp] = 0.001002*pow(10,(-1.3272*T-0.001053*T*T)/(_temp[_qp]+105));

  _density[_qp] =  0.14395/pow(0.0112, 1+pow(1.0-(_temp[_qp]+273.0)/649.727, 0.05107));

  Real water_k = 0.6;  // (W/m*K)
  Real water_cp = 4181.3; // (J/kg*K)
  //Real water_rho = 995.6502;  // (kg/m^3 @ 303K)

  Real rock_k = 2.5;  // (W/m*K)
  Real rock_cp = 840;  // (J/kg*K) //Basalt rock?
  Real rock_rho = 2800;  // (kg/m^3)

  // Now actually set the value at the quadrature point
  _thermal_conductivity[_qp] = _porosity[_qp]*water_k + (1.0-_porosity[_qp])*rock_k;
  _density[_qp] = _porosity[_qp]*_density[_qp] + (1.0-_porosity[_qp])*rock_rho;
  _heat_capacity[_qp] = _porosity[_qp]*water_cp*_density[_qp] + (1.0-_porosity[_qp])*rock_cp*rock_rho;
  _thermal_diffusivity[_qp] = _thermal_conductivity[_qp]/_density[_qp]/_heat_capacity[_qp];
  //_density_ratio[_qp] = _density[_qp]/_density_old[_qp];
}
