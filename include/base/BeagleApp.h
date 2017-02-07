#ifndef BEAGLEAPP_H
#define BEAGLEAPP_H

#include "MooseApp.h"

class BeagleApp;

template<>
InputParameters validParams<BeagleApp>();

class BeagleApp : public MooseApp
{
public:
  BeagleApp(InputParameters parameters);
  virtual ~BeagleApp();

  static void registerApps();
  static void registerObjects(Factory & factory);
  static void associateSyntax(Syntax & syntax, ActionFactory & action_factory);
};

#endif /* BEAGLEAPP_H */
