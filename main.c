#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern void base64_encode(char *text, char *dest);

int main(int argc, char ** argv){

    if(argc <= 1){
        fprintf(stderr, "Nincs eleg argumentum!\n");
        return 1;
    }

    int len = 4 * (strlen(argv[1])+2)/3;
    char *dest = (char *) malloc(len);

    base64_encode(argv[1], dest);
    //base64_encode("xdxdxd", dest);
    
    printf("%s \n", dest);

    free(dest);
    return 0;
}