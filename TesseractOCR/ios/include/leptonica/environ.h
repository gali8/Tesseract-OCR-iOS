/*====================================================================*
 -  Copyright (C) 2001 Leptonica.  All rights reserved.
 -
 -  Redistribution and use in source and binary forms, with or without
 -  modification, are permitted provided that the following conditions
 -  are met:
 -  1. Redistributions of source code must retain the above copyright
 -     notice, this list of conditions and the following disclaimer.
 -  2. Redistributions in binary form must reproduce the above
 -     copyright notice, this list of conditions and the following
 -     disclaimer in the documentation and/or other materials
 -     provided with the distribution.
 -
 -  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 -  ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 -  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 -  A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL ANY
 -  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 -  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 -  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 -  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 -  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 -  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 -  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *====================================================================*/

#ifndef  LEPTONICA_ENVIRON_H
#define  LEPTONICA_ENVIRON_H

/*------------------------------------------------------------------------*
 *  Defines and includes differ for Unix and Windows.  Also for Windows,  *
 *  differentiate between conditionals based on platform and compiler.    *
 *      For platforms:                                                    *
 *          _WIN32       =>     Windows, 32- or 64-bit                    *
 *          _WIN64       =>     Windows, 64-bit only                      *
 *          __CYGWIN__   =>     Cygwin                                    *
 *      For compilers:                                                    *
 *          __GNUC__     =>     gcc                                       *
 *          _MSC_VER     =>     msvc                                      *
 *------------------------------------------------------------------------*/

/* MS VC++ does not provide stdint.h, so define the missing types here */


#ifndef _MSC_VER
#include <stdint.h>

#else
/* Note that _WIN32 is defined for both 32 and 64 bit applications,
   whereas _WIN64 is defined only for the latter */

#ifdef _WIN64
typedef __int64 intptr_t;
typedef unsigned __int64 uintptr_t;
#else
typedef int intptr_t;
typedef unsigned int uintptr_t;
#endif

/* VC++6 doesn't seem to have powf, expf. */
#if (_MSC_VER < 1400)
#define powf(x, y) (float)pow((double)(x), (double)(y))
#define expf(x) (float)exp((double)(x))
#endif

#endif /* _MSC_VER */

/* Windows specifics */
#ifdef _WIN32
  /* DLL EXPORTS and IMPORTS */
  #if defined(LIBLEPT_EXPORTS)
    #define LEPT_DLL __declspec(dllexport)
  #elif defined(LIBLEPT_IMPORTS)
    #define LEPT_DLL __declspec(dllimport)
  #else
    #define LEPT_DLL
  #endif
#else  /* non-Windows specifics */
  #include <stdint.h>
  #define LEPT_DLL
#endif  /* _WIN32 */

typedef intptr_t l_intptr_t;
typedef uintptr_t l_uintptr_t;


/*--------------------------------------------------------------------*
 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*
 *                          USER CONFIGURABLE                         *
 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*
 *               Environment variables with I/O libraries             *
 *               Manual Configuration Only: NOT AUTO_CONF             *
 *--------------------------------------------------------------------*/
/*
 *  Leptonica provides interfaces to link to several external image
 *  I/O libraries, plus zlib.  Setting any of these to 0 here causes
 *  non-functioning stubs to be linked.
 */
#if !defined(HAVE_CONFIG_H) && !defined(ANDROID_BUILD) && !defined(OS_IOS)

  #if !defined(HAVE_LIBJPEG)
  #define  HAVE_LIBJPEG       1
  #endif
  #if !defined(HAVE_LIBTIFF)
  #define  HAVE_LIBTIFF       1
  #endif
  #if !defined(HAVE_LIBPNG)
  #define  HAVE_LIBPNG        1
  #endif
  #if !defined(HAVE_LIBZ)
  #define  HAVE_LIBZ          1
  #endif
  #if !defined(HAVE_LIBGIF)
  #define  HAVE_LIBGIF        0
  #endif
  #if !defined(HAVE_LIBUNGIF)
  #define  HAVE_LIBUNGIF      0
  #endif
  #if !defined(HAVE_LIBWEBP)
  #define  HAVE_LIBWEBP       0
  #endif
  #if !defined(HAVE_LIBJP2K)
  #define  HAVE_LIBJP2K       0
  #endif

  /*-----------------------------------------------------------------------*
   * Leptonica supports OpenJPEG 2.0+.  If you have a version of openjpeg  *
   * (HAVE_LIBJP2K == 1) that is >= 2.0, set the path to the openjpeg.h    *
   * header in angle brackets here.                                        *
   *-----------------------------------------------------------------------*/
  #define  LIBJP2K_HEADER   <openjpeg-2.3/openjpeg.h>

