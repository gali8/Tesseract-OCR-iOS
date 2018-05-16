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

#ifndef  LEPTONICA_PIX_H
#define  LEPTONICA_PIX_H

/*!
 * \file pix.h
 *
 * <pre>
 *   Valid image types in leptonica:
 *       Pix: 1 bpp, with and without colormap
 *       Pix: 2 bpp, with and without colormap
 *       Pix: 4 bpp, with and without colormap
 *       Pix: 8 bpp, with and without colormap
 *       Pix: 16 bpp (1 spp)
 *       Pix: 32 bpp (rgb, 3 spp)
 *       Pix: 32 bpp (rgba, 4 spp)
 *       FPix: 32 bpp float
 *       DPix: 64 bpp double
 *       Notes:
 *          (1) The only valid Pix image type with alpha is rgba.
 *              In particular, the alpha component is not used in
 *              cmapped images.
 *          (2) PixComp can hold any Pix with IFF_PNG encoding.
 *
 *   Contents:
 *
 *   (1) This file defines most of the image-related structs used in leptonica:
 *         struct Pix
 *         struct PixColormap
 *         struct RGBA_Quad
 *         struct Pixa
 *         struct Pixaa
 *         struct Box
 *         struct Boxa
 *         struct Boxaa
 *         struct Pta
 *         struct Ptaa
 *         struct Pixacc
 *         struct PixTiling
 *         struct FPix
 *         struct FPixa
 *         struct DPix
 *         struct PixComp
 *         struct PixaComp
 *
 *   (2) This file has definitions for:
 *         Colors for RGB
 *         Colors for drawing boxes
 *         Perceptual color weights
 *         Colormap conversion flags
 *         Rasterop bit flags
 *         Structure access flags (for insert, copy, clone, copy-clone)
 *         Sorting flags (by type and direction)
 *         Blending flags
 *         Graphics pixel setting flags
 *         Size filtering flags
 *         Color component selection flags
 *         16-bit conversion flags
 *         Rotation and shear flags
 *         Affine transform order flags
 *         Grayscale filling flags
 *         Flags for setting to white or black
 *         Flags for getting white or black pixel value
 *         Flags for 8 and 16 bit pixel sums
 *         Dithering flags
 *         Distance flags
 *         Value flags
 *         Statistical measures
 *         Set selection flags
 *         Text orientation flags
 *         Edge orientation flags
 *         Line orientation flags
 *         Image orientation flags
 *         Scan direction flags
 *         Box size adjustment flags
 *         Flags for modifying box boundaries using a second box
 *         Handling overlapping bounding boxes in boxa
 *         Flags for replacing invalid boxes
 *         Horizontal warp
 *         Pixel selection for resampling
 *         Thinning flags
 *         Runlength flags
 *         Edge filter flags
 *         Subpixel color component ordering in LCD display
 *         HSV histogram flags
 *         Region flags (inclusion, exclusion)
 *         Flags for adding text to a pix
 *         Flags for plotting on a pix
 *         Flags for selecting display program
 *         Flags in the 'special' pix field for non-default operations
 *         Handling negative values in conversion to unsigned int
 *         Relative to zero flags
 *         Flags for adding or removing traling slash from string
 *
 *   (3) This file has typedefs for the pix allocator and deallocator functions
 *         alloc_fn()
 *         dealloc_fn().
 * </pre>
 */


/*-------------------------------------------------------------------------*
 *                              Basic Pix                                  *
 *-------------------------------------------------------------------------*/
    /* The 'special' field is by default 0, but it can hold integers
     * that direct non-default actions, e.g., in png and jpeg I/O. */

/*! Basic Pix */
struct Pix
{
    l_uint32             w;         /*!< width in pixels                   */
    l_uint32             h;         /*!< height in pixels                  */
    l_uint32             d;         /*!< depth in bits (bpp)               */
    l_uint32             spp;       /*!< number of samples per pixel       */
    l_uint32             wpl;       /*!< 32-bit words/line                 */
    l_uint32             refcount;  /*!< reference count (1 if no clones)  */
    l_int32              xres;      /*!< image res (ppi) in x direction    */
                                    /*!< (use 0 if unknown)                */
    l_int32              yres;      /*!< image res (ppi) in y direction    */
                                    /*!< (use 0 if unknown)                */
    l_int32              informat;  /*!< input file format, IFF_*          */
    l_int32              special;   /*!< special instructions for I/O, etc */
    char                *text;      /*!< text string associated with pix   */
    struct PixColormap  *colormap;  /*!< colormap (may be null)            */
    l_uint32            *data;      /*!< the image data                    */
};
typedef struct Pix PIX;

/*! Colormap of a Pix */
struct PixColormap
{
    void            *array;   /*!< colormap table (array of RGBA_QUAD)     */
    l_int32          depth;   /*!< of pix (1, 2, 4 or 8 bpp)               */
    l_int32          nalloc;  /*!< number of color entries allocated       */
    l_int32          n;       /*!< number of color entries used            */
};
typedef struct PixColormap  PIXCMAP;


    /*! Colormap table entry (after the BMP version).
     * Note that the BMP format stores the colormap table exactly
     * as it appears here, with color samples being stored sequentially,
     * in the order (b,g,r,a). */
struct RGBA_Quad
{
    l_uint8     blue;         /*!< blue value */
    l_uint8     green;        /*!< green value */
    l_uint8     red;          /*!< red value */
    l_uint8     alpha;        /*!< alpha value */
};
typedef struct RGBA_Quad  RGBA_QUAD;



/*-------------------------------------------------------------------------*
 *                             Colors for 32 bpp                           *
 *-------------------------------------------------------------------------*/
/* <pre>
 *  Notes:
 *      (1) These are the byte indices for colors in 32 bpp images.
 *          They are used through the GET/SET_DATA_BYTE accessors.
 *          The 4th byte, typically known as the "alpha channel" and used
 *          for blending, is used to a small extent in leptonica.
 *      (2) Do not change these values!  If you redefine them, functions
 *          that have the shifts hardcoded for efficiency and conciseness
 *          (instead of using the constants below) will break.  These
 *          functions are labelled with "***"  next to their names at
 *          the top of the files in which they are defined.
 *      (3) The shifts to extract the red, green, blue and alpha components
 *          from a 32 bit pixel are defined here.
 * </pre>
 */

/*! Colors for 32 bpp */
enum {
    COLOR_RED = 0,        /*!< red color index in RGBA_QUAD    */
    COLOR_GREEN = 1,      /*!< green color index in RGBA_QUAD  */
    COLOR_BLUE = 2,       /*!< blue color index in RGBA_QUAD   */
    L_ALPHA_CHANNEL = 3   /*!< alpha value index in RGBA_QUAD  */
};

static const l_int32  L_RED_SHIFT =
       8 * (sizeof(l_uint32) - 1 - COLOR_RED);           /* 24 */
