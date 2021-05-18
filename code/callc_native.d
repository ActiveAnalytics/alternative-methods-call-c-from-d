import std.stdio: writeln;
import std.traits: isFloatingPoint, isNumeric;
import std.conv: to;

extern (C)
{
  enum FFTW_ESTIMATE = 1U << 6;
  enum FFTW_FORWARD = -1;
  enum FFTW_BACKWARD = +1;
  alias fftw_complex = double[2];
  struct fftw_plan_s;
  alias fftw_plan = fftw_plan_s*;
  fftw_plan fftw_plan_dft_1d(int n, fftw_complex* in_, fftw_complex* out_, int sign, uint flags);
  void fftw_execute(const fftw_plan p);
  void fftw_destroy_plan(fftw_plan p);
}


/**
  To compile:
  dmd callc_native.d -L-lfftw3 -L-lm && ./callc_native
*/

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
  string toString()
  {
    return to!string(re) ~ " + " ~ to!string(im) ~ "im";
  }
  string repr()
  {
    return "Complex!(" ~ T.stringof ~ ")(" ~ to!(string)(re) ~ ", " ~ to!(string)(im) ~ ")";
  }
  /*
    In your article make sure you write a mini section clarifying 
    casting in D using this as an example.
  */
  T[] opCast(U: T[])()
  {
    return data;
  }
  typeof(this) opCast(U: Complex!(T))(T[] x)
  {
    return Complex!(T)(x);
  }
  Complex!T opBinary(string op, N)(N x)
  if(((op == "*") || (op == "/")) && isNumeric!N)
  {
    auto num = Complex!T(data.dup);
    mixin("num.data[0] " ~ op ~ "= cast(T)x;");
    mixin("num.data[1] " ~ op ~ "= cast(T)x;");
    return num;
  }
  Complex!T opBinary(string op, N)(N x)
  if(((op == "+") || (op == "-")) && isNumeric!N)
  {
    auto num = Complex!T(data.dup);
    // For addition and subtraction real part only
    mixin("num.data[0] " ~ op ~ "= cast(T)x;");
    return num;
  }
  ref Complex!T opOpAssign(string op, N)(N x)
  if(((op == "+") || (op == "-")) && isNumeric!N)
  {
    // For addition and subtraction real part only
    mixin("data[0] " ~ op ~ "= cast(T)x;");
    return this;
  }
  ref Complex!T opOpAssign(string op, N)(N x)
  if(((op == "*") || (op == "/")) && isNumeric!N)
  {
    mixin("data[0] " ~ op ~ "= cast(T)x;");
    mixin("data[1] " ~ op ~ "= cast(T)x;");
    return this;
  }
  bool opEquals(Complex!T rhs) const
  {
    return (data[0] == rhs.data[0]) && (data[1] == rhs.data[1]);
  }
}

auto complex(T)(auto ref T _re, auto ref T _im)
{
  return Complex!(T)(_re, _im);
}
auto complex(T)(T[] x)
{
  return Complex!(T)(x);
}

/**
  Creates a complex number array fftw_complex*
*/
fftw_complex* randomFFTWComplexArray(ulong n)
{
  import std.random: Mt19937_64, uniform01, unpredictableSeed;
  auto rnd = Mt19937_64(unpredictableSeed);
  auto arr = new fftw_complex[n];
  foreach(ref el; arr)
  {
    el = [rnd.uniform01!double, rnd.uniform01!double];
  }
  return arr.ptr;
}

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


auto allocateFFTWArray(ulong n)
{
  auto arr = new fftw_complex[n];
  return arr.ptr;
}

auto toComplexArray(fftw_complex* arr, ulong n)
{
  return (cast(Complex!double*)cast(void*)arr)[0..n];
}
auto toFFTWArray(Complex!double[] arr)
{
  return cast(fftw_complex*)cast(void*)arr;
}

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


void main()
{
  auto complex_sample = randomComplexArray(100);
  writeln("Input: \n\n", complex_sample, "\n");
  auto test_fft = fft(complex_sample);
  writeln("\n\nFrom fft function: ", test_fft);
  auto test_iff = ifft(test_fft);
  writeln("\n\nFrom ifft function: ", test_iff);
}


