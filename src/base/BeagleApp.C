#include "BeagleApp.h"
#include "Moose.h"
#include "AppFactory.h"
//#include "ModulesApp.h"
#include "LevelSetApp.h"
#include "MooseSyntax.h"

#include "PorousDiffusion.h"
#include "PorousConvection.h"
#include "ExampleTimeDerivative.h"
#include "DarcyPressure.h"
#include "MassBalance.h"
#include "MomentumBalance.h"

//ics
#include "FunctionRandomIC.h"
#include "PerturbationRandomIC.h"

//bcs
#include "CoupledNeumannBC.h"

//kernel
#include "ExampleDiffusion.h"
#include "ExampleConvection.h"
#include "FunctionSource.h"
#include "RayleighConvection.h"
#include "RayleighConvection3d.h"
#include "PressureConvection.h"
#include "StreamDiffusion.h"
#include "PressureDiffusion.h"
#include "PressureDiffusion_test.h"
#include "Supg.h"
#include "Vorticity.h"
#include "VelocityDiffusion_second.h"
#include "VelocityDiffusion_secondu.h"
#include "VelocityDiffusion_half.h"
#include "VelocityDiffusionZ.h"
#include "VelocityDiffusionZ_secondu.h"
#include "PressureConvection_SUPG.h"
#include "StreamEigenKernel.h"
#include "StreamTempEigenKernel.h"

//AuxKernel
#include "AuxDensity.h"
#include "AuxVelocity.h"
#include "VariableGradientSign.h"
#include "DarcyVelocity.h"
#include "StreamVelocityZ.h"
#include "CellPeclet.h"
#include "CellCFL.h"
#include "EntropyProduction.h"
#include "AuxPerturb.h"

//Materials
#include "PorousMaterial.h"
#include "RayleighMaterial.h"
#include "RayleighMaterialFunc.h"

//TimeSteppers
#include "CFLDT.h"

//Indicators
#include "PecletIndicator.h"

template<>
InputParameters validParams<BeagleApp>()
{
  InputParameters params = validParams<MooseApp>();
  return params;
}

BeagleApp::BeagleApp(InputParameters parameters) :
    MooseApp(parameters)
{
  Moose::registerObjects(_factory);
  //ModulesApp::registerObjects(_factory);
  LevelSetApp::registerObjects(_factory);
  BeagleApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  //ModulesApp::associateSyntax(_syntax, _action_factory);
  LevelSetApp::associateSyntax(_syntax, _action_factory);
  BeagleApp::associateSyntax(_syntax, _action_factory);
}

BeagleApp::~BeagleApp()
{
}


// External entry point for dynamic application loading
extern "C" void BeagleApp__registerApps() { BeagleApp::registerApps(); }
void
BeagleApp::registerApps()
{
  registerApp(BeagleApp);
}

// External entry point for dynamic object registration
extern "C" void BeagleApp__registerObjects(Factory & factory) { BeagleApp::registerObjects(factory); }
void
BeagleApp::registerObjects(Factory & factory)
{
    registerKernel(PorousConvection);
    registerKernel(PorousDiffusion);
    registerKernel(ExampleTimeDerivative);
    registerKernel(DarcyPressure);
    registerKernel(MassBalance);
    registerKernel(MomentumBalance);
    registerKernel(ExampleDiffusion);
    registerKernel(ExampleConvection);
    registerKernel(FunctionSource);
    registerKernel(RayleighConvection);
    registerKernel(RayleighConvection3d);
    registerKernel(PressureConvection);
    registerKernel(StreamDiffusion);
    registerKernel(PressureDiffusion);
    registerKernel(PressureDiffusion_test);
    registerKernel(Supg);
    registerKernel(Vorticity);
    registerKernel(VelocityDiffusion_half);
    registerKernel(VelocityDiffusion_second);
    registerKernel(VelocityDiffusion_secondu);
    registerKernel(VelocityDiffusionZ);
    registerKernel(VelocityDiffusionZ_secondu);
    registerKernel(PressureConvection_SUPG);
    registerKernel(StreamEigenKernel);
    registerKernel(StreamTempEigenKernel);
    registerInitialCondition(FunctionRandomIC);
    registerInitialCondition(PerturbationRandomIC);
    registerBoundaryCondition(CoupledNeumannBC);
    registerAux(AuxDensity);
    registerAux(AuxVelocity);
    registerAux(VariableGradientSign);
    registerAux(DarcyVelocity);
    registerAux(StreamVelocityZ);
    registerAux(CellPeclet);
    registerAux(CellCFL);
    registerAux(EntropyProduction);
    registerAux(AuxPerturb);
    registerMaterial(PorousMaterial);
    registerMaterial(RayleighMaterial);
    registerMaterial(RayleighMaterialFunc);
    registerTimeStepper(CFLDT);
    registerIndicator(PecletIndicator);
}

// External entry point for dynamic syntax association
extern "C" void BeagleApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory) { BeagleApp::associateSyntax(syntax, action_factory); }
void
BeagleApp::associateSyntax(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
}
