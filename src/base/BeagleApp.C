#include "BeagleApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

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
  ModulesApp::registerObjects(_factory);
  BeagleApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ModulesApp::associateSyntax(_syntax, _action_factory);
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
}

// External entry point for dynamic syntax association
extern "C" void BeagleApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory) { BeagleApp::associateSyntax(syntax, action_factory); }
void
BeagleApp::associateSyntax(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
}
