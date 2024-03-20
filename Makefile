# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vzurera- <vzurera-@student.42malaga.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/01/16 11:45:10 by vzurera-          #+#    #+#              #
#    Updated: 2024/03/03 12:54:40 by vzurera-         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# ───────────────────────────────────────────────────────────── #
# ─────────────────────── CONFIGURATION ─────────────────────── #
# ───────────────────────────────────────────────────────────── #

# ──────────── #
# ── COLORS ── #
# ──────────── #

NC    				= \033[0m
RED     			= \033[0;31m
GREEN   			= \033[0;32m
YELLOW  			= \033[0;33m
CYAN    			= \033[0;36m
WHITE   			= \033[0;37m
INV_CYAN			= \033[7;36m
BG_CYAN				= \033[40m
FG_YELLOW			= \033[89m
COUNTER 			= 0

# ─────────── #
# ── FLAGS ── #
# ─────────── #

FLAGS				= -Wall -Wextra -Werror
EXTRA_FLAGS			= 
# (Philosophers) 	EXTRA_FLAGS			= -pthread -g -fsanitize=thread	# Check for data races (CAN'T USE BOTH SANITIZE AT THE SAME TIME OR WITH LEAKS OR VALGRIND)
# (Philosophers) 	EXTRA_FLAGS			= -pthread -g -fsanitize=address	# Check for bad memory access (FOR MEMORY LEAKS, USE LEAKS OR VALGRIND)
# (MLX42 - MacOS) 	EXTRA_FLAGS			= -lglfw -L"/Users/$(USER)/.brew/opt/glfw/lib/" -pthread -lm
# (MLX42 - WSL) 	EXTRA_FLAGS			= -ldl -lglfw -pthread -lm

# ─────────────── #
# ── VARIABLES ── #
# ─────────────── #

ENABLE_LIBFT		= 0
ENABLE_BONUS		= 0
ENABLE_NORMINETTE	= 0

#	TITLE NOTES:	To center the title, edit the 'title' and 'title_bonus' rules by adding or removing spaces

# ────────── #
# ── NAME ── #
# ────────── #

NAME				= 
NAME_B				= 

# ─────────── #
# ── FILES ── #
# ─────────── #

SRCS	=	
SRCS_B	= 	

# ───────────────── #
# ── DIRECTORIES ── #
# ───────────────── #

INC_DIR				= ./inc/
OBJ_DIR				= ./build/obj/
LIB_DIR				= ./build/lib/
LIBFT_INC			= ./src/libft/inc/
LIBFT_DIR			= ./src/libft/
LIBFT				= libft.a
# MLX_INC				= ./src/MLX42/include/MLX42/	# Add -I$(MLX_INC) to object compilation
# MLX					= ./src/MLX42/libmlx42.a	# Add $(MLX) to 'gcc' command
SRC_DIR				= ./src/$(NAME)/
ifneq ($(NAME),$(NAME_B))
    ifeq ($(shell test -d ./src/$(NAME_B) && echo yes),yes)
        SRC_DIR_B = ./src/$(NAME_B)/
    else
        SRC_DIR_B = ./src/$(NAME_B)_bonus/
    endif
else
    SRC_DIR_B = ./src/$(NAME_B)_bonus/
endif

# ────────────────────────────────────────────────────────── #
# ───────────────────────── NORMAL ───────────────────────── #
# ────────────────────────────────────────────────────────── #

TARGET=$(if $(SRCS),$(NAME),empty)
TARGET=$(if $(NAME),$(NAME),empty)
all: $(TARGET)

empty:
#	Check if NAME is empty
	@rm -f .is_re; if [ ! -n "$(NAME)" ] || [ ! -n "$(SRCS)" ]; then printf "\n\t$(CYAN)source files doesn't exist\n\n$(NC)"; exit 1; fi

#all: $(NAME)

OBJS		= $(SRCS:%.c=$(OBJ_DIR)%.o)
DEPS		= $(OBJS:.o=.d)
-include $(DEPS)

$(NAME): normal_extra $(OBJS)
#	Compile program
	@if [ -f $(NAME) ]; then \
		printf "\r%50s\r\t$(CYAN)Compiled    $(GREEN)✓ $(YELLOW)$(NAME)$(NC)"; \
	else \
		printf "\r%50s\r\t$(CYAN)Compiling... $(YELLOW)$(NAME)$(NC)"; \
	fi
	@if [ "$(ENABLE_LIBFT)" = "1" ] && [ -d "$(LIBFT_DIR)" ]; then \
        gcc $(FLAGS) -I$(INC_DIR) $(OBJS) $(LIB_DIR)$(LIBFT) $(EXTRA_FLAGS) -o $(NAME); \
    else \
        gcc $(FLAGS) -I$(INC_DIR) $(OBJS) $(EXTRA_FLAGS) -o $(NAME); \
    fi
	@printf "\r%50s\r\t$(CYAN)Compiled    $(GREEN)✓ $(YELLOW)$(NAME)$(NC)\n"
#	Progress line
	@$(MAKE) -s progress
#	Norminette
	@if [ "$(ENABLE_NORMINETTE)" = "1" ]; then \
		printf "\n\t$(WHITE)─────────────────────────$(NC)\033[1A\r"; \
		printf "\r%50s\r\t$(CYAN)Norminette  $(YELLOW)scanning...$(NC)"; \
		output2=""; \
		if [ "$(ENABLE_LIBFT)" = "1" ] && [ -d "$(LIBFT_DIR)" ]; then output2=$$(norminette $(LIBFT_DIR) 2>&1); fi; \
		output1=$$(norminette $(SRC_DIR) 2>&1); \
		if echo $$output1 $$output2 | grep -q "Error"; then \
			printf "\r%50s\r\t$(CYAN)Norminette  $(RED)X $(YELLOW)errors$(NC)\n"; \
		else \
			printf "\r%50s\r\t$(CYAN)Norminette  $(GREEN)✓ $(YELLOW)perfect$(NC)\n"; \
		fi; $(MAKE) -s progress; \
	fi; printf "\n"
#	Restore cursor
	@$(MAKE) -s show_cursor

# ───────────── #
# ── OBJECTS ── #
# ───────────── #

$(OBJ_DIR)%.o: $(SRC_DIR)%.c
#	Create folder
	@mkdir -p $(@D)
#	Compile objects
	@filename=$$(basename $<); filename=$${filename%.*}; \
	BAR=$$(printf "/ ─ \\ |" | cut -d" " -f$$(($(COUNTER) % 4 + 1))); \
	printf "\r%50s\r\t$(CYAN)Compiling... $(GREEN)$$BAR  $(YELLOW)$$filename$(NC)"; \
	$(eval COUNTER=$(shell echo $$(($(COUNTER)+1))))
	@gcc $(FLAGS) -I$(INC_DIR) -I$(LIBFT_INC) $(EXTRA_FLAGS) -MMD -o $@ -c $<

# ───────────────── #
# ── EXTRA RULES ── #
# ───────────────── #

normal_extra:
#	Check if NAME is empty and source directory exists
	@if [ ! -n "$(NAME)" ] || [ ! -n "$(SRCS)" ] || [ ! -d "$(SRC_DIR)" ]; then printf "\n\t$(CYAN)source files doesn't exist\n\n$(NC)"; rm -f .is_re; exit 1; fi
#	Hide cursor
	@$(MAKE) -s hide_cursor
#	Create folders
	@mkdir -p build/lib
#	Title
	@if [ ! -f .is_re ]; then clear; $(MAKE) -s title; fi; rm -f .is_re
#	Compile LIBFT
	@if [ "$(ENABLE_LIBFT)" = "1" ] && [ -d "$(LIBFT_DIR)" ]; then \
		(make -s all -C $(LIBFT_DIR)/; exit 0); $(MAKE) -s hide_cursor; \
	else \
		printf "\t$(WHITE)─────────────────────────\n$(NC)"; \
	fi; printf "\n\t─────────────────────────$(NC)\033[1A\r"

# ───────────────────────────────────────────────────────── #
# ───────────────────────── BONUS ───────────────────────── #
# ───────────────────────────────────────────────────────── #

ifneq ($(NAME),$(NAME_B))
$(NAME_B): bonus
else
$(NAME_B)_bonus: bonus
endif

OBJS_B		= $(SRCS_B:%.c=$(OBJ_DIR)%.o)
DEPS_B		= $(OBJS_B:.o=.d)
-include $(DEPS_B)

bonus: bonus_extra $(OBJS_B)
#	Compile program
	@printf "\n\t$(WHITE)─────────────────────────$(NC)\033[1A\r"
	@if [ -f $(NAME_B) ]; then \
		printf "\r%50s\r\t$(CYAN)Compiled    $(GREEN)✓ $(YELLOW)$(NAME_B)$(NC)"; \
    else \
		printf "\r%50s\r\t$(CYAN)Compiling... $(YELLOW)$(NAME_B)$(NC)"; \
    fi
	@if [ "$(ENABLE_LIBFT)" = "1" ] && [ -d "$(LIBFT_DIR)" ]; then \
        gcc $(FLAGS) -I$(INC_DIR) $(OBJS_B) $(LIB_DIR)$(LIBFT) $(EXTRA_FLAGS) -o $(NAME_B); \
    else \
        gcc $(FLAGS) -I$(INC_DIR) $(OBJS_B) $(EXTRA_FLAGS) -o $(NAME_B); \
    fi
	@printf "\r%50s\r\t$(CYAN)Compiled    $(GREEN)✓ $(YELLOW)$(NAME_B)$(NC)\n"
#	Progress line
	@$(MAKE) -s progress
#	Norminette
	@if [ "$(ENABLE_NORMINETTE)" = "1" ]; then \
		printf "\n\t$(WHITE)─────────────────────────$(NC)\033[1A\r"; \
		printf "\r%50s\r\t$(CYAN)Norminette  $(YELLOW)scanning...$(NC)"; \
		output1=$$(norminette $(SRC_DIR_B) 2>&1); \
		output2=""; \
		if [ $(ENABLE_LIBFT) = "1" ] && [ -d "$(LIBFT_DIR)" ]; then output2=$$(norminette $(LIBFT_DIR) 2>&1); fi; \
    	if echo $$output1 $$output2 | grep -q "Error"; then \
        	printf "\r%50s\r\t$(CYAN)Norminette  $(RED)X $(YELLOW)errors$(NC)\n"; \
    	else \
			printf "\r%50s\r\t$(CYAN)Norminette  $(GREEN)✓ $(YELLOW)perfect$(NC)\n"; \
    	fi; $(MAKE) -s progress; \
	fi; printf "\n"
#	Restore cursor
	@$(MAKE) -s show_cursor

# ───────────── #
# ── OBJECTS ── #
# ───────────── #

$(OBJ_DIR)%.o: $(SRC_DIR_B)%.c
#	Create folder
	@mkdir -p $(@D)
#	Compile objects
	@filename=$$(basename $<); filename=$${filename%.*}; \
	BAR=$$(printf "/ ─ \\ |" | cut -d" " -f$$(($(COUNTER) % 4 + 1))); \
	printf "\r%50s\r\t$(CYAN)Compiling... $(GREEN)$$BAR  $(YELLOW)$$filename$(NC)"; \
	$(eval COUNTER=$(shell echo $$(($(COUNTER)+1))))
	@gcc $(FLAGS) -I$(INC_DIR) -I$(LIBFT_INC) $(EXTRA_FLAGS) -MMD -o $@ -c $<

# ───────────────── #
# ── EXTRA RULES ── #
# ───────────────── #

bonus_extra:
#	Check if NAME_B is empty, bonus is enabled and bonus directory exists
	@if [ ! -n "$(NAME_B)" ] || [ ! -n "$(SRCS_B)" ] || [ $(ENABLE_BONUS) = "0" ] || [ ! -d "$(SRC_DIR_B)" ]; then \
		printf "\n\t$(YELLOW)BONUS $(CYAN)is disabled in Makefile or source files doesn't exist\n\n$(NC)"; \
		rm -f .is_re; exit 1; \
	fi
#	Hide cursor
	@$(MAKE) -s hide_cursor
#	Create folders
	@mkdir -p build/lib
#	Title
	@if [ ! -f .is_re ]; then clear; $(MAKE) -s title_bonus; fi; rm -f .is_re
#	Compile LIBFT
	@if [ "$(ENABLE_LIBFT)" = "1" ] && [ -d "$(LIBFT_DIR)" ]; then \
		(make -s all -C $(LIBFT_DIR)/; exit 0); $(MAKE) -s hide_cursor; \
	else \
		printf "\t$(WHITE)─────────────────────────\n$(NC)"; \
	fi; printf "\n\t─────────────────────────$(NC)\033[1A\r"

# ───────────────────────────────────────────────────────────── #
# ────────────────────────── RE-MAKE ────────────────────────── #
# ───────────────────────────────────────────────────────────── #

# ──────── #
# ── RE ── #
# ──────── #

re:
#	Check if NAME is empty and source directory exists
	@rm -f .is_re; if [ ! -n "$(NAME)" ] || [ ! -n "$(SRCS)" ] || [ ! -d "$(SRC_DIR)" ]; then printf "\n\t$(CYAN)source files doesn't exist\n\n$(NC)"; exit 1; fi
#	Hide cursor
	@$(MAKE) -s hide_cursor
#	FClean
	@$(MAKE) -s fclean
#	Create files
	@touch .is_re; printf "\033[1A\033[1A\r"
#	Execute $(NAME)
	@$(MAKE) -s $(NAME)

# ───────── #
# ── REB ── #
# ───────── #

reb:
#	Check if NAME_B is empty, bonus is enabled and bonus directory exists
	@rm -f .is_re; if [ ! -n "$(NAME_B)" ] || [ ! -n "$(SRCS_B)" ] || [ $(ENABLE_BONUS) = "0" ] || [ ! -d "$(SRC_DIR_B)" ]; then \
		printf "\n\t$(YELLOW)BONUS $(CYAN)is disabled in Makefile or source files doesn't exist\n\n$(NC)"; exit 1; \
	fi
#	Hide cursor
	@$(MAKE) -s hide_cursor
#	FClean bonus
	@$(MAKE) -s fcleanb
#	Create files
	@touch .is_re; printf "\033[1A\033[1A\r"
#	Execute $(NAME_B)
	@$(MAKE) -s bonus

# ───────────────────────────────────────────────────────────── #
# ─────────────────────────── CLEAN ─────────────────────────── #
# ───────────────────────────────────────────────────────────── #

# ─────────── #
# ── CLEAN ── #
# ─────────── #

clean:
#	Check if NAME is empty
	@rm -f .is_re; if [ ! -n "$(NAME)" ] || [ ! -n "$(SRCS)" ]; then printf "\n\t$(CYAN)source files doesn't exist\n\n$(NC)"; exit 1; fi
#	Hide cursor
	@$(MAKE) -s hide_cursor
#	Title
	@clear; $(MAKE) -s title
#	Delete objects
	@if [ "$(ENABLE_LIBFT)" = "1" ] && [ -d "$(LIBFT_DIR)" ]; then \
		(make -s delete_objects -C $(LIBFT_DIR)/; exit 0); \
	else \
		printf "\t$(WHITE)─────────────────────────\n$(NC)"; \
	fi
#	Delete objects
	@$(MAKE) -s delete_objects; $(MAKE) -s delete_objects_b 
	@printf "\r%50s\r\t$(CYAN)Deleted     $(GREEN)✓ $(YELLOW)objects$(NC)\n"
#	Progress line
	@$(MAKE) -s progress; printf "\n"
#	Restore cursor
	@$(MAKE) -s show_cursor

# ──────────── #
# ── CLEANB ── #
# ──────────── #

cleanb:
#	Check if NAME_B is empty
	@rm -f .is_re; if [ ! -n "$(NAME_B)" ] || [ ! -n "$(SRCS_B)" ]; then printf "\n\t$(CYAN)source files doesn't exist\n\n$(NC)"; exit 1; fi
#	Hide cursor
	@$(MAKE) -s hide_cursor
#	Title
	@clear; $(MAKE) -s title_bonus
#	Delete objects
	@if [ "$(ENABLE_LIBFT)" = "1" ] && [ -d "$(LIBFT_DIR)" ]; then \
		(make -s delete_objects -C $(LIBFT_DIR)/; exit 0); \
	else \
		printf "\t$(WHITE)─────────────────────────\n$(NC)"; \
	fi
#	Delete objects
	@$(MAKE) -s delete_objects_b
	@printf "\r%50s\r\t$(CYAN)Deleted     $(GREEN)✓ $(YELLOW)objects$(NC)\n"
#	Progress line
	@$(MAKE) -s progress; printf "\n"
#	Restore cursor
	@$(MAKE) -s show_cursor

# ───────────────────────────────────────────────────────────── #
# ────────────────────────── F-CLEAN ────────────────────────── #
# ───────────────────────────────────────────────────────────── #

# ──────────── #
# ── FCLEAN ── #
# ──────────── #

fclean:
#	Check if NAME is empty
	@rm -f .is_re; if [ ! -n "$(NAME)" ] || [ ! -n "$(SRCS)" ]; then printf "\n\t$(CYAN)source files doesn't exist\n\n$(NC)"; exit 1; fi
#	Hide cursor
	@$(MAKE) -s hide_cursor
#	Title
	@clear; $(MAKE) -s title
#	Delete LIBFT
	@if [ "$(ENABLE_LIBFT)" = "1" ] && [ -d "$(LIBFT_DIR)" ]; then \
		(make -s -C $(LIBFT_DIR) fclean; exit 0); \
	else \
		printf "\t$(WHITE)─────────────────────────\n$(NC)"; \
	fi
#	Delete objects
	@$(MAKE) -s delete_objects; $(MAKE) -s delete_objects_b
#	Delete $(NAME)
	@if [ -f $(NAME) ]; then \
		printf "\t$(CYAN)Deleting... $(YELLOW)$(NAME)$(NC)"; \
		rm -f $(NAME); \
	fi
	@printf "\r%50s\r\t$(CYAN)Deleted     $(GREEN)✓ $(YELLOW)$(NAME)$(NC)\n"
	@$(MAKE) -s progress
#	Delete $(NAME_B)
	@if [ -n "$(NAME_B)" ] && [ -f $(NAME_B) ]; then \
		printf "\t$(CYAN)Deleting... $(YELLOW)$(NAME_B)$(NC)"; \
		rm -f $(NAME_B); \
		printf "\r%50s\r\t$(CYAN)Deleted     $(GREEN)✓ $(YELLOW)$(NAME_B)$(NC)\n"; \
		$(MAKE) -s progress; \
	fi; printf "\n"
#	Delete folder and files
	@-rm -d $(LIB_DIR) >/dev/null 2>&1 || true
	@-rm -d ./build >/dev/null 2>&1 || true
#	Restore cursor
	@$(MAKE) -s show_cursor

# ───────────── #
# ── FCLEANB ── #
# ───────────── #

fcleanb:
#	Check if NAME_B is empty
	@rm -f .is_re; if [ ! -n "$(NAME_B)" ] || [ ! -n "$(SRCS_B)" ]; then printf "\n\t$(CYAN)source files doesn't exist\n\n$(NC)"; exit 1; fi
#	Hide cursor
	@$(MAKE) -s hide_cursor
#	Title
	@clear; $(MAKE) -s title_bonus
#	Delete LIBFT
	@if [ "$(ENABLE_LIBFT)" = "1" ] && [ -d "$(LIBFT_DIR)" ]; then \
		(make -s -C $(LIBFT_DIR) fclean; exit 0); \
	else \
		printf "\t$(WHITE)─────────────────────────\n$(NC)"; \
	fi
#	Delete objects
	@$(MAKE) -s delete_objects_b
#	Delete $(NAME_B)
	@if [ -f $(NAME_B) ]; then \
		printf "\t$(CYAN)Deleting... $(YELLOW)$(NAME_B)$(NC)"; \
		rm -f $(NAME_B); \
	fi
	@printf "\r%50s\r\t$(CYAN)Deleted     $(GREEN)✓ $(YELLOW)$(NAME_B)$(NC)\n"
#	Progress line
	@$(MAKE) -s progress; printf "\n"
#	Delete folder and files
	@-rm -d $(LIB_DIR) >/dev/null 2>&1 || true
	@-rm -d ./build >/dev/null 2>&1 || true
#	Restore cursor
	@$(MAKE) -s show_cursor

# ───────────────────────────────────────────────────────────── #
# ───────────────────────── FUNCTIONS ───────────────────────── #
# ───────────────────────────────────────────────────────────── #

# ─────────── #
# ── TITLE ── #
# ─────────── #

title:
	@printf "\n$(NC)\t$(INV_CYAN)          $(shell echo $(NAME) | tr a-z A-Z | tr '_' ' ')          $(NC)\n"

title_bonus:
	@printf "\n$(NC)\t$(INV_CYAN) $(BG_CYAN)$(FG_YELLOW)★$(INV_CYAN) $(BG_CYAN)$(FG_YELLOW)★$(INV_CYAN) $(BG_CYAN)$(FG_YELLOW)★\
	$(INV_CYAN)    $(NC)$(INV_CYAN)$(shell echo $(NAME_B) | tr a-z A-Z | tr '_' ' ')$(INV_CYAN)    \
	$(BG_CYAN)$(FG_YELLOW)★$(INV_CYAN) $(BG_CYAN)$(FG_YELLOW)★$(INV_CYAN) $(BG_CYAN)$(FG_YELLOW)★$(INV_CYAN) $(NC)\n"

# ───────────── #
# ── CURSORS ── #
# ───────────── #

hide_cursor:
	@printf "\e[?25l"
 
show_cursor:
	@printf "\e[?25h"

# ──────────────────── #
# ── DELETE OBJECTS ── #
# ──────────────────── #

delete_objects:
	@printf "\n\t$(WHITE)─────────────────────────$(NC)\033[1A\r"
	@if [ -n "$(shell ls -A $(OBJ_DIR) 2>/dev/null)" ]; then \
		COUNTER=0; \
		for file in $(OBJ_DIR)/*.o; do \
			BAR=$$(printf "/ ─ \\ |" | cut -d" " -f$$((COUNTER % 4 + 1))); \
			filename=$$(basename $$file); \
			for src in $(SRCS); do \
				srcname=$$(basename $$src .c); \
				if [ $$filename = $$srcname.o ]; then \
					rm -f $$file $$(dirname $$file)/$$srcname.d; \
					filename=$${filename%.*}; \
					printf "\r%50s\r\t$(CYAN)Deleting... $(GREEN)$$BAR $(YELLOW)$$filename$(NC)"; sleep 0.05; \
					COUNTER=$$((COUNTER+1)); \
					break; \
				fi; \
			done; \
		done; \
    fi; printf "\r%50s\r"
#	Delete object folder
	@-rm -d $(OBJ_DIR) >/dev/null 2>&1 || true

delete_objects_b:
	@printf "\n\t$(WHITE)─────────────────────────$(NC)\033[1A\r"
	@if [ -n "$(shell ls -A $(OBJ_DIR) 2>/dev/null)" ]; then \
		COUNTER=0; \
		for file in $(OBJ_DIR)/*.o; do \
			BAR=$$(printf "/ ─ \\ |" | cut -d" " -f$$((COUNTER % 4 + 1))); \
			filename=$$(basename $$file); \
			for src in $(SRCS_B); do \
				srcname=$$(basename $$src .c); \
				if [ $$filename = $$srcname.o ]; then \
					rm -f $$file $$(dirname $$file)/$$srcname.d; \
					filename=$${filename%.*}; \
					printf "\r%50s\r\t$(CYAN)Deleting... $(GREEN)$$BAR $(YELLOW)$$filename$(NC)"; sleep 0.05; \
					COUNTER=$$((COUNTER+1)); \
					break; \
				fi; \
			done; \
		done; \
    fi; printf "\r%50s\r"
#	Delete object folder
	@-rm -d $(OBJ_DIR) >/dev/null 2>&1 || true

wipe:
	@rm -rf build ; rm -f .is_re $(NAME) $(NAME_B)

# ─────────────────── #
# ── PROGRESS LINE ── #
# ─────────────────── #

progress:
	@total=25; printf "\r\t"; for i in $$(seq 1 $$total); do printf "$(RED)─"; sleep 0.01; done; printf "$(NC)"
	@total=25; printf "\r\t"; for i in $$(seq 1 $$total); do printf "─"; sleep 0.01; done; printf "\n$(NC)"

# ─────────── #
# ── PHONY ── #
# ─────────── #

.PHONY: all clean cleanb fclean fcleanb re reb bonus normal_extra bonus_extra wipe \
		delete_objects delete_objects_b title title_bonus hide_cursor show_cursor progress
