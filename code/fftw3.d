/*
 * Copyright (c) 2003, 2007-14 Matteo Frigo
 * Copyright (c) 2003, 2007-14 Massachusetts Institute of Technology
 *
 * The following statement of license applies *only* to this header file,
 * and *not* to the other files distributed with FFTW or derived therefrom:
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/***************************** NOTE TO USERS *********************************
 *
 *                 THIS IS A HEADER FILE, NOT A MANUAL
 *
 *    If you want to know how to use FFTW, please read the manual,
 *    online at http://www.fftw.org/doc/ and also included with FFTW.
 *    For a quick start, see the manual's tutorial section.
 *
 *   (Reading header files to learn how to use a library is a habit
 *    stemming from code lacking a proper manual.  Arguably, it's a
 *    *bad* habit in most cases, because header files can contain
 *    interfaces that are not part of the public, stable API.)
 *
 ****************************************************************************/

import core.stdc.stdio;

extern (C):

/* __cplusplus */

/* If <complex.h> is included, use the C99 complex type.  Otherwise
   define a type bit-compatible with C99 complex */

extern (D) string FFTW_CONCAT(T0, T1)(auto ref T0 prefix, auto ref T1 name)
{
    import std.conv : to;

    return to!string(prefix) ~ to!string(name);
}

extern (D) auto FFTW_MANGLE_DOUBLE(T)(auto ref T name)
{
    return FFTW_CONCAT(fftw_, name);
}

extern (D) auto FFTW_MANGLE_FLOAT(T)(auto ref T name)
{
    return FFTW_CONCAT(fftwf_, name);
}

extern (D) auto FFTW_MANGLE_LONG_DOUBLE(T)(auto ref T name)
{
    return FFTW_CONCAT(fftwl_, name);
}

extern (D) auto FFTW_MANGLE_QUAD(T)(auto ref T name)
{
    return FFTW_CONCAT(fftwq_, name);
}

/* IMPORTANT: for Windows compilers, you should add a line
        #define FFTW_DLL
   here and in kernel/ifftw.h if you are compiling/using FFTW as a
   DLL, in order to do the proper importing/exporting, or
   alternatively compile with -DFFTW_DLL or the equivalent
   command-line flag.  This is not necessary under MinGW/Cygwin, where
   libtool does the imports/exports automatically. */

/* annoying Windows syntax for shared-library declarations */
/* defined in api.h when compiling FFTW */

/* user is calling FFTW; import symbol */

/* specify calling convention (Windows only) */

enum fftw_r2r_kind_do_not_use_me
{
    FFTW_R2HC = 0,
    FFTW_HC2R = 1,
    FFTW_DHT = 2,
    FFTW_REDFT00 = 3,
    FFTW_REDFT01 = 4,
    FFTW_REDFT10 = 5,
    FFTW_REDFT11 = 6,
    FFTW_RODFT00 = 7,
    FFTW_RODFT01 = 8,
    FFTW_RODFT10 = 9,
    FFTW_RODFT11 = 10
}

struct fftw_iodim_do_not_use_me
{
    int n; /* dimension size */
    int is_; /* input stride */
    int os; /* output stride */
}

/* for ptrdiff_t */
struct fftw_iodim64_do_not_use_me
{
    ptrdiff_t n; /* dimension size */
    ptrdiff_t is_; /* input stride */
    ptrdiff_t os; /* output stride */
}

alias fftw_write_char_func_do_not_use_me = void function (char c, void*);
alias fftw_read_char_func_do_not_use_me = int function (void*);

/*
  huge second-order macro that defines prototypes for all API
  functions.  We expand this macro for each supported precision

  X: name-mangling macro
  R: real data type
  C: complex data type
*/

/* end of FFTW_DEFINE_API macro */

