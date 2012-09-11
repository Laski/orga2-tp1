#ifndef __LISTA_H__
#define __LISTA_H__

      typedef enum boolean_e { false=0, true=1 } boolean;

/*** Estructuras para el tipo lista ***/

      typedef enum tipo_e {
            sin_tipo=0,
            tipo_int=1,
            tipo_double=2,
            tipo_string=3
      } tipo;

      typedef struct lista_t {
            enum tipo_e tipo_dato;
            struct nodo_t *primero;
      } __attribute__((__packed__)) lista;

      typedef struct nodo_t {
            struct nodo_t *siguiente;
            void *dato;
      } __attribute__((__packed__)) nodo;

/*** Declaracion de funciones de lista ***/

      lista * listaCrear();
      void  listaInsertar(lista * l, enum tipo_e, void* dato);
      void  listaDestruir(lista * l);
      void  listaImprimir(lista  * l, char *archivo);

      void  listaFilter(lista * l, enum boolean_e (*funcion_filter)(void*) );
      void   listaMap(lista * l, void* (*funcion_map)(void*) );

/*** Declaracion de funciones para filter ***/

      enum boolean_e es_multiplo_de_5(int* dato);
      /* toma un puntero a entero y determina si es multiplo de 5 */

      enum boolean_e es_negativo(double* dato);
      /* toma un puntero a un double y detemina si es negativo */

      enum boolean_e es_largo_mayor_10(char* dato);
      /* toma una string de C y determina si su longitud es mayor a 10 caracteres */

/*** Declaracion de funciones para map ***/

      int* dividir_por_dos(int* dato);
      /* toma un puntero a entero y retorna un puntero a entero dividido por dos */

      double* multiplicar_por_pi(double* dato);
      /* toma un puntero a double y retorna un puntero a double multiplicado por pi */

      char* tomar_primeros_10(char* dato);
      /* toma una string de C y retorna una una string con los primeros 10 caracteres de la misma */

#endif /*__LISTA_H__*/
