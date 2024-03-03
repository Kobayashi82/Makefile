# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vzurera- <vzurera-@student.42malaga.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/01/16 16:40:56 by vzurera-          #+#    #+#              #
#    Updated: 2024/03/03 12:57:53 by vzurera-         ###   ########.fr        #
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

FLAGS	= -Wall -Wextra -Werror

# ───────────────── #
# ── DIRECTORIES ── #
# ───────────────── #

INC_DIR		= ./inc/
OBJ_DIR		= ../../build/obj/
LIB_DIR		= ../../build/lib/
SRC_DIR		= ./src/

# ────────── #
# ── NAME ── #
# ────────── #

NAME	= libft.a

# ─────────── #
# ── FILES ── #
# ─────────── #

SRCS		= 

# ────────────────────────────────────────────────────────── #
# ───────────────────────── NORMAL ───────────────────────── #
# ────────────────────────────────────────────────────────── #

all: $(NAME)

OBJS		= $(SRCS:%.c=$(OBJ_DIR)%.o)
DEPS		= $(OBJS:.o=.d)
-include $(DEPS)

$(NAME): normal_extra $(OBJS)
#	Create folder
	@mkdir -p $(LIB_DIR)
#	Compile library
	@if [ -f $(LIB_DIR)$(NAME) ]; then \
		printf "\r%50s\r\t$(CYAN)Compiled    $(GREEN)✓ $(YELLOW)$(NAME)$(NC)"; \
    else \
        printf "\r%50s\r\t$(CYAN)Compiling... $(YELLOW)$(NAME)$(NC)"; \
    fi
	@ar rcs $(LIB_DIR)$(NAME) $(OBJS)
	@printf "\r%50s\r\t$(CYAN)Compiled    $(GREEN)✓ $(YELLOW)$(NAME)$(NC)\n"
#	Progress line
	@$(MAKE) -s progress

# ───────────── #
# ── OBJECTS ── #
# ───────────── #

-include $(DEPS)

$(OBJ_DIR)%.o: $(SRC_DIR)%.c
#	Create folder
	@mkdir -p $(@D)
#	Compile objects
	@filename=$$(basename $<); filename=$${filename%.*}; \
	BAR=$$(printf "/ ─ \\ |" | cut -d" " -f$$(($(COUNTER) % 4 + 1))); \
	printf "\r%50s\r\t$(CYAN)Compiling... $(GREEN)$$BAR $(YELLOW)$$filename$(NC)"; \
	$(eval COUNTER=$(shell echo $$(($(COUNTER)+1))))
	@gcc $(FLAGS) -I$(INC_DIR) -MMD -o $@ -c $<

# ───────────────── #
# ── EXTRA RULES ── #
# ───────────────── #

normal_extra:
#	Hide cursor
	@$(MAKE) -s hide_cursor
	@printf "\t$(WHITE)─────────────────────────\n$(NC)"
	@printf "\n\t$(WHITE)─────────────────────────$(NC)\033[1A\r"

# ───────────────────────────────────────────────────────────── #
# ───────────────────────── RE - CLEAN ─────────────────────────#
# ───────────────────────────────────────────────────────────── #

# ───────────── #
# ── RE-MAKE ── #
# ───────────── #

re: fclean
	@printf "\033[1A\r"
#	Execute $(NAME)
	@$(MAKE) -s $(NAME)

# ─────────── #
# ── CLEAN ── #
# ─────────── #

clean:
#	Delete objects
	@$(MAKE) -s delete_objects
	@printf "\r%50s\r\t$(CYAN)Deleted     $(GREEN)✓ $(YELLOW)objects$(NC)\n"
#	Hide cursor
	@$(MAKE) -s hide_cursor
#	Progress line
	@$(MAKE) -s progress

# ──────────── #
# ── FCLEAN ── #
# ──────────── #

fclean:
#	Delete objects
	@$(MAKE) -s delete_objects
#	Delete $(NAME)
	@if [ -f $(LIB_DIR)$(NAME) ]; then \
		printf "\t$(CYAN)Deleting... $(YELLOW)$(NAME)$(NC)"; \
		rm -f $(LIB_DIR)$(NAME); \
	fi
#	Hide cursor
	@$(MAKE) -s hide_cursor
	@printf "\r%50s\r\t$(CYAN)Deleted     $(GREEN)✓ $(YELLOW)$(NAME)$(NC)\n"
#	Progress line
	@$(MAKE) -s progress

# ───────────────────────────────────────────────────────────── #
# ───────────────────────── FUNCTIONS ───────────────────────── #
# ───────────────────────────────────────────────────────────── #

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
	@printf "\t$(WHITE)─────────────────────────\n$(NC)"
	@printf "\n\t$(WHITE)─────────────────────────$(NC)\033[1A\r"
	@COUNTER=0; \
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
	done; printf "\r%50s\r"

# ─────────────────── #
# ── PROGRESS LINE ── #
# ─────────────────── #

progress:
	@total=25; printf "\r\t"; for i in $$(seq 1 $$total); do printf "$(RED)─"; sleep 0.01; done; printf "$(NC)"
	@total=25; printf "\r\t"; for i in $$(seq 1 $$total); do printf "─"; sleep 0.01; done; printf "\n$(NC)"

# ─────────── #
# ── PHONY ── #
# ─────────── #

.PHONY: all clean fclean re normal_extra hide_cursor show_cursor progress