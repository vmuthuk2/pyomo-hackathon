
from pyomo import environ, mpec


model = environ.ConcreteModel()


# define the model variables
model.x1 = environ.Var()
model.x2 = environ.Var()
model.x3 = environ.Var()

# define the complementarity conditions
model.f1 = mpec.Complementarity(expr=mpec.complements(model.x1 >= 0, model.x1 + 2 * model.x2 + 3 * model.x3 >= 1))
model.f2 = mpec.Complementarity(expr=mpec.complements(model.x2 >= 0, model.x2 - model.x3 >= -1))
model.f3 = mpec.Complementarity(expr=mpec.complements(model.x3 >= 0, model.x1 + model.x2 >= -1))