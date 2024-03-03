  <h1 style="text-align: center;">Makefile Template</h1>

 ---
#### Colorful Output
- Utilizes colorful output to enhance readability and provide clear feedback during compilation and execution.

#### Configuration Section
- Allows easy customization of compiler flags, directories, and project-specific variables.

#### Object Compilation
- Automatically compiles source files into object files and manages dependencies.

#### Automatic Dependency Handling
- Handles dependencies automatically, ensuring that object files are recompiled whenever their dependencies change, including header files.

#### Support for Libraries
- Supports the inclusion of external libraries such as `libft` or `MLX42`.

#### Bonus
- Includes support for bonus, allowing developers to define additional targets and source files.

#### Re, Clean and Fclean
- Provides commands to recompile (`re`), clean up object files (`clean`) and executable files (`fclean`).

#### Progress Visual Indicator
- Displays a visual bar during compilation, providing visual feedback on the build process.
---
### Basic Commands

- `make`: 				Compiles the default target specified in the `Makefile`.
- `make $(NAME)`: 		Compiles the target used for `$(NAME)` specified in the `Makefile`.
- `make clean`: 		Removes object files generated during compilation.
- `make fclean`: 		Removes object files and executable files.
- `make re`: 			Rebuilds the default target from scratch.
- `make wipe`: 			Completely removes the build directory and all generated files silently.

- `make bonus`: 		Compiles the bonus target specified in the `Makefile`.
- `make $(NAME_B)`:		Compiles the target used for `$(NAME_B)` specified in the `Makefile`.
  If `$(NAME_B)` is the same as `$(NAME)`, then use `make $(NAME_B)_bonus`.
- `make cleanb`: 		Removes bonus object files generated during compilation.
- `make fcleanb`: 		Removes bonus object files and executable file.
- `make reb`: 			Rebuilds the bonus target from scratch.
---
### Customization

- `FLAGS`: 				Variable to customize compiler flags. Usually (`-Wall -Werror, -Wextra`)
- `EXTRA_FLAGS`: 		Variable to customize extra compiler flags. Usually used for specific projects where you need an extra flag
- `ENABLE_LIBFT`:		Compile `libft` from `src/libft` and include the library generated in the project.
- `ENABLE_BONUS`:		Enable the option to compile a `bonus` project.
- `ENABLE_NORMINETTE`:	Execute `Norminette` in the source directory of the target and `libft` if enabled.
- `NAME` & `NAME_B`: 	Names for the main and bonus targets.
- `SRCS` & `SRCS_B`: 	Source files for the main and bonus targets.

- You can customize directory paths and file names according to your project structure.
- Modify the `title` and `title_bonus` rules to customize the project titles displayed during compilation.
---
- `MLX42` is included, you can delete it if you don't need it.
- `src/libft` included the Makefile for ´libft´, you just need to add a `src` and `inc` folders, copy your files and add them in `libft/Makefile`.
---
<p style="text-align: center;">Kobayashi82 (vzurera-)</p>