alias fftw_complex = double[2];
struct fftw_plan_s;
alias fftw_plan = fftw_plan_s*;
alias fftw_iodim = fftw_iodim_do_not_use_me;
alias fftw_iodim64 = fftw_iodim64_do_not_use_me;
alias fftw_r2r_kind = fftw_r2r_kind_do_not_use_me;
alias fftw_write_char_func = void function ();
alias fftw_read_char_func = int function ();
void fftw_execute (const fftw_plan p);
fftw_plan fftw_plan_dft (int rank, const(int)* n, fftw_complex* in_, fftw_complex* out_, int sign, uint flags);
fftw_plan fftw_plan_dft_1d (int n, fftw_complex* in_, fftw_complex* out_, int sign, uint flags);
fftw_plan fftw_plan_dft_2d (int n0, int n1, fftw_complex* in_, fftw_complex* out_, int sign, uint flags);
fftw_plan fftw_plan_dft_3d (int n0, int n1, int n2, fftw_complex* in_, fftw_complex* out_, int sign, uint flags);
fftw_plan fftw_plan_many_dft (int rank, const(int)* n, int howmany, fftw_complex* in_, const(int)* inembed, int istride, int idist, fftw_complex* out_, const(int)* onembed, int ostride, int odist, int sign, uint flags);
fftw_plan fftw_plan_guru_dft (int rank, const(fftw_iodim)* dims, int howmany_rank, const(fftw_iodim)* howmany_dims, fftw_complex* in_, fftw_complex* out_, int sign, uint flags);
fftw_plan fftw_plan_guru_split_dft (int rank, const(fftw_iodim)* dims, int howmany_rank, const(fftw_iodim)* howmany_dims, double* ri, double* ii, double* ro, double* io, uint flags);
fftw_plan fftw_plan_guru64_dft (int rank, const(fftw_iodim64)* dims, int howmany_rank, const(fftw_iodim64)* howmany_dims, fftw_complex* in_, fftw_complex* out_, int sign, uint flags);
fftw_plan fftw_plan_guru64_split_dft (int rank, const(fftw_iodim64)* dims, int howmany_rank, const(fftw_iodim64)* howmany_dims, double* ri, double* ii, double* ro, double* io, uint flags);
void fftw_execute_dft (const fftw_plan p, fftw_complex* in_, fftw_complex* out_);
void fftw_execute_split_dft (const fftw_plan p, double* ri, double* ii, double* ro, double* io);
fftw_plan fftw_plan_many_dft_r2c (int rank, const(int)* n, int howmany, double* in_, const(int)* inembed, int istride, int idist, fftw_complex* out_, const(int)* onembed, int ostride, int odist, uint flags);
fftw_plan fftw_plan_dft_r2c (int rank, const(int)* n, double* in_, fftw_complex* out_, uint flags);
fftw_plan fftw_plan_dft_r2c_1d (int n, double* in_, fftw_complex* out_, uint flags);
fftw_plan fftw_plan_dft_r2c_2d (int n0, int n1, double* in_, fftw_complex* out_, uint flags);
fftw_plan fftw_plan_dft_r2c_3d (int n0, int n1, int n2, double* in_, fftw_complex* out_, uint flags);
fftw_plan fftw_plan_many_dft_c2r (int rank, const(int)* n, int howmany, fftw_complex* in_, const(int)* inembed, int istride, int idist, double* out_, const(int)* onembed, int ostride, int odist, uint flags);
fftw_plan fftw_plan_dft_c2r (int rank, const(int)* n, fftw_complex* in_, double* out_, uint flags);
fftw_plan fftw_plan_dft_c2r_1d (int n, fftw_complex* in_, double* out_, uint flags);
fftw_plan fftw_plan_dft_c2r_2d (int n0, int n1, fftw_complex* in_, double* out_, uint flags);
fftw_plan fftw_plan_dft_c2r_3d (int n0, int n1, int n2, fftw_complex* in_, double* out_, uint flags);
fftw_plan fftw_plan_guru_dft_r2c (int rank, const(fftw_iodim)* dims, int howmany_rank, const(fftw_iodim)* howmany_dims, double* in_, fftw_complex* out_, uint flags);
fftw_plan fftw_plan_guru_dft_c2r (int rank, const(fftw_iodim)* dims, int howmany_rank, const(fftw_iodim)* howmany_dims, fftw_complex* in_, double* out_, uint flags);
fftw_plan fftw_plan_guru_split_dft_r2c (int rank, const(fftw_iodim)* dims, int howmany_rank, const(fftw_iodim)* howmany_dims, double* in_, double* ro, double* io, uint flags);
fftw_plan fftw_plan_guru_split_dft_c2r (int rank, const(fftw_iodim)* dims, int howmany_rank, const(fftw_iodim)* howmany_dims, double* ri, double* ii, double* out_, uint flags);
fftw_plan fftw_plan_guru64_dft_r2c (int rank, const(fftw_iodim64)* dims, int howmany_rank, const(fftw_iodim64)* howmany_dims, double* in_, fftw_complex* out_, uint flags);
fftw_plan fftw_plan_guru64_dft_c2r (int rank, const(fftw_iodim64)* dims, int howmany_rank, const(fftw_iodim64)* howmany_dims, fftw_complex* in_, double* out_, uint flags);
fftw_plan fftw_plan_guru64_split_dft_r2c (int rank, const(fftw_iodim64)* dims, int howmany_rank, const(fftw_iodim64)* howmany_dims, double* in_, double* ro, double* io, uint flags);
fftw_plan fftw_plan_guru64_split_dft_c2r (int rank, const(fftw_iodim64)* dims, int howmany_rank, const(fftw_iodim64)* howmany_dims, double* ri, double* ii, double* out_, uint flags);
void fftw_execute_dft_r2c (const fftw_plan p, double* in_, fftw_complex* out_);
void fftw_execute_dft_c2r (const fftw_plan p, fftw_complex* in_, double* out_);
void fftw_execute_split_dft_r2c (const fftw_plan p, double* in_, double* ro, double* io);
void fftw_execute_split_dft_c2r (const fftw_plan p, double* ri, double* ii, double* out_);
fftw_plan fftw_plan_many_r2r (int rank, const(int)* n, int howmany, double* in_, const(int)* inembed, int istride, int idist, double* out_, const(int)* onembed, int ostride, int odist, const(fftw_r2r_kind)* kind, uint flags);
fftw_plan fftw_plan_r2r (int rank, const(int)* n, double* in_, double* out_, const(fftw_r2r_kind)* kind, uint flags);
fftw_plan fftw_plan_r2r_1d (int n, double* in_, double* out_, fftw_r2r_kind kind, uint flags);
fftw_plan fftw_plan_r2r_2d (int n0, int n1, double* in_, double* out_, fftw_r2r_kind kind0, fftw_r2r_kind kind1, uint flags);
fftw_plan fftw_plan_r2r_3d (int n0, int n1, int n2, double* in_, double* out_, fftw_r2r_kind kind0, fftw_r2r_kind kind1, fftw_r2r_kind kind2, uint flags);
fftw_plan fftw_plan_guru_r2r (int rank, const(fftw_iodim)* dims, int howmany_rank, const(fftw_iodim)* howmany_dims, double* in_, double* out_, const(fftw_r2r_kind)* kind, uint flags);
fftw_plan fftw_plan_guru64_r2r (int rank, const(fftw_iodim64)* dims, int howmany_rank, const(fftw_iodim64)* howmany_dims, double* in_, double* out_, const(fftw_r2r_kind)* kind, uint flags);
void fftw_execute_r2r (const fftw_plan p, double* in_, double* out_);
void fftw_destroy_plan (fftw_plan p);
void fftw_forget_wisdom ();
void fftw_cleanup ();
void fftw_set_timelimit (double t);
void fftw_plan_with_nthreads (int nthreads);
int fftw_planner_nthreads ();
int fftw_init_threads ();
void fftw_cleanup_threads ();
void fftw_threads_set_callback (void function (void* function (char*) work, char* jobdata, size_t elsize, int njobs, void* data) parallel_loop, void* data);
void fftw_make_planner_thread_safe ();
int fftw_export_wisdom_to_filename (const(char)* filename);
void fftw_export_wisdom_to_file (FILE* output_file);
char* fftw_export_wisdom_to_string ();
void fftw_export_wisdom (fftw_write_char_func write_char, void* data);
int fftw_import_system_wisdom ();
int fftw_import_wisdom_from_filename (const(char)* filename);
int fftw_import_wisdom_from_file (FILE* input_file);
int fftw_import_wisdom_from_string (const(char)* input_string);
int fftw_import_wisdom (fftw_read_char_func read_char, void* data);
void fftw_fprint_plan (const fftw_plan p, FILE* output_file);
void fftw_print_plan (const fftw_plan p);
char* fftw_sprint_plan (const fftw_plan p);
void* fftw_malloc (size_t n);
double* fftw_alloc_real (size_t n);
fftw_complex* fftw_alloc_complex (size_t n);
void fftw_free (void* p);
void fftw_flops (const fftw_plan p, double* add, double* mul, double* fmas);
double fftw_estimate_cost (const fftw_plan p);
double fftw_cost (const fftw_plan p);
int fftw_alignment_of (double* p);
extern __gshared const(char)[] fftw_version;
extern __gshared const(char)[] fftw_cc;
extern __gshared const(char)[] fftw_codelet_optim;
alias fftwf_complex = float[2];
struct fftwf_plan_s;
alias fftwf_plan = fftwf_plan_s*;
alias fftwf_iodim = fftw_iodim_do_not_use_me;
alias fftwf_iodim64 = fftw_iodim64_do_not_use_me;
alias fftwf_r2r_kind = fftw_r2r_kind_do_not_use_me;
alias fftwf_write_char_func = void function ();
alias fftwf_read_char_func = int function ();
void fftwf_execute (const fftwf_plan p);
fftwf_plan fftwf_plan_dft (int rank, const(int)* n, fftwf_complex* in_, fftwf_complex* out_, int sign, uint flags);
fftwf_plan fftwf_plan_dft_1d (int n, fftwf_complex* in_, fftwf_complex* out_, int sign, uint flags);
fftwf_plan fftwf_plan_dft_2d (int n0, int n1, fftwf_complex* in_, fftwf_complex* out_, int sign, uint flags);
fftwf_plan fftwf_plan_dft_3d (int n0, int n1, int n2, fftwf_complex* in_, fftwf_complex* out_, int sign, uint flags);
fftwf_plan fftwf_plan_many_dft (int rank, const(int)* n, int howmany, fftwf_complex* in_, const(int)* inembed, int istride, int idist, fftwf_complex* out_, const(int)* onembed, int ostride, int odist, int sign, uint flags);
fftwf_plan fftwf_plan_guru_dft (int rank, const(fftwf_iodim)* dims, int howmany_rank, const(fftwf_iodim)* howmany_dims, fftwf_complex* in_, fftwf_complex* out_, int sign, uint flags);
fftwf_plan fftwf_plan_guru_split_dft (int rank, const(fftwf_iodim)* dims, int howmany_rank, const(fftwf_iodim)* howmany_dims, float* ri, float* ii, float* ro, float* io, uint flags);
fftwf_plan fftwf_plan_guru64_dft (int rank, const(fftwf_iodim64)* dims, int howmany_rank, const(fftwf_iodim64)* howmany_dims, fftwf_complex* in_, fftwf_complex* out_, int sign, uint flags);
fftwf_plan fftwf_plan_guru64_split_dft (int rank, const(fftwf_iodim64)* dims, int howmany_rank, const(fftwf_iodim64)* howmany_dims, float* ri, float* ii, float* ro, float* io, uint flags);
void fftwf_execute_dft (const fftwf_plan p, fftwf_complex* in_, fftwf_complex* out_);
void fftwf_execute_split_dft (const fftwf_plan p, float* ri, float* ii, float* ro, float* io);
fftwf_plan fftwf_plan_many_dft_r2c (int rank, const(int)* n, int howmany, float* in_, const(int)* inembed, int istride, int idist, fftwf_complex* out_, const(int)* onembed, int ostride, int odist, uint flags);
fftwf_plan fftwf_plan_dft_r2c (int rank, const(int)* n, float* in_, fftwf_complex* out_, uint flags);
fftwf_plan fftwf_plan_dft_r2c_1d (int n, float* in_, fftwf_complex* out_, uint flags);
fftwf_plan fftwf_plan_dft_r2c_2d (int n0, int n1, float* in_, fftwf_complex* out_, uint flags);
fftwf_plan fftwf_plan_dft_r2c_3d (int n0, int n1, int n2, float* in_, fftwf_complex* out_, uint flags);
fftwf_plan fftwf_plan_many_dft_c2r (int rank, const(int)* n, int howmany, fftwf_complex* in_, const(int)* inembed, int istride, int idist, float* out_, const(int)* onembed, int ostride, int odist, uint flags);
fftwf_plan fftwf_plan_dft_c2r (int rank, const(int)* n, fftwf_complex* in_, float* out_, uint flags);
fftwf_plan fftwf_plan_dft_c2r_1d (int n, fftwf_complex* in_, float* out_, uint flags);
fftwf_plan fftwf_plan_dft_c2r_2d (int n0, int n1, fftwf_complex* in_, float* out_, uint flags);
fftwf_plan fftwf_plan_dft_c2r_3d (int n0, int n1, int n2, fftwf_complex* in_, float* out_, uint flags);
fftwf_plan fftwf_plan_guru_dft_r2c (int rank, const(fftwf_iodim)* dims, int howmany_rank, const(fftwf_iodim)* howmany_dims, float* in_, fftwf_complex* out_, uint flags);
fftwf_plan fftwf_plan_guru_dft_c2r (int rank, const(fftwf_iodim)* dims, int howmany_rank, const(fftwf_iodim)* howmany_dims, fftwf_complex* in_, float* out_, uint flags);
fftwf_plan fftwf_plan_guru_split_dft_r2c (int rank, const(fftwf_iodim)* dims, int howmany_rank, const(fftwf_iodim)* howmany_dims, float* in_, float* ro, float* io, uint flags);
fftwf_plan fftwf_plan_guru_split_dft_c2r (int rank, const(fftwf_iodim)* dims, int howmany_rank, const(fftwf_iodim)* howmany_dims, float* ri, float* ii, float* out_, uint flags);
fftwf_plan fftwf_plan_guru64_dft_r2c (int rank, const(fftwf_iodim64)* dims, int howmany_rank, const(fftwf_iodim64)* howmany_dims, float* in_, fftwf_complex* out_, uint flags);
fftwf_plan fftwf_plan_guru64_dft_c2r (int rank, const(fftwf_iodim64)* dims, int howmany_rank, const(fftwf_iodim64)* howmany_dims, fftwf_complex* in_, float* out_, uint flags);
fftwf_plan fftwf_plan_guru64_split_dft_r2c (int rank, const(fftwf_iodim64)* dims, int howmany_rank, const(fftwf_iodim64)* howmany_dims, float* in_, float* ro, float* io, uint flags);
fftwf_plan fftwf_plan_guru64_split_dft_c2r (int rank, const(fftwf_iodim64)* dims, int howmany_rank, const(fftwf_iodim64)* howmany_dims, float* ri, float* ii, float* out_, uint flags);
void fftwf_execute_dft_r2c (const fftwf_plan p, float* in_, fftwf_complex* out_);
void fftwf_execute_dft_c2r (const fftwf_plan p, fftwf_complex* in_, float* out_);
void fftwf_execute_split_dft_r2c (const fftwf_plan p, float* in_, float* ro, float* io);
void fftwf_execute_split_dft_c2r (const fftwf_plan p, float* ri, float* ii, float* out_);
fftwf_plan fftwf_plan_many_r2r (int rank, const(int)* n, int howmany, float* in_, const(int)* inembed, int istride, int idist, float* out_, const(int)* onembed, int ostride, int odist, const(fftwf_r2r_kind)* kind, uint flags);
fftwf_plan fftwf_plan_r2r (int rank, const(int)* n, float* in_, float* out_, const(fftwf_r2r_kind)* kind, uint flags);
fftwf_plan fftwf_plan_r2r_1d (int n, float* in_, float* out_, fftwf_r2r_kind kind, uint flags);
fftwf_plan fftwf_plan_r2r_2d (int n0, int n1, float* in_, float* out_, fftwf_r2r_kind kind0, fftwf_r2r_kind kind1, uint flags);
fftwf_plan fftwf_plan_r2r_3d (int n0, int n1, int n2, float* in_, float* out_, fftwf_r2r_kind kind0, fftwf_r2r_kind kind1, fftwf_r2r_kind kind2, uint flags);
fftwf_plan fftwf_plan_guru_r2r (int rank, const(fftwf_iodim)* dims, int howmany_rank, const(fftwf_iodim)* howmany_dims, float* in_, float* out_, const(fftwf_r2r_kind)* kind, uint flags);
fftwf_plan fftwf_plan_guru64_r2r (int rank, const(fftwf_iodim64)* dims, int howmany_rank, const(fftwf_iodim64)* howmany_dims, float* in_, float* out_, const(fftwf_r2r_kind)* kind, uint flags);
void fftwf_execute_r2r (const fftwf_plan p, float* in_, float* out_);
void fftwf_destroy_plan (fftwf_plan p);
void fftwf_forget_wisdom ();
void fftwf_cleanup ();
void fftwf_set_timelimit (double t);
void fftwf_plan_with_nthreads (int nthreads);
int fftwf_planner_nthreads ();
int fftwf_init_threads ();
void fftwf_cleanup_threads ();
void fftwf_threads_set_callback (void function (void* function (char*) work, char* jobdata, size_t elsize, int njobs, void* data) parallel_loop, void* data);
void fftwf_make_planner_thread_safe ();
int fftwf_export_wisdom_to_filename (const(char)* filename);
void fftwf_export_wisdom_to_file (FILE* output_file);
char* fftwf_export_wisdom_to_string ();
void fftwf_export_wisdom (fftwf_write_char_func write_char, void* data);
int fftwf_import_system_wisdom ();
int fftwf_import_wisdom_from_filename (const(char)* filename);
int fftwf_import_wisdom_from_file (FILE* input_file);
int fftwf_import_wisdom_from_string (const(char)* input_string);
int fftwf_import_wisdom (fftwf_read_char_func read_char, void* data);
void fftwf_fprint_plan (const fftwf_plan p, FILE* output_file);
void fftwf_print_plan (const fftwf_plan p);
char* fftwf_sprint_plan (const fftwf_plan p);
void* fftwf_malloc (size_t n);
float* fftwf_alloc_real (size_t n);
fftwf_complex* fftwf_alloc_complex (size_t n);
void fftwf_free (void* p);
void fftwf_flops (const fftwf_plan p, double* add, double* mul, double* fmas);
double fftwf_estimate_cost (const fftwf_plan p);
double fftwf_cost (const fftwf_plan p);
int fftwf_alignment_of (float* p);
extern __gshared const(char)[] fftwf_version;
extern __gshared const(char)[] fftwf_cc;
extern __gshared const(char)[] fftwf_codelet_optim;
alias fftwl_complex = real[2];
struct fftwl_plan_s;
alias fftwl_plan = fftwl_plan_s*;
alias fftwl_iodim = fftw_iodim_do_not_use_me;
alias fftwl_iodim64 = fftw_iodim64_do_not_use_me;
alias fftwl_r2r_kind = fftw_r2r_kind_do_not_use_me;
alias fftwl_write_char_func = void function ();
alias fftwl_read_char_func = int function ();
void fftwl_execute (const fftwl_plan p);
fftwl_plan fftwl_plan_dft (int rank, const(int)* n, fftwl_complex* in_, fftwl_complex* out_, int sign, uint flags);
fftwl_plan fftwl_plan_dft_1d (int n, fftwl_complex* in_, fftwl_complex* out_, int sign, uint flags);
fftwl_plan fftwl_plan_dft_2d (int n0, int n1, fftwl_complex* in_, fftwl_complex* out_, int sign, uint flags);
fftwl_plan fftwl_plan_dft_3d (int n0, int n1, int n2, fftwl_complex* in_, fftwl_complex* out_, int sign, uint flags);
fftwl_plan fftwl_plan_many_dft (int rank, const(int)* n, int howmany, fftwl_complex* in_, const(int)* inembed, int istride, int idist, fftwl_complex* out_, const(int)* onembed, int ostride, int odist, int sign, uint flags);
fftwl_plan fftwl_plan_guru_dft (int rank, const(fftwl_iodim)* dims, int howmany_rank, const(fftwl_iodim)* howmany_dims, fftwl_complex* in_, fftwl_complex* out_, int sign, uint flags);
fftwl_plan fftwl_plan_guru_split_dft (int rank, const(fftwl_iodim)* dims, int howmany_rank, const(fftwl_iodim)* howmany_dims, real* ri, real* ii, real* ro, real* io, uint flags);
fftwl_plan fftwl_plan_guru64_dft (int rank, const(fftwl_iodim64)* dims, int howmany_rank, const(fftwl_iodim64)* howmany_dims, fftwl_complex* in_, fftwl_complex* out_, int sign, uint flags);
fftwl_plan fftwl_plan_guru64_split_dft (int rank, const(fftwl_iodim64)* dims, int howmany_rank, const(fftwl_iodim64)* howmany_dims, real* ri, real* ii, real* ro, real* io, uint flags);
void fftwl_execute_dft (const fftwl_plan p, fftwl_complex* in_, fftwl_complex* out_);
void fftwl_execute_split_dft (const fftwl_plan p, real* ri, real* ii, real* ro, real* io);
fftwl_plan fftwl_plan_many_dft_r2c (int rank, const(int)* n, int howmany, real* in_, const(int)* inembed, int istride, int idist, fftwl_complex* out_, const(int)* onembed, int ostride, int odist, uint flags);
fftwl_plan fftwl_plan_dft_r2c (int rank, const(int)* n, real* in_, fftwl_complex* out_, uint flags);
fftwl_plan fftwl_plan_dft_r2c_1d (int n, real* in_, fftwl_complex* out_, uint flags);
fftwl_plan fftwl_plan_dft_r2c_2d (int n0, int n1, real* in_, fftwl_complex* out_, uint flags);
fftwl_plan fftwl_plan_dft_r2c_3d (int n0, int n1, int n2, real* in_, fftwl_complex* out_, uint flags);
fftwl_plan fftwl_plan_many_dft_c2r (int rank, const(int)* n, int howmany, fftwl_complex* in_, const(int)* inembed, int istride, int idist, real* out_, const(int)* onembed, int ostride, int odist, uint flags);
fftwl_plan fftwl_plan_dft_c2r (int rank, const(int)* n, fftwl_complex* in_, real* out_, uint flags);
fftwl_plan fftwl_plan_dft_c2r_1d (int n, fftwl_complex* in_, real* out_, uint flags);
fftwl_plan fftwl_plan_dft_c2r_2d (int n0, int n1, fftwl_complex* in_, real* out_, uint flags);
fftwl_plan fftwl_plan_dft_c2r_3d (int n0, int n1, int n2, fftwl_complex* in_, real* out_, uint flags);
fftwl_plan fftwl_plan_guru_dft_r2c (int rank, const(fftwl_iodim)* dims, int howmany_rank, const(fftwl_iodim)* howmany_dims, real* in_, fftwl_complex* out_, uint flags);
fftwl_plan fftwl_plan_guru_dft_c2r (int rank, const(fftwl_iodim)* dims, int howmany_rank, const(fftwl_iodim)* howmany_dims, fftwl_complex* in_, real* out_, uint flags);
fftwl_plan fftwl_plan_guru_split_dft_r2c (int rank, const(fftwl_iodim)* dims, int howmany_rank, const(fftwl_iodim)* howmany_dims, real* in_, real* ro, real* io, uint flags);
fftwl_plan fftwl_plan_guru_split_dft_c2r (int rank, const(fftwl_iodim)* dims, int howmany_rank, const(fftwl_iodim)* howmany_dims, real* ri, real* ii, real* out_, uint flags);
fftwl_plan fftwl_plan_guru64_dft_r2c (int rank, const(fftwl_iodim64)* dims, int howmany_rank, const(fftwl_iodim64)* howmany_dims, real* in_, fftwl_complex* out_, uint flags);
fftwl_plan fftwl_plan_guru64_dft_c2r (int rank, const(fftwl_iodim64)* dims, int howmany_rank, const(fftwl_iodim64)* howmany_dims, fftwl_complex* in_, real* out_, uint flags);
fftwl_plan fftwl_plan_guru64_split_dft_r2c (int rank, const(fftwl_iodim64)* dims, int howmany_rank, const(fftwl_iodim64)* howmany_dims, real* in_, real* ro, real* io, uint flags);
fftwl_plan fftwl_plan_guru64_split_dft_c2r (int rank, const(fftwl_iodim64)* dims, int howmany_rank, const(fftwl_iodim64)* howmany_dims, real* ri, real* ii, real* out_, uint flags);
void fftwl_execute_dft_r2c (const fftwl_plan p, real* in_, fftwl_complex* out_);
void fftwl_execute_dft_c2r (const fftwl_plan p, fftwl_complex* in_, real* out_);
void fftwl_execute_split_dft_r2c (const fftwl_plan p, real* in_, real* ro, real* io);
void fftwl_execute_split_dft_c2r (const fftwl_plan p, real* ri, real* ii, real* out_);
fftwl_plan fftwl_plan_many_r2r (int rank, const(int)* n, int howmany, real* in_, const(int)* inembed, int istride, int idist, real* out_, const(int)* onembed, int ostride, int odist, const(fftwl_r2r_kind)* kind, uint flags);
fftwl_plan fftwl_plan_r2r (int rank, const(int)* n, real* in_, real* out_, const(fftwl_r2r_kind)* kind, uint flags);
fftwl_plan fftwl_plan_r2r_1d (int n, real* in_, real* out_, fftwl_r2r_kind kind, uint flags);
fftwl_plan fftwl_plan_r2r_2d (int n0, int n1, real* in_, real* out_, fftwl_r2r_kind kind0, fftwl_r2r_kind kind1, uint flags);
fftwl_plan fftwl_plan_r2r_3d (int n0, int n1, int n2, real* in_, real* out_, fftwl_r2r_kind kind0, fftwl_r2r_kind kind1, fftwl_r2r_kind kind2, uint flags);
fftwl_plan fftwl_plan_guru_r2r (int rank, const(fftwl_iodim)* dims, int howmany_rank, const(fftwl_iodim)* howmany_dims, real* in_, real* out_, const(fftwl_r2r_kind)* kind, uint flags);
fftwl_plan fftwl_plan_guru64_r2r (int rank, const(fftwl_iodim64)* dims, int howmany_rank, const(fftwl_iodim64)* howmany_dims, real* in_, real* out_, const(fftwl_r2r_kind)* kind, uint flags);
void fftwl_execute_r2r (const fftwl_plan p, real* in_, real* out_);
void fftwl_destroy_plan (fftwl_plan p);
void fftwl_forget_wisdom ();
void fftwl_cleanup ();
void fftwl_set_timelimit (double t);
void fftwl_plan_with_nthreads (int nthreads);
int fftwl_planner_nthreads ();
int fftwl_init_threads ();
void fftwl_cleanup_threads ();
void fftwl_threads_set_callback (void function (void* function (char*) work, char* jobdata, size_t elsize, int njobs, void* data) parallel_loop, void* data);
void fftwl_make_planner_thread_safe ();
int fftwl_export_wisdom_to_filename (const(char)* filename);
void fftwl_export_wisdom_to_file (FILE* output_file);
char* fftwl_export_wisdom_to_string ();
void fftwl_export_wisdom (fftwl_write_char_func write_char, void* data);
int fftwl_import_system_wisdom ();
int fftwl_import_wisdom_from_filename (const(char)* filename);
int fftwl_import_wisdom_from_file (FILE* input_file);
int fftwl_import_wisdom_from_string (const(char)* input_string);
int fftwl_import_wisdom (fftwl_read_char_func read_char, void* data);
void fftwl_fprint_plan (const fftwl_plan p, FILE* output_file);
void fftwl_print_plan (const fftwl_plan p);
char* fftwl_sprint_plan (const fftwl_plan p);
void* fftwl_malloc (size_t n);
real* fftwl_alloc_real (size_t n);
fftwl_complex* fftwl_alloc_complex (size_t n);
void fftwl_free (void* p);
void fftwl_flops (const fftwl_plan p, double* add, double* mul, double* fmas);
double fftwl_estimate_cost (const fftwl_plan p);
double fftwl_cost (const fftwl_plan p);
int fftwl_alignment_of (real* p);
extern __gshared const(char)[] fftwl_version;
extern __gshared const(char)[] fftwl_cc;
extern __gshared const(char)[] fftwl_codelet_optim;

