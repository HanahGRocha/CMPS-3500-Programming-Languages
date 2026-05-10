#!/usr/bin/perl
# PhoneProcessor.perl
# CMPS 3500

use strict;
use warnings;
use Text::ParseWords;

my $infile = "Phones.txt";
my $outfile = ">CleanPhones.txt";

# Open files to open and read operations, use '>' to overwrite existing file; use '>>' to append
open(INFILE, "<:encoding(UTF-8)", $infile)   or die "Cannot open $infile: $!";
open(OUTFILE, ">:encoding(UTF-8)", "$outfile") or die "Cannot open $outfile: $!";

#printing headers for both the screened the output file
#headers for screen
printf("%-15s%-15s%-18s%-9s%-15s%-21s\n","Last", "First","Clean","String","Usable", "Formatted");
printf("%-15s%-15s%-18s%-9s%-15s%-21s\n","Name", "Name", "Phone Number", "Length", "Phone Number", "Phone Number");
printf("%-15s%-15s%-18s%-9s%-15s%-21s\n","************", "************", "************", "*******", "*************", "*******************");

#output file
printf OUTFILE ("%-15s%-15s%-18s%-9s%-15s%-21s\n","Last", "First","Clean","String","Usable", "Formatted");
printf OUTFILE ("%-15s%-15s%-18s%-9s%-15s%-21s\n","Name", "Name", "Phone Number", "Length", "Phone Number", "Phone Number");
printf OUTFILE ("%-15s%-15s%-18s%-9s%-15s%-21s\n","************", "************", "************", "*******", "*************", "*******************");

#initializing variables to count phone numbers
my $ndropped = 0;
my $nten = 0;
my $nrows = 0;  # to track number of lines in input file.

#Reading input file
while(my $line = <INFILE>) {
  
    $nrows = $nrows  + 1; # counte ro track number of lines in input file
    next if $. == 1;   # skip the first line
    chomp $line;

  #remove commas from text within quotation marks
  $line =~ s/(?:\G(?!\A)|[^"]*")[^",]*\K(?:,|"(*SKIP)(*FAIL))//g;

  # remove quotation marks
  $line =~ s/"//g;
  # print $line

  # split the line into 2 fields using a comma as the delimiter
  (my $index, my $name, my $city, my $state, my $phone) = split(',', $line);

  # split field1 into 2 fields using a blank as the delimiter
  (my $lname,my $fname) = split(' ', $name);

  # Always have defined strings for printing:
  $fname = defined($fname) ? $fname : "";
  $lname = defined($lname) ? $lname : "";

  # #removing all non-numeric haracters from $field2 to create a "clean phone number"
   $phone =~ s/[^0-9,]//g;

  # Calculating the length of the clean phone number
   my $phonelenth = length($phone);

  # initializing varialbe to hold a usable phone number
   my $phonenumber = "";

  # Creating a "usable phone number" using provided rules
   if($phonelenth == 7){
     $phonenumber = "661".$phone;
   }
   elsif($phonelenth == 8){
     $phonenumber = "661".substr($phone,0,7);
   }
   elsif($phonelenth == 9){
     $phonenumber = "92".substr($phone,1,8);
   }
   else{
     $phonenumber = "Dropped";
     $ndropped = $ndropped + 1;
  }

  #initializing #$formatnumber
  my $formatnumber ="";

  #constructing formated phone phone number when id not Dropped
  if($phonelenth == 7 or $phonelenth == 8 or $phonelenth == 9){
    $formatnumber =  "(".substr($phonenumber,0,3).") ".substr($phonenumber,3,3)." - ".substr($phonenumber,6,4);
  }
  else{
    $formatnumber = "";
  }
  # printing output in screen
  printf("%-15s%-15s%-18s%-9s%-15s%-21s\n","$lname", "$fname","$phone","$phonelenth","$phonenumber","$formatnumber");

  # printing output in output file
  printf OUTFILE ("%-15s%-15s%-18s%-9s%-15s%-21s\n", "$lname", "$fname", "$phone", "$phonelenth", "$phonenumber", "$formatnumber");


}
close(INFILE);
close(OUTFILE);

#printing amswers for pdf
print "\n".$ndropped." phone numbers were dropped...";
print "\n".(($nrows - 1) - $ndropped)." phone numbers were correctly identified...\n"; # we use ($nrows - 1) since we dropped the first le.
