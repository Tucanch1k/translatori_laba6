# Транслятор арифметических выражений (Bison + Flex)

## Автор
Коц Алексей, КМБО-05-23, Вариант 6

## Описание
Транслятор арифметических выражений с поддержкой:
- Операции: +, *
- Функция: pow(a, b)
- Скобки: (, )
- Отрицательные числа

## Грамматика
Expr -> Term Expr'
Expr' -> + Term Expr' | ε
Term -> Factor Term'
Term' -> * Factor Term' | ε
Factor -> NUM | pow ( Expr , Expr ) | ( Expr )

## Структура проекта
.
├── CMakeLists.txt
├── README.md
├── files/
│   ├── mini.l
│   └── mini.y
├── examples/
│   ├── valid/
│   ├── invalid/
│   └── run_tests.sh
└── .gitignore

## Требования
- CMake >= 3.10
- Bison
- Flex
- GCC

## Сборка
cmake -B build
cmake --build build

## Запуск
./build/main examples/valid/arithmetic.mini

## Тестирование
./examples/run_tests.sh ./build/main

## Результаты тестирования
Положительные примеры (valid/):
  PASS  arithmetic.mini
  PASS  parentheses.mini
  PASS  power.mini

Негативные примеры (invalid/):
  PASS  empty_parentheses.mini
  PASS  extra_parenthesis.mini
  PASS  extra_pow_arg.mini
  PASS  float_number.mini
  PASS  missing_operand.mini
  PASS  missing_parenthesis.mini
  PASS  missing_pow_arg.mini
  PASS  unknown_identifier.mini
  PASS  unknown_symbol.mini

Итог: 12 прошло / 0 упало / 12 всего

## Примеры работы

Корректное выражение:
./build/main examples/valid/arithmetic.mini

Вывод:
5
14
20
8
18
-2
-8
512

Ошибка:
./build/main examples/invalid/unknown_symbol.mini

Вывод:
Лексическая ошибка в строке 2: недопустимый символ '&'

## Коды возврата
- 0 - успешное выполнение
- 1 - ошибка

