# Course: CSUB - CMPS 3500
# Activity: 08
# Date: 11/28/25
# Name: Hanah Rocha

import sys
import os

USAGE = "Usage: word_writer.py FILE_NAME WORD COUNT"

def print_words(file_name, word, count):
    """
    Writes `word` to a new file `file_name` exactly `count` times,
    one per line. Assumes arguments are already validated and that
    the file does not yet exist.
    """
    # If something OS-related goes wrong here (like permissions),
    # we let the exception propagate and handle it in main().
    with open(file_name, 'w') as file_obj:
        for _ in range(count):
            file_obj.write(word + "\n")

def main():
    # Check number of arguments (script name + 3 arguments)
    if len(sys.argv) != 4:
        print("Incorrect number of arguments.")
        print(USAGE)
        return

    file_name = sys.argv[1]
    word = sys.argv[2]
    count_str = sys.argv[3]

    # Convert COUNT to integer
    try:
        count = int(count_str)
    except ValueError:
        print(f"'{count_str}' cannot be converted to an integer.")
        print(USAGE)
        return

    # Check if file already exists
    if os.path.exists(file_name):
        print(f"The file {file_name} already exists in this folder.")
        print(USAGE)
        return

    # Try writing to the file, catching OS-level issues
    try:
        print_words(file_name, word, count)
    except PermissionError:
        print(f"You do not have permission to create or write to {file_name}.")
        print(USAGE)
    except OSError as e:
        # Generic OS error (disk full, invalid path, etc.)
        print(f"An error occurred while working with {file_name}: {e}")
        print(USAGE)

if __name__ == "__main__":
    main()

