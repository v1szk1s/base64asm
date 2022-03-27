#include <stdio.h>
#include <stdlib.h>

int main(int argc, char ** argv){
    if(argc <= 1){
        fprintf(stderr, "args");
        return 1;
    }

    char t[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    printf("%s -> %c\n",argv[1], t[atoi(argv[1])]);

    if(argc <= 2){
        return 0;
    }

    printf("%c -> %d, 0x%x\n", argv[2][0], argv[2][0], argv[2][0]);


    return 0;
}