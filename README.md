# Alternative methods for calling C From D
author: "Dr Chibisi Chima-Okereke"
date: 2021-05-16T19:48:47+01:00
publishdate: 2021-05-18T05:34:47+01:00

## Introduction

D has always had a close association with the C programming language, and it is relatively straightforward to call C functions from D. Recently, a pull request has been initiated on the <a href="https://github.com/dlang/dmd/" target="_blank">GitHub repository</a> of the D reference compiler DMD by <a href="https://twitter.com/WalterBright" target="_blank">Walter Bright</a> the originator of the language titled <a href="https://github.com/dlang/dmd/pull/12507" target="_blank">`add ImportC Compiler`</a>. This PR would allow D programmers to import and compile C files directly with D code, enabling a frictionless interface calling C from D. This is significant for many applications that integrate or are looking to integrate C libraries including the area of numerical computing. Many fundamental algorithms from BLAS, LAPACK, to FFTW have well supported open source C implementations, and the proposed changes would ease integration and allow programmers to keep up with the latest changes and adopt new features easily. In addition, such a feature would ease the transition of prospective C programmers considering using D as a safe and more productive language.

There are currently two main ways of calling C functions from D. The first is to use `extern (C)` and then declare the function signature using directions in the <a href="https://dlang.org/spec/interfaceToC.html" target="_blank">language documentation</a>. A <a href="../interface-d-with-c-fortran/" target="_blank">previous article</a> describes some basics of this technique (which is also covered here). The other technique is to use the <a href="https://github.com/jacob-carlborg/dstep" target="_blank">dstep</a> package which converts C header files to D files containing the appropriate type definitions and signatures. A third option <a href="https://github.com/atilaneves/dpp" target="_blank">dpp</a> does exist but it is still in early developement. This article outlines how to use the basic native method for declaring C functions and how to use the dstep package to call C functions in D from the <a href="http://www.fftw.org/" target="_blank">fftw3</a> package (Fastest Fourier Transforms in the West). The example will create functions that call the library to carry out an FFT and inverse FFT.

To be clear, this article is *not* about Fast Fourier Transforms (FFT) (though there may be articles about this topic at a later stage). Using `fftw3` library serves as an example to the main aim of outlining the methods of calling C from D.

The code for this article can be found <a href="https://github.com/ActiveAnalytics/alternative-methods-call-c-from-d" target="_blank">here</a>.

## Preliminaries

D does have a `Complex` number data type but in this exercise we shall implemented a type based on `T[2]` (where `T` is a floating point type) which is in line with fftw underlying complex data type (`fftw_complex`) rather than the D library's <a href="" target="_blank">Complex type</a> based on `struct Complex(T){T re; T im}`. Why? Because we can be **absolutely** sure that an array of `T[2]` elements in D is the same as an array of `T[2]` elements in C for floating point types without have to consider anything else. While the type conversion of `fftw_complex` to D's `Complex` type is straightforward, we want to avoid the possibility of other issues with type conversion of arrays of complex numbers which we will do by directly changing the type signatures of the array blocks. It is probably over-cautious but it's the path taken here. Another reason for going this route is that writing our own complex type with basic functionality is relatively simple and fun, there's always more to learn.

### Imports

During this article you will see these functions used:

```
import std.stdio: writeln;
import std.traits: isFloatingPoint, isNumeric;
import std.conv: to;
```

... now you know where they're from.

### Creating `Complex(T)` type

The complex type data member and constructors are given below:

```d
struct Complex(T)
if(isFloatingPoint!T)
{
  T[2] data;

  this(T[2] x)
  {
    data = x;
  }
  this(T[] x)
  {
    assert(x.length == 2, "Length of submitted array not equal to 2.");
    data = x;
  }
  this()(auto ref T _re, auto ref T _im)
  {
    data[0] = _re;
    data[1] = _im;
  }
  //...
}
```

Note that in D structs can not be declared with a `this(){//...}` constructor except to disable it using `@disable this();`. The D compiler itself autogenerates this constructor and it can only be disabled. The third constructor uses `auto ref` so that if an <a href="https://ddili.org/ders/d.en/lvalue_rvalue.html">lvalue</a> (named variable) is submitted it is passed as a reference and if an `rvalue` (literal) is submitted it is passed as a value type and copied.

Next the getters and setters for the real and imaginary part are given by:

```d
struct Complex(T)
if(isFloatingPoint!T)
{
  //...
  auto re() const
  {
    return data[0];
  }
  auto im() const
  {
    return data[1];
  }
  auto re(T x)
  {
    data[0] = x;
  }
  auto im(T x)
  {
    data[1] = x;
  }
  //...
}
```

