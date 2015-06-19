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

#ifndef  LEPTONICA_RECOG_H
#define  LEPTONICA_RECOG_H

/*
 *  recog.h
 *
 *     A simple utility for training and recognizing individual
 *     machine-printed text characters.  In an application, one can
 *     envision using a number of these, one for each trained set.
 *
 *     In training mode, a set of labelled bitmaps is presented, either
 *     one at a time, or in a directory, or in a pixa.  If in a directory,
 *     or a pixa, the labelling text string must be embedded in the
 *     text field of the image file.
 *
 *     Any number of recognizers (L_Recog) can be trained and then used
 *     together in an array (L_Recoga).  All these trained structures
 *     can be serialized to file and read back.  The serialized version
 *     holds all the bitmaps used for training, plus, for arbitrary
 *     character sets, the UTF8 representation and the lookup table
 *     mapping from the character representation to index.
 *
 *     There are three levels of "sets" here:
 *
 *       (1) Example set: the examples representing a character that
 *           were printed in the same way, so that they can be combined
 *           without scaling to form an "average" template for the character.
 *           In the recognition phase, we use either this aligned average,
 *           or the individual bitmaps.  All examples in the set are given
 *           the same character label.   Example: the letter 'a' in the
 *           predominant font in a book.
 *
 *       (2) Character set (represented by L_Recog, a single recognizer):
 *           The set of different characters, each of which is described
 *           by (1).  Each element of the set has a different character
 *           label.  Example: the digits '0' through '9' that are used for
 *           page numbering in a book.
 *
 *       (3) Recognizer set (represented by L_Recoga, an array of recogs):
 *           A set of recognizers, each of which is described by (2).
 *           In general, we do not want to combine the character sets
 *           with the same labels within different recognizer sets,
 *           because the bitmaps can differ in font type, style or size.
 *           Example 1: the letter 'a' can be printed in two very different
 *           ways (either with a large loop or with a smaller loop in
 *           the lower half); both share the same label but need to be
 *           distinguished so that they are not mixed when averaging.
 *           Example 2: a recognizer trained for a book may be missing
 *           some characters, so we need to supplement it with another
 *           "generic" or "bootstrap" recognizer that has the additional
 *           characters from a variety of sources.  Bootstrap recognizers
 *           must be run in a mode where all characters are scaled.
 *
 *     In the recognition process, for each component in an input image,
 *     each recognizer (L_Recog) records the best match (highest
 *     correlation score).  If there is more than one recognizer, these
 *     results are aggregated to find the best match for each character
 *     for all the recognizers, and this is stored in L_Recoga.
 */

#define  RECOG_VERSION_NUMBER      1

struct L_Recoga {
    l_int32              n;      /* number of recogs                         */
    l_int32              nalloc; /* number of recog ptrs allocated           */
    struct L_Recog     **recog;  /* recog ptr array                          */
    struct L_Rcha       *rcha;   /* stores the array of best chars           */
};
typedef struct L_Recoga L_RECOGA;


