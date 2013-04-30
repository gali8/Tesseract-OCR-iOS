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

#ifndef  LEPTONICA_BMP_H
#define  LEPTONICA_BMP_H

/*
 * This file is here to describe the fields in the header of
 * the BMP file.  These fields are not used directly in Leptonica.
 * The only thing we use are the sizes of these two headers.
 * Furthermore, because of potential namespace conflicts with
 * the typedefs and defined sizes, we have changed the names
 * to protect anyone who may also need to use the original definitions.
 * Thanks to J. D. Bryan for pointing out the potential problems when
 * developing on Win32 compatible systems.
 */

/*-------------------------------------------------------------*
 *                       BMP file header                       *
 *-------------------------------------------------------------*/
struct BMP_FileHeader
{
    l_int16        bfType;                /* file type; must be "BM" */
    l_int16        bfSize;                /* length of the file;
                                   sizeof(BMP_FileHeader) +
                                   sizeof(BMP_InfoHeader) +
                                   size of color table +
                                   size of DIB bits */
    l_int16        bfFill1;        /* remainder of the bfSize field */
    l_int16        bfReserved1;        /* don't care (set to 0)*/
    l_int16        bfReserved2;        /* don't care (set to 0)*/
    l_int16        bfOffBits;        /* offset from beginning of file */
    l_int16        bfFill2;        /* remainder of the bfOffBits field */
};
typedef struct BMP_FileHeader  BMP_FH;

#define BMP_FHBYTES  sizeof(BMP_FH)


/*-------------------------------------------------------------*
 *                       BMP info header                       *
 *-------------------------------------------------------------*/
struct BMP_InfoHeader
{
    l_int32        biSize;                  /* size of the BMP_InfoHeader struct */
    l_int32        biWidth;         /* bitmap width in pixels */
    l_int32        biHeight;         /* bitmap height in pixels */
    l_int16        biPlanes;         /* number of bitmap planes */
    l_int16        biBitCount;         /* number of bits per pixel */
    l_int32        biCompression;         /* compression format (0 == uncompressed) */
    l_int32        biSizeImage;         /* size of image in bytes */
    l_int32        biXPelsPerMeter; /* pixels per meter in x direction */
    l_int32        biYPelsPerMeter; /* pixels per meter in y direction */
    l_int32        biClrUsed;          /* number of colors used */
    l_int32        biClrImportant;         /* number of important colors used */
};
typedef struct BMP_InfoHeader  BMP_IH;

#define BMP_IHBYTES  sizeof(BMP_IH)

 
#endif  /* LEPTONICA_BMP_H */
