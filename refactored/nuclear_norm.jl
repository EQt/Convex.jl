#############################################################################
# nuclear_norm.jl
# Handles nuclear norm
# All expressions and atoms are subtpyes of AbstractExpr.
# Please read expressions.jl first.
#############################################################################

export nuclear_norm

### Unary Negation

type NuclearNormAtom <: AbstractExpr
  head::Symbol
  children_hash::Uint64
  children::(AbstractExpr,)
  size::(Int64, Int64)

  function NuclearNormAtom(x::AbstractExpr)
    children = (x,)
    return new(:-, hash(children), children, x.size)
  end
end

function sign(x::NuclearNormAtom)
  return Positive()
end

# The monotonicity
function monotonicity(x::NuclearNormAtom)
  return (NoMonotonicity(),)
end

function curvature(x::NuclearNormAtom)
  return Convex()
end

# XXX verify this returns all the eigenvalues even in new versions of julia (>=3.0)
function evaluate(x::NuclearNormAtom)
  evals, evecs = eigs(evaluate(x.children[1]),ritzvec=false)
  return sum(evals)
end

nuclear_norm(x::AbstractExpr) = NuclearNormAtom(x)

# Create the equivalent conic problem:
#   minimize (trace(U) + trace(V))/2
#   subject to
#            [U A; A' V] is positive semidefinite
function dual_conic_form(e::NuclearNormAtom)
  objective, constraints = dual_conic_form(e.children[1])
  return Error("Not implemented")
end