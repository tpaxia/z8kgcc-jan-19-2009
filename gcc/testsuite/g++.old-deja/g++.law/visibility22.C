// Build don't link: 
// GROUPS passed visibility
// excess errors test - XFAIL *-*-*
// visibility file
// From: Robert Carden <carden@thoth.ics.uci.edu>
// Date:     Thu, 12 Aug 1993 13:48:05 -0700
// Subject:  bug 8/12/93 -- #5
// Message-ID: <9308121348.aa26256@Paris.ics.uci.edu>

// 5.cc
#include <stream.h>

class A {
        int x;
public:
        void f(int);
        void f(float);
        void g(void *);
};

class B : private A {
protected:
        A::f;
public:
        A::g;
};
