# Компилятор и флаги
CC = gcc
CFLAGS = -Wall -g
LDFLAGS = -lm

# Целевой исполняемый файл
TARGET = parser

# Файлы для генерации
PARSER_C = parser.tab.c
PARSER_H = parser.tab.h
LEXER_C = lex.yy.c

# Исходные файлы
PARSER_Y = parser.y
SCANNER_L = scanner.l

# Тестовые файлы
TEST_CORRECT = test_correct.mini
TEST_ERRORS = test_errors.mini

# Правило по умолчанию
all: $(TARGET)

# Сборка парсера
$(TARGET): $(PARSER_C) $(LEXER_C)
	$(CC) $(CFLAGS) -o $(TARGET) $(PARSER_C) $(LEXER_C) $(LDFLAGS)

# Генерация парсера из parser.y
$(PARSER_C) $(PARSER_H): $(PARSER_Y)
	bison -d $(PARSER_Y)

# Генерация лексера из scanner.l
$(LEXER_C): $(SCANNER_L) $(PARSER_H)
	flex $(SCANNER_L)

# Очистка сгенерированных файлов
clean:
	rm -f $(TARGET) $(PARSER_C) $(PARSER_H) $(LEXER_C)
	rm -f parser.output

# Полная очистка (включая тестовые файлы)
distclean: clean
	rm -f $(TEST_CORRECT) $(TEST_ERRORS)

# Запуск тестов
test: $(TARGET) $(TEST_CORRECT) $(TEST_ERRORS)
	@echo "=== КОРРЕКТНЫЕ ВЫРАЖЕНИЯ ==="
	./$(TARGET) < $(TEST_CORRECT)
	@echo ""
	@echo "=== ТЕСТЫ С ОШИБКАМИ ==="
	./$(TARGET) < $(TEST_ERRORS)

# Создание тестовых файлов
create-tests:
	@echo "Создание test_correct.mini..."
	@printf "2+3\n" > $(TEST_CORRECT)
	@printf "2+3*4\n" >> $(TEST_CORRECT)
	@printf "(2+3)*4\n" >> $(TEST_CORRECT)
	@printf "pow(2,3)\n" >> $(TEST_CORRECT)
	@printf "2+pow(2,3)*(1+1)\n" >> $(TEST_CORRECT)
	@printf "-5+3\n" >> $(TEST_CORRECT)
	@printf "pow(-2,3)\n" >> $(TEST_CORRECT)
	@printf "pow(2,pow(3,2))\n" >> $(TEST_CORRECT)
	@echo "Создание test_errors.mini..."
	@printf "2 & 3\n" > $(TEST_ERRORS)
	@printf "foo(2,3)\n" >> $(TEST_ERRORS)
	@printf "2+3*\n" >> $(TEST_ERRORS)
	@printf "(2+3\n" >> $(TEST_ERRORS)
	@printf "2+3)\n" >> $(TEST_ERRORS)
	@printf "pow(2,)\n" >> $(TEST_ERRORS)
	@printf "2.5\n" >> $(TEST_ERRORS)
	@printf "()\n" >> $(TEST_ERRORS)
	@echo "Тестовые файлы созданы!"

# Интерактивный запуск
run: $(TARGET)
	./$(TARGET)

# Показать справку
help:
	@echo "Доступные команды:"
	@echo "  make          - собрать проект"
	@echo "  make clean    - удалить сгенерированные файлы"
	@echo "  make test     - запустить тесты"
	@echo "  make run      - запустить в интерактивном режиме"
	@echo "  make create-tests - создать тестовые файлы"
	@echo "  make distclean - полная очистка"
	@echo "  make help     - показать эту справку"

.PHONY: all clean test run help distclean create-tests