/* __float128 (quad precision) is a gcc extension on i386, x86_64, and ia64
   for gcc >= 4.6 (compiled in FFTW with --enable-quad-precision) */

/* note: __float128 is a typedef, which is not supported with the _Complex
         keyword in gcc, so instead we use this ugly __attribute__ version.
         However, we can't simply pass the __attribute__ version to
         FFTW_DEFINE_API because the __attribute__ confuses gcc in pointer
         types.  Hence redefining FFTW_DEFINE_COMPLEX.  Ugh. */

enum FFTW_FORWARD = -1;
enum FFTW_BACKWARD = +1;

enum FFTW_NO_TIMELIMIT = -1.0;

/* documented flags */
enum FFTW_MEASURE = 0U;
enum FFTW_DESTROY_INPUT = 1U << 0;
enum FFTW_UNALIGNED = 1U << 1;
enum FFTW_CONSERVE_MEMORY = 1U << 2;
enum FFTW_EXHAUSTIVE = 1U << 3; /* NO_EXHAUSTIVE is default */
enum FFTW_PRESERVE_INPUT = 1U << 4; /* cancels FFTW_DESTROY_INPUT */
enum FFTW_PATIENT = 1U << 5; /* IMPATIENT is default */
enum FFTW_ESTIMATE = 1U << 6;
enum FFTW_WISDOM_ONLY = 1U << 21;

/* undocumented beyond-guru flags */
enum FFTW_ESTIMATE_PATIENT = 1U << 7;
enum FFTW_BELIEVE_PCOST = 1U << 8;
enum FFTW_NO_DFT_R2HC = 1U << 9;
enum FFTW_NO_NONTHREADED = 1U << 10;
enum FFTW_NO_BUFFERING = 1U << 11;
enum FFTW_NO_INDIRECT_OP = 1U << 12;
enum FFTW_ALLOW_LARGE_GENERIC = 1U << 13; /* NO_LARGE_GENERIC is default */
enum FFTW_NO_RANK_SPLITS = 1U << 14;
enum FFTW_NO_VRANK_SPLITS = 1U << 15;
enum FFTW_NO_VRECURSE = 1U << 16;
enum FFTW_NO_SIMD = 1U << 17;
enum FFTW_NO_SLOW = 1U << 18;
enum FFTW_NO_FIXED_RADIX_LARGE_N = 1U << 19;
enum FFTW_ALLOW_PRUNING = 1U << 20;

/* extern "C" */
/* __cplusplus */

/* FFTW3_H */
