EXTRAFLAGS:= -Wall -Werror -pedantic --std=c99 -ggdb -O0
NASMEXTRAFLAGS:=-f elf64 -g -F dwarf 
OBJS=funciones.o
HEADS=lista.h
EXE=tp1
INCLUDE=-include /usr/include/errno.h

.PHONY: all clean


$(EXE): $(EXE).c $(OBJS) $(HEADS)
	gcc $(INCLUDE) -o $@ $(EXTRAFLAGS) $< $(OBJS)

%.o: %.asm
	nasm $(NASMEXTRAFLAGS) -o $@ $<

%.o: %.c
	gcc -c $(EXTRAFLAGS) -o $@ $<
	
all: $(EXE)

clean:
	rm -f $(OBJS)
	rm -f $(EXE)
