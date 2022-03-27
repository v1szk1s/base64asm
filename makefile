PROG:=prog
CSRC:=main.c
COBJ:=$(CSRC:%.c=%.o)
ASRC:=base64.S
AOBJ:=$(ASRC:%.S=%.o)

.PHONY: all
all: ${PROG}


${PROG}: ${COBJ} ${AOBJ}
	arm-linux-gnueabihf-gcc -static -g -marm -mcpu=cortex-a7 ${COBJ} ${AOBJ} -o ${PROG}

${COBJ}: %.o: %.c
	arm-linux-gnueabihf-gcc -static -g -marm -mcpu=cortex-a7 -c $< -o $@

${AOBJ}: %.o: %.S
	arm-linux-gnueabihf-gcc -static -g -marm -mcpu=cortex-a7 -c $< -o $@


.PHONY: clean
clean:
	rm ${COBJ} ${AOBJ} ${PROG}