struct L_Recog {
    l_int32        scalew;       /* scale all examples to this width;        */
                                 /* use 0 prevent horizontal scaling         */
    l_int32        scaleh;       /* scale all examples to this height;       */
                                 /* use 0 prevent vertical scaling           */
    l_int32        templ_type;   /* template type: either an average of      */
                                 /* examples (L_USE_AVERAGE) or the set      */
                                 /* of all examples (L_USE_ALL)              */
    l_int32        maxarraysize; /* initialize container arrays to this      */
    l_int32        setsize;      /* size of character set                    */
    l_int32        threshold;    /* for binarizing if depth > 1              */
    l_int32        maxyshift;    /* vertical jiggle on nominal centroid      */
                                 /* alignment; typically 0 or 1              */
    l_float32      asperity_fr;  /* +- allowed fractional asperity ratio     */
    l_int32        charset_type; /* one of L_ARABIC_NUMERALS, etc.           */
    l_int32        charset_size; /* expected number of classes in charset    */
    char          *bootdir;      /* dir with bootstrap pixa charsets         */
    char          *bootpattern;  /* file pattern for bootstrap pixa charsets */
    char          *bootpath;     /* path for single bootstrap pixa charset   */
    l_int32        min_nopad;    /* min number of samples without padding    */
    l_int32        max_afterpad; /* max number of samples after padding      */
    l_int32        samplenum;    /* keep track of number of training samples */
    l_int32        minwidth_u;   /* min width of averaged unscaled templates */
    l_int32        maxwidth_u;   /* max width of averaged unscaled templates */
    l_int32        minheight_u;  /* min height of averaged unscaled templates */
    l_int32        maxheight_u;  /* max height of averaged unscaled templates */
    l_int32        minwidth;     /* min width of averaged scaled templates   */
    l_int32        maxwidth;     /* max width of averaged scaled templates   */
    l_int32        ave_done;     /* set to 1 when averaged bitmaps are made  */
    l_int32        train_done;   /* set to 1 when training is complete or    */
                                 /* identification has started               */
    l_int32        min_splitw;   /* min component width kept in splitting    */
    l_int32        min_splith;   /* min component height kept in splitting   */
    l_int32        max_splith;   /* max component height kept in splitting   */
    struct Sarray *sa_text;      /* text array for arbitrary char set        */
    struct L_Dna  *dna_tochar;   /* index-to-char lut for arbitrary char set */
    l_int32       *centtab;      /* table for finding centroids              */
    l_int32       *sumtab;       /* table for finding pixel sums             */
    char          *fname;        /* serialized filename (if read)            */
    struct Pixaa  *pixaa_u;      /* all unscaled bitmaps for each class      */
    struct Pixa   *pixa_u;       /* averaged unscaled bitmaps for each class */
    struct Ptaa   *ptaa_u;       /* centroids of all unscaled bitmaps        */
    struct Pta    *pta_u;        /* centroids of unscaled averaged bitmaps   */
    struct Numaa  *naasum_u;     /* area of all unscaled bitmap examples     */
    struct Numa   *nasum_u;      /* area of unscaled averaged bitmaps        */
    struct Pixaa  *pixaa;        /* all bitmap examples for each class       */
    struct Pixa   *pixa;         /* averaged bitmaps for each class          */
    struct Ptaa   *ptaa;         /* centroids of all bitmap examples         */
    struct Pta    *pta;          /* centroids of averaged bitmaps            */
    struct Numaa  *naasum;       /* area of all bitmap examples              */
    struct Numa   *nasum;        /* area of averaged bitmaps                 */
    struct Pixa   *pixa_tr;      /* input training images                    */
    struct Pixa   *pixadb_ave;   /* unscaled and scaled averaged bitmaps     */
    struct Pixa   *pixa_id;      /* input images for identifying             */
    struct Pix    *pixdb_ave;    /* debug: best match of input against ave.  */
    struct Pix    *pixdb_range;  /* debug: best matches within range         */
    struct Pixa   *pixadb_boot;  /* debug: bootstrap training results        */
    struct Pixa   *pixadb_split; /* debug: splitting results                 */
    struct L_Bmf  *bmf;          /* bmf fonts                                */
    l_int32        bmf_size;     /* font size of bmf; default is 6 pt        */
    struct L_Rdid *did;          /* temp data used for image decoding        */
    struct L_Rch  *rch;          /* temp data used for holding best char     */
    struct L_Rcha *rcha;         /* temp data used for array of best chars   */
    l_int32        bootrecog;    /* 1 if using bootstrap samples; else 0     */
    l_int32        index;        /* recog index in recoga; -1 if no parent   */
    struct L_Recoga  *parent;    /* ptr to parent array; can be null         */

};
typedef struct L_Recog L_RECOG;

/*
 *  Data returned from correlation matching on a single character
 */
struct L_Rch {
    l_int32        index;        /* index of best template                   */
    l_float32      score;        /* correlation score of best template       */
    char          *text;         /* character string of best template        */
    l_int32        sample;       /* index of best sample (within the best    */
                                 /* template class, if all samples are used) */
    l_int32        xloc;         /* x-location of template (delx + shiftx)   */
    l_int32        yloc;         /* y-location of template (dely + shifty)   */
    l_int32        width;        /* width of best template                   */
};
typedef struct L_Rch L_RCH;

