#commadn line Perl skript to turn your data model definitions (JSON) into a graphqviz readable Format
#ARGV[0] path to data_model_definitions Folder

use strict;
use warnings;

use JSON::Parse 'json_file_to_perl';
use Data::Dumper;

my $dir = $ARGV[0];
my %attributes;
my %associations;

foreach my $fp (glob("$dir/*.json")) {
    open my $fh, "<", $fp or die "can't read open";
    if ($fp =~ /_to_/) {
        next;
    }
  
    my $json_file_to_perl = json_file_to_perl($fp);
    my @tmp = ();
    my @tmp2= ();
    my $assocs = %$json_file_to_perl{"associations"};
    foreach(keys %$assocs) {
        chomp;
        my $current = %$assocs{$_};
        my $target = %$current{'target'};
        my $type = %$current{'type'};
        if($type eq 'to_one') {
            $target = $target."1";
        } else {
            $target = $target."2";
        }
        push(@tmp, $target);
    }
    $associations{%$json_file_to_perl{"model"}} = [@tmp];
    my $longest_att = 0;
    my $targetAttributes = %$json_file_to_perl{"attributes"};
    foreach(keys %$targetAttributes){
        if(length($_) + length(%$targetAttributes{$_}) > $longest_att){
            $longest_att = length($_) + length(%$targetAttributes{$_});
        }
        push(@tmp2,$_." ".$longest_att." ".%$targetAttributes{$_});
    }
    $attributes{%$json_file_to_perl{"model"}} = [@tmp2];
    close $fh or die "can't read close";
}

print ("digraph hierarchy {\n");
print("node[shape=record,style=filled,fillcolor=gray95, fontname=Courier, fontsize=15]\n");
print("graph [splines=ortho]\n");
print("edge[arrowsize=1.5, style=bold]\n");
print("ranksep=0.5\n");
print("nodesep=1\n");
print("esep=1");
print("\n");

my @order = ("program","trial","study","event","eventParameter","contact","environmentParameter","season","observation","observationUnit","observationUnit","observationUnitPosition","observationTreatment","location","germplasm","breedingMethod","image","observationVariable","ontologyReference","trait","method","scale");

foreach(@order) {
    my $lc = lcfirst($_);
    print "  ".$_." [label = < {<B>".ucfirst($_)."</B>|";
    my $tmp_attr = $attributes{$_};
    my @lst = split(" ",@$tmp_attr[-1]);
    my $longest = $lst[1];
    my @AttPrint = ();
    my @AttPrintForeign = ();

    foreach(@$tmp_attr){
        my @split = split / /,$_;
        
        if($split[0] eq $lc."DbId" || ($lc eq "ontologyReference" && $split[0] eq "ontologyDbId")){
            unshift(@AttPrint, $_);
        } elsif ($split[0] =~ /DbId/){
            push(@AttPrintForeign, $_);
        } else {
            push(@AttPrint, $_);
        }
    }

    foreach(@AttPrint){
        my @split = split / /,$_;
        my $tabCalc = calcSpaces(length($split[0])+length($split[2]),$longest);

        if($split[0] eq $lc."DbId" || ($lc eq "ontologyReference" && $split[0] eq "ontologyDbId")){
            print "<font color=\"red\">".$split[0];
            print " " x $tabCalc;
            print "<i>".$split[2]."</i></font><br ALIGN=\"LEFT\"/>";
        } else {
            print $split[0];
            print " " x $tabCalc;
            print "<i>".$split[2]."</i><br ALIGN=\"LEFT\"/>";
        }
    }
    foreach(@AttPrintForeign){
        my @split = split / /,$_;
        my $tabCalc = calcSpaces(length($split[0])+length($split[2]),$longest);

        print "<font color=\"darkgreen\">".$split[0];
        print " " x $tabCalc;
        print "<i>".$split[2]."</i></font><br ALIGN=\"LEFT\"/>";
    }
    print "}>]\n";
}
print "\n";

foreach(keys %associations) {
    my $tmp_assoc = $_;
    my $curr_assoc = $associations{$_};
    foreach(@$curr_assoc){
        my $last_char = chop;
        if($last_char == 1) {
            print "  ".$tmp_assoc." -> ".$_."[color=navy]";
        } else {
            print "  ".$tmp_assoc." -> ".$_."[color=crimson]";
        }
        print "\n";
    }
}

print ("}");

sub calcSpaces {
    my $len = shift(@_);
    my $maxLen = shift(@_);
    my $longestSpace = $maxLen + 4;
    my $lenSpace = $longestSpace - $len;
    return $lenSpace;
}
