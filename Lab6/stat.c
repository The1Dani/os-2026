#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void print_err(void);

void print_stat(const char *, struct stat);

char *
typename(int t)
{
  switch (t) {
  case T_DIR:
    return "directory";
    break;
  case T_FILE:
    return "regular";
    break;
  case T_DEVICE:
    return "device";
    break;
  default:
    return "";
  }
}

int
main(int argc, char *argv[])
{
  struct stat st;
  for (int i = 1; i < argc; i++) {
    int err = stat(argv[i], &st);
    if (err != 0) {
      print_err();
      return err;
    }
    print_stat(argv[i], st);
  }
  exit(0);
}

void
print_err()
{
  fprintf(2, "stat has failed misserably!\n");
}

void
print_stat(const char *name, struct stat st)
{
  printf("%s: %s, inode %d, links %d, size %ld bytes\n", name, typename(st.type),
         st.ino, st.nlink, st.size);
}