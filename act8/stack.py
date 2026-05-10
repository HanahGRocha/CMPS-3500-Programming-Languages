# Course: CSUB - CMPS 3500
# Activity: 08
# Date: 11/28/25
# Name: Hanah Rocha

#CMPS 3500
#########################
#  Basic Stack Simulator
#########################

MAX_SIZE = 10  # maximum number of elements in the stack

def isEmpty(stack):
    return len(stack) == 0

def isFull(stack):
    return len(stack) >= MAX_SIZE

def size(stack):
    return len(stack)

print("***********************************")
print("          Stack Simulator          ")
print("***********************************")
print("Please only use digits from 0 to 9 ")
print("***********************************")
print("Please enter 'pop' for popping")
print("Please enter 'push' for pushing")
print("Please enter 'print' to print")
print("Please enter 'IsEmpty' to check if the stack is empty")
print("Please enter 'IsFull' to check if the stack is full")
print("Please enter 'size' to print the current size of the stack")
print("Please enter 'end' to terminate the program")

stack = []  # make a list named 'stack'

while True:
    val = input("...")  # get input from the user

    if val == 'push':
        # check if stack is already full
        if isFull(stack):
            print("The stack is full, please pop an element to continue")
            continue

        a = input("Which number to push?... ")

        # validate: one-character string, digit 0–9
        if len(a) == 1 and a.isdigit():
            stack.append(a)  # push the number
        else:
            # invalid input
            print("please enter only a 1 digit positive numbers")

    elif val == 'pop':
        if isEmpty(stack):
            print("Cannot pop from an empty stack, please push some elements")
        else:
            print(stack.pop())  # pop

    elif val == 'print':
        print(stack)  # print the list

    elif val == 'IsEmpty':
        if isEmpty(stack):
            print("Stack is empty")
        else:
            print("Stack is not empty")

    elif val == 'IsFull':
        if isFull(stack):
            print("Stack is full")
        else:
            print("Stack is not full")

    elif val == 'size':
        print(f"The current size of the stack is {size(stack)}")

    elif val == 'end':
        break  # terminate the while loop

    else:
        print("Unknown command ")

print("Thank you")

