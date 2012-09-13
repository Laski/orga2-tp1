#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include "lista.h"
int ej3();

int main(){
	lista *l_i = listaCrear();
	int val_i = 325;
	listaInsertar(l_i, tipo_int, &val_i);
	val_i = 823;
	listaInsertar(l_i, tipo_int, &val_i);
	val_i = 100;
	listaInsertar(l_i, tipo_int, &val_i);
	val_i = 105;
	listaInsertar(l_i, tipo_int, &val_i);
	listaFilter(l_i, (enum boolean_e (*)(void*)) es_multiplo_de_5);
	listaMap(l_i, (void * (*)(void*)) dividir_por_dos);
	listaImprimir(l_i, "main.out");
	listaDestruir(l_i);
	
	lista *l_d = listaCrear();
	double val_d = -3.25;
	listaInsertar(l_d, tipo_double, &val_d);
	val_d = 8.23;
	listaInsertar(l_d, tipo_double, &val_d);
	val_d = 1.00;
	listaInsertar(l_d, tipo_double, &val_d);
	val_d = -1.05;
	listaInsertar(l_d, tipo_double, &val_d);
	listaFilter(l_d, (enum boolean_e (*)(void*)) es_negativo);
	listaMap(l_d, (void * (*)(void*)) multiplicar_por_pi);
	listaImprimir(l_d, "main.out");
	listaDestruir(l_d);
				
	lista *l_s = listaCrear();
	char *val_s = "Ricardo, Ricardo, Ricardo Ruben";
	listaInsertar(l_s, tipo_string, val_s);
	val_s = "mono";
	listaInsertar(l_s, tipo_string, val_s);
	val_s = "en escalada no hay nada";
	listaInsertar(l_s, tipo_string, val_s);
	listaFilter(l_s, (enum boolean_e (*)(void*)) es_largo_mayor_10);
	listaMap(l_s, (void * (*)(void*)) tomar_primeros_10);
	listaImprimir(l_s, "main.out");
	listaDestruir(l_s);

	ej3();

	return 0;
}

int ej3(){
	//https://www.youtube.com/watch?v=osmN3gYyGPA =)
	lista *l_s = listaCrear();
	char *val_s = "cuca";
	listaInsertar(l_s, tipo_string, val_s);
	val_s = "puse";
	listaInsertar(l_s, tipo_string, val_s);
	val_s = "le";
	listaInsertar(l_s, tipo_string, val_s);
	val_s = "grande";
	listaInsertar(l_s, tipo_string, val_s);
	val_s = "la";
	listaInsertar(l_s, tipo_string, val_s);
	val_s = "a";
	listaInsertar(l_s, tipo_string, val_s);
	listaImprimir(l_s, "ej3.out");
	listaDestruir(l_s);
			
	return 42;
}