#endif  /* ! HAVE_CONFIG_H etc. */

/*--------------------------------------------------------------------*
 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*
 *                          USER CONFIGURABLE                         *
 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*
 *     Environ variables for image I/O without external libraries     *
 *--------------------------------------------------------------------*/
/*
 *  Leptonica supplies I/O support without using external libraries for:
 *     * image read/write for bmp, pnm
 *     * header read for jp2k
 *     * image wrapping write for pdf and ps.
 *  Setting any of these to 0 causes non-functioning stubs to be linked.
 */
#define  USE_BMPIO        1
#define  USE_PNMIO        1
#define  USE_JP2KHEADER   1
#define  USE_PDFIO        1
#define  USE_PSIO         1


/*-------------------------------------------------------------------------*
 * On linux systems, you can do I/O between Pix and memory.  Specifically,
 * you can compress (write compressed data to memory from a Pix) and
 * uncompress (read from compressed data in memory to a Pix).
 * For jpeg, png, jp2k, gif, pnm and bmp, these use the non-posix GNU
 * functions fmemopen() and open_memstream().  These functions are not
 * available on other systems.
 * To use these functions in linux, you must define HAVE_FMEMOPEN to 1.
 * To use them on MacOS, which does not support these functions, set it to 0.
 *-------------------------------------------------------------------------*/
#if !defined(HAVE_CONFIG_H) && !defined(ANDROID_BUILD) && !defined(OS_IOS) && \
    !defined(_WIN32)
#define  HAVE_FMEMOPEN    1
#endif  /* ! HAVE_CONFIG_H etc. */

/*-------------------------------------------------------------------------*
 * fstatat() is defined by POSIX, but some systems do not support it.      *
 * One example is older macOS systems (pre-10.10).                         *
 * Play it safe and set the default value to 0.                            *
 *-------------------------------------------------------------------------*/
#if !defined(HAVE_CONFIG_H)
#define  HAVE_FSTATAT     0
#endif /* ! HAVE_CONFIG_H */

/*--------------------------------------------------------------------*
 * It is desirable on Windows to have all temp files written to the same
 * subdirectory of the Windows <Temp> directory, because files under <Temp>
 * persist after reboot, and the regression tests write a lot of files.
 * We write all test files to /tmp/lept or subdirectories of /tmp/lept.
 * Windows temp files are specified as in unix, but have the translation
 *        /tmp/lept/xxx  -->   <Temp>/lept/xxx
 *--------------------------------------------------------------------*/


/*--------------------------------------------------------------------*
 *                          Built-in types                            *
 *--------------------------------------------------------------------*/
typedef int                     l_ok;    /*!< return type 0 if OK, 1 on error */
typedef signed char             l_int8;     /*!< signed 8-bit value */
typedef unsigned char           l_uint8;    /*!< unsigned 8-bit value */
typedef short                   l_int16;    /*!< signed 16-bit value */
typedef unsigned short          l_uint16;   /*!< unsigned 16-bit value */
typedef int                     l_int32;    /*!< signed 32-bit value */
typedef unsigned int            l_uint32;   /*!< unsigned 32-bit value */
typedef float                   l_float32;  /*!< 32-bit floating point value */
typedef double                  l_float64;  /*!< 64-bit floating point value */
#ifdef COMPILER_MSVC
typedef __int64                 l_int64;    /*!< signed 64-bit value */
typedef unsigned __int64        l_uint64;   /*!< unsigned 64-bit value */
#else
typedef long long               l_int64;    /*!< signed 64-bit value */
typedef unsigned long long      l_uint64;   /*!< unsigned 64-bit value */
#endif  /* COMPILER_MSVC */


/*-------------------------------------------------------------------------*
 * For security, the library is distributed in a configuration that does   *
 * not permit (1) forking with 'system', which is used for displaying      *
 * images and generating gnuplots, and (2) writing files with specified    *
 * compiled-in file names.  All such writes are with functions such as     *
 * pixWriteDebug() where the "Debug" is appended to the usual name.        *
 * Whether the "Debug" version defaults to the standard version or is a    *
 * no-op depends on the value of this global variable.  The default value  *
 * of LeptDebugOK is 0, and it is set in writefile.c.  This value can be   *
 * over-ridden, for development and debugging, by setLeptDebugOK().        *
 *-------------------------------------------------------------------------*/
