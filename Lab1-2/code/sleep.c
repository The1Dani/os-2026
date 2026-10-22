#include "kernel/types.h"
#include "user/user.h"

// Sleeps 10*n ticks.
// One tick is around 100ms
int
main(int argc, char *argv[])
{
  if (argc != 2) {
    fprintf(2, "usage: sleep <ticks>\n");
    exit(1);
  }
  pause(atoi(argv[1])*10); // system call into the kernel
  exit(0);
}
