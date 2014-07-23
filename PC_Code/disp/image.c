/*
 *  image.c
 *
 *  Image routines.  Supports binary grey/color ppm files.
 *
 *  For lack of anything as quick to implement, allow P7 for 16-bit 
 *  luminance-alpha images, and allow P8 for 32-bit rgba images.
 *
 *  Kekoa Proudfoot
 *  8/26/99
 */

#include <assert.h>
#include <stdio.h>

#include "sys.h"
#include "image.h"

image_t *
image_alloc (int width, int height, int components)
{
    image_t *image = (image_t *)allocate(sizeof(image_t));

    assert(components >= 1 && components <= 4);

    image->width = width;
    image->height = height;
    image->components = components;
    image->pixels = (char *)allocate(width * height * components);

    return image;
}

void
image_free (image_t *image)
{
    deallocate(image->pixels);
    deallocate(image);
}

image_t *
image_readpnm (char *name)
{
    FILE *file;
    char magic[2], c;
    int max;
    int w, h, n, y;
    image_t *image;

    if (name) {
	if (!(file = fopen(name, "rb")))
	    fatal("%s: couldn't open for reading\n", name);
    }
    else {
	name = "stdin";
	file = stdin;
    }

    if (fscanf(file, "%c%c\n", &magic[0], &magic[1]) != 2)
	fatal("%s: bad magic number\n", name);

    if (magic[0] != 'P')
	fatal("%s: not a recognized pnm format\n", name);

    switch (magic[1]) {
    case '5': n = 1; break;
    case '6': n = 3; break;
    case '7': n = 2; break;
    case '8': n = 4; break;
    default:
	fatal("%s: not a recognized pnm format\n", name);
    }

    while ((c = getc(file)) == '#')
	fscanf(file, "%*[^\n]\n");

    ungetc(c, file);

    if (fscanf(file, "%d%d%d%c", &w, &h, &max, &c) != 4)
	fatal("%s: bad pnm header\n", name);

    if (w <= 0 || h <= 0)
	fatal("%s: bad image size\n", name);

    if (max != 255)
	fatal("%s: bad image max\n", name);

    image = image_alloc(w, h, n);

    for (y = h - 1; y >= 0; y--)
	if (fread(&image->pixels[y * w * n], w, n, file) != n)
	    fatal("%s: unexpected end of file\n", name);

    fclose(file);

    return image;
}

void
image_writepnm (image_t *image, char *name)
{
    int w = image->width;
    int h = image->height;
    int n = image->components;
    int c;
    int y;
    FILE *file;

    if (!(file = fopen(name, "wb")))
	fatal("%s: couldn't open for writing\n");

    c = (n == 1) ? '5' : (n == 2) ? '7' : (n == 3) ? '6' : '8';

    fprintf(file, "P%c\n%d %d\n%d\n", c, w, h, 255);

    for (y = h - 1; y >= 0; y--)
	fwrite(&image->pixels[y * w * n], w, n, file);

    fclose(file);
}
