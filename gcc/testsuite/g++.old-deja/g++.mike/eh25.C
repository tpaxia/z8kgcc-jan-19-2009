// Special g++ Options: -fexceptions
// excess errors test - XFAIL a29k-*-* sparc64-*-elf sh-*-* arm-*-pe**-*

#include <exception>

void my_terminate() {
  exit (0);		// Double faults should call terminate
}

struct A {
  A() { }
  ~A() {
    set_terminate (my_terminate);
    throw 1;		// This throws from EH dtor, should call my_terminate
  }
};

main() {
  try {
    try {
      throw 1;
    } catch (int i) {
      A a;		// A hit on this EH dtor went to the wrong place
      throw 1;
    }
  } catch (...) {
    return 1;
  }
  return 1;
}
