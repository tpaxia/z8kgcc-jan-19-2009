// Special g++ Options: -fexceptions
// excess errors test - XFAIL a29k-*-* sparc64-*-elf sh-*-* arm-*-pe**-*

#include <exception>

struct double_fault { };
int fault_now;

class E {
public:
  E() { }
  E(const E&) {
    if (fault_now)
      throw double_fault();
  }
};

void foo() {
  try {
    throw E();
  } catch (...) {
    fault_now = 1;
    throw;
  }
}

void bar() {
  try {
    foo();
  } catch (E e) {	// double fault here
  }
}

void my_terminate() {
  exit (0);		// double faults should call terminate
}

main() {
  set_terminate (my_terminate);
  try {
    bar();
  } catch (...) {
    return 1;
  }
  return 1;
}
