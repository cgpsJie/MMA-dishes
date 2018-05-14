(* ::Package:: *)

Chebyshev[f_,x_,n_]:=Module[{mk,c},
mk=Table[N@Cos[(\[Pi] m(k+1/2))/n],{m,0,n-1},{k,0,n-1}];
c=f/@mk[[2]];
c=2mk.c/n;
c.Table[ChebyshevT[k,x],{k,0,n-1}]-c[[1]]/2
]

f[x_]:=Sin[10x];
Chebyshev[f,x,10]//Simplify
Plot[{f[x],Chebyshev[f,x,10]}//Evaluate,{x,0,1}]
