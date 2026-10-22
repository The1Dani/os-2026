#import "@templates/gc:1.0.0": temp

#set document(title: [
  Report Lab 1-2
])

#show: temp.with(
  lab-number: "1-2",
  toc: false,
  year: "2026",
  checked-by: ([Reițman Patricia, university assistant],),
  title: "of Operating Systems"
)

// Inline code. Not using raw: the template's `show raw: set par(..)` rule
// breaks the paragraph around every inline raw element.

#let c(body) = text(font: "Courier New", size: 10pt, body)

// Terminal screenshots, scaled by pixel width so their text size matches.
#let shot(path, px) = figure(
  block(fill: black, inset: 6pt, radius: 4pt, image(path, width: px * 0.17mm)),
)

// The original lab question, shown under its short heading.
#let q(body) = par(first-line-indent: 0pt, emph(body))

#set list(indent: 1.5cm, body-indent: 0.6em)

#show raw.where(block: true): block.with(
  breakable: false,
  width: 100%,
  fill: luma(245),
  stroke: luma(200),
  inset: 10pt,
  radius: 4pt,
)

= Lab 1

== Part 1 — Files and Permissions

=== File ownership

#q[Who owns the files you just created, and which group?]

The owner of a file on creation is determined by the file permissions on the parent folder. Since the files are owned by the user #c("debian"), group #c("debian"), the files also inherit that.

#shot("static/figure2.png", 775)

=== Permission string

#q[What do the ten characters at the start of #c("ls -l") mean for #c("note.txt") after #c("chmod 600")?]

The first characters are deciphered by file-type / user / group / all, in triplets except the first one.

The numbers come from the bits that hold this:

#align(center, table(
  columns: 3,
  align: (center, center, left),
  inset: (x: 10pt, y: 6pt),
  table.header([*Bit*], [*Value*], [*Meaning*]),
  c("r"), [4], [Read],
  c("w"), [2], [Write],
  c("x"), [1], [Execute],
))

And the #c("600") is just short to say #c("rw-/---/---").

=== Root directories

#q[Name two directories directly under #c("/") and say, in one line each, what they hold.]

- #c("/tmp") holds short-time temporary files which are deleted periodically
- #c("/bin") holds executable binaries

== Part 2 — Processes

=== PID 1

#q[What is the PID of process number 1, and what is it (look it up)?]

The PID 1 is the first process that is run by the kernel. In Linux all of the processes are children of other processes except this one. This special process is run by the kernel on boot and it's used to initialize all other programs which your computer may run. On modern systems it's usually systemd.

=== Process count

#q[Roughly how many processes were running on your idle VM?]

#shot("static/figure3.png", 453)

It's roughly 130.

=== Process state

#q[From #c("/proc/<pid>/status"), what does the "State:" line say for your sleeping process?]

#shot("static/figure4.png", 403)

The state is running.

== Part 3 — Memory

#shot("static/figure5.png", 733)

=== Total and free RAM

#q[How much total RAM does the VM have, and how much is free?]

=== Swap

#q[What is swap, and how much is configured?]

Swap is memory saved on disk.
In the VM there is no swap configured.

=== Resident memory of #c("sleep")

#q[How much resident memory (VmRSS) does a bare #c("sleep") process use, and does that surprise you?]

#shot("static/figure6.png", 742)

The sleep process uses a few kB; this is mostly the code loaded on to RAM.

== Part 4 — Devices and Filesystems

#shot("static/figure7.png", 1008)

=== Root filesystem device

#q[Which device is your root filesystem #c("/") mounted on?]

The device that's mounted on #c("/") is #c("/dev/sda1"), which is the virtual hard-drive.

=== A #c("/dev") entry

#q[Give one entry from #c("/dev") and say what real thing it stands for.]

#c("/dev/zero") is a special file that contains all zeros.

=== Everything is a file

#q[In one sentence: what does "everything is a file" mean, based on what you saw?]

All of the connected devices, ports, etc. are files that map memory; any of them are abstracted with #c("files").

= Lab 2

== Part 2 — Using xv6

=== Bundled programs

#q[List three programs xv6 ships with.]

- #c("cat")
- #c("echo")
- #c("wc")

=== Pipes

#q[You just used a pipe (#c("|")) inside xv6. Which two OS features must exist for a pipe to work? (Hint: think processes and communication.)]

Read and write should exist as a minimum.

=== xv6 shell vs. Linux shell

#q[In one sentence: how does the xv6 shell compare to the Linux shell from Lab 1?]

The shell is more minimal, I can move the cursor up and down, there are fewer features.

== Part 3 — System Calls

=== System calls in #c("cat")

#q[Which system calls does #c("user/cat.c") use, and what does each one ask the kernel to do?]

The program uses read, write and pipe.
It asks the kernel to read and write data to files;
also pipe is a special thing to communicate between processes.

=== Location of #c("sys_read")

#q[In which kernel file, and on which line, is #c("sys_read") implemented?]

The #c("kernel/sysfile.c").

=== #c("kernel/") vs. #c("user/")

#q[In one sentence: what is the difference between the code in #c("kernel/") and the code in #c("user/")?]

The code in #c("kernel/") is used to compile the kernel; it contains system-calls and all other OS internals and provides an API for user-space programs.

The #c("user/") is used to compile user-space programs like #c("ls") or #c("cat").

== Part 4 — The #c("sleep") Program

#block(breakable: false)[
This is the #c("sleep") program for the VM:

```c
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
```
]

= Conclusion

In Lab 1 we worked on a Linux VM and looked at file ownership and permissions, processes and #c("/proc"), memory and swap, and how devices are exposed as files under #c("/dev"). In Lab 2 we ran xv6, used its minimal shell and programs, read how user programs such as #c("cat") talk to the kernel, and wrote a #c("sleep") program that does its work through a single system call.

The main takeaway is the split between user space and the kernel: user programs never touch the hardware directly, they ask the kernel for everything through system calls.
