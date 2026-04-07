#!/bin/bash

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Проверка аргументов
if [ $# -ne 1 ]; then
    echo "Usage: $0 <path_to_translator>"
    exit 1
fi

TRANSLATOR=$1
VALID_DIR="examples/valid"
INVALID_DIR="examples/invalid"
PASSED=0
FAILED=0
TOTAL=0

echo "Транслятор: $TRANSLATOR"
echo "──────────────────────────────────────────"

# Проверка положительных примеров
echo -e "${YELLOW}Положительные примеры (valid/):${NC}"
for file in "$VALID_DIR"/*.mini; do
    if [ -f "$file" ]; then
        TOTAL=$((TOTAL + 1))
        $TRANSLATOR "$file" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo -e "  ${GREEN}PASS${NC}  $(basename "$file")"
            PASSED=$((PASSED + 1))
        else
            echo -e "  ${RED}FAIL${NC}  $(basename "$file") — транслятор вернул ошибку, ожидался успех"
            FAILED=$((FAILED + 1))
        fi
    fi
done

echo ""

# Проверка отрицательных примеров
echo -e "${YELLOW}Негативные примеры (invalid/):${NC}"
for file in "$INVALID_DIR"/*.mini; do
    if [ -f "$file" ]; then
        TOTAL=$((TOTAL + 1))
        $TRANSLATOR "$file" > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo -e "  ${GREEN}PASS${NC}  $(basename "$file")"
            PASSED=$((PASSED + 1))
        else
            echo -e "  ${RED}FAIL${NC}  $(basename "$file") — транслятор не обнаружил ошибку"
            FAILED=$((FAILED + 1))
        fi
    fi
done

echo ""
echo "──────────────────────────────────────────"
echo -e "Итог: ${GREEN}$PASSED прошло${NC} / ${RED}$FAILED упало${NC} / $TOTAL всего"

if [ $FAILED -eq 0 ]; then
    exit 0
else
    exit 1
fi
