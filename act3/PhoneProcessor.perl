#!/usr/bin/perl
# NAME: Hanah G. Rocha
# FILE: PhoneProcessor.perl
# ORGN: CSUB - CMPS 3500
# ASGT: Activity 3 "Introduction to Perl Scripting"
# DATE: 10/13/25

use strict;
use warnings;
use Text::ParseWords;

my $infile = "PhoneBook.txt";
my $outfile = "CleanPhoneBook.txt";

# Open files to open and read operations, use '>' to overwrite existing file; use '>>' to append
open(my $in, "<:encoding(UTF-8)", $infile)   or die "Cannot open $infile: $!";
open(my $out, ">:encoding(UTF-8)", "$outfile") or die "Cannot open $outfile: $!";

#output file
printf $out ("%-21s %-20s %-15s %-9s %-15s %-10s %-21s\n","Last","First","Clean","String","Usable","Status","Formatted");
printf $out ("%-21s %-20s %-15s %-9s %-15s %-10s %-21s\n","Name","Name","Phone Number","Length","Phone Number","","Phone Number");
printf $out ("%-21s %-20s %-15s %-9s %-15s %-10s %-21s\n",
    "*********************","********************","************","*******",
    "*************","********","*********************");

#initializing variables to count phone numbers
my $ndropped = 0;
my $validno = 0;
my $usableno = 0;
my $invalidno = 0;
my $valid10   = 0;

#Reading input file
while(my $line = <$in>) {
    # Skip header row (Index,Name,City,State,Phone Number)
    next if $. == 1;                # skip header row
    next if $line =~ /^\s*$/;  # skip blank lines just in case  

    #remove commas from text within quotation marks
    $line =~ s/(?:\G(?!\A)|[^"]*")[^",]*\K(?:,|"(*SKIP)(*FAIL))//g;

    # remove quotation marks
    $line =~ s/"//g;
    # print $line

    # Columns: Index,Name,City,State,Phone Number
    my ($index, $name, $city, $state, $phone) = split(',', $line);
    $name  //= "";
    $phone //= "";

    #Task 5: Clean Names
    my $name_clean = $name;
    $name_clean =~ s/[",]//g;
    $name_clean =~ s/^\s+|\s+$//g;
    $name_clean =~ s/\s+/ /g;

    my ($last, $first) = ("", "");
    if (length $name_clean) {
        my @words = split(/\s+/, $name_clean);
        $last  = $words[0] // "";
        $first = $words[1] // "";
    }

    # Clean to digits-only + length
    (my $clean = $phone) =~ s/\D//g;
    my $len = length($clean);

    # Apply Task 3 rules
    #Prefix 661 for 7 digits
    my $usable = "";
    if ($len == 7) {
        $usable = "661" . $clean;
    }
    #Prefix 661 for 8 digits, drop 1st digit from the right
    elsif ($len == 8) {
        $usable = "661" . substr($clean, 0, 7);
    }
    #Prefix 92 for 9 digits, drop 0 from the left
    elsif ($len == 9){
        $usable = "92"  . substr($clean, 1);
    }
    #All 10 digits are usable
    elsif ($len == 10) {
        $usable = $clean;
    }
    #For 11 digits, drop 1st digit from the left
    elsif ($len == 11) {
        $usable = substr($clean, 1);
    }
    #For 12 digits, drop 2 digits from the left
    elsif ($len == 12) {
        $usable = substr($clean, 2);
    }
    #For 13 digits, drop 3 digits from the right
    elsif ($len == 13) {
        $usable = substr($clean, 0, 10);
    }
    #Drop everything else
    else {
        $usable = "Dropped";
        $ndropped++;
    } 
    my $status = "Invalid";
    my $formatted = "";
    #logic for pdf answers
    if ($usable ne "Dropped") {
        $usableno++;
        ($status) = validate_10_digit($usable);  # ("Valid", ...) or ("Invalid", ...)
        if ($status =~ /^Valid/) {
            $validno++;
            $formatted = format_phone($usable);
            $valid10++ if $len == 10;    
        } else {
            $invalidno++;            
        }
    }
    # File row (Status is "Valid"/"Invalid" )
    my $status_simple = ($status =~ /^Valid/) ? "Valid" : "Invalid";
    printf $out ("%-21s %-20s %-15s %-9s %-15s %-10s %-21s\n",
        $last, $first, $clean, $len, ($usable eq "Dropped" ? "Dropped" : $usable),
        $status_simple, $formatted);

}
close $in;
close $out;

#printing amswers for pdf
print "\n Dropped (Not Usable): $ndropped\n";
print " Invalid:                $invalidno\n";
print " Valid (correct):        $validno\n";
print " Valid 10-digit:         $valid10\n";

print "\n ... Output files has been created\n";
print "\n Good bye!\n";

#helper functions i wrote for task 4
sub validate_10_digit {
    my ($n) = @_;
    return ("Invalid","Not 10 digits") unless defined $n && $n =~ /^\d{10}$/;

    # All digits the same
    return ("Invalid","All digits the same") if $n =~ /^([0-9])\1{9}$/;

    # Placeholder
    return ("Invalid","Placeholder sequence 1234567890") if $n eq '1234567890';

    my $area     = substr($n, 0, 3);
    my $exchange = substr($n, 3, 3);

    # Area code rules
    return ("Invalid","Area code starts with 0 or 1") if $area =~ /^[01]/;
    return ("Invalid","Area code second digit is 9")  if substr($area,1,1) eq '9';

    # Reserved 555-01XX block when area=555
    if ($area eq '555' && substr($exchange,0,2) eq '01') {
        return ("Invalid","Reserved 555-01XX block");
    }

    # Exchange code cannot start with 0 or 1
    return ("Invalid","Exchange code starts with 0 or 1") if $exchange =~ /^[01]/;

    # Special service area codes: valid (marked special)
    return ("Valid","Toll-free")         if $area =~ /^(800|833|844|855|866|877|888)$/;
    return ("Valid","Premium-rate 900")  if $area eq '900';

    return ("Valid","Standard 10-digit number");
}

#helper function that formats clean phones into (xxx) xxx - xxxx
sub format_phone {
    my ($n) = @_;
    return "" unless defined $n && $n =~ /^\d{10}$/;
    return "(" . substr($n,0,3) . ") " . substr($n,3,3) . " - " . substr($n,6,4);
}