where the real and the imaginary part are the first and second elements of the one-dimensional array of length two. The `toString` method is used to create a string representation of the object for the output.

```d
struct Complex(T)
if(isFloatingPoint!T)
{
  //...
  string toString()
  {
    return to!string(re) ~ " + " ~ to!string(im) ~ "im";
  }
  //...
}
```

Casting operators to and from `T[]`

```d
struct Complex(T)
if(isFloatingPoint!T)
{
  //...
  T[] opCast(U: T[])()
  {
    return data;
  }
  typeof(this) opCast(U: Complex!(T))(T[] x)
  {
    return Complex!(T)(x);
  }
  //...
}
```

The first casts from `Complex!(T)` to `T[]` and the second casts in the reverse direction. The output of an inverse one-dimensional DFT in fftw3 requires rescaling by the length of the array, so basic arithmetic operators of Complex numbers with *real* operands are implemented. Firstly binary operators for multiply and divide:

```d
struct Complex(T)
if(isFloatingPoint!T)
{
  //...
  Complex!T opBinary(string op, N)(N x)
  if(((op == "*") || (op == "/")) && isNumeric!N)
  {
    auto num = Complex!T(data.dup);
    mixin("num.data[0] " ~ op ~ "= cast(T)x;");
    mixin("num.data[1] " ~ op ~ "= cast(T)x;");
    return num;
  }
  //...
}
```

the `if(...)` under the function declaration is a (compile time) <a href="https://dlang.org/concepts.html" target="_blank">template constraint</a> limiting the operators we use to multiply and divide. String `mixins` are used generate the code to conduct the numeric operation. The same method can be used to generate the code for addition and subtraction, as you can see, in this case only the real part is affected:


```d
struct Complex(T)
if(isFloatingPoint!T)
{
  //...
  Complex!T opBinary(string op, N)(N x)
  if(((op == "+") || (op == "-")) && isNumeric!N)
  {
    auto num = Complex!T(data.dup);
    // For addition and subtraction real part only
    mixin("num.data[0] " ~ op ~ "= cast(T)x;");
    return num;
  }
  //...
}
```

Next the `opOpAssign` operator defines operations of the form `x op= y` where `op` is an arithmetic operator, so the addition and subtraction operators are given by:

```d
struct Complex(T)
if(isFloatingPoint!T)
{
  //...
  ref Complex!T opOpAssign(string op, N)(N x)
  if(((op == "+") || (op == "-")) && isNumeric!N)
  {
    // For addition and subtraction real part only
    mixin("data[0] " ~ op ~ "= cast(T)x;");
    return this;
  }
  //...
}
```

... and the multiplication and division operators are given by


```d
struct Complex(T)
if(isFloatingPoint!T)
{
  //...
  ref Complex!T opOpAssign(string op, N)(N x)
  if(((op == "*") || (op == "/")) && isNumeric!N)
  {
    mixin("data[0] " ~ op ~ "= cast(T)x;");
    mixin("data[1] " ~ op ~ "= cast(T)x;");
    return this;
  }
  //...
}
```

Lastly the equality operator of two complex numbers are given by:

```d
struct Complex(T)
if(isFloatingPoint!T)
{
  //...
  bool opEquals(Complex!T rhs) const
  {
    return (data[0] == rhs.data[0]) && (data[1] == rhs.data[1]);
  }
  //...
}
```

### Convenience construction functions

Convenience construction functions are given by:

```d
auto complex(T)(auto ref T _re, auto ref T _im)
{
  return Complex!(T)(_re, _im);
}
auto complex(T)(T[] x)
{
  return Complex!(T)(x);
}
```

### Basic random number generator

This function generates a one-dimensional random array of complex numbers and defaults to `Complex!double` types.

```d
auto randomComplexArray(T = double)(long n)
if(isFloatingPoint!T)
{
  import std.random: Mt19937_64, uniform01, unpredictableSeed;
  auto rnd = Mt19937_64(unpredictableSeed);
  auto arr = new Complex!T[n];
  foreach(ref el; arr)
  {
    el = complex(rnd.uniform01!T, rnd.uniform01!T);
  }
  return arr;
}
```

### Convenience function for creating fftw_complex pointer to array

Below is a convenience function for creating a pointer to an fftw_complex array.


```d
auto allocateFFTWArray(ulong n)
{
  auto arr = new fftw_complex[n];
  return arr.ptr;
}
```

### Casting between `Complex!double[]` and `fftw_complex*`

