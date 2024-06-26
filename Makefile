# Makefile for UM (Comp 40 Assignment 6)
# Modified from locality (Comp 40 Assignment 3)
# Modified by: Isabelle Lai (ilai01) and Andrea Foo (afoo01)
# 
# Includes build rules 
#
# Last updated: April 12, 2020


############## Variables ###############

CC = gcc # The compiler being used

# Updating include path to use Comp 40 .h files and CII interfaces
IFLAGS = -I/comp/40/build/include -I/usr/sup/cii40/include/cii

# Compile flags
# Set debugging information, allow the c99 standard,
# max out warnings, and use the updated include path
# CFLAGS = -g -std=c99 -Wall -Wextra -Werror -Wfatal-errors -pedantic $(IFLAGS)
# 
# For this assignment, we have to change things a little.  We need
# to use the GNU 99 standard to get the right items in time.h for the
# the timing support to compile.
# 
CFLAGS = -g -std=gnu99 -Wall -Wextra -Werror -Wfatal-errors -pedantic $(IFLAGS)

# Linking flags
# Set debugging information and update linking path
# to include course binaries and CII implementations
LDFLAGS = -g -L/comp/40/build/lib -L/usr/sup/cii40/lib64

# Libraries needed for linking
# All programs cii40 (Hanson binaries) and *may* need -lm (math)
# 40locality is a catch-all for this assignment, netpbm is needed for pnm
# rt is for the "real time" timing library, which contains the clock support
LDLIBS = -l40locality -lnetpbm -lcii40 -lm -lrt -larith40 -lum-dis -lcii 

# Collect all .h files in your directory.
# This way, you can never forget to add
# a local .h file in your dependencies.
#
# This bugs Mark, who dislikes false dependencies, but
# he agrees with Noah that you'll probably spend hours 
# debugging if you forget to put .h files in your 
# dependency list.
INCLUDES = $(shell echo *.h)

############### Rules ###############

all: um


## Compile step (.c files -> .o files)

# To get *any* .o file, compile its .c file with the following rule.
%.o: %.c $(INCLUDES)
	$(CC) $(CFLAGS) -c $< -o $@


## Linking step (.o -> executable program)

um: bitpack.o arith_instructions.o io_instructions.o mem_instructions.o \
	 um.o main.o 
	$(CC) $(LDFLAGS) $^ -o $@ $(LDLIBS)

writetests: bitpack.o umlabwrite.o umlab.o 
	$(CC) $(LDFLAGS) $^ -o $@ $(LDLIBS)
	
test_arch: mem_instructions.o test_arch.o
		$(CC) $(LDFLAGS) $^ -o $@ $(LDLIBS)

clean: 
	rm -f um writetests test_arch *.o