LEPT_DLL extern l_int32  LeptDebugOK;  /* default is 0 */


/*------------------------------------------------------------------------*
 *                            Standard macros                             *
 *------------------------------------------------------------------------*/
#ifndef L_MIN
/*! Minimum of %x and %y */
#define L_MIN(x,y)   (((x) < (y)) ? (x) : (y))
#endif

#ifndef L_MAX
/*! Maximum of %x and %y */
#define L_MAX(x,y)   (((x) > (y)) ? (x) : (y))
#endif

#ifndef L_ABS
/*! Absolute value of %x */
#define L_ABS(x)     (((x) < 0) ? (-1 * (x)) : (x))
#endif

#ifndef L_SIGN
/*! Sign of %x */
#define L_SIGN(x)    (((x) < 0) ? -1 : 1)
#endif

#ifndef UNDEF
/*! Undefined value */
#define UNDEF        -1
#endif

#ifndef NULL
/*! NULL value */
#define NULL          0
#endif

#ifndef TRUE
/*! True value */
#define TRUE          1
#endif

#ifndef FALSE
/*! False value */
#define FALSE         0
#endif


/*--------------------------------------------------------------------*
 *            Environment variables for endian dependence             *
 *--------------------------------------------------------------------*/
/*
 *  To control conditional compilation, one of two variables
 *
 *       L_LITTLE_ENDIAN  (e.g., for Intel X86)
 *       L_BIG_ENDIAN     (e.g., for Sun SPARC, Mac Power PC)
 *
 *  is defined when the GCC compiler is invoked.
 *  All code should compile properly for both hardware architectures.
 */


/*------------------------------------------------------------------------*
 *                    Simple search state variables                       *
 *------------------------------------------------------------------------*/
/*! Simple search state variables */
enum {
    L_NOT_FOUND = 0,
    L_FOUND = 1
};


/*------------------------------------------------------------------------*
 *                     Path separator conversion                          *
 *------------------------------------------------------------------------*/
/*! Path separator conversion */
enum {
    UNIX_PATH_SEPCHAR = 0,
    WIN_PATH_SEPCHAR = 1
};


/*------------------------------------------------------------------------*
 *                          Timing structs                                *
 *------------------------------------------------------------------------*/
typedef void *L_TIMER;

/*! Timing struct */
struct L_WallTimer {
    l_int32  start_sec;
    l_int32  start_usec;
    l_int32  stop_sec;
    l_int32  stop_usec;
};
typedef struct L_WallTimer  L_WALLTIMER;


/*------------------------------------------------------------------------*
 *                      Standard memory allocation                        *
 *                                                                        *
 *  These specify the memory management functions that are used           *
 *  on all heap data except for Pix.  Memory management for Pix           *
 *  also defaults to malloc and free.  See pix1.c for details.            *
 *------------------------------------------------------------------------*/
#define LEPT_MALLOC(blocksize)           malloc(blocksize)
#define LEPT_CALLOC(numelem, elemsize)   calloc(numelem, elemsize)
#define LEPT_REALLOC(ptr, blocksize)     realloc(ptr, blocksize)
#define LEPT_FREE(ptr)                   free(ptr)


/*------------------------------------------------------------------------*
 *         Control printing of error, warning, and info messages          *
 *                                                                        *
 *  To omit all messages to stderr, simply define NO_CONSOLE_IO on the    *
 *  command line.  For finer grained control, we have a mechanism         *
 *  based on the message severity level.  The following assumes that      *
 *  NO_CONSOLE_IO is not defined.                                         *
 *                                                                        *
 *  Messages are printed if the message severity is greater than or equal *
 *  to the current severity threshold.  The current severity threshold    *
 *  is the greater of the compile-time severity, which is the minimum     *
 *  severity that can be reported, and the run-time severity, which is    *
 *  the severity threshold at the moment.                                 *
 *                                                                        *
 *  The compile-time threshold determines which messages are compiled     *
 *  into the library for potential printing.  Messages below the          *
 *  compile-time threshold are omitted and can never be printed.  The     *
 *  default compile-time threshold is L_SEVERITY_INFO, but this may be    *
 *  overridden by defining MINIMUM_SEVERITY to the desired enumeration    *
 *  identifier on the compiler command line.  Defining NO_CONSOLE_IO on   *
 *  the command line is the same as setting MINIMUM_SEVERITY to           *
 *  L_SEVERITY_NONE.                                                      *
 *                                                                        *
 *  The run-time threshold determines which messages are printed during   *
 *  library execution.  It defaults to the compile-time threshold but     *
 *  may be changed either statically by defining DEFAULT_SEVERITY to      *
 *  the desired enumeration identifier on the compiler command line, or   *
 *  dynamically by calling setMsgSeverity() to specify a new threshold.   *
 *  The run-time threshold may also be set from the value of the          *
 *  environment variable LEPT_MSG_SEVERITY by calling setMsgSeverity()   *
 *  and specifying L_SEVERITY_EXTERNAL.                                   *
 *                                                                        *
 *  In effect, the compile-time threshold setting says, "Generate code    *
 *  to permit messages of equal or greater severity than this to be       *
 *  printed, if desired," whereas the run-time threshold setting says,    *
 *  "Print messages that have an equal or greater severity than this."    *
 *------------------------------------------------------------------------*/

