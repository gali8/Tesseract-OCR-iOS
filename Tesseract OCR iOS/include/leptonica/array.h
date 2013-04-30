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

#ifndef  LEPTONICA_ARRAY_H
#define  LEPTONICA_ARRAY_H

/*
 *  Contains the following structs:
 *      struct Numa
 *      struct Numaa
 *      struct Numa2d
 *      struct NumaHash
 *      struct L_Dna
 *      struct L_Dnaa
 *      struct Sarray
 *      struct L_Bytea
 *
 *  Contains definitions for:
 *      Numa interpolation flags
 */


/*------------------------------------------------------------------------* 
 *                             Array Structs                              *
 *------------------------------------------------------------------------*/

#define  NUMA_VERSION_NUMBER     1

    /* Number array: an array of floats */
struct Numa
{
    l_int32          nalloc;    /* size of allocated number array      */
    l_int32          n;         /* number of numbers saved             */
    l_int32          refcount;  /* reference count (1 if no clones)    */
    l_float32        startx;    /* x value assigned to array[0]        */
    l_float32        delx;      /* change in x value as i --> i + 1    */
    l_float32       *array;     /* number array                        */
};
typedef struct Numa  NUMA;


    /* Array of number arrays */
struct Numaa
{
    l_int32          nalloc;    /* size of allocated ptr array          */
    l_int32          n;         /* number of Numa saved                 */
    struct Numa    **numa;      /* array of Numa                        */
};
typedef struct Numaa  NUMAA;


    /* Sparse 2-dimensional array of number arrays */
struct Numa2d
{
    l_int32          nrows;      /* number of rows allocated for ptr array  */
    l_int32          ncols;      /* number of cols allocated for ptr array  */
    l_int32          initsize;   /* initial size of each numa that is made  */
    struct Numa   ***numa;       /* 2D array of Numa                        */
};
typedef struct Numa2d  NUMA2D;


    /* A hash table of Numas */
struct NumaHash
{
    l_int32          nbuckets;
    l_int32          initsize;   /* initial size of each numa that is made  */
    struct Numa    **numa;
};
typedef struct NumaHash NUMAHASH;


#define  DNA_VERSION_NUMBER     1

    /* Double number array: an array of doubles */
struct L_Dna
{
    l_int32          nalloc;    /* size of allocated number array      */
    l_int32          n;         /* number of numbers saved             */
    l_int32          refcount;  /* reference count (1 if no clones)    */
    l_float64        startx;    /* x value assigned to array[0]        */
    l_float64        delx;      /* change in x value as i --> i + 1    */
    l_float64       *array;     /* number array                        */
};
typedef struct L_Dna  L_DNA;


    /* Array of double number arrays */
struct L_Dnaa
{
    l_int32          nalloc;    /* size of allocated ptr array          */
    l_int32          n;         /* number of L_Dna saved                */
    struct L_Dna   **dna;       /* array of L_Dna                       */
};
typedef struct L_Dnaa  L_DNAA;


#define  SARRAY_VERSION_NUMBER     1

    /* String array: an array of C strings */
struct Sarray
{
    l_int32          nalloc;    /* size of allocated ptr array         */
    l_int32          n;         /* number of strings allocated         */
    l_int32          refcount;  /* reference count (1 if no clones)    */
    char           **array;     /* string array                        */
};
typedef struct Sarray SARRAY;


    /* Byte array (analogous to C++ "string") */
struct L_Bytea
{
    size_t           nalloc;    /* number of bytes allocated in data array  */
    size_t           size;      /* number of bytes presently used           */
    l_int32          refcount;  /* reference count (1 if no clones)         */
    l_uint8         *data;      /* data array                               */
};
typedef struct L_Bytea L_BYTEA;


/*------------------------------------------------------------------------* 
 *                              Array flags                               *
 *------------------------------------------------------------------------*/

    /* Flags for interpolation in Numa */
enum {
    L_LINEAR_INTERP = 1,        /* linear     */
    L_QUADRATIC_INTERP = 2      /* quadratic  */
};

    /* Flags for added borders in Numa and Fpix */
enum {
    L_CONTINUED_BORDER = 1,     /* extended with same value                  */
    L_SLOPE_BORDER = 2,         /* extended with constant normal derivative  */
    L_MIRRORED_BORDER = 3       /* mirrored                                  */
};


#endif  /* LEPTONICA_ARRAY_H */
