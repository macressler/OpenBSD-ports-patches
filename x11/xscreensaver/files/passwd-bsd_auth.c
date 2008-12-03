/* $OpenBSD: passwd-bsd_auth.c,v 1.3 2008/11/04 15:28:41 ajacoutot Exp $
 * passwd-bsd_auth.c --- verifying typed passwords with bsd_auth(3)
 *
 * Copyright (c) 2008 Antoine Jacoutot <ajacoutot@openbsd.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#ifdef HAVE_CONFIG_H
# include "config.h"
#endif

#ifndef NO_LOCKING  /* whole file */

#include <stdio.h>
#include <signal.h>
#include <stdlib.h>
#include <string.h>
#ifdef HAVE_UNISTD_H
# include <unistd.h>
#endif
#include <pwd.h>
#include <sys/types.h>

#include <login_cap.h>
#include <bsd_auth.h>

/* xscreensaver.h */
#ifdef HAVE_SIGACTION
 extern sigset_t block_sigchld (void);
#else  /* !HAVE_SIGACTION */
 extern int block_sigchld (void);
#endif /* !HAVE_SIGACTION */
extern void unblock_sigchld (void);

extern int bsdauth_passwd_valid_p (const char *typed_passwd, int verbose_p);

int
bsdauth_passwd_valid_p (const char *typed_passwd, int verbose_p)
{
  int res;
  struct passwd *pw;

  pw = getpwuid(getuid());

  if (pw != NULL) {
    block_sigchld();

/*
XXX It should be possible to specify an authentication style by
appending it to the user's name with a single colon (`:') as a separator
but xscreensaver does not allow to modify username (yet?).
*/
#ifdef ALLOW_ROOT_PASSWD
    res = (auth_userokay(pw->pw_name, NULL, "auth-xscreensaver", typed_passwd)) ||
          (auth_userokay("root", "passwd", "auth-xscreensaver", typed_passwd));
#else
    res = (auth_userokay(pw->pw_name, NULL, "auth-xscreensaver", typed_passwd));
#endif

    unblock_sigchld();

  if (res)
    return 1;
  else
    return 0;
  } else {
    fprintf(stderr, "getpwuid: couldn't get user ID.\n");
    return 0;
  }
}

#endif /* NO_LOCKING -- whole file */
