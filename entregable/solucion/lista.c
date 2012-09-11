#include "lista.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

static void *copiar_dato(tipo t, void *dato) {
    int *nuevo_i;
    double *nuevo_d;
    char *nuevo_s;

    switch (t) {
        case tipo_int:
            nuevo_i = malloc(sizeof(int));
            *nuevo_i = *((int *) dato);
            return (void *) nuevo_i;
        case tipo_double:
            nuevo_d = malloc(sizeof(double));
            *nuevo_d = *((double *) dato);
            return (void *) nuevo_d;
        case tipo_string:
            nuevo_s = malloc( sizeof(char) * strlen((char *) dato) + 1);
            strcpy(nuevo_s, (char *) dato);
            return (void *) nuevo_s;
        default:
            break;
    }

    return NULL;
}

lista *listaCrear_c() {
    lista *new = malloc(sizeof(lista));
    new->tipo_dato = sin_tipo;
    new->primero = NULL;

    return new;
}

void listaInsertar_c(lista *l, tipo t, void *dato) {
    if (l->tipo_dato == sin_tipo) l->tipo_dato = t;
    if (t != l->tipo_dato) return;

    nodo *new = malloc(sizeof(nodo));
    new->siguiente = l->primero;
    l->primero = new;

    new->dato = copiar_dato(t, dato);
}

static nodo *borrar(nodo *n) {
    nodo *tmp = n->siguiente;
    free(n->dato);
    free(n);

    return tmp;
}

void listaDestruir(lista *l) {
    nodo *node = l->primero;

    while (node != NULL) {
        node = borrar(node);
    }

    free(l);
}

static void imprimir_lista(nodo *n, tipo t, FILE *f) {
    if (n == NULL) return;


    switch (t) {
        case tipo_int:
            fprintf(f, "[%d]", * (int *) n->dato);
            break;
        case tipo_double:
            fprintf(f, "[%f]", * (double *) n->dato);
            break;
        case tipo_string:
            fprintf(f, "[%s]", (char *) n->dato);
            break;
        default:
            break;
    }

    imprimir_lista(n->siguiente, t, f);
}

void listaImprimir(lista *l, char *archivo) {
    FILE *file = fopen(archivo, "a");

    if (file == NULL) {
        perror("Al imprimir el archivo");
        exit(1);
    }
    
    imprimir_lista(l->primero, l->tipo_dato, file);
    fprintf(file, "\n");
    fclose(file);
}

void listaFilter(lista *l, boolean (*funcion_filter)(void*)) {
    nodo *tmp = l->primero;

    if (tmp == NULL) return;

    while (tmp->siguiente != NULL) {
        if (funcion_filter(tmp->siguiente->dato) == false) {
            tmp->siguiente = borrar(tmp->siguiente);
        } else {
            tmp = tmp->siguiente;
        }
    }

    if (funcion_filter(l->primero->dato) == false) {
        l->primero = borrar(l->primero);
    }
}

void listaMap(lista *l, void* (*funcion_map)(void*) ) {
    nodo *tmp = l->primero;

    while (tmp != NULL) {
        void *dato = funcion_map(tmp->dato);
        free(tmp->dato);
        tmp->dato = dato;
        tmp = tmp->siguiente;
    }
}

boolean es_multiplo_de_5(int* dato) {
    return *dato % 5 == 0;
}

boolean es_negativo(double* dato) {
    return *dato < 0;
}

boolean es_largo_mayor_10(char* dato) {
    return strlen(dato) > 10;
}

int *dividir_por_dos(int *dato) {
    int *res = malloc(sizeof(int));
    *res = *dato / 2;
    return res;
}
/* toma un puntero a entero y retorna un puntero a entero dividido por dos */

double *multiplicar_por_pi(double *dato) {
    double *res = malloc(sizeof(double));
    *res = *dato * 3.14159265;
    return res;
}
/* toma un puntero a double y retorna un puntero a double multiplicado por pi */

char *tomar_primeros_10(char *dato) {
    char *res = malloc(sizeof(char) * 11);
    res[10] = '\0';
    strncpy(res, dato, 10);

    return res;
}
/* toma una string de C y retorna una una string con los primeros 10 caracteres de la misma */
