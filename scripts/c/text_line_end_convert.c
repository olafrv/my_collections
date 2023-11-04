/* Filename : ttxt.c
 * Translate Text 1.0 is a program to convert
 * plain ascii text between the variations
 * of this format in unix based system and
 * win-dos system.
 * Author: Olaf Reitmaier
 * Author's email: olafrv@hotmail.com
 * Version: 1.0 - March 2002
 */
#include <stdio.h>
#include <string.h>
void help(void);
int main(int argc, char *argv[]){
  FILE* in;
  FILE* out;
  char c;
  if (argc>=4){
    in = fopen(argv[2], "r");
    out = fopen(argv[3], "w");
    if (!strcmp(argv[1], "-w")){
      printf("\n   Making convertion to win-dos...\n\n");
      while((c=fgetc(in)) != EOF){
        if(c!='\n'){
          fprintf(out, "%c", c);
        }else{
          fprintf(out, "%c", '\r');
          fprintf(out, "%c", '\n');
        }
      }
    }else{
      if (!strcmp(argv[1], "-u")){
        printf("\n   Making convertion to unix...\n\n");
        while((c=fgetc(in)) != EOF){
          if(c!='\r'){
            fprintf(out, "%c", c);
          }else{
            fgetc(in);
            fprintf(out, "%c", '\n');
          }
        }
      }else{
        help();
      }
    }
    fclose(in);
    fclose(out);
  }else{
    help();
  }
}
void help(){
  printf("\n Translate Text 1.0 is a program to convert\n");
  printf(" plain ascii text between the variations\n");
  printf(" of this format in unix based system and\n");
  printf(" win-dos operating system\n");
  printf("\n Command line options:\n\n");
  printf(" ttxt -u <my_win-dos_file> <my_new_unix_file>\n");
  printf(" ttxt -w <my_unix_file> <my_new_win-dos_file>\n\n");
  printf(" This program was made by Olaf Reitmaier / March 2002\n");
  printf(" please send any question to olafrv@hotmail.com\n");
}