static const l_int32  L_GREEN_SHIFT =
       8 * (sizeof(l_uint32) - 1 - COLOR_GREEN);         /* 16 */
static const l_int32  L_BLUE_SHIFT =
       8 * (sizeof(l_uint32) - 1 - COLOR_BLUE);          /*  8 */
static const l_int32  L_ALPHA_SHIFT =
       8 * (sizeof(l_uint32) - 1 - L_ALPHA_CHANNEL);     /*  0 */


/*-------------------------------------------------------------------------*
 *                       Colors for drawing boxes                          *
 *-------------------------------------------------------------------------*/
/*! Colors for drawing boxes */
enum {
    L_DRAW_RED = 0,         /*!< draw in red                   */
    L_DRAW_GREEN = 1,       /*!< draw in green                 */
    L_DRAW_BLUE = 2,        /*!< draw in blue                  */
    L_DRAW_SPECIFIED = 3,   /*!< draw specified color          */
    L_DRAW_RGB = 4,         /*!< draw as sequence of r,g,b     */
    L_DRAW_RANDOM = 5       /*!< draw randomly chosen colors   */
};


/*-------------------------------------------------------------------------*
 *                       Perceptual color weights                          *
 *-------------------------------------------------------------------------*/
/* <pre>
 *  Notes:
 *      (1) These perceptual weighting factors are ad-hoc, but they do
 *          add up to 1.  Unlike, for example, the weighting factors for
 *          converting RGB to luminance, or more specifically to Y in the
 *          YUV colorspace.  Those numbers come from the
 *          International Telecommunications Union, via ITU-R.
 * </pre>
 */
static const l_float32  L_RED_WEIGHT =   0.3;  /*!< Percept. weight for red   */
static const l_float32  L_GREEN_WEIGHT = 0.5;  /*!< Percept. weight for green */
static const l_float32  L_BLUE_WEIGHT =  0.2;  /*!< Percept. weight for blue  */


/*-------------------------------------------------------------------------*
 *                        Flags for colormap conversion                    *
 *-------------------------------------------------------------------------*/
/*! Flags for colormap conversion */
enum {
    REMOVE_CMAP_TO_BINARY = 0,     /*!< remove colormap for conv to 1 bpp  */
    REMOVE_CMAP_TO_GRAYSCALE = 1,  /*!< remove colormap for conv to 8 bpp  */
    REMOVE_CMAP_TO_FULL_COLOR = 2, /*!< remove colormap for conv to 32 bpp */
    REMOVE_CMAP_WITH_ALPHA = 3,    /*!< remove colormap and alpha          */
    REMOVE_CMAP_BASED_ON_SRC = 4   /*!< remove depending on src format     */
};


/*------------------------------------------------------------------------*
 *!
 * <pre>
 * The following operation bit flags have been modified from
 * Sun's pixrect.h.
 *
 * The 'op' in 'rasterop' is represented by an integer
 * composed with Boolean functions using the set of five integers
 * given below.  The integers, and the op codes resulting from
 * boolean expressions on them, need only be in the range from 0 to 15.
 * The function is applied on a per-pixel basis.
 *
 * Examples: the op code representing ORing the src and dest
 * is computed using the bit OR, as PIX_SRC | PIX_DST;  the op
 * code representing XORing src and dest is found from
 * PIX_SRC ^ PIX_DST;  the op code representing ANDing src and dest
 * is found from PIX_SRC & PIX_DST.  Note that
 * PIX_NOT(PIX_CLR) = PIX_SET, and v.v., as they must be.
 *
 * We use the following set of definitions:
 *
 *      #define   PIX_SRC      0xc
 *      #define   PIX_DST      0xa
 *      #define   PIX_NOT(op)  (op) ^ 0xf
 *      #define   PIX_CLR      0x0
 *      #define   PIX_SET      0xf
 *
 * These definitions differ from Sun's, in that Sun left-shifted
 * each value by 1 pixel, and used the least significant bit as a
 * flag for the "pseudo-operation" of clipping.  We don't need
 * this bit, because it is both efficient and safe ALWAYS to clip
 * the rectangles to the src and dest images, which is what we do.
 * See the notes in rop.h on the general choice of these bit flags.
 *
 * [If for some reason you need compatibility with Sun's xview package,
 * you can adopt the original Sun definitions to avoid redefinition conflicts:
 *
 *      #define   PIX_SRC      (0xc << 1)
 *      #define   PIX_DST      (0xa << 1)
 *      #define   PIX_NOT(op)  ((op) ^ 0x1e)
 *      #define   PIX_CLR      (0x0 << 1)
 *      #define   PIX_SET      (0xf << 1)
 * ]
 *
 * We have, for reference, the following 16 unique op flags:
 *
 *      PIX_CLR                           0000             0x0
 *      PIX_SET                           1111             0xf
 *      PIX_SRC                           1100             0xc
 *      PIX_DST                           1010             0xa
 *      PIX_NOT(PIX_SRC)                  0011             0x3
 *      PIX_NOT(PIX_DST)                  0101             0x5
 *      PIX_SRC | PIX_DST                 1110             0xe
 *      PIX_SRC & PIX_DST                 1000             0x8
 *      PIX_SRC ^ PIX_DST                 0110             0x6
 *      PIX_NOT(PIX_SRC) | PIX_DST        1011             0xb
 *      PIX_NOT(PIX_SRC) & PIX_DST        0010             0x2
 *      PIX_SRC | PIX_NOT(PIX_DST)        1101             0xd
 *      PIX_SRC & PIX_NOT(PIX_DST)        0100             0x4
 *      PIX_NOT(PIX_SRC | PIX_DST)        0001             0x1
 *      PIX_NOT(PIX_SRC & PIX_DST)        0111             0x7
 *      PIX_NOT(PIX_SRC ^ PIX_DST)        1001             0x9
 *
 * </pre>
 *-------------------------------------------------------------------------*/

#define   PIX_SRC      (0xc)                      /*!< use source pixels      */
#define   PIX_DST      (0xa)                      /*!< use destination pixels */
#define   PIX_NOT(op)  ((op) ^ 0x0f)              /*!< invert operation %op   */
#define   PIX_CLR      (0x0)                      /*!< clear pixels           */
#define   PIX_SET      (0xf)                      /*!< set pixels             */

#define   PIX_PAINT    (PIX_SRC | PIX_DST)        /*!< paint = src | dst      */
#define   PIX_MASK     (PIX_SRC & PIX_DST)        /*!< mask = src & dst       */
#define   PIX_SUBTRACT (PIX_DST & PIX_NOT(PIX_SRC)) /*!< subtract =           */
                                                    /*!<    src & !dst        */
#define   PIX_XOR      (PIX_SRC ^ PIX_DST)        /*!< xor = src ^ dst        */


