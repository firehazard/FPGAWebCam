/*
 *  image.h
 *
 *  Image routines.  Supports pnm files with 1-4 color channels.
 *
 *  Formats with 2 channels use P7 header, formats with 4 channels use P8
 *  header.
 *
 *  Kekoa Proudfoot
 *  8/26/99
 */

#ifndef IMAGE_H_INCLUDED
#define IMAGE_H_INCLUDED

typedef struct {
    int width;
    int height;
    int components;
    char *pixels;
} image_t;

extern image_t *image_alloc (int width, int height, int components);
extern void image_free (image_t *image);

extern image_t *image_readpnm (char *name);
extern void image_writepnm (image_t *image, char *name);

#endif /* IMAGE_H_INCLUDED */
