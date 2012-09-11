#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include "lista.h"

int main(){
	lista *l_i = listaCrear();
	int val_i = 5;
	listaInsertar(l_i, tipo_int, &val_i);
	val_i = 6;
	listaInsertar(l_i, tipo_int, &val_i);
	listaImprimir(l_i, "out.out");
	
	lista *l_d = listaCrear();
	double val_d = 5.2;
	listaInsertar(l_d, tipo_double, &val_d);
	val_d = 3.9;
	listaInsertar(l_d, tipo_double, &val_d);
	listaImprimir(l_d, "out.out");

	lista *l_s = listaCrear();
	char *val_s = "hola";
	listaInsertar(l_s, tipo_string, val_s);
	val_s = "3.9";
	listaInsertar(l_s, tipo_string, val_s);
	listaImprimir(l_s, "out.out");

	return 0;
}
	
	
