# 一些MMA代码备忘

-------
[TOC]

## Compile

### 打印可以编译的函数

```Mathematica
≪CompiledFunctionTools`
Compile`CompilerFunctions[]
```

### PackedArray

```Mathematica
Developer`PackedArrayQ
```

## Parallel

### 相关文档位置：

- guide∕ResourceSharingInParallelComputing
- LightweightGridClient∕guide∕LightweightGridClient
- ParallelTools∕tutorial∕Overview


```Mathematica
Needs["Parallel`Developer`"]
$Queue	(*the list of evaluations submitted with ParallelSubmit but not yet assigned to an available kernel*)
$QueueLength	(*gives the length of the input queue $Queue *)
ResetQueues[]	(*waits for all running processes and abandons any queued processes*)
QueueRun[]	(*collects finished evaluations from all kernels and assign new ones from the queue *)
ProcessID[pid]	(*a unique integer identifying the process *)
Process[pid]	(*the expression representing the process*)
Scheduling[pid]	(*the priority assigned to the process *)
ProcessState[pid]	(*the state of the process: queued, running, finished*)
```

## FEM

```Mathematica
Needs["NDSolve`FEM`"]
{state} = NDSolve`ProcessEquations[{Laplacian[u[x,y],{x,y}]⩵1,       DirichletCondition[u[x,y]⩵0,True]},u,{x,0,1},{y,0,1},Method−>{"FiniteElement"}]
NDSolve`Iterate[state]
u/.NDSolve`ProcessSolutions[state]
```

### 传给``NDSolve``的选项

```Mathematica
Method -> {
    "PDEDiscretization" -> {
    "FiniteElement",
    "MeshOptions" -> {"MaxCellMeasure" -> 0.1}, 
        "IntegrationOrder" -> 5
    } 
}


Method -> {
    "PDEDiscretization" -> {
        "MethodOfLines",
        "SpatialDiscretization" -> {
            "FiniteElement", 
            "MeshOptions" -> {"MaxCellMeasure" -> 0.1}, 
            "IntegrationOrder" -> 5
        }
    }
}
```

## SqrtQ
### 最快速的,较大会不准

```Mathematica
SqrtQ[num_,power_:2]:=Round@Surd[N@num,power]^power==num;
```

### 精确和速度兼备的

```Mathematica
Internal`PerfectPower

EvenQ[Last[Internal`PerfectPower[10^10000]]]
```

## NDSolve

```Mathematica
Method→{"EquationSimplification"→{Automatic,"SimplifySystem"→True}
}
```

## Debug

首先开启Debug模式，然后运行

```Mathematica
RuntimeTools`Profile[expr]
```

## Variables查看

```Mathematica
Internal`AllUnheldSymbols[x^4 + y^4 + z^4 - 3 x y z]
Variables[x^4 + y^4 + z^4 - 3 x y z]
```

## 查看函数优先级

```Mathematica
Precedence[f]
```

## PrintDefinitions

```Mathematica
<< GeneralUtilities`
PrintDefinitions@FindFormula
```

## Failure

```Mathematica
Internal`$LastInternalFailure
```

## Simplify`PWToUnitStep

```Mathematica
f[x_] := Piecewise[{{-x, x < 0}, {3 x, 0 < x < 1}, {x^2, x > 1}}]
Simplify`PWToUnitStep@f[x] /. UnitStep -> ((1 + Tanh[100 #])/2 &)
Plot[%, {x, -3, 5}]
```

## clc

放在"init.m"里面
 

```Mathematica
System`cls := (SelectionMove[InputNotebook[], All, Notebook];
FrontEndExecute[
FrontEndToken["Clear"]]);
(*加入System是防止Clear["Global`*"]会清除clc的定义*)
```


## 查看 Integrate 的方法

https://mathematica.stackexchange.com/questions/26401/determining-which-rule-nintegrate-selects-automatically

```Mathematica
symbNames = Names["NIntegrate`*"];
symbNames = 
  Append[Pick[symbNames, 
    StringMatchQ[
     symbNames, (__ ~~ "Rule") | (__ ~~ 
        "Global" | "Local" | "MonteCarlo" | "Principal" | "Levin" | 
         "Osc" ~~ ___)]], "NIntegrate`AutomaticStrategy"];
symbs = ToExpression[#] & /@ symbNames;
dvs = DownValues /@ symbs;
uvs = UpValues /@ symbs;
Unprotect /@ symbs;
dvsNew = MapThread[
   With[{s = #2}, 
     DownValues[s] = 
      ReplaceAll[#1, 
       HoldPattern[
         a_ :> b___] :> (a :> (Print["DownValue call for: ", 
            Style[s, Red]]; b))]] &, {dvs, symbs, symbNames}];
uvsNew = MapThread[
   With[{s = #2}, 
     UpValues[s] = 
      ReplaceAll[#1, 
       HoldPattern[Block[vars_, CompoundExpression[b___]]] :> 
        Block[{res = Block[vars, CompoundExpression[b]]}, 
         Print["UpValue call for: ", Style[s, Blue], 
          Style[" ::\n", Blue], res]; res]]] &, {uvs, symbs, 
    symbNames}];


NIntegrate[Sin[x]^2 Sin[1000 x]^2/x^(5/2), {x, 0, Infinity}]

```

### 三角函数

```Mathematica
Tan[1/7 ArcTan[t]] /. 
  e : (Sin | Cos | Tan | Cot | Csc |  Sec)[(ArcSin | ArcCos | ArcTan | ArcCot | ArcSec | ArcCsc)[_] Rational[1, n_]] :> 
   First[y /.  Solve[Reduce[{y == e, 0 < t < 2 Pi}, t, Reals] /.  c : (_Sin | _Cos | _Tan | _Cot | _Csc | _Sec) :> 
           Simplify@TrigExpand[c], y, Reals] // Simplify // Normal // Union] // ToRadicals
```

