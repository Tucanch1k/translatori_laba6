cmake_minimum_required(VERSION 3.10)
project(Translator C)

set(CMAKE_C_STANDARD 99)

# Находим Bison и Flex
find_package(BISON REQUIRED)
find_package(FLEX REQUIRED)

# Генерируем парсер из mini.y
BISON_TARGET(MyParser ${CMAKE_CURRENT_SOURCE_DIR}/files/mini.y 
    ${CMAKE_CURRENT_BINARY_DIR}/parser.tab.c
    DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/parser.tab.h)

# Генерируем лексер из mini.l
FLEX_TARGET(MyLexer ${CMAKE_CURRENT_SOURCE_DIR}/files/mini.l 
    ${CMAKE_CURRENT_BINARY_DIR}/lex.yy.c)

# Добавляем сгенерированные файлы в проект
add_flex_bison_dependency(MyLexer MyParser)

# Создаём исполняемый файл
add_executable(main ${FLEX_MyLexer_OUTPUTS} ${BISON_MyParser_OUTPUTS})

# Добавляем директорию для заголовочных файлов
target_include_directories(main PRIVATE ${CMAKE_CURRENT_BINARY_DIR})

# Линкуем математическую библиотеку
target_link_libraries(main m)

# Устанавливаем свойства
set_target_properties(main PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}
)