/*-------------------------------------------------------------------------*
 * <pre>
 *   Important Notes:
 *
 *       (1) The image data is stored in a single contiguous
 *           array of l_uint32, into which the pixels are packed.
 *           By "packed" we mean that there are no unused bits
 *           between pixels, except for end-of-line padding to
 *           satisfy item (2) below.
 *
 *       (2) Every image raster line begins on a 32-bit word
 *           boundary within this array.
 *
 *       (3) Pix image data is stored in 32-bit units, with the
 *           pixels ordered from left to right in the image being
 *           stored in order from the MSB to LSB within the word,
 *           for both big-endian and little-endian machines.
 *           This is the natural ordering for big-endian machines,
 *           as successive bytes are stored and fetched progressively
 *           to the right.  However, for little-endians, when storing
 *           we re-order the bytes from this byte stream order, and
 *           reshuffle again for byte access on 32-bit entities.
 *           So if the bytes come in sequence from left to right, we
 *           store them on little-endians in byte order:
 *                3 2 1 0 7 6 5 4 ...
 *           This MSB to LSB ordering allows left and right shift
 *           operations on 32 bit words to move the pixels properly.
 *
 *       (4) We use 32 bit pixels for both RGB and RGBA color images.
 *           The A (alpha) byte is ignored in most leptonica functions
 *           operating on color images.  Within each 4 byte pixel, the
 *           color samples are ordered from MSB to LSB, as follows:
 *
 *                |  MSB  |  2nd MSB  |  3rd MSB  |  LSB  |
 *                   red      green       blue      alpha
 *                    0         1           2         3   (big-endian)
 *                    3         2           1         0   (little-endian)
 *
 *           Because we use MSB to LSB ordering within the 32-bit word,
 *           the individual 8-bit samples can be accessed with
 *           GET_DATA_BYTE and SET_DATA_BYTE macros, using the
 *           (implicitly big-ending) ordering
 *                 red:    byte 0  (MSB)
 *                 green:  byte 1  (2nd MSB)
 *                 blue:   byte 2  (3rd MSB)
 *                 alpha:  byte 3  (LSB)
 *
 *           The specific color assignment is made in this file,
 *           through the definitions of COLOR_RED, etc.  Then the R, G
 *           B and A sample values can be retrieved using
 *                 redval = GET_DATA_BYTE(&pixel, COLOR_RED);
 *                 greenval = GET_DATA_BYTE(&pixel, COLOR_GREEN);
 *                 blueval = GET_DATA_BYTE(&pixel, COLOR_BLUE);
 *                 alphaval = GET_DATA_BYTE(&pixel, L_ALPHA_CHANNEL);
 *           and they can be set with
 *                 SET_DATA_BYTE(&pixel, COLOR_RED, redval);
 *                 SET_DATA_BYTE(&pixel, COLOR_GREEN, greenval);
 *                 SET_DATA_BYTE(&pixel, COLOR_BLUE, blueval);
 *                 SET_DATA_BYTE(&pixel, L_ALPHA_CHANNEL, alphaval);
 *
 *           More efficiently, these components can be extracted directly
 *           by shifting and masking, explicitly using the values in
 *           L_RED_SHIFT, etc.:
 *                 (pixel32 >> L_RED_SHIFT) & 0xff;         (red)
 *                 (pixel32 >> L_GREEN_SHIFT) & 0xff;       (green)
 *                 (pixel32 >> L_BLUE_SHIFT) & 0xff;        (blue)
 *                 (pixel32 >> L_ALPHA_SHIFT) & 0xff;       (alpha)
 *           The functions extractRGBValues() and extractRGBAValues() are
 *           provided to do this.  Likewise, the pixels can be set
 *           directly by shifting, using composeRGBPixel() and
 *           composeRGBAPixel().
 *
 *           All these operations work properly on both big- and little-endians.
 *
 *       (5) A reference count is held within each pix, giving the
 *           number of ptrs to the pix.  When a pixClone() call
 *           is made, the ref count is increased by 1, and
 *           when a pixDestroy() call is made, the reference count
 *           of the pix is decremented.  The pix is only destroyed
 *           when the reference count goes to zero.
 *
 *       (6) The version numbers (below) are used in the serialization
 *           of these data structures.  They are placed in the files,
 *           and rarely (if ever) change.  Provision is currently made for
 *           backward compatibility in reading from boxaa version 2.
 *
 *       (7) The serialization dependencies are as follows:
 *               pixaa  :  pixa  :  boxa
 *               boxaa  :  boxa
 *           So, for example, pixaa and boxaa can be changed without
 *           forcing a change in pixa or boxa.  However, if pixa is
 *           changed, it forces a change in pixaa, and if boxa is
 *           changed, if forces a change in the other three.
 *           We define four version numbers:
 *               PIXAA_VERSION_NUMBER
 *               PIXA_VERSION_NUMBER
 *               BOXAA_VERSION_NUMBER
 *               BOXA_VERSION_NUMBER
 * </pre>
 *-------------------------------------------------------------------------*/



/*-------------------------------------------------------------------------*
 *                              Array of pix                               *
 *-------------------------------------------------------------------------*/

    /*  Serialization for primary data structures */
#define  PIXAA_VERSION_NUMBER      2  /*!< Version for Pixaa serialization */
#define  PIXA_VERSION_NUMBER       2  /*!< Version for Pixa serialization  */
#define  BOXA_VERSION_NUMBER       2  /*!< Version for Boxa serialization  */
#define  BOXAA_VERSION_NUMBER      3  /*!< Version for Boxaa serialization */

/*! Array of pix */
struct Pixa
{
    l_int32             n;          /*!< number of Pix in ptr array        */
    l_int32             nalloc;     /*!< number of Pix ptrs allocated      */
    l_uint32            refcount;   /*!< reference count (1 if no clones)  */
    struct Pix        **pix;        /*!< the array of ptrs to pix          */
    struct Boxa        *boxa;       /*!< array of boxes                    */
};
typedef struct Pixa PIXA;

/*! Array of arrays of pix */
struct Pixaa
{
    l_int32             n;          /*!< number of Pixa in ptr array       */
    l_int32             nalloc;     /*!< number of Pixa ptrs allocated     */
    struct Pixa       **pixa;       /*!< array of ptrs to pixa             */
    struct Boxa        *boxa;       /*!< array of boxes                    */
};
typedef struct Pixaa PIXAA;


/*-------------------------------------------------------------------------*
 *                    Basic rectangle and rectangle arrays                 *
 *-------------------------------------------------------------------------*/

/*! Basic rectangle */
struct Box
{
    l_int32            x;           /*!< left coordinate                   */
    l_int32            y;           /*!< top coordinate                    */
    l_int32            w;           /*!< box width                         */
    l_int32            h;           /*!< box height                        */
    l_uint32           refcount;    /*!< reference count (1 if no clones)  */

};
typedef struct Box    BOX;

