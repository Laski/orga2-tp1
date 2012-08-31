#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include "lista.h"

#define MAXLISTAS 30

#ifdef DEBUG
#define DLOG(...) printf("DEBUG:: "); printf(__VA_ARGS__);
#else
#define DLOG(...)
#endif

char* getParam(char * needle, char* haystack[], int count) {
	int i = 0;
	for (i = 0; i < count; i ++) {
		if (strcmp(needle, haystack[i]) == 0) {
			if (i < count -1) {
				return haystack[i+1];
			}	
		}
	}
	return 0;	
}


int isParam(char * needle, char* haystack[], int count) {
	int i = 0;
	for (i = 0; i < count; i ++) {
		if (strcmp(needle, haystack[i]) == 0) {
			return 1;
		}
	}
	return 0;	
}

int parsecommand(char *comando, lista l, char *dirbuf, char *dir);

void showusage(char* filename);

lista *mislistas[MAXLISTAS];
tipo tipolistas[MAXLISTAS];

int main (int argc, char *argv[]) {
  
  char * testfilename = getParam("-f", argv, argc);
  
   if (! isParam("-f", argv, argc) && ! isParam("-t", argv, argc)) {
     DLOG("No hay parametros\n");
     showusage(argv[0]);
     return 0;
   }

  freopen(testfilename,"r",stdin);
  char outputfile[100];
  sprintf(outputfile,"%s.out",testfilename);

  char command[50];
  int id;
  int tp;
  while(~scanf("%s",command)){
    switch(command[0]){
      case 'C':
        scanf("%d%d",&id,&tp);
        mislistas[id]=listaCrear();
        tipolistas[id]=(tipo)tp;
        break;
      case 'I':
        scanf("%d",&id);
        listaImprimir(mislistas[id],outputfile);
        break;
      case 'D':
        scanf("%d",&id);
        listaDestruir(mislistas[id]);
        break;
      case 'A':
        scanf("%d",&id);
        if(tipolistas[id]==1){
          int val;
          scanf("%d",&val);
          listaInsertar( mislistas[id], tipo_int, &val);
        }
        if(tipolistas[id]==2){
          double val;
          scanf("%lf",&val);
          listaInsertar( mislistas[id], tipo_double, &val);
        }
        if(tipolistas[id]==3){
          char val[50];
          scanf("%s",val);
          listaInsertar( mislistas[id], tipo_string, val);
        }
        break;
      case 'M':
        scanf("%d",&id);
        if(tipolistas[id]==1) listaMap( mislistas[id], (void* (*) (void*)) dividir_por_dos);
        if(tipolistas[id]==2) listaMap( mislistas[id], (void* (*) (void*)) multiplicar_por_pi);
        if(tipolistas[id]==3) listaMap( mislistas[id], (void* (*) (void*)) tomar_primeros_10);
        break;
      case 'F':
        scanf("%d",&id);
        if(tipolistas[id]==1) listaFilter( mislistas[id], (enum boolean_e (*)(void*)) es_multiplo_de_5);
        if(tipolistas[id]==2) listaFilter( mislistas[id], (enum boolean_e (*)(void*))  es_negativo);
        if(tipolistas[id]==3) listaFilter( mislistas[id], (enum boolean_e (*)(void*))  es_largo_mayor_10);
        break;    
        
    }
  }

return 0;
}

void printerrno() {
	printf("%#x\n", errno);
}

void showusage(char* filename) {
	printf("Uso: %s -f ARCHIVO\n", filename);
	printf("\n");
	printf("Utiliza ARCHIVO como un conjunto de acciones a seguir. Cada linea del archivo de texto representa una accion a realizar. El archivo de salida se realizara en el mismo directorio con el mismo nombre que la entrada y extension .out.\n");
	printf("\n");
	printf("Las acciones posibles son:\n");
	printf("CREAR <ID> <TIPO>\n");
	printf("AGREGAR <ID> <DATO>\n");
	printf("DESTRUIR <ID>\n");
	printf("FILTRAR <ID>\n");
	printf("MAP <ID>\n");
	printf("IMPRIMIR <ID>\n");
	printf("\n");
  printf("<ID> corresponde al identificador de la lista. Un mismo archivo puede crear muchas listas distintas, cada una con tipo distinto.\n");
  printf("<TIPO> corresponde a un valor del 1 si es una lista de INT, 2 si es una lista de FLOAT y 3 si es una lista de strings.\n");
  printf("<DATO> corresponde al elemento ingresado. No se realiza un chequeo de que dato sea del tipo de la lista, por lo que es responsabilidad del que crea ARCHIVO que los datos sean del tipo de la lista.\n");
	printf("\n");
  printf("Para ver ejemplos, se puden consultar los archivos *.in provistos por la cátedra.\n");
}
