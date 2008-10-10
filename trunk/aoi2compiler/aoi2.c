/**
 * aoi2
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define USAGE "[ERROR] Please set $JAVA_HOME, $AOI2_HOME\n"

int main(int argc, char** argv)
{
    int i;
    char cmd[4096];
    char java_opt[256];
    char aoi_opt[256];
    char* java_home = getenv("JAVA_HOME");
    char* aoi2_home = getenv("AOI2_HOME");
    if (java_home == NULL || aoi2_home == NULL) {
        fprintf(stderr, USAGE);
        return -1;
    }
    sprintf(java_opt, "%s/bin/java -Dfile.encoding=UTF8", java_home);
    sprintf(aoi_opt,  "-jar %s/bin/aoi2.jar --lib %s/bin", aoi2_home, aoi2_home);
    sprintf(cmd, "%s %s", java_opt, aoi_opt);
    for (i = 1; i < argc; i++) {
        strcat(cmd, " ");
        strcat(cmd, argv[i]);
    }
    /* printf("path=%s\n", cmd); */
    return system(cmd);
}