This is done by changing the type signature by casting through `void*` this is fine since the elements of both arrays are `double[2]`.

```
auto toComplexArray(fftw_complex* arr, ulong n)
{
  return (cast(Complex!double*)cast(void*)arr)[0..n];
}
auto toFFTWArray(Complex!double[] arr)
{
  return cast(fftw_complex*)cast(void*)arr;
}
```


## Calling fftw3 C functions from D using `extern (C)`

Now that the preliminaries/supporting code has been described, we can declare the items from `fftw3` that we wish to import.

```c
extern (C)
{
  // For chosing the algorithm to be used
  enum FFTW_ESTIMATE = 1U << 6;
  // For defining whether the algorithm 
  //     calculates the FFT or its inverse
  enum FFTW_FORWARD = -1;
  enum FFTW_BACKWARD = +1;
  // The fftw library'd complex number (double)
  alias fftw_complex = double[2];
  // Opaque struct for execution plan
  struct fftw_plan_s;
  alias fftw_plan = fftw_plan_s*;
  // Function for creating the execution plan
  fftw_plan fftw_plan_dft_1d(int n, fftw_complex* in_, fftw_complex* out_, int sign, uint flags);
  // Function for carrying out the execution plan
  void fftw_execute(const fftw_plan p);
  // Function for destroying the plan
  void fftw_destroy_plan(fftw_plan p);
}
```


Then create the function to perform the forward FFT call as

```d
auto fft(Complex!double[] x)
{
  auto in_arr = x.toFFTWArray;
  auto out_arr = allocateFFTWArray(x.length);
  int n = cast(int)x.length;
  auto plan_forward = fftw_plan_dft_1d(n, in_arr, out_arr, FFTW_FORWARD, FFTW_ESTIMATE);
  fftw_execute(plan_forward);
  fftw_destroy_plan(plan_forward);
  return out_arr.toComplexArray(x.length);
}
```

and the inverse FFT as

```d
auto ifft(Complex!double[] x)
{
  auto in_arr = x.toFFTWArray;
  auto out_arr = allocateFFTWArray(x.length);
  int n = cast(int)x.length;
  auto plan_backward = fftw_plan_dft_1d(n, in_arr, out_arr, FFTW_BACKWARD, FFTW_ESTIMATE);
  fftw_execute(plan_backward);
  fftw_destroy_plan(plan_backward);
  auto inv_fft_arr = out_arr.toComplexArray(x.length);
  foreach(ref el; inv_fft_arr)
  {
    el /= cast(double)x.length;
  }
  return inv_fft_arr;
}
```


A possible program to run in D:

```d
void main()
{
  checkComplexNumbers();
  auto complex_sample = randomComplexArray(100);
  writeln("Input: \n\n", complex_sample, "\n");
  auto test_fft = fft(complex_sample);
  writeln("\n\nFrom fft function: ", test_fft);
  auto test_iff = ifft(test_fft);
  writeln("\n\nFrom ifft function: ", test_iff);
}
```

Then compile and run with the flags `-lfftw3` and `-lm`:

```bash
$ dmd callc_native.d -L-lfftw3 -L-lm && ./callc_native
```

*When using the DMD compiler, C flags are passed with a `-L` prefix*.

## Calling fftw3 C functions from D using `dstep`

The `dstep` library works by converting C header files to a D file with all the exported items within `extern (C)` so there is no need to write the interface yourself, you simply compile the new file with your code as if it where just another module. The installation details for `dstep` can be found at the <a href="https://github.com/jacob-carlborg/dstep" target="_blank">GitHub page</a>.

Once installed, using `dstep` is pretty easy. Simply run the `dstep` command executable against the header file(s) containing the functionality you wish to use:

```bash
$ dstep fftw3.h
```

The above command creates a D file `fftw3.d`. However `dstep` sometimes makes conversion errors. In this case we see

```d
//...
alias fftw_complex = double[[];
//...
alias fftwf_complex = float[[];
//...
alias fftwl_complex = real[[];
```

instead of:

```d
//...
alias fftw_complex = double[2];
//...
alias fftwf_complex = float[2];
//...
alias fftwl_complex = real[2];
```

After making the corrections, we can compile our code with:

```bash
$ dmd callc_dstep.d fftw3.d -L-lfftw3 -L-lm && ./callc_dstep
```

## Summary

This article gives a good overview of the basics of calling C code from D using the native `extern (C)` interface and the `dstep` library. News of the possible new DMD compiler feature that will compile C code along with D allowing users to simply include C headers is great news, for further reducing friction calling C code which will be a boon to library writers and programmers alike.