/*! Control printing of error, warning and info messages */
enum {
    L_SEVERITY_EXTERNAL = 0,   /* Get the severity from the environment   */
    L_SEVERITY_ALL      = 1,   /* Lowest severity: print all messages     */
    L_SEVERITY_DEBUG    = 2,   /* Print debugging and higher messages     */
    L_SEVERITY_INFO     = 3,   /* Print informational and higher messages */
    L_SEVERITY_WARNING  = 4,   /* Print warning and higher messages       */
    L_SEVERITY_ERROR    = 5,   /* Print error and higher messages         */
    L_SEVERITY_NONE     = 6    /* Highest severity: print no messages     */
};

/*  No message less than the compile-time threshold will ever be
 *  reported, regardless of the current run-time threshold.  This allows
 *  selection of the set of messages to include in the library.  For
 *  example, setting the threshold to L_SEVERITY_WARNING eliminates all
 *  informational messages from the library.  With that setting, both
 *  warning and error messages would be printed unless setMsgSeverity()
 *  was called, or DEFAULT_SEVERITY was redefined, to set the run-time
 *  severity to L_SEVERITY_ERROR.  In that case, only error messages
 *  would be printed.
 *
 *  This mechanism makes the library smaller and faster, by eliminating
 *  undesired message reporting and the associated run-time overhead for
 *  message threshold checking, because code for messages whose severity
 *  is lower than MINIMUM_SEVERITY won't be generated.
 *
 *  A production library might typically permit ERROR messages to be
 *  generated, and a development library might permit DEBUG and higher.
 *  The actual messages printed (as opposed to generated) would depend
 *  on the current run-time severity threshold.
 *
 *  This is a complex mechanism and a few examples may help.
 *  (1) No output permitted under any circumstances.
 *      Use:  -DNO_CONSOLE_IO  or  -DMINIMUM_SEVERITY=6
 *  (2) Suppose you want to only allow error messages, and you don't
 *      want to permit info or warning messages at runtime.
 *      Use:  -DMINIMUM_SEVERITY=5
 *  (3) Suppose you want to only allow error messages by default,
 *      but you will permit this to be over-ridden at runtime.
 *      Use:  -DDEFAULT_SEVERITY=5
 *            and to allow info and warning override:
 *                 setMsgSeverity(L_SEVERITY_INFO);
 */

#ifdef  NO_CONSOLE_IO
  #undef MINIMUM_SEVERITY
  #undef DEFAULT_SEVERITY

  #define MINIMUM_SEVERITY      L_SEVERITY_NONE    /*!< Compile-time default */
  #define DEFAULT_SEVERITY      L_SEVERITY_NONE    /*!< Run-time default */

#else
  #ifndef MINIMUM_SEVERITY
    #define MINIMUM_SEVERITY    L_SEVERITY_INFO    /*!< Compile-time default */
  #endif

  #ifndef DEFAULT_SEVERITY
    #define DEFAULT_SEVERITY    MINIMUM_SEVERITY   /*!< Run-time default */
  #endif
#endif


/*!  The run-time message severity threshold is defined in utils.c.  */
LEPT_DLL extern l_int32  LeptMsgSeverity;

