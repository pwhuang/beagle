#include "BeagleApp.h"
#include "Moose.h"
#include "AppFactory.h"
//#include "ModulesApp.h"
#include "MooseSyntax.h"

#include "PorousDiffusion.h"
#include "PorousConvection.h"
#include "ExampleTimeDerivative.h"
#include "DarcyPressure.h"
#include "MassBalance.h"
#include "MomentumBalance.h"

//ics
#include "FunctionRandomIC.h"

//kernel
#include "ExampleDiffusion.h"
#include "ExampleConvection.h"
#include "FunctionSource.h"
#include "RayleighConvection.h"
#include "RayleighConvection3d.h"
#include "StreamDiffusion.h"
#include "Supg.h"

//AuxKernel
#include "AuxDensity.h"
#include "AuxVelocity.h"
#include "VariableGradientSign.h"

//Materials
#include "PorousMaterial.h"
#include "RayleighMaterial.h"

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
  BeagleApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  //ModulesApp::associateSyntax(_syntax, _action_factory);
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
    registerKernel(StreamDiffusion);
    registerKernel(Supg);
    registerInitialCondition(FunctionRandomIC);
    registerAux(AuxDensity);
    registerAux(AuxVelocity);
    registerAux(VariableGradientSign);
    registerMaterial(PorousMaterial);
    registerMaterial(RayleighMaterial);
}

// External entry point for dynamic syntax association
extern "C" void BeagleApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory) { BeagleApp::associateSyntax(syntax, action_factory); }
void
BeagleApp::associateSyntax(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
}
