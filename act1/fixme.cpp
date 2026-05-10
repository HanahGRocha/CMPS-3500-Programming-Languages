#include <iostream> 
#include <string> 
#include <bits/stdc++.h>
using namespace std;
int f1(int a[], int n, int x)
{for (int i = 0; i < n; i++)
 if (a[i] == x) return i; return -1;}
int f2(int a[], int beg, int end, int key) {int mid;  
if(end >= beg) { mid = (beg + end)/2;  
if(a[mid] == key) {return mid+1;}  
else if(a[mid] < key) {return f2(a,mid+1,end,key);}  
else {return f2(a,beg,mid-1,key);}}  
return -1;} int f3(int a[], int n, int x){int step = sqrt(n);
int prev = 0;
while (a[min(step, n)-1] < x) {prev = step; step += sqrt(n); 
if (prev >= n) return -1;}
while (a[prev] < x) {prev++;
if (prev == min(step, n)) return -1;}
if (a[prev] == x) return prev; return -1;}
int main () {  
int a[100] = { 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 
73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 
163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 
251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 
349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 
443, 449, 457, 461, 463, 467, 479, 487, 491, 499, 503, 509, 521, 523, 541}; 
int key; int l1 = -1; int l2 = -1; int l3 = -1;
cout<<"Enter the number that is to be searched: "; cin >> key;
l1 = f1(a,100, key); l2 = f2(a, 0, 100, key); l3 = f3(a, 100,key); 
if((l1 + l2 + l3) != -3)  {  
cout<<"Key found at location using <your answer>: "<< l1 + 1<<"\n"; 
cout<<"Key found at location using <your answer>: "<< l2 <<"\n"; 
cout<<"Key found at location using <your answer>: "<< l3 + 1 <<"\n\n"; }  
else {cout<<"Requested key not found\n\n";}}