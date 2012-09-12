#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include "lista.h"

int main(){
	lista *l_i = listaCrear();
	int val_i = 3;
	while (val_i < 30){
		listaInsertar(l_i, tipo_int, &val_i);
		val_i++;
	}
	listaImprimir(l_i, "out.out");
	

	lista *l_d = listaCrear();
	double val_d = 5.2;
	listaInsertar(l_d, tipo_double, &val_d);
	val_d = -3.9;
	listaInsertar(l_d, tipo_double, &val_d);
	val_d = -3.9;
	listaInsertar(l_d, tipo_double, &val_d);
	val_d = 6.7;
	listaInsertar(l_d, tipo_double, &val_d);
	val_d = 3.2;
	listaInsertar(l_d, tipo_double, &val_d);
	val_d = 3.9;
	listaInsertar(l_d, tipo_double, &val_d);
	listaImprimir(l_d, "out.out");

	lista *l_s = listaCrear();
	char *val_s = "hola";
	listaInsertar(l_s, tipo_string, val_s);
	val_s = "3.9";
	listaInsertar(l_s, tipo_string, val_s);
	val_s = "holacomoteva";
	listaInsertar(l_s, tipo_string, val_s);
	listaImprimir(l_s, "out.out");


	listaFilter(l_i, (enum boolean_e (*)(void*)) es_multiplo_de_5);
	listaImprimir(l_i, "out.out");

	listaFilter(l_d, (enum boolean_e (*)(void*)) es_negativo);
	listaImprimir(l_d, "out.out");

	listaFilter(l_s, (enum boolean_e (*)(void*)) es_largo_mayor_10);
	listaImprimir(l_s, "out.out");	




	return 0;
}
	
	