/*
 * <pre>
 *  Usage
 *  =====
 *  Messages are of two types.
 *
 *  (1) The messages
 *      ERROR_INT(a,b,c)       : returns l_int32
 *      ERROR_FLOAT(a,b,c)     : returns l_float32
 *      ERROR_PTR(a,b,c)       : returns void*
 *  are used to return from functions and take a fixed set of parameters:
 *      a : <message string>
 *      b : procName
 *      c : <return value from function>
 *  where procName is the name of the local variable naming the function.
 *
 *  (2) The purely informational L_* messages
 *      L_ERROR(a,...)
 *      L_WARNING(a,...)
 *      L_INFO(a,...)
 *  do not take a return value, but they take at least two parameters:
 *      a  :  <message string> with optional format conversions
 *      v1 : procName    (this must be included as the first vararg)
 *      v2, ... :  optional varargs to match format converters in the message
 *
 *  To return an error from a function that returns void, use:
 *      L_ERROR(<message string>, procName, [...])
 *      return;
 *
 *  Implementation details
 *  ======================
 *  Messages are defined with the IF_SEV macro.  The first parameter is
 *  the message severity, the second is the function to call if the
 *  message is to be printed, and the third is the return value if the
 *  message is to be suppressed.  For example, we might have an
 *  informational message defined as:
 *
 *    IF_SEV(L_SEVERITY_INFO, fprintf(.......), 0)
 *
 *  The macro expands into a conditional.  Because the first comparison
 *  is between two constants, an optimizing compiler will remove either
 *  the comparison (if it's true) or the entire macro expansion (if it
 *  is false).  This means that there is no run-time overhead for
 *  messages whose severity falls below the minimum specified at compile
 *  time, and for others the overhead is one (not two) comparisons.
 *
 *  The L_nnn() macros below do not return a value, but because the
 *  conditional operator requires one for the false condition, we
 *  specify a void expression.
 * </pre>
 */

#ifdef  NO_CONSOLE_IO

  #define PROCNAME(name)
  #define ERROR_INT(a,b,c)            ((l_int32)(c))
  #define ERROR_FLOAT(a,b,c)          ((l_float32)(c))
  #define ERROR_PTR(a,b,c)            ((void *)(c))
  #define L_ERROR(a,...)
  #define L_WARNING(a,...)
  #define L_INFO(a,...)

#else

  #define PROCNAME(name)              static const char procName[] = name
  #define IF_SEV(l,t,f) \
      ((l) >= MINIMUM_SEVERITY && (l) >= LeptMsgSeverity ? (t) : (f))

  #define ERROR_INT(a,b,c) \
      IF_SEV(L_SEVERITY_ERROR, returnErrorInt((a),(b),(c)), (l_int32)(c))
  #define ERROR_FLOAT(a,b,c) \
      IF_SEV(L_SEVERITY_ERROR, returnErrorFloat((a),(b),(c)), (l_float32)(c))
  #define ERROR_PTR(a,b,c) \
      IF_SEV(L_SEVERITY_ERROR, returnErrorPtr((a),(b),(c)), (void *)(c))

  #define L_ERROR(a,...) \
      IF_SEV(L_SEVERITY_ERROR, \
             (void)fprintf(stderr, "Error in %s: " a, __VA_ARGS__), \
             (void)0)
  #define L_WARNING(a,...) \
      IF_SEV(L_SEVERITY_WARNING, \
             (void)fprintf(stderr, "Warning in %s: " a, __VA_ARGS__), \
             (void)0)
  #define L_INFO(a,...) \
      IF_SEV(L_SEVERITY_INFO, \
             (void)fprintf(stderr, "Info in %s: " a, __VA_ARGS__), \
             (void)0)

#if 0  /* Alternative method for controlling L_* message output */
  #define L_ERROR(a,...) \
    { if (L_SEVERITY_ERROR >= MINIMUM_SEVERITY && \
          L_SEVERITY_ERROR >= LeptMsgSeverity) \
          fprintf(stderr, "Error in %s: " a, __VA_ARGS__) \
    }
  #define L_WARNING(a,...) \
    { if (L_SEVERITY_WARNING >= MINIMUM_SEVERITY && \
          L_SEVERITY_WARNING >= LeptMsgSeverity) \
          fprintf(stderr, "Warning in %s: " a, __VA_ARGS__) \
    }
  #define L_INFO(a,...) \
    { if (L_SEVERITY_INFO >= MINIMUM_SEVERITY && \
          L_SEVERITY_INFO >= LeptMsgSeverity) \
             fprintf(stderr, "Info in %s: " a, __VA_ARGS__) \
    }
#endif

#endif  /* NO_CONSOLE_IO */


/*------------------------------------------------------------------------*
 *              snprintf() renamed in MSVC (pre-VS2015)                   *
 *------------------------------------------------------------------------*/
#if defined _MSC_VER && _MSC_VER < 1900
#define snprintf(buf, size, ...)  _snprintf_s(buf, size, _TRUNCATE, __VA_ARGS__)
#endif


#endif /* LEPTONICA_ENVIRON_H */