/*! Array of Box */
struct Boxa
{
    l_int32            n;           /*!< number of box in ptr array        */
    l_int32            nalloc;      /*!< number of box ptrs allocated      */
    l_uint32           refcount;    /*!< reference count (1 if no clones)  */
    struct Box       **box;         /*!< box ptr array                     */
};
typedef struct Boxa  BOXA;

/*! Array of Boxa */
struct Boxaa
{
    l_int32            n;           /*!< number of boxa in ptr array       */
    l_int32            nalloc;      /*!< number of boxa ptrs allocated     */
    struct Boxa      **boxa;        /*!< boxa ptr array                    */
};
typedef struct Boxaa  BOXAA;


/*-------------------------------------------------------------------------*
 *                               Array of points                           *
 *-------------------------------------------------------------------------*/
#define  PTA_VERSION_NUMBER      1  /*!< Version for Pta serialization     */

/*! Array of points */
struct Pta
{
    l_int32            n;           /*!< actual number of pts              */
    l_int32            nalloc;      /*!< size of allocated arrays          */
    l_uint32           refcount;    /*!< reference count (1 if no clones)  */
    l_float32         *x, *y;       /*!< arrays of floats                  */
};
typedef struct Pta PTA;


/*-------------------------------------------------------------------------*
 *                              Array of Pta                               *
 *-------------------------------------------------------------------------*/

/*! Array of Pta */
struct Ptaa
{
    l_int32              n;         /*!< number of pta in ptr array        */
    l_int32              nalloc;    /*!< number of pta ptrs allocated      */
    struct Pta         **pta;       /*!< pta ptr array                     */
};
typedef struct Ptaa PTAA;


/*-------------------------------------------------------------------------*
 *                       Pix accumulator container                         *
 *-------------------------------------------------------------------------*/

/*! Pix accumulator container */
struct Pixacc
{
    l_int32             w;          /*!< array width                       */
    l_int32             h;          /*!< array height                      */
    l_int32             offset;     /*!< used to allow negative            */
                                    /*!< intermediate results              */
    struct Pix         *pix;        /*!< the 32 bit accumulator pix        */
};
typedef struct Pixacc PIXACC;


/*-------------------------------------------------------------------------*
 *                              Pix tiling                                 *
 *-------------------------------------------------------------------------*/

/*! Pix tiling */
struct PixTiling
{
    struct Pix          *pix;       /*!< input pix (a clone)               */
    l_int32              nx;        /*!< number of tiles horizontally      */
    l_int32              ny;        /*!< number of tiles vertically        */
    l_int32              w;         /*!< tile width                        */
    l_int32              h;         /*!< tile height                       */
    l_int32              xoverlap;  /*!< overlap on left and right         */
    l_int32              yoverlap;  /*!< overlap on top and bottom         */
    l_int32              strip;     /*!< strip for paint; default is TRUE  */
};
typedef struct PixTiling PIXTILING;


/*-------------------------------------------------------------------------*
 *                       FPix: pix with float array                        *
 *-------------------------------------------------------------------------*/
#define  FPIX_VERSION_NUMBER      2 /*!< Version for FPix serialization    */

/*! Pix with float array */
struct FPix
{
    l_int32              w;         /*!< width in pixels                   */
    l_int32              h;         /*!< height in pixels                  */
    l_int32              wpl;       /*!< 32-bit words/line                 */
    l_uint32             refcount;  /*!< reference count (1 if no clones)  */
    l_int32              xres;      /*!< image res (ppi) in x direction    */
                                    /*!< (use 0 if unknown)                */
    l_int32              yres;      /*!< image res (ppi) in y direction    */
                                    /*!< (use 0 if unknown)                */
    l_float32           *data;      /*!< the float image data              */
};
typedef struct FPix FPIX;

/*! Array of FPix */
struct FPixa
{
    l_int32             n;          /*!< number of fpix in ptr array       */
    l_int32             nalloc;     /*!< number of fpix ptrs allocated     */
    l_uint32            refcount;   /*!< reference count (1 if no clones)  */
    struct FPix       **fpix;       /*!< the array of ptrs to fpix         */
};
typedef struct FPixa FPIXA;


/*-------------------------------------------------------------------------*
 *                       DPix: pix with double array                       *
 *-------------------------------------------------------------------------*/
#define  DPIX_VERSION_NUMBER      2 /*!< Version for DPix serialization    */

/*! Pix with double array */
struct DPix
{
    l_int32              w;         /*!< width in pixels                   */
    l_int32              h;         /*!< height in pixels                  */
    l_int32              wpl;       /*!< 32-bit words/line                 */
    l_uint32             refcount;  /*!< reference count (1 if no clones)  */
    l_int32              xres;      /*!< image res (ppi) in x direction    */
                                    /*!< (use 0 if unknown)                */
    l_int32              yres;      /*!< image res (ppi) in y direction    */
                                    /*!< (use 0 if unknown)                */
    l_float64           *data;      /*!< the double image data             */
};
typedef struct DPix DPIX;


/*-------------------------------------------------------------------------*
 *                        PixComp: compressed pix                          *
 *-------------------------------------------------------------------------*/

/*! Compressed Pix */
struct PixComp
{
    l_int32              w;         /*!< width in pixels                   */
    l_int32              h;         /*!< height in pixels                  */
    l_int32              d;         /*!< depth in bits                     */
    l_int32              xres;      /*!< image res (ppi) in x direction    */
                                    /*!<   (use 0 if unknown)              */
    l_int32              yres;      /*!< image res (ppi) in y direction    */
                                    /*!<   (use 0 if unknown)              */
    l_int32              comptype;  /*!< compressed format (IFF_TIFF_G4,   */
                                    /*!<   IFF_PNG, IFF_JFIF_JPEG)         */
    char                *text;      /*!< text string associated with pix   */
    l_int32              cmapflag;  /*!< flag (1 for cmap, 0 otherwise)    */
    l_uint8             *data;      /*!< the compressed image data         */
    size_t               size;      /*!< size of the data array            */
};
typedef struct PixComp PIXC;


/*-------------------------------------------------------------------------*
 *                     PixaComp: array of compressed pix                   *
 *-------------------------------------------------------------------------*/
#define  PIXACOMP_VERSION_NUMBER 2  /*!< Version for PixaComp serialization */

/*! Array of compressed pix */
struct PixaComp
{
    l_int32              n;         /*!< number of PixComp in ptr array    */
    l_int32              nalloc;    /*!< number of PixComp ptrs allocated  */
    l_int32              offset;    /*!< indexing offset into ptr array    */
    struct PixComp     **pixc;      /*!< the array of ptrs to PixComp      */
    struct Boxa         *boxa;      /*!< array of boxes                    */
};
typedef struct PixaComp PIXAC;


