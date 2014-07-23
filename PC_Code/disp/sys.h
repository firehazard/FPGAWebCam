/*
 *  sys.h
 *
 *  Header file for system routines.
 *
 *  Kekoa Proudfoot
 *  8/26/99
 */

#ifndef SYS_H_INCLUDED
#define SYS_H_INCLUDED

extern void *allocate (int size);
extern void *reallocate (void *ptr, int size);
extern void deallocate (void *ptr);

extern char *duplicate (const char *string);

extern void warn (char *fmt, ...);
extern void fatal (char *fmt, ...);

#endif /* SYS_H_INCLUDED */
