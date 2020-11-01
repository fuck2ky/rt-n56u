/* Copyright (C) 1997, 1999, 2001 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, see
   <http://www.gnu.org/licenses/>.  */

#ifndef _SYS_UCONTEXT_H
#define _SYS_UCONTEXT_H	1

#include <features.h>
#include <signal.h>
#include <bits/sigcontext.h>

/* A machine context is exactly a sigcontext.  */
typedef struct sigcontext mcontext_t;

/* Userlevel context.  */
typedef struct ucontext
{
	unsigned long    uc_flags;
	struct ucontext *uc_link;
	stack_t          uc_stack;
	mcontext_t       uc_mcontext;
	__sigset_t       uc_sigmask;
} ucontext_t;

#endif /* sys/ucontext.h */