/*-------------------------------------------------------------------------*
 *                         Access and storage flags                        *
 *-------------------------------------------------------------------------*/
/*
 * <pre>
 *  For Pix, Box, Pta and Numa, there are 3 standard methods for handling
 *  the retrieval or insertion of a struct:
 *     (1) direct insertion (Don't do this if there is another handle
 *                           somewhere to this same struct!)
 *     (2) copy (Always safe, sets up a refcount of 1 on the new object.
 *               Can be undesirable if very large, such as an image or
 *               an array of images.)
 *     (3) clone (Makes another handle to the same struct, and bumps the
 *                refcount up by 1.  Safe to do unless you're changing
 *                data through one of the handles but don't want those
 *                changes to be seen by the other handle.)
 *
 *  For Pixa and Boxa, which are structs that hold an array of clonable
 *  structs, there is an additional method:
 *     (4) copy-clone (Makes a new higher-level struct with a refcount
 *                     of 1, but clones all the structs in the array.)
 *
 *  Unlike the other structs, when retrieving a string from an Sarray,
 *  you are allowed to get a handle without a copy or clone (i.e., that
 *  you don't own!).  You must not free or insert such a string!
 *  Specifically, for an Sarray, the copyflag for retrieval is either:
 *         L_COPY or L_NOCOPY
 *  and for insertion, the copyflag is either:
 *         L_COPY or one of {L_INSERT , L_NOCOPY} (the latter are equivalent
 *                                                 for insertion))
 * </pre>
 */

/*! Access and storage flags */
enum {
    L_NOCOPY = 0,     /*!< do not copy the object; do not delete the ptr  */
    L_COPY = 1,       /*!< make/use a copy of the object                  */
    L_CLONE = 2,      /*!< make/use clone (ref count) of the object       */
    L_COPY_CLONE = 3  /*!< make a new object and fill each object in the  */
                      /*!< array(s) with clones                           */
};
static const l_int32  L_INSERT = 0;  /*!< stuff it in; no copy or clone   */


/*----------------------------------------------------------------------------*
 *                              Sort flags                                    *
 *----------------------------------------------------------------------------*/

/*! Sort mode flags */
enum {
    L_SHELL_SORT = 1,            /*!< use shell sort                        */
    L_BIN_SORT = 2               /*!< use bin sort                          */
};

/*! Sort order flags */
enum {
    L_SORT_INCREASING = 1,       /*!< sort in increasing order              */
    L_SORT_DECREASING = 2        /*!< sort in decreasing order              */
};

/*! Sort type flags */
enum {
    L_SORT_BY_X = 1,             /*!< sort box or c.c. by left edge location  */
    L_SORT_BY_Y = 2,             /*!< sort box or c.c. by top edge location   */
    L_SORT_BY_RIGHT = 3,         /*!< sort box or c.c. by right edge location */
    L_SORT_BY_BOT = 4,           /*!< sort box or c.c. by bot edge location   */
    L_SORT_BY_WIDTH = 5,         /*!< sort box or c.c. by width               */
    L_SORT_BY_HEIGHT = 6,        /*!< sort box or c.c. by height              */
    L_SORT_BY_MIN_DIMENSION = 7, /*!< sort box or c.c. by min dimension       */
    L_SORT_BY_MAX_DIMENSION = 8, /*!< sort box or c.c. by max dimension       */
    L_SORT_BY_PERIMETER = 9,     /*!< sort box or c.c. by perimeter           */
    L_SORT_BY_AREA = 10,         /*!< sort box or c.c. by area                */
    L_SORT_BY_ASPECT_RATIO = 11  /*!< sort box or c.c. by width/height ratio  */
};


/*---------------------------------------------------------------------------*
 *                             Blend flags                                   *
 *---------------------------------------------------------------------------*/

/*! Blend flags */
enum {
    L_BLEND_WITH_INVERSE = 1,     /*!< add some of src inverse to itself     */
    L_BLEND_TO_WHITE = 2,         /*!< shift src colors towards white        */
    L_BLEND_TO_BLACK = 3,         /*!< shift src colors towards black        */
    L_BLEND_GRAY = 4,             /*!< blend src directly with blender       */
    L_BLEND_GRAY_WITH_INVERSE = 5 /*!< add amount of src inverse to itself,  */
                                  /*!< based on blender pix value            */
};

enum {
    L_PAINT_LIGHT = 1,            /*!< colorize non-black pixels             */
    L_PAINT_DARK = 2              /*!< colorize non-white pixels             */
};


/*-------------------------------------------------------------------------*
 *                        Graphics pixel setting                           *
 *-------------------------------------------------------------------------*/

/*! Graphics pixel setting */
enum {
    L_SET_PIXELS = 1,           /*!< set all bits in each pixel to 1       */
    L_CLEAR_PIXELS = 2,         /*!< set all bits in each pixel to 0       */
    L_FLIP_PIXELS = 3           /*!< flip all bits in each pixel           */
};


/*-------------------------------------------------------------------------*
 *                     Size and location filter flags                      *
 *-------------------------------------------------------------------------*/

/*! Location filter flags */
enum {
    L_SELECT_WIDTH = 1,         /*!< width must satisfy constraint         */
    L_SELECT_HEIGHT = 2,        /*!< height must satisfy constraint        */
    L_SELECT_XVAL = 3,          /*!< x value satisfy constraint            */
    L_SELECT_YVAL = 4,          /*!< y value must satisfy constraint       */
    L_SELECT_IF_EITHER = 5,     /*!< either width or height (or xval       */
                                /*!< or yval) can satisfy                  */
    L_SELECT_IF_BOTH = 6        /*!< both width and height (or xval        */
                                /*!< and yval must satisfy                 */
};

/*! Size filter flags */
enum {
    L_SELECT_IF_LT = 1,         /*!< save if value is less than threshold  */
    L_SELECT_IF_GT = 2,         /*!< save if value is more than threshold  */
    L_SELECT_IF_LTE = 3,        /*!< save if value is <= to the threshold  */
    L_SELECT_IF_GTE = 4         /*!< save if value is >= to the threshold  */
};


/*-------------------------------------------------------------------------*
 *                    Color component selection flags                      *
 *-------------------------------------------------------------------------*/

/*! Color component selection flags */
enum {
    L_SELECT_RED = 1,           /*!< use red component                     */
    L_SELECT_GREEN = 2,         /*!< use green component                   */
    L_SELECT_BLUE = 3,          /*!< use blue component                    */
    L_SELECT_MIN = 4,           /*!< use min color component               */
    L_SELECT_MAX = 5,           /*!< use max color component               */
    L_SELECT_AVERAGE = 6,       /*!< use average of color components       */
    L_SELECT_HUE = 7,           /*!< use hue value (in HSV color space)    */
    L_SELECT_SATURATION = 8     /*!< use saturation value (in HSV space)   */
};


