/*
 *  sys.c
 *
 *  System routines, including memory allocation and error reporting.
 *
 *  Kekoa Proudfoot
 *  8/26/99
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <assert.h>

#include "sys.h"

/* Memory allocation */

void *
allocate (int size)
{
    void *ptr = (void *)malloc(size);
    if (!ptr)
	fatal("allocate: failed to malloc %d bytes\n", size);
    return ptr;
}

void *
reallocate (void *ptr, int size)
{
    ptr = (void *)realloc(ptr, size);
    if (size && !ptr)
        fatal("reallocate: failed to realloc %d bytes\n", size);
    return ptr;
}

void
deallocate (void *ptr)
{
    free(ptr);
}

char *
duplicate (const char *string)
{
    char *ptr = (char *)allocate(strlen(string) + 1);
    strcpy(ptr, string);
    return ptr;
}

/* Error reporting */

void
warn (char *fmt, ...)
{
    va_list arglist;
    va_start(arglist, fmt);
    vfprintf(stderr, fmt, arglist);
    va_end(arglist);
#ifdef WIN32
    fflush(stderr);
#endif
}

void
fatal (char *fmt, ...)
{
    va_list arglist;
    va_start(arglist, fmt);
    vfprintf(stderr, fmt, arglist);
    va_end(arglist);
    exit(1);
}
