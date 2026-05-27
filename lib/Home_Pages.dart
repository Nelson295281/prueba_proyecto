import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String pantalla = '0';
  String operacion = '';

  double numero1 = 0;
  double numero2 = 0;

  String operador = '';

  List<String> historial = [];

  // FUNCION PRINCIPAL
  void presionarBoton(String texto) {

    setState(() {

      // LIMPIAR TODO
      if (texto == 'AC') {

        pantalla = '0';
        operacion = '';
        numero1 = 0;
        numero2 = 0;
        operador = '';
      }

      // PORCENTAJE
      else if (texto == '%') {

        double valor = double.parse(pantalla) / 100;

        pantalla = valor.toString();

        if (pantalla.endsWith('.0')) {
          pantalla = pantalla.replaceAll('.0', '');
        }
      }

      // CAMBIO SIGNO
      else if (texto == '+/-') {

        double valor = double.parse(pantalla) * -1;

        pantalla = valor.toString();

        if (pantalla.endsWith('.0')) {
          pantalla = pantalla.replaceAll('.0', '');
        }
      }

      // OPERADORES
      else if (texto == '+' ||
          texto == '-' ||
          texto == '×' ||
          texto == '÷') {

        numero1 = double.parse(pantalla);
        operador = texto;

        operacion = pantalla + ' ' + operador;

        pantalla = '0';
      }

      // RESULTADO
      else if (texto == '=') {

        numero2 = double.parse(pantalla);

        double resultado = 0;

        switch (operador) {

          case '+':
            resultado = numero1 + numero2;
            break;

          case '-':
            resultado = numero1 - numero2;
            break;

          case '×':
            resultado = numero1 * numero2;
            break;

          case '÷':
            resultado = numero2 != 0
                ? numero1 / numero2
                : 0;
            break;
        }

        String resultadoTexto = resultado.toString();

        if (resultadoTexto.endsWith('.0')) {
          resultadoTexto = resultadoTexto.replaceAll('.0', '');
        }

        // ELIMINAR .0 DEL HISTORIAL
        String numero1Texto = numero1.toString();
        String numero2Texto = numero2.toString();

        if (numero1Texto.endsWith('.0')) {
          numero1Texto = numero1Texto.replaceAll('.0', '');
        }

        if (numero2Texto.endsWith('.0')) {
          numero2Texto = numero2Texto.replaceAll('.0', '');
        }

        historial.add(
          numero1Texto +
              ' ' +
              operador +
              ' ' +
              numero2Texto +
              ' = ' +
              resultadoTexto,
        );

        pantalla = resultadoTexto;
        operacion = '';
      }

      // DECIMAL
      else if (texto == '.') {

        if (!pantalla.contains('.')) {
          pantalla += '.';
        }
      }

      // NUMEROS
      else {

        if (pantalla == '0') {
          pantalla = texto;
        } else {
          pantalla += texto;
        }
      }
    });
  }

  // BOTONES
  Widget boton(String texto,
      {Color color = CupertinoColors.systemGrey5,
      Color textoColor = CupertinoColors.black}) {

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),

        child: CupertinoButton(

          padding: const EdgeInsets.all(20),

          color: color,

          borderRadius: BorderRadius.circular(25),

          onPressed: () {
            presionarBoton(texto);
          },

          child: Text(
            texto,

            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: textoColor,
            ),
          ),
        ),
      ),
    );
  }

  // FILAS
  Widget fila(List<Widget> botones) {
    return Row(children: botones);
  }

  @override
  Widget build(BuildContext context) {

    return CupertinoPageScaffold(

      navigationBar: CupertinoNavigationBar(

        middle: const Text('Calculadora Profesional'),

        trailing: CupertinoButton(
          padding: EdgeInsets.zero,

          child: const Icon(
            CupertinoIcons.delete,
            color: CupertinoColors.systemRed,
          ),

          onPressed: () {

            setState(() {
              historial.clear();
            });
          },
        ),
      ),

      child: SafeArea(

        child: Container(

          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1E1E1E),
                Color(0xFF2D2D2D),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),

          child: Column(
            children: [

              // HISTORIAL
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(
                    top: 20,
                    right: 20,
                    left: 20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: historial.reversed.take(3).map((e) {
                    return Text(
                      e,

                      style: const TextStyle(
                        color: CupertinoColors.systemGrey,
                        fontSize: 18,
                      ),
                    );
                  }).toList(),
                ),
              ),

              // OPERACION
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 24),

                child: Text(
                  operacion,

                  style: const TextStyle(
                    color: CupertinoColors.systemGrey2,
                    fontSize: 30,
                  ),
                ),
              ),

              // PANTALLA
              Expanded(
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(24),

                  child: SingleChildScrollView(
                    reverse: true,
                    scrollDirection: Axis.horizontal,

                    child: Text(
                      pantalla,

                      style: const TextStyle(
                        fontSize: 70,
                        fontWeight: FontWeight.w200,
                        color: CupertinoColors.white,
                      ),
                    ),
                  ),
                ),
              ),

              // BOTONES
              fila([
                boton('AC',
                    color: CupertinoColors.systemRed,
                    textoColor: CupertinoColors.white),

                boton('+/-',
                    color: CupertinoColors.systemGrey,
                    textoColor: CupertinoColors.white),

                boton('%',
                    color: CupertinoColors.systemGrey,
                    textoColor: CupertinoColors.white),

                boton('÷',
                    color: CupertinoColors.systemOrange,
                    textoColor: CupertinoColors.white),
              ]),

              fila([
                boton('7'),
                boton('8'),
                boton('9'),

                boton('×',
                    color: CupertinoColors.systemOrange,
                    textoColor: CupertinoColors.white),
              ]),

              fila([
                boton('4'),
                boton('5'),
                boton('6'),

                boton('-',
                    color: CupertinoColors.systemOrange,
                    textoColor: CupertinoColors.white),
              ]),

              fila([
                boton('1'),
                boton('2'),
                boton('3'),

                boton('+',
                    color: CupertinoColors.systemOrange,
                    textoColor: CupertinoColors.white),
              ]),

              fila([
                boton('0'),
                boton('.'),

                boton('=',
                    color: CupertinoColors.activeGreen,
                    textoColor: CupertinoColors.white),
              ]),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}