/*-------------------------------------------------------------------------*
 *                         16-bit conversion flags                         *
 *-------------------------------------------------------------------------*/

/*! 16-bit conversion flags */
enum {
    L_LS_BYTE = 1,              /*!< use LSB                               */
    L_MS_BYTE = 2,              /*!< use MSB                               */
    L_AUTO_BYTE = 3,            /*!< use LSB if max(val) < 256; else MSB   */
    L_CLIP_TO_FF = 4,           /*!< use max(val, 255)                     */
    L_LS_TWO_BYTES = 5,         /*!< use two LSB                           */
    L_MS_TWO_BYTES = 6,         /*!< use two MSB                           */
    L_CLIP_TO_FFFF = 7          /*!< use max(val, 65535)                   */
};


/*-------------------------------------------------------------------------*
 *                        Rotate and shear flags                           *
 *-------------------------------------------------------------------------*/

/*! Rotate flags */
enum {
    L_ROTATE_AREA_MAP = 1,     /*!< use area map rotation, if possible     */
    L_ROTATE_SHEAR = 2,        /*!< use shear rotation                     */
    L_ROTATE_SAMPLING = 3      /*!< use sampling                           */
};

/*! Background flags */
enum {
    L_BRING_IN_WHITE = 1,      /*!< bring in white pixels from the outside */
    L_BRING_IN_BLACK = 2       /*!< bring in black pixels from the outside */
};

/*! Shear flags */
enum {
    L_SHEAR_ABOUT_CORNER = 1,  /*!< shear image about UL corner            */
    L_SHEAR_ABOUT_CENTER = 2   /*!< shear image about center               */
};


/*-------------------------------------------------------------------------*
 *                     Affine transform order flags                        *
 *-------------------------------------------------------------------------*/

/*! Affine transform order flags */
enum {
    L_TR_SC_RO = 1,            /*!< translate, scale, rotate               */
    L_SC_RO_TR = 2,            /*!< scale, rotate, translate               */
    L_RO_TR_SC = 3,            /*!< rotate, translate, scale               */
    L_TR_RO_SC = 4,            /*!< translate, rotate, scale               */
    L_RO_SC_TR = 5,            /*!< rotate, scale, translate               */
    L_SC_TR_RO = 6             /*!< scale, translate, rotate               */
};


/*-------------------------------------------------------------------------*
 *                       Grayscale filling flags                           *
 *-------------------------------------------------------------------------*/

/*! Grayscale filling flags */
enum {
    L_FILL_WHITE = 1,         /*!< fill white pixels (e.g, in fg map)      */
    L_FILL_BLACK = 2          /*!< fill black pixels (e.g., in bg map)     */
};


/*-------------------------------------------------------------------------*
 *                   Flags for setting to white or black                   *
 *-------------------------------------------------------------------------*/

/*! Flags for setting to white or black */
enum {
    L_SET_WHITE = 1,         /*!< set pixels to white                      */
    L_SET_BLACK = 2          /*!< set pixels to black                      */
};


/*-------------------------------------------------------------------------*
 *                  Flags for getting white or black value                 *
 *-------------------------------------------------------------------------*/

/*! Flags for getting white or black value */
enum {
    L_GET_WHITE_VAL = 1,     /*!< get white pixel value                    */
    L_GET_BLACK_VAL = 2      /*!< get black pixel value                    */
};


/*-------------------------------------------------------------------------*
 *                  Flags for 8 bit and 16 bit pixel sums                  *
 *-------------------------------------------------------------------------*/

/*! Flags for 8 bit and 16 bit pixel sums */
enum {
    L_WHITE_IS_MAX = 1, /*!< white pixels are 0xff or 0xffff; black are 0  */
    L_BLACK_IS_MAX = 2  /*!< black pixels are 0xff or 0xffff; white are 0  */
};


/*-------------------------------------------------------------------------*
 *                           Dither parameters                             *
 *         If within this grayscale distance from black or white,          *
 *         do not propagate excess or deficit to neighboring pixels.       *
 *-------------------------------------------------------------------------*/

/*! Dither parameters */
enum {
    DEFAULT_CLIP_LOWER_1 = 10, /*!< dist to black with no prop; 1 bpp      */
    DEFAULT_CLIP_UPPER_1 = 10, /*!< dist to black with no prop; 1 bpp      */
    DEFAULT_CLIP_LOWER_2 = 5,  /*!< dist to black with no prop; 2 bpp      */
    DEFAULT_CLIP_UPPER_2 = 5   /*!< dist to black with no prop; 2 bpp      */
};


/*-------------------------------------------------------------------------*
 *                             Distance flags                              *
 *-------------------------------------------------------------------------*/

/*! Distance flags */
enum {
    L_MANHATTAN_DISTANCE = 1,  /*!< L1 distance (e.g., in color space)     */
    L_EUCLIDEAN_DISTANCE = 2   /*!< L2 distance                            */
};


/*-------------------------------------------------------------------------*
 *                               Value flags                               *
 *-------------------------------------------------------------------------*/

/*! Value flags */
enum {
    L_NEGATIVE = 1,      /*!< values < 0                                   */
    L_NON_NEGATIVE = 2,  /*!< values >= 0                                  */
    L_POSITIVE = 3,      /*!< values > 0                                   */
    L_NON_POSITIVE = 4,  /*!< values <= 0                                  */
    L_ZERO = 5,          /*!< values = 0                                   */
    L_ALL = 6            /*!< all values                                   */
};


/*-------------------------------------------------------------------------*
 *                         Statistical measures                            *
 *-------------------------------------------------------------------------*/

/*! Statistical measures */
enum {
    L_MEAN_ABSVAL = 1,         /*!< average of abs values                  */
    L_MEDIAN_VAL = 2,          /*!< median value of set                    */
    L_MODE_VAL = 3,            /*!< mode value of set                      */
    L_MODE_COUNT = 4,          /*!< mode count of set                      */
    L_ROOT_MEAN_SQUARE = 5,    /*!< rms of values                          */
    L_STANDARD_DEVIATION = 6,  /*!< standard deviation from mean           */
    L_VARIANCE = 7             /*!< variance of values                     */
};


/*-------------------------------------------------------------------------*
 *                          Set selection flags                            *
 *-------------------------------------------------------------------------*/

/*! Set selection flags */
enum {
    L_CHOOSE_CONSECUTIVE = 1,  /*!< select 'n' consecutive                 */
    L_CHOOSE_SKIP_BY = 2       /*!< select at intervals of 'n'             */
};


/*-------------------------------------------------------------------------*
 *                         Text orientation flags                          *
 *-------------------------------------------------------------------------*/

