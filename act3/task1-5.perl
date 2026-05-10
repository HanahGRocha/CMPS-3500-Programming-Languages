#!/usr/bin/perl
use strict;
use warnings;
use Text::ParseWords; 
use File::Basename qw(dirname);
use File::Path qw(make_path);

my $infile = "PhoneBook.txt";  
my $outfile = "CleanPhones.txt";          #Clean Numbers 
my $validfile = "ValidPhones.txt";        # only valid 10-digit numbers
my $namefile  = "NameBook.txt";           # Names

# ensure output dirs exist (if any were given)
for my $f ($outfile, $validfile, $namefile) {
    my $d = dirname($f);
    if ($d ne '.' && !-d $d) { make_path($d) or die "Cannot create $d: $!" }
}

open(my $in, "<:encoding(UTF-8)", $infile) or die "Cannot open $infile: $!";
open(my $out, ">:encoding(UTF-8)", $outfile) or die "Cannot open $outfile: $!";
open(my $val, ">:encoding(UTF-8)", $validfile)  or die "Cannot open $validfile: $!";
open(my $nam, ">:encoding(UTF-8)", $namefile)  or die "Cannot open $namefile: $!";

# headers (terminal)
printf("%-15s%-18s%-9s%-12s%-12s%s\n","Original","Clean","Length","Usable","Status","Explanation");
printf("%-15s%-18s%-9s%-12s%-12s%s\n","Phone #","Phone #","String","(10 digits)","","");
printf("%-15s%-18s%-9s%-12s%-12s%s\n","*************","**************","*******","************","********","************");

# headers (outfile)
printf $out ("%-15s%-18s%-9s%-12s%-12s%s\n","Original","Clean","Length","Usable","Status","Explanation");
printf $out ("%-15s%-18s%-9s%-12s%-12s%s\n","Phone #","Phone #","String","(10 digits)","","");
printf $out ("%-15s%-18s%-9s%-12s%-12s%s\n","*************","**************","*******","************","********","************");

#headers (namefile)
printf $nam ("%-28s %-20s\n", "Last Name", "First Name");
printf $nam ("%-28s %-20s\n", "****************************", "********************");

my $lineno = 0;
my $ndropped = 0;
my $nusable = 0;
my $validno = 0;
my $invalidno = 0;

while (my $line = <$in>) {
    $lineno++;
    chomp $line;

    # Skip header row (Index,Name,City,State,Phone Number)
    next if $lineno == 1;
    next if $line =~ /^\s*$/;  # skip blank lines just in case

    # 1) Remove commas that occur inside quoted text
    $line =~ s/(?:\G(?!\A)|[^"]*")[^",]*\K(?:,|"(*SKIP)(*FAIL))//g;

    # 2) Remove the remaining quote characters
    $line =~ s/"//g;

    # 3) Split by commas into the 5 expected columns
    my ($index, $name, $city, $state, $phone) = split(',', $line);

    $name //= "";
    my $name_clean = $name;

    # Drop commas and quotes (quotes already removed from line, but safe to repeat)
    $name_clean =~ s/[",]//g;

    # Trim and collapse internal whitespace
    $name_clean =~ s/^\s+|\s+$//g;
    $name_clean =~ s/\s+/ /g;

    my ($last, $first) = ("", "");
    if (length $name_clean) {
        my @words = split(/\s+/, $name_clean);
        $last  = $words[0] // "";
        $first = $words[1] // "";   # may be empty if only one word
    }

    # Write names to CleanPhoneBook.txt (Last, First)
    printf $nam ("%-28s %-20s\n", $last, $first);

    $phone //= "";                      # guard
    my $original = $phone;              # keep original for printing

    # digits-only
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

    $nusable++ if $usable ne "Dropped";
    my $status = "Dropped"; 
    my $explain = "Not a 10-digit usable number";
    if ($usable ne "Dropped") {
        # Validate per Task 4 rules
        ($status, $explain) = validate_10_digit($usable);
        if ($status =~ /^Valid/) {
            $validno++;
            print   $val "$usable\n";
        } else {
            $invalidno++;
        }
    } else {
        $invalidno++;
    }


    # Print one row (terminal)
    printf("%-15s%-18s%-9s%-12s%-12s%s\n",
        $original, $clean, $len, ($usable eq "Dropped" ? "" : $usable), $status, $explain);

    # Write one row (file)
    printf $out ("%-15s%-18s%-9s%-12s%-12s%s\n",
        $original, $clean, $len, ($usable eq "Dropped" ? "" : $usable), $status, $explain);


}

close $in;
close $out;
close $val;
close $nam;

print "\nSummary:\n";
print "  Dropped by Task 3 rules: $ndropped\n";
print "  Invalid by Task 4 rules: $invalidno\n";
print "  Valid phone numbers:     $validno\n";
print "  Wrote valid numbers to:  $validfile\n";
print "  Full phone audit:        $outfile\n";
print "  Cleaned names file:      $namefile\n";

#task 4 helper function
sub validate_10_digit {
    my ($n) = @_;
    # Length
    return ("Invalid","Not 10 digits") unless defined $n && $n =~ /^\d{10}$/;

    # All digits the same
    return ("Invalid","All digits the same") if $n =~ /^([0-9])\1{9}$/;

    # Obvious placeholder
    return ("Invalid","Placeholder sequence 1234567890") if $n eq '1234567890';

    my $area     = substr($n, 0, 3);
    my $exchange = substr($n, 3, 3);
    # my $line   = substr($n, 6, 4); # (unused kept for clarity)

    # Area code rules
    return ("Invalid","Area code starts with 0 or 1") if $area =~ /^[01]/;
    return ("Invalid","Area code second digit is 9")  if substr($area,1,1) eq '9';

    # Reserved 555-01XX block when area=555
    if ($area eq '555' && substr($exchange,0,2) eq '01') {
        return ("Invalid","Reserved 555-01XX block");
    }

    # Exchange code cannot start with 0 or 1
    return ("Invalid","Exchange code starts with 0 or 1") if $exchange =~ /^[01]/;

    # Special service area codes
    if ($area =~ /^(800|833|844|855|866|877|888)$/) {
        return ("Valid (toll-free)","Toll-free area code $area");
    }
    if ($area eq '900') {
        return ("Valid (premium-rate)","900 premium-rate area");
    }

    # Otherwise valid
    return ("Valid","Standard 10-digit number");
}