/*
 *  Data returned from correlation matching on an array of characters
 */
struct L_Rcha {
    struct Numa   *naindex;      /* indices of best templates                */
    struct Numa   *nascore;      /* correlation scores of best templates     */
    struct Sarray *satext;       /* character strings of best templates      */
    struct Numa   *nasample;     /* indices of best samples                  */
    struct Numa   *naxloc;       /* x-locations of templates (delx + shiftx) */
    struct Numa   *nayloc;       /* y-locations of templates (dely + shifty) */
    struct Numa   *nawidth;      /* widths of best templates                 */
};
typedef struct L_Rcha L_RCHA;

/*
 *  Data used for decoding a line of characters.
 */
struct L_Rdid {
    struct Pix    *pixs;         /* clone of pix to be decoded               */
    l_int32      **counta;       /* count array for each averaged template   */
    l_int32      **delya;        /* best y-shift array per averaged template */
    l_int32        narray;       /* number of averaged templates             */
    l_int32        size;         /* size of count array (width of pixs)      */
    l_int32       *setwidth;     /* setwidths for each template              */
    struct Numa   *nasum;        /* pixel count in pixs by column            */
    struct Numa   *namoment;     /* first moment of pixels in pixs by column */
    l_int32        fullarrays;   /* 1 if full arrays are made; 0 otherwise   */
    l_float32     *beta;         /* channel coeffs for template fg term      */
    l_float32     *gamma;        /* channel coeffs for bit-and term          */
    l_float32     *trellisscore; /* score on trellis                         */
    l_int32       *trellistempl; /* template on trellis (for backtrack)      */
    struct Numa   *natempl;      /* indices of best path templates           */
    struct Numa   *naxloc;       /* x locations of best path templates       */
    struct Numa   *nadely;       /* y locations of best path templates       */
    struct Numa   *nawidth;      /* widths of best path templates            */
    struct Numa   *nascore;      /* correlation scores: best path templates  */
    struct Numa   *natempl_r;    /* indices of best rescored templates       */
    struct Numa   *naxloc_r;     /* x locations of best rescoredtemplates    */
    struct Numa   *nadely_r;     /* y locations of best rescoredtemplates    */
    struct Numa   *nawidth_r;    /* widths of best rescoredtemplates         */
    struct Numa   *nascore_r;    /* correlation scores: rescored templates   */
};
typedef struct L_Rdid L_RDID;


/*-------------------------------------------------------------------------*
 *                    Flags for selecting processing                       *
 *-------------------------------------------------------------------------*/
enum {
    L_SELECT_UNSCALED = 0,       /* select the unscaled bitmaps            */
    L_SELECT_SCALED = 1,         /* select the scaled bitmaps              */
    L_SELECT_BOTH = 2            /* select both unscaled and scaled        */
};

/*-------------------------------------------------------------------------*
 *                Flags for determining what to test against               *
 *-------------------------------------------------------------------------*/
enum {
    L_USE_AVERAGE = 0,         /* form template from class average         */
    L_USE_ALL = 1              /* match against all elements of each class */
};

/*-------------------------------------------------------------------------*
 *             Flags for describing limited character sets                 *
 *-------------------------------------------------------------------------*/
enum {
    L_UNKNOWN = 0,             /* character set type is not specified      */
    L_ARABIC_NUMERALS = 1,     /* 10 digits                                */
    L_LC_ROMAN_NUMERALS = 2,   /* 7 lower-case letters (i,v,x,l,c,d,m)     */
    L_UC_ROMAN_NUMERALS = 3,   /* 7 upper-case letters (I,V,X,L,C,D,M)     */
    L_LC_ALPHA = 4,            /* 26 lower-case letters                    */
    L_UC_ALPHA = 5             /* 26 upper-case letters                    */
};

#endif  /* LEPTONICA_RECOG_H */