/*! Text orientation flags */
enum {
    L_TEXT_ORIENT_UNKNOWN = 0, /*!< low confidence on text orientation     */
    L_TEXT_ORIENT_UP = 1,      /*!< portrait, text rightside-up            */
    L_TEXT_ORIENT_LEFT = 2,    /*!< landscape, text up to left             */
    L_TEXT_ORIENT_DOWN = 3,    /*!< portrait, text upside-down             */
    L_TEXT_ORIENT_RIGHT = 4    /*!< landscape, text up to right            */
};


/*-------------------------------------------------------------------------*
 *                         Edge orientation flags                          *
 *-------------------------------------------------------------------------*/

/*! Edge orientation flags */
enum {
    L_HORIZONTAL_EDGES = 0,   /*!< filters for horizontal edges            */
    L_VERTICAL_EDGES = 1,     /*!< filters for vertical edges              */
    L_ALL_EDGES = 2           /*!< filters for all edges                   */
};


/*-------------------------------------------------------------------------*
 *                         Line orientation flags                          *
 *-------------------------------------------------------------------------*/

/*! Line orientation flags */
enum {
    L_HORIZONTAL_LINE = 0,   /*!< horizontal line                          */
    L_POS_SLOPE_LINE = 1,    /*!< 45 degree line with positive slope       */
    L_VERTICAL_LINE = 2,     /*!< vertical line                            */
    L_NEG_SLOPE_LINE = 3,    /*!< 45 degree line with negative slope       */
    L_OBLIQUE_LINE = 4       /*!< neither horizontal nor vertical */
};


/*-------------------------------------------------------------------------*
 *                         Image orientation flags                         *
 *-------------------------------------------------------------------------*/

/*! Image orientation flags */
enum {
    L_PORTRAIT_MODE = 0,   /*!< typical: page is viewed with height > width  */
    L_LANDSCAPE_MODE = 1   /*!< page is viewed at 90 deg to portrait mode    */
};


/*-------------------------------------------------------------------------*
 *                           Scan direction flags                          *
 *-------------------------------------------------------------------------*/

/*! Scan direction flags */
enum {
    L_FROM_LEFT = 0,         /*!< scan from left                           */
    L_FROM_RIGHT = 1,        /*!< scan from right                          */
    L_FROM_TOP = 2,          /*!< scan from top                            */
    L_FROM_BOT = 3,          /*!< scan from bottom                         */
    L_SCAN_NEGATIVE = 4,     /*!< scan in negative direction               */
    L_SCAN_POSITIVE = 5,     /*!< scan in positive direction               */
    L_SCAN_BOTH = 6,         /*!< scan in both directions                  */
    L_SCAN_HORIZONTAL = 7,   /*!< horizontal scan (direction unimportant)  */
    L_SCAN_VERTICAL = 8      /*!< vertical scan (direction unimportant)    */
};


/*-------------------------------------------------------------------------*
 *                Box size adjustment and location flags                   *
 *-------------------------------------------------------------------------*/

/*! Box size adjustment and location flags */
enum {
    L_ADJUST_SKIP = 0,           /*!< do not adjust                        */
    L_ADJUST_LEFT = 1,           /*!< adjust left edge                     */
    L_ADJUST_RIGHT = 2,          /*!< adjust right edge                    */
    L_ADJUST_LEFT_AND_RIGHT = 3, /*!< adjust both left and right edges     */
    L_ADJUST_TOP = 4,            /*!< adjust top edge                      */
    L_ADJUST_BOT = 5,            /*!< adjust bottom edge                   */
    L_ADJUST_TOP_AND_BOT = 6,    /*!< adjust both top and bottom edges     */
    L_ADJUST_CHOOSE_MIN = 7,     /*!< choose the min median value          */
    L_ADJUST_CHOOSE_MAX = 8,     /*!< choose the max median value          */
    L_SET_LEFT = 9,              /*!< set left side to a given value       */
    L_SET_RIGHT = 10,            /*!< set right side to a given value      */
    L_SET_TOP = 11,              /*!< set top side to a given value        */
    L_SET_BOT = 12,              /*!< set bottom side to a given value     */
    L_GET_LEFT = 13,             /*!< get left side location               */
    L_GET_RIGHT = 14,            /*!< get right side location              */
    L_GET_TOP = 15,              /*!< get top side location                */
    L_GET_BOT = 16               /*!< get bottom side location             */
};


/*-------------------------------------------------------------------------*
 *          Flags for modifying box boundaries using a second box          *
 *-------------------------------------------------------------------------*/

/*! Flags for modifying box boundaries using a second box */
enum {
    L_USE_MINSIZE = 1,           /*!< use boundaries giving min size       */
    L_USE_MAXSIZE = 2,           /*!< use boundaries giving max size       */
    L_SUB_ON_LOC_DIFF = 3,       /*!< modify boundary if big location diff */
    L_SUB_ON_SIZE_DIFF = 4,      /*!< modify boundary if big size diff     */
    L_USE_CAPPED_MIN = 5,        /*!< modify boundary with capped min      */
    L_USE_CAPPED_MAX = 6         /*!< modify boundary with capped max      */
};

/*-------------------------------------------------------------------------*
 *              Handling overlapping bounding boxes in boxa                *
 *-------------------------------------------------------------------------*/

/*! Handling overlapping bounding boxes in Boxa */
enum {
    L_COMBINE = 1,         /*!< resize to bounding region; remove smaller  */
    L_REMOVE_SMALL = 2     /*!< only remove smaller                        */
};

/*-------------------------------------------------------------------------*
 *                    Flags for replacing invalid boxes                    *
 *-------------------------------------------------------------------------*/

/*! Flags for replacing invalid boxes */
enum {
    L_USE_ALL_BOXES = 1,         /*!< consider all boxes in the sequence   */
    L_USE_SAME_PARITY_BOXES = 2  /*!< consider boxes with the same parity  */
};

/*-------------------------------------------------------------------------*
 *                            Horizontal warp                              *
 *-------------------------------------------------------------------------*/

/*! Horizonal warp direction */
enum {
    L_WARP_TO_LEFT = 1,    /*!< increasing stretch or contraction to left  */
    L_WARP_TO_RIGHT = 2    /*!< increasing stretch or contraction to right */
};

/*! Horizonal warp stretch mode */
enum {
    L_LINEAR_WARP = 1,     /*!< stretch or contraction grows linearly      */
    L_QUADRATIC_WARP = 2   /*!< stretch or contraction grows quadratically */
};


/*-------------------------------------------------------------------------*
 *                      Pixel selection for resampling                     *
 *-------------------------------------------------------------------------*/

/*! Pixel selection for resampling */
enum {
    L_INTERPOLATED = 1,    /*!< linear interpolation from src pixels       */
    L_SAMPLED = 2          /*!< nearest src pixel sampling only            */
};


/*-------------------------------------------------------------------------*
 *                             Thinning flags                              *
 *-------------------------------------------------------------------------*/

