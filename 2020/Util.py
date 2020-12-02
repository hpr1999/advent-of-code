import os

def read_file(dayString):
    """
    Reads the input file for the given day and returns it as a list of strings
    """
    with open(os.path.abspath("./2020/input/"+dayString),mode='r') as file:
        return file.read().splitlines()
