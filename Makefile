# Compiler and tools
CC = gcc
LEX = flex
YACC = bison

# Files
LEX_FILE = lexer.l
YACC_FILE = parser.y
LEX_C = lex.yy.c
YACC_C = parser.tab.c
YACC_H = parser.tab.h
SYMBOL_TABLE_C = symbol_table.c  # Added symbol_table.c
EXECUTABLE = js_parser

# Default target
all: $(EXECUTABLE)

# Rule to build the executable
$(EXECUTABLE): $(YACC_C) $(LEX_C) $(SYMBOL_TABLE_C)
	$(CC) -o $@ $^ -lfl

# Rule to generate the parser code from the YACC file
$(YACC_C) $(YACC_H): $(YACC_FILE)
	$(YACC) -d $(YACC_FILE)

# Rule to generate the lexer code from the LEX file
$(LEX_C): $(LEX_FILE)
	$(LEX) $(LEX_FILE)

# Rule to run the parser with a sample JavaScript file
run: $(EXECUTABLE)
	@echo "Running the parser..."
	./$(EXECUTABLE) sample.js

# Rule to clean up generated files
clean:
	@echo "Cleaning up..."
	rm -f $(EXECUTABLE) $(LEX_C) $(YACC_C) $(YACC_H) lex.yy.c parser.tab.c parser.tab.h

.PHONY: all run clean
