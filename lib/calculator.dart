import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math';

class Calculator extends StatelessWidget
{
  const Calculator({super.key});

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp
    (
      title: 'Calculator',
      theme: ThemeData
      (
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CalculatorPage(title: 'Calculator'),
    );
  }
}

class CalculatorPage extends StatefulWidget
{
  const CalculatorPage({super.key, required this.title});

  final String title;

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage>
{
  String input = '0';
  String output = '0';

  Widget getCalculatorButton(String buttonText)
  {
    return Padding
    (
      padding: const EdgeInsets.all(10),
      child: ElevatedButton
      (
        style: ButtonStyle
        (
          foregroundColor: WidgetStateProperty.all(Colors.white),
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states)
          {
            if (states.contains(WidgetState.pressed))
            {
              return Colors.blue;
            }
            return Colors.deepPurple;
          }),
        ),
        onPressed: ()
        {
          buttonPressed(buttonText);
        },
        child: Text
        (
          buttonText,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  void buttonPressed(String buttonText)
  {
    setState(()
    {
      if (buttonText == 'C')
      {
        if (input.isNotEmpty)
        {
          input = input.substring(0, input.length - 1);
          output = input.isEmpty ? '0' : input;
        }
      }
      else if (buttonText == 'CE')
      {
        input = '';
        output = '0';
      }
      else if (['=', 'Sqr', 'Sqrt'].contains(buttonText))
      {
        try
        {
          Expression expression = Parser().parse(input);
          double evaluation =
              expression.evaluate(EvaluationType.REAL, ContextModel());

          if (buttonText == '=')
          {
            output = evaluation.toString();
            input = output;
          }
          else if (buttonText == 'Sqr')
          {
            output = (pow(evaluation, 2)).toString();
            input = output;
          }
          else if (buttonText == 'Sqrt')
          {
            if (evaluation < 0)
            {
              output = 'Invalid input!';
            }
            else
            {
              output = (sqrt(evaluation)).toString();
              input = output;
            }
          }

          if (output == 'Infinity')
          {
            output = 'Error!';
            input = '0';
          }
        }
        catch (e)
        {
          output = 'Error!';
          input = '0';
        }
      }
      else
      {
        if (['0', '1'].contains(buttonText) && input == '0')
        {
          input = buttonText;
          output = input;
        }
        input += buttonText;
        output = input;
      }
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar
      (
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center
      (
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children:
        [
          Container
          (
            alignment: Alignment.centerRight,
            height: 112.5,
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView
            (
              scrollDirection: Axis.vertical,
              reverse: false,
              child: Text
              (
                output,
                style:
                    const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          Expanded
          (
            child: GridView.count
            (
              crossAxisCount: 4,
              children:
              [
                for (var text in
                [
                  'C', 'Sqr', 'Sqrt', 'CE',
                  '7', '8', '9', '/',
                  '4', '5', '6', '*',
                  '1', '2', '3', '-',
                  '0', '.', '=', '+'
                ])
                  getCalculatorButton(text)
              ],
            ),
          )
        ]),
      ),
    );
  }
}