/*! Thinning flags */
enum {
    L_THIN_FG = 1,             /*!< thin foreground of 1 bpp image         */
    L_THIN_BG = 2              /*!< thin background of 1 bpp image         */
};


/*-------------------------------------------------------------------------*
 *                            Runlength flags                              *
 *-------------------------------------------------------------------------*/

/*! Runlength flags */
enum {
    L_HORIZONTAL_RUNS = 0,   /*!< determine runlengths of horizontal runs  */
    L_VERTICAL_RUNS = 1      /*!< determine runlengths of vertical runs    */
};


/*-------------------------------------------------------------------------*
 *                          Edge filter flags                              *
 *-------------------------------------------------------------------------*/

/*! Edge filter flags */
enum {
    L_SOBEL_EDGE = 1,        /*!< Sobel edge filter                        */
    L_TWO_SIDED_EDGE = 2     /*!< Two-sided edge filter                    */
};


/*-------------------------------------------------------------------------*
 *             Subpixel color component ordering in LCD display            *
 *-------------------------------------------------------------------------*/

/*! Subpixel color component ordering in LC display */
enum {
    L_SUBPIXEL_ORDER_RGB = 1,   /*!< sensor order left-to-right RGB        */
    L_SUBPIXEL_ORDER_BGR = 2,   /*!< sensor order left-to-right BGR        */
    L_SUBPIXEL_ORDER_VRGB = 3,  /*!< sensor order top-to-bottom RGB        */
    L_SUBPIXEL_ORDER_VBGR = 4   /*!< sensor order top-to-bottom BGR        */
};


/*-------------------------------------------------------------------------*
 *                          HSV histogram flags                            *
 *-------------------------------------------------------------------------*/

/*! HSV histogram flags */
enum {
    L_HS_HISTO = 1,            /*!< Use hue-saturation histogram           */
    L_HV_HISTO = 2,            /*!< Use hue-value histogram                */
    L_SV_HISTO = 3             /*!< Use saturation-value histogram         */
};


/*-------------------------------------------------------------------------*
 *                    Region flags (inclusion, exclusion)                  *
 *-------------------------------------------------------------------------*/

/*! Region flags (inclusion, exclusion) */
enum {
    L_INCLUDE_REGION = 1,      /*!< Use hue-saturation histogram           */
    L_EXCLUDE_REGION = 2       /*!< Use hue-value histogram                */
};


/*-------------------------------------------------------------------------*
 *                    Flags for adding text to a pix                       *
 *-------------------------------------------------------------------------*/

/*! Flags for adding text to a Pix */
enum {
    L_ADD_ABOVE = 1,           /*!< Add text above the image               */
    L_ADD_BELOW = 2,           /*!< Add text below the image               */
    L_ADD_LEFT = 3,            /*!< Add text to the left of the image      */
    L_ADD_RIGHT = 4,           /*!< Add text to the right of the image     */
    L_ADD_AT_TOP = 5,          /*!< Add text over the top of the image     */
    L_ADD_AT_BOT = 6,          /*!< Add text over the bottom of the image  */
    L_ADD_AT_LEFT = 7,         /*!< Add text over left side of the image   */
    L_ADD_AT_RIGHT = 8         /*!< Add text over right side of the image  */
};


/*-------------------------------------------------------------------------*
 *                       Flags for plotting on a pix                       *
 *-------------------------------------------------------------------------*/

/*! Flags for plotting on a Pix */
enum {
    L_PLOT_AT_TOP = 1,         /*!< Plot horizontally at top               */
    L_PLOT_AT_MID_HORIZ = 2,   /*!< Plot horizontally at middle            */
    L_PLOT_AT_BOT = 3,         /*!< Plot horizontally at bottom            */
    L_PLOT_AT_LEFT = 4,        /*!< Plot vertically at left                */
    L_PLOT_AT_MID_VERT = 5,    /*!< Plot vertically at middle              */
    L_PLOT_AT_RIGHT = 6        /*!< Plot vertically at right               */
};


/*-------------------------------------------------------------------------*
 *                   Flags for selecting display program                   *
 *-------------------------------------------------------------------------*/

/*! Flags for selecting display program */
enum {
    L_DISPLAY_WITH_XZGV = 1,  /*!< Use xzgv with pixDisplay()              */
    L_DISPLAY_WITH_XLI = 2,   /*!< Use xli with pixDisplay()               */
    L_DISPLAY_WITH_XV = 3,    /*!< Use xv with pixDisplay()                */
    L_DISPLAY_WITH_IV = 4,    /*!< Use irfvanview (win) with pixDisplay()  */
    L_DISPLAY_WITH_OPEN = 5   /*!< Use open (apple) with pixDisplay()      */
};

/*-------------------------------------------------------------------------*
 *    Flag(s) used in the 'special' pix field for non-default operations   *
 *      - 0 is default for chroma sampling in jpeg                         *
 *      - 10-19 are used for zlib compression in png write                 *
 *      - 4 and 8 are used for specifying connectivity in labelling        *
 *-------------------------------------------------------------------------*/

/*! Flags used in Pix::special */
enum {
    L_NO_CHROMA_SAMPLING_JPEG = 1   /*!< Write full resolution chroma      */
};


/*-------------------------------------------------------------------------*
 *          Handling negative values in conversion to unsigned int         *
 *-------------------------------------------------------------------------*/

/*! Handling negative values in conversion to unsigned int */
enum {
    L_CLIP_TO_ZERO = 1,      /*!< Clip negative values to 0                */
    L_TAKE_ABSVAL = 2        /*!< Convert to positive using L_ABS()        */
};


/*-------------------------------------------------------------------------*
 *                        Relative to zero flags                           *
 *-------------------------------------------------------------------------*/

/*! Relative to zero flags */
enum {
    L_LESS_THAN_ZERO = 1,    /*!< Choose values less than zero             */
    L_EQUAL_TO_ZERO = 2,     /*!< Choose values equal to zero              */
    L_GREATER_THAN_ZERO = 3  /*!< Choose values greater than zero          */
};


/*-------------------------------------------------------------------------*
 *         Flags for adding or removing traling slash from string          *
 *-------------------------------------------------------------------------*/

/*! Flags for adding or removing traling slash from string */
enum {
    L_ADD_TRAIL_SLASH = 1,     /*!< Add trailing slash to string           */
    L_REMOVE_TRAIL_SLASH = 2   /*!< Remove trailing slash from string      */
};


/*-------------------------------------------------------------------------*
 *               Pix allocator and deallocator function types              *
 *-------------------------------------------------------------------------*/
/*! Allocator function type */
typedef void *(*alloc_fn)(size_t);

/*! Deallocator function type */
typedef void (*dealloc_fn)(void *);


#endif  /* LEPTONICA_PIX_H